# ApertureTube • Cinema & RAW Masters Platform 🎞️✨

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110+-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org)
[![Google Drive](https://img.shields.io/badge/Google_Drive-API_v3-4285F4?style=for-the-badge&logo=googledrive&logoColor=white)](https://developers.google.com/drive)
[![bKash](https://img.shields.io/badge/bKash-Merchant_PGW-E2136E?style=for-the-badge)](https://developer.bka.sh)
[![Stripe](https://img.shields.io/badge/Stripe-PaymentIntents-635BFF?style=for-the-badge&logo=stripe&logoColor=white)](https://stripe.com)
[![Google Pay](https://img.shields.io/badge/Google_Pay-Business-4285F4?style=for-the-badge&logo=googlepay&logoColor=white)](https://pay.google.com)
[![SQLite](https://img.shields.io/badge/SQLite-Async_SQLAlchemy-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://sqlite.org)

**ApertureTube** is an ultra-premium, full-stack photography marketplace, vault curation workspace, and escrow payment platform designed for high-end cinema cinematographers, fine-art wedding photographers, and luxury editorial studios.

---

## Key Features

### 🎨 Mobile & Web Frontend (Flutter)
- **Dual Aesthetic Ambience**:
  - 🌙 **Obsidian Gilt (Night Cinema)**: Deep obsidian surfaces (`#0B0C10`), elevated cards (`#14161D`), and 24K gold accents (`#F2CA50`).
  - ☀️ **Daylight Studio (Day Mode)**: Warm ivory cream background (`#FAF7F0`), crisp white cards, gold-bordered containers, and high-contrast mocha/obsidian typography.
  - **1-Tap Quick Switcher**: Toggle theme instantly from the app header or login screen.
- **Master Projects & RAW Vault Workspace**:
  - 2x2 Bento telemetry grid (Live Shoots, Curations, Ready for Handoff, Secured Balance).
  - Status filtering (`In Progress`, `Needs Selection`, `Ready for Delivery`).
  - Darkroom photo curation modal with EXIF camera lens telemetry (aperture, shutter speed, ISO, focal length).
- **Google Drive Archival & Escrow Invoicing**:
  - Live escrow status with breakdown of 4K DCI footage, 8K CineDNG drone reels, and cloud archival.
  - Cryptographic token delivery (`AT-891-XK94`) and unshielded RAW download permissions.
- **Artisan Community Marketplace**:
  - Curated directory of top-tier cinematographers, drone pilots, and fashion retouchers.
  - Discipline filter (Wedding, Editorial, Drone, Macro) with escrow booking requests.
- **Studio Pro Profile & Payout Engine**:
  - Studio master analytics, storage allocation telemetry (10 TB vault), and LUT preview modes.

---

### ⚡ High-Performance REST Backend (FastAPI + Async SQLAlchemy 2.0)
- **100% Free Architecture**:
  - Powered by local asynchronous SQLite (`sqlite+aiosqlite:///./data/aperturetube.db`). Zero recurring database bills or third-party cloud costs.
  - Automatic seed initialization populating photographer Elena Vance, 4 master projects with EXIF data, active escrow invoice, and artisan profiles.
- **Google Drive API v3 RAW Vault Engine**:
  - Automated project folder creation and vault telemetry.
  - HMAC-SHA256 signed cryptographic download token generator & validator (`/api/v1/drive/tokens/*`).
  - Automated client permission delegation upon invoice settlement.
- **Multi-Gateway Payment Processing**:
  - 🇧🇩 **bKash Merchant PGW v1.2.0-beta**: Full OAuth grant token handshake, `createPayment`, and `executePayment` flow with sandbox fallback.
  - 💳 **Stripe PaymentIntents**: Official Stripe SDK integration for global credit/debit card processing.
  - 📱 **Google Pay Business**: 1-Tap cryptographic payment token processing and auto-settlement.
- **Automated Test Suite**:
  - 17 comprehensive integration tests covering Auth, Google Drive, Projects, Curation, Invoices, bKash, Stripe, and Google Pay with 100% passing rate in `1.39s`.

---

## Project Structure

```
aperturetube/
├── lib/                             # Flutter Cross-Platform Frontend
│   ├── models/                      # Dart domain models
│   ├── screens/                     # AppShell, Login, Projects, Invoices, Community, Profile
│   ├── state/                       # AppState ChangeNotifier
│   ├── theme/                       # AppPalette (ThemeExtension), AppTheme, AppTypography
│   ├── widgets/                     # PaymentModal, AppHeader, ProjectCard, etc.
│   └── main.dart                    # Application entry point
├── backend/                         # FastAPI High-Performance Backend
│   ├── app/
│   │   ├── models/                  # SQLAlchemy 2.0 async models
│   │   ├── routers/                 # Modular API routers (auth, drive, projects, payments, etc.)
│   │   ├── schemas/                 # Pydantic v2 validation schemas
│   │   ├── services/                # Google Drive v3, bKash, Stripe, Google Pay services
│   │   ├── config.py                # Pydantic Settings
│   │   ├── database.py              # Async engine & sessionmaker
│   │   └── init_db.py               # Auto-seeder for development
│   ├── tests/                       # Pytest asynchronous integration tests
│   ├── main.py                      # FastAPI app entry with CORS & lifespan
│   ├── pytest.ini                   # Pytest configuration
│   └── requirements.txt             # Backend dependencies
└── README.md
```

---

## Quickstart Guide

### 1. Run the FastAPI Backend
```bash
cd backend

# Create virtual environment (Python 3.11+)
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run pytest test suite
pytest tests/ -v

# Start development server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```
- **Interactive Swagger UI**: [http://localhost:8000/docs](http://localhost:8000/docs)
- **ReDoc Documentation**: [http://localhost:8000/redoc](http://localhost:8000/redoc)

### 2. Run the Flutter Frontend
```bash
# In the root project directory:
flutter pub get

# Run on Chrome Web
flutter run -d chrome

# Run on macOS Desktop
flutter run -d macos
```

---

## API Endpoints Overview

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/` | API Status & Active Modules |
| `POST` | `/api/v1/auth/login` | Studio Pro credential authentication |
| `POST` | `/api/v1/auth/token-access` | Client VIP token access (`MONACO-2024-VIP`) |
| `GET` | `/api/v1/projects` | List projects with status filtering |
| `GET` | `/api/v1/projects/metrics/summary` | 2x2 Bento telemetry overview |
| `PATCH`| `/api/v1/projects/{proj_id}/photos/{photo_id}` | Toggle curation, favorite, or retouch |
| `GET` | `/api/v1/drive/vault-status` | Google Drive vault telemetry |
| `POST` | `/api/v1/drive/tokens/generate` | Generate HMAC-SHA256 download token |
| `GET` | `/api/v1/drive/tokens/verify/{token}` | Verify token & return unshielded download URLs |
| `POST` | `/api/v1/payments/bkash/create` | Initiate bKash Tokenized Checkout |
| `POST` | `/api/v1/payments/bkash/execute` | Execute bKash payment & unlock escrow |
| `POST` | `/api/v1/payments/stripe/create-intent` | Create Stripe PaymentIntent |
| `POST` | `/api/v1/payments/google-pay/process` | Process Google Pay 1-Tap settlement |
| `GET` | `/api/v1/community/artisans` | Browse artisan directory by discipline |

---

## License
MIT License © 2026 Shakil Ahmed
