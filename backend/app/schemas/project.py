from typing import List, Optional
from pydantic import BaseModel, ConfigDict

class PhotoCaptureSchema(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    project_id: str
    title: str
    image_url: str
    camera: str
    lens: str
    aperture: str
    shutter: str
    iso: str
    focal_length: str
    is_selected: bool
    is_favorite: bool
    is_retouch_requested: bool

class ProjectSchema(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    client_name: str
    package_description: str
    camera_gear: str
    status: str
    selected_photos: int
    total_photos: int
    drive_sync_size: str
    due_date: str
    image_url: str
    is_vault_synced: bool


class ProjectDetailSchema(ProjectSchema):
    photos: List[PhotoCaptureSchema] = []

class PhotoStatusUpdate(BaseModel):
    is_selected: Optional[bool] = None
    is_favorite: Optional[bool] = None
    is_retouch_requested: Optional[bool] = None
