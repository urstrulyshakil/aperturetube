from datetime import datetime
from sqlalchemy import Column, String, Float, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Invoice(Base):
    __tablename__ = "invoices"

    id = Column(String, primary_key=True, index=True)
    invoice_number = Column(String, unique=True, index=True, nullable=False)
    token_code = Column(String, unique=True, index=True, nullable=False)
    target_drive_email = Column(String, nullable=False)
    raw_storage_size = Column(String, default="128 GB RAW")
    master_captures_count = Column(String, default="1,420 High-Res Masters")
    due_date = Column(String, nullable=False)
    tax_amount = Column(Float, default=90.0)
    total_usd = Column(Float, nullable=False)
    total_bdt = Column(String, nullable=False)
    is_settled = Column(Boolean, default=False)
    settlement_method = Column(String, nullable=True)
    settled_at = Column(DateTime, nullable=True)
    
    created_at = Column(DateTime, default=datetime.utcnow)
    
    line_items = relationship("InvoiceLineItem", back_populates="invoice", cascade="all, delete-orphan")
    payments = relationship("PaymentRecord", back_populates="invoice", cascade="all, delete-orphan")

class InvoiceLineItem(Base):
    __tablename__ = "invoice_line_items"

    id = Column(String, primary_key=True, index=True)
    invoice_id = Column(String, ForeignKey("invoices.id"), nullable=False)
    title = Column(String, nullable=False)
    subtitle = Column(String, nullable=False)
    amount = Column(Float, nullable=False)
    
    invoice = relationship("Invoice", back_populates="line_items")

class PaymentRecord(Base):
    __tablename__ = "payment_records"

    id = Column(String, primary_key=True, index=True)
    invoice_id = Column(String, ForeignKey("invoices.id"), nullable=False)
    gateway = Column(String, nullable=False)  # 'bKash', 'stripe', 'googlePay'
    transaction_id = Column(String, unique=True, index=True, nullable=False)
    amount_usd = Column(Float, nullable=False)
    currency = Column(String, default="USD")
    status = Column(String, default="Completed")
    gateway_response = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    invoice = relationship("Invoice", back_populates="payments")
