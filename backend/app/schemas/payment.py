from typing import Optional
from pydantic import BaseModel

class BkashCreatePaymentRequest(BaseModel):
    invoice_id: str
    amount: float
    payer_reference: str  # e.g. "01712345678"

class BkashCreatePaymentResponse(BaseModel):
    payment_id: str
    amount: str
    currency: str
    status: str
    callback_url: str

class BkashExecutePaymentRequest(BaseModel):
    payment_id: str
    otp: Optional[str] = None
    pin: Optional[str] = None

class StripeCreateIntentRequest(BaseModel):
    invoice_id: str
    amount: float
    currency: str = "usd"

class StripeCreateIntentResponse(BaseModel):
    client_secret: str
    payment_intent_id: str

class GooglePayProcessRequest(BaseModel):
    invoice_id: str
    amount: float
    payment_token: str

class PaymentResultResponse(BaseModel):
    success: bool
    invoice_id: str
    transaction_id: str
    gateway: str
    message: str
    drive_vault_unlocked: bool
