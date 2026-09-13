from datetime import datetime
from sqlalchemy import Column, String, Integer, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from app.database import Base

class Project(Base):
    __tablename__ = "projects"

    id = Column(String, primary_key=True, index=True)
    title = Column(String, nullable=False)
    client_name = Column(String, nullable=False)
    package_description = Column(String, nullable=False)
    camera_gear = Column(String, nullable=False)
    status = Column(String, default="selection")  # 'selection', 'inProgress', 'delivered'
    selected_photos = Column(Integer, default=0)
    total_photos = Column(Integer, default=0)
    drive_sync_size = Column(String, default="128 GB RAW")
    due_date = Column(String, nullable=False)
    image_url = Column(String, nullable=False)
    drive_folder_id = Column(String, nullable=True)
    is_vault_synced = Column(Boolean, default=True)
    
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    photos = relationship("PhotoCapture", back_populates="project", cascade="all, delete-orphan")

class PhotoCapture(Base):
    __tablename__ = "photo_captures"

    id = Column(String, primary_key=True, index=True)
    project_id = Column(String, ForeignKey("projects.id"), nullable=False)
    title = Column(String, nullable=False)
    image_url = Column(String, nullable=False)
    camera = Column(String, default="Sony FX6 Cinema")
    lens = Column(String, default="FE 50mm f/1.2 GM")
    aperture = Column(String, default="ƒ/1.2")
    shutter = Column(String, default="1/800s")
    iso = Column(String, default="ISO 100")
    focal_length = Column(String, default="50mm")
    is_selected = Column(Boolean, default=False)
    is_favorite = Column(Boolean, default=False)
    is_retouch_requested = Column(Boolean, default=False)
    
    project = relationship("Project", back_populates="photos")
