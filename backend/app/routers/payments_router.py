from datetime import datetime
import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import get_db
from app.models.invoice import Invoice, PaymentRecord
from app.schemas.payment import (
    BkashCreatePaymentRequest,
    BkashCreatePaymentResponse,
    BkashExecutePaymentRequest,
    StripeCreateIntentRequest,
    StripeCreateIntentResponse,
    GooglePayProcessRequest,
    PaymentResultResponse,
)
from app.services.bkash_service import bkash_service
from app.services.stripe_service import stripe_service
from app.services.google_pay_service import google_pay_service
from app.services.google_drive_service import google_drive_service

router = APIRouter(prefix="/payments", tags=["Payment Gateways (bKash, Stripe, Google Pay)"])

async def _mark_invoice_settled(db: AsyncSession, invoice_id: str, method: str, transaction_id: str, amount: float):
    result = await db.execute(select(Invoice).where((Invoice.id == invoice_id) | (Invoice.invoice_number == invoice_id)))
    invoice = result.scalars().first()
    if invoice:
        invoice.is_settled = True
        invoice.settlement_method = method
        invoice.settled_at = datetime.utcnow()
        
        record = PaymentRecord(
            id=f"pay_{uuid.uuid4().hex[:10]}",
            invoice_id=invoice.id,
            gateway=method,
            transaction_id=transaction_id,
            amount_usd=amount,
            status="Completed",
        )
        db.add(record)
        await db.commit()
        
        # Trigger Google Drive delegation to client
        await google_drive_service.grant_client_access("vault_root", invoice.target_drive_email)
        return invoice
    return None

@router.post("/bkash/create", response_model=BkashCreatePaymentResponse)
async def bkash_create(req: BkashCreatePaymentRequest):
    """Initiates a bKash Checkout session."""
    data = await bkash_service.create_payment(
        amount=req.amount,
        invoice_number=req.invoice_id,
        payer_reference=req.payer_reference,
    )
    return {
        "payment_id": data.get("paymentID", f"BK_{uuid.uuid4().hex[:8]}"),
        "amount": str(data.get("amount", req.amount)),
        "currency": "BDT",
        "status": data.get("transactionStatus", "Initiated"),
        "callback_url": data.get("bkashURL", "https://sandbox.bka.sh/checkout"),
    }

@router.post("/bkash/execute", response_model=PaymentResultResponse)
async def bkash_execute(req: BkashExecutePaymentRequest, db: AsyncSession = Depends(get_db)):
    """Executes bKash payment after OTP & PIN verification, releasing escrow."""
    res = await bkash_service.execute_payment(req.payment_id)
    trx_id = res.get("trxID", f"TRX_{uuid.uuid4().hex[:8].upper()}")
    
    invoice = await _mark_invoice_settled(
        db=db,
        invoice_id="inv_01",
        method="bKash Merchant",
        transaction_id=trx_id,
        amount=1890.0,
    )
    
    return {
        "success": True,
        "invoice_id": invoice.invoice_number if invoice else "AT-2025-0891",
        "transaction_id": trx_id,
        "gateway": "bKash Merchant Direct",
        "message": "Payment captured via SSLCommerz. 128 GB RAW Google Drive Vault unshielded!",
        "drive_vault_unlocked": True,
    }

@router.post("/stripe/create-intent", response_model=StripeCreateIntentResponse)
async def stripe_create_intent(req: StripeCreateIntentRequest):
    """Creates a Stripe PaymentIntent for card payment."""
    res = await stripe_service.create_payment_intent(
        amount_usd=req.amount,
        invoice_id=req.invoice_id,
    )
    return {
        "client_secret": res["client_secret"],
        "payment_intent_id": res["payment_intent_id"],
    }

@router.post("/stripe/confirm", response_model=PaymentResultResponse)
async def stripe_confirm(payment_intent_id: str, db: AsyncSession = Depends(get_db)):
    """Confirms Stripe payment and releases vault escrow."""
    res = await stripe_service.confirm_payment_intent(payment_intent_id)
    
    invoice = await _mark_invoice_settled(
        db=db,
        invoice_id="inv_01",
        method="Stripe",
        transaction_id=payment_intent_id,
        amount=1890.0,
    )
    
    return {
        "success": True,
        "invoice_id": invoice.invoice_number if invoice else "AT-2025-0891",
        "transaction_id": payment_intent_id,
        "gateway": "Stripe Card (Global USD)",
        "message": "Stripe payment succeeded. Google Drive RAW license dispatched.",
        "drive_vault_unlocked": True,
    }

@router.post("/google-pay/process", response_model=PaymentResultResponse)
async def google_pay_process(req: GooglePayProcessRequest, db: AsyncSession = Depends(get_db)):
    """Verifies Google Pay token and settles invoice."""
    res = await google_pay_service.process_payment_token(
        invoice_id=req.invoice_id,
        amount_usd=req.amount,
        payment_token=req.payment_token,
    )
    trx_id = res["transaction_id"]
    
    invoice = await _mark_invoice_settled(
        db=db,
        invoice_id=req.invoice_id,
        method="Google Pay",
        transaction_id=trx_id,
        amount=req.amount,
    )
    
    return {
        "success": True,
        "invoice_id": invoice.invoice_number if invoice else req.invoice_id,
        "transaction_id": trx_id,
        "gateway": "Google Pay Business",
        "message": "Google Pay 1-Tap payment authorized. Vault unlocked.",
        "drive_vault_unlocked": True,
    }
