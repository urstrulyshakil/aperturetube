from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from app.database import get_db
from app.models.project import Project, PhotoCapture
from app.schemas.project import (
    ProjectSchema,
    ProjectDetailSchema,
    PhotoStatusUpdate,
    PhotoCaptureSchema,
)

router = APIRouter(prefix="/projects", tags=["Projects & Master Vault"])

@router.get("", response_model=List[ProjectSchema])
async def list_projects(
    status: Optional[str] = Query(None, description="Filter by status: selection, inProgress, delivered"),
    db: AsyncSession = Depends(get_db),
):
    query = select(Project)
    if status and status != "all":
        query = query.where(Project.status == status)
    result = await db.execute(query)
    return result.scalars().all()

@router.get("/metrics/summary")
async def get_bento_metrics(db: AsyncSession = Depends(get_db)):
    """Returns the 2x2 Bento quick metrics for the dashboard."""
    result = await db.execute(select(Project))
    projects = result.scalars().all()
    
    live_shoots = len(projects)
    curations = len([p for p in projects if p.status == "selection"])
    ready = len([p for p in projects if p.status == "delivered"])
    
    return {
        "live_shoots": f"{live_shoots:02d}",
        "client_curations": f"{curations:02d}",
        "ready_for_handoff": f"{ready:02d}",
        "secured_balance": "$2,450",
    }

@router.get("/{project_id}", response_model=ProjectDetailSchema)
async def get_project_detail(project_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(Project).options(selectinload(Project.photos)).where(Project.id == project_id)
    )
    project = result.scalars().first()
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")
    return project

@router.patch("/{project_id}/photos/{photo_id}", response_model=PhotoCaptureSchema)
async def update_photo_status(
    project_id: str,
    photo_id: str,
    req: PhotoStatusUpdate,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(PhotoCapture).where(PhotoCapture.id == photo_id, PhotoCapture.project_id == project_id)
    )
    photo = result.scalars().first()
    if not photo:
        raise HTTPException(status_code=404, detail="Photo capture not found")
        
    if req.is_selected is not None:
        photo.is_selected = req.is_selected
    if req.is_favorite is not None:
        photo.is_favorite = req.is_favorite
    if req.is_retouch_requested is not None:
        photo.is_retouch_requested = req.is_retouch_requested
        
    await db.commit()
    await db.refresh(photo)
    return photo
