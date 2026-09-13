from datetime import datetime
from sqlalchemy import Column, String, Boolean, DateTime, Float, Integer
from app.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String, nullable=False)
    role = Column(String, default="photographer")  # 'photographer' or 'client'
    avatar_url = Column(String, nullable=True)
    
    # Studio Settings
    role_title = Column(String, default="Principal Visual Architect")
    rating = Column(Float, default=4.98)
    reviews_count = Column(Integer, default=142)
    drive_sync_path = Column(String, default="Google Drive/ApertureTube_Vault/RAW_Masters")
    storage_used_tb = Column(Float, default=3.4)
    storage_total_tb = Column(Float, default=10.0)
    auto_sync_raw = Column(Boolean, default=True)
    payout_gateway = Column(String, default="bKash Merchant Direct")
    default_currency = Column(String, default="USD ($)")
    lut_mode = Column(String, default="darkCinema")
    
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
