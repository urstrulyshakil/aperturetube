from typing import List, Optional
from datetime import datetime
from pydantic import BaseModel, ConfigDict

class InvoiceLineItemSchema(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    subtitle: str
    amount: float

class InvoiceSchema(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    invoice_number: str
    token_code: str
    target_drive_email: str
    raw_storage_size: str
    master_captures_count: str
    due_date: str
    tax_amount: float
    total_usd: float
    total_bdt: str
    is_settled: bool
    settlement_method: Optional[str] = None
    settled_at: Optional[datetime] = None
    line_items: List[InvoiceLineItemSchema] = []

