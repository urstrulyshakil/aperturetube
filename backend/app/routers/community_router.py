from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import get_db
from app.models.artisan import Artisan
from app.schemas.artisan import ArtisanSchema, BookingRequest

router = APIRouter(prefix="/community", tags=["Artisan Community & Directory"])

@router.get("/artisans", response_model=List[ArtisanSchema])
async def list_artisans(
    discipline: Optional[str] = Query(None, description="Category: Wedding, Editorial, Drone, Macro, Commercial"),
    db: AsyncSession = Depends(get_db),
):
    query = select(Artisan)
    if discipline and discipline != "All":
        query = query.where(Artisan.category == discipline)
    result = await db.execute(query)
    return result.scalars().all()

@router.get("/artisans/{artisan_id}", response_model=ArtisanSchema)
async def get_artisan(artisan_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Artisan).where(Artisan.id == artisan_id))
    artisan = result.scalars().first()
    if not artisan:
        raise HTTPException(status_code=404, detail="Artisan profile not found")
    return artisan

@router.post("/book")
async def create_booking(req: BookingRequest, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Artisan).where(Artisan.id == req.artisan_id))
    artisan = result.scalars().first()
    if not artisan:
        raise HTTPException(status_code=404, detail="Artisan not found")
        
    return {
        "status": "CONFIRMED_WITH_ESCROW",
        "artisan_name": artisan.name,
        "starting_price": artisan.starting_price,
        "escrow_guarantee": "Your deposit is held securely until deliverables are approved in Google Drive.",
        "client_email": req.client_email,
        "event_date": req.event_date,
    }
