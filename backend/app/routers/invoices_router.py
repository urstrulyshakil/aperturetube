from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from app.database import get_db
from app.models.invoice import Invoice
from app.schemas.invoice import InvoiceSchema

router = APIRouter(prefix="/invoices", tags=["Invoices & Vault Escrow"])

@router.get("", response_model=List[InvoiceSchema])
async def list_invoices(db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(Invoice).options(selectinload(Invoice.line_items))
    )
    return result.scalars().all()

@router.get("/active", response_model=InvoiceSchema)
async def get_active_invoice(db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(Invoice).options(selectinload(Invoice.line_items)).limit(1)
    )
    invoice = result.scalars().first()
    if not invoice:
        raise HTTPException(status_code=404, detail="No active invoice found")
    return invoice

@router.get("/{invoice_id}", response_model=InvoiceSchema)
async def get_invoice(invoice_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(Invoice).options(selectinload(Invoice.line_items)).where(Invoice.id == invoice_id)
    )
    invoice = result.scalars().first()
    if not invoice:
        raise HTTPException(status_code=404, detail="Invoice not found")
    return invoice
