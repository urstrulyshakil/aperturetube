from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.init_db import init_database
from app.routers import (
    auth_router,
    projects_router,
    drive_router,
    invoices_router,
    payments_router,
    community_router,
)

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Initialize SQLite tables and seed data
    await init_database()
    yield
    # Shutdown logic if any

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    description="ApertureTube Cinema & RAW Masters Backend API. Integrated with Google Drive, bKash, Stripe, and Google Pay.",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

# Enable CORS for Flutter Web, iOS, Android, and macOS clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register modular API routers under /api/v1
app.include_router(auth_router.router, prefix=settings.API_V1_PREFIX)
app.include_router(projects_router.router, prefix=settings.API_V1_PREFIX)
app.include_router(drive_router.router, prefix=settings.API_V1_PREFIX)
app.include_router(invoices_router.router, prefix=settings.API_V1_PREFIX)
app.include_router(payments_router.router, prefix=settings.API_V1_PREFIX)
app.include_router(community_router.router, prefix=settings.API_V1_PREFIX)

@app.get("/", tags=["Health"])
async def root():
    return {
        "app": settings.APP_NAME,
        "version": settings.APP_VERSION,
        "status": "ONLINE",
        "docs_url": "/docs",
        "database": "SQLite (100% Free Local Database)",
        "modules": [
            "Google Drive RAW Vault Sync & Token Verification",
            "bKash Merchant PGW API v1.2.0",
            "Stripe PaymentIntents & Webhooks",
            "Google Pay Business Settlement",
            "Projects & EXIF Telemetry",
            "Artisan Community & Escrow Bookings",
        ],
    }

@app.get("/health", tags=["Health"])
async def health():
    return {"status": "healthy"}
