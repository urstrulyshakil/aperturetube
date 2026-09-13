from datetime import datetime
from sqlalchemy import Column, String, Float, Integer, DateTime
from app.database import Base

class Artisan(Base):
    __tablename__ = "artisans"

    id = Column(String, primary_key=True, index=True)
    name = Column(String, nullable=False)
    specialty = Column(String, nullable=False)
    category = Column(String, nullable=False)  # 'Wedding', 'Editorial', 'Drone', 'Macro', 'Commercial'
    rating = Column(Float, default=4.95)
    reviews_count = Column(Integer, default=50)
    starting_price = Column(String, nullable=False)
    availability = Column(String, nullable=False)
    gear_kit = Column(String, nullable=False)
    avatar_url = Column(String, nullable=False)
    cover_image_url = Column(String, nullable=False)
    showreel_url = Column(String, nullable=True)
    
    created_at = Column(DateTime, default=datetime.utcnow)
