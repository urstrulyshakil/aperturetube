from typing import Optional
from pydantic import BaseModel, ConfigDict

class ArtisanSchema(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    name: str
    specialty: str
    category: str
    rating: float
    reviews_count: int
    starting_price: str
    availability: str
    gear_kit: str
    avatar_url: str
    cover_image_url: str
    showreel_url: Optional[str] = None


class BookingRequest(BaseModel):
    artisan_id: str
    client_name: str
    client_email: str
    event_date: str
    notes: Optional[str] = None
