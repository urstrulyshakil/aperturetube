from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import Base, engine, AsyncSessionLocal
from app.models.user import User
from app.models.project import Project, PhotoCapture
from app.models.invoice import Invoice, InvoiceLineItem
from app.models.artisan import Artisan

async def init_database():
    """Initializes schema and seeds realistic data matching the Flutter app."""
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async with AsyncSessionLocal() as db:
        # 1. Seed Studio Pro User
        user_check = await db.execute(select(User).limit(1))
        if not user_check.scalars().first():
            db.add(
                User(
                    id="user_elena",
                    email="elena@luxframe.studio",
                    hashed_password="plain:MasterKey2026!",
                    full_name="Elena Vance",
                    role="photographer",
                    role_title="Principal Visual Architect",
                    avatar_url="https://lh3.googleusercontent.com/aida/AEtjO1W2d40aK4i2E3OdQabT3q2MX50QbYaBikw3sAiiNICxgg5kC9Q_9BFpBK5phvLLC2Ds0r2o0yI0_gYhzO9H2dQTP807oFA_V6cAhVfPk6AR1nOlU_dHgWuog7jbVj45B3DrmJ1LVtFB9_ujFQ_2Qs1tggkQ5gDCtFA-vN-LwjLqob6tt3QJFr2HHS8viGp25fiSeXQNonm8-mhL5iR73VrkyDsgFq0-eja2qRX2lTbatHOT58mTs1AaMfltDpZDVZqAlMjI6lyBgg",
                    rating=4.98,
                    reviews_count=142,
                    drive_sync_path="Google Drive/ApertureTube_Vault/RAW_Masters",
                    storage_used_tb=3.4,
                    storage_total_tb=10.0,
                    auto_sync_raw=True,
                    payout_gateway="bKash Merchant Direct",
                    default_currency="USD ($)",
                    lut_mode="darkCinema",
                )
            )

        # 2. Seed Projects & Photos
        proj_check = await db.execute(select(Project).limit(1))
        if not proj_check.scalars().first():
            p1 = Project(
                id="proj_01",
                title="Royal Bengal Wedding • Curation Batch",
                client_name="Farhan & Anika",
                package_description="Full-Day 4K Masters + Uncompressed RAW Footage",
                camera_gear="Sony FX6 • RED Komodo • G-Master 50mm f/1.2",
                status="selection",
                selected_photos=128,
                total_photos=140,
                drive_sync_size="128 GB RAW",
                due_date="Due Nov 12",
                image_url="https://lh3.googleusercontent.com/aida-public/AB6AXuDTGZ7uNUZtDneGtBKvXVIwhtXINg3M1eGtn0ggI53LlxbO4GtHiIB3QcuJ_GcbYrVNSM6EYj8OWz6r3Wf-6b_0B-1iXqaXlMrAsMKRCRAzbYCLzQHQvkYNQBgNTSKKuAQlUSbsOVx4msn9r579r9eVlJR9R1wKDCGON8kS7jV_q9RCFE2jLDWTGVVWEZppnlXg3YT7s0MfXzkoXshMdOEIfbFckqvjE4GVNnZ-leBSCwxNMjprYfOq",
            )
            p2 = Project(
                id="proj_02",
                title="Sommer & Julian Editorial • Tuscany",
                client_name="Sommer & Julian",
                package_description="Golden Hour Ceremony & Intimate Fine-Art Reception",
                camera_gear="Leica M11 • 50mm Summilux • 35mm Summicron",
                status="inProgress",
                selected_photos=278,
                total_photos=320,
                drive_sync_size="64 GB RAW",
                due_date="Due in 2d",
                image_url="https://lh3.googleusercontent.com/aida-public/AB6AXuDPqF5JWIPrQulRaFSfxzeaWN7_41BAHywyGQZJrw2nqhcwa9yvuGI19f8oq6GgJgGoFXC8OOd3j6pGejdtwsfws6XcLgMJo9Heps05k6cRA73sdRsTfREdfeGKkv9VGmLV9ag1IkThPN1a5IJKGVK6fXskuplshvlB9OckWZMIpo-NFkFb_LnC4xYUTLXhkeEKgoRvIY34OwUfsjq0Q1ZeCaLLbFqsR4u7sPy5sozusQX-PjwlOzuz",
            )
            p3 = Project(
                id="proj_03",
                title="Clara Vance Studio Portrait & Editorial",
                client_name="Clara Vance",
                package_description="Haute Couture Studio Shoot with Calibrated Display LUT",
                camera_gear="Hasselblad X2D 100C • XCD 90mm f/2.5",
                status="delivered",
                selected_photos=94,
                total_photos=94,
                drive_sync_size="42 GB RAW",
                due_date="Completed Oct 28",
                image_url="https://lh3.googleusercontent.com/aida-public/AB6AXuALorL7rXBotULSsIHGDks_HTVYCaT18XrQuK6GYNy45f6ialAxxmXMvSHsjLH89F4lXwM7fyzn07w7SJ0L3RAS5xI-DejCs8OtZgNPq88eA4nCXJ8btL_3qD3iaTwY1wSC05-DRqcBK55E6Z_eILJfcwPJEySxTqKpLojhu9v1jTnFe-I_EsNzC9b-CA-UH4RMtIIFxvWubqy5ICwkrSESlZj-a0e02ZIUIBy8keKhSVRXdNR-_EIy",
            )
            p4 = Project(
                id="proj_04",
                title="Monaco Grand Prix VIP Yacht Gala",
                client_name="Aston Martin Racing",
                package_description="High-Speed Telephoto RAWs + Night Gala Curation",
                camera_gear="Sony A1 • FE 400mm f/2.8 GM • FX3 Rig",
                status="inProgress",
                selected_photos=412,
                total_photos=550,
                drive_sync_size="190 GB RAW",
                due_date="Due Nov 20",
                image_url="https://lh3.googleusercontent.com/aida-public/AB6AXuBcBP5iLsfiuzvaSfxO-LJ3jY3wb8dBqfYK63b7rhgcqW5Jeo18X2svLV00pbHTkzeqd-tLIKZzMAey_SSKiErlO0Sa2SP-GL_wMbno5VJ4Rr9uyjBml6Rifz9p-84a02o87JqcTo2sOCk_bXe7B99JV3FdTzWHzKvFVeF_gbEkh0ZaJLXpL5f1PTycHxNyp4qDvxp6XdddKTUUV9ZCEJnB2Qg4EJZiqMGnYMk2e4lbYhRAw0glY_9p",
            )
            db.add_all([p1, p2, p3, p4])

            # Seed sample photos
            db.add_all([
                PhotoCapture(
                    id="photo_01",
                    project_id="proj_01",
                    title="Ceremonial Royal Portrait 01",
                    image_url=p1.image_url,
                    camera="Sony FX6 Cinema",
                    lens="FE 50mm f/1.2 GM",
                    aperture="ƒ/1.2",
                    shutter="1/800s",
                    iso="ISO 100",
                    focal_length="50mm",
                    is_selected=True,
                    is_favorite=True,
                ),
                PhotoCapture(
                    id="photo_02",
                    project_id="proj_02",
                    title="Tuscany Sunset Master",
                    image_url=p2.image_url,
                    camera="Leica M11",
                    lens="50mm Summilux-M f/1.4 ASPH.",
                    aperture="ƒ/1.4",
                    shutter="1/1250s",
                    iso="ISO 64",
                    focal_length="50mm",
                    is_selected=True,
                ),
            ])

        # 3. Seed Active Escrow Invoice
        inv_check = await db.execute(select(Invoice).limit(1))
        if not inv_check.scalars().first():
            inv = Invoice(
                id="inv_01",
                invoice_number="#AT-2025-0891",
                token_code="AT-891-XK94",
                target_drive_email="farhan.archive@gmail.com",
                raw_storage_size="128 GB RAW",
                master_captures_count="1,420 High-Res Masters",
                due_date="DUE NOV 12, 2025",
                tax_amount=90.0,
                total_usd=1890.0,
                total_bdt="৳225,750 BDT",
                is_settled=False,
            )
            db.add(inv)
            db.add_all([
                InvoiceLineItem(
                    id="item_01",
                    invoice_id=inv.id,
                    title="Full-Day Wedding Cinematography",
                    subtitle="4K DCI + Uncompressed RAW Footage (Dual Cams)",
                    amount=1150.00,
                ),
                InvoiceLineItem(
                    id="item_02",
                    invoice_id=inv.id,
                    title="RAW Drone Aerial Reels",
                    subtitle="8K CineDNG Sequences • Certified Pilot Delivery",
                    amount=350.00,
                ),
                InvoiceLineItem(
                    id="item_03",
                    invoice_id=inv.id,
                    title="Master Retouching Package",
                    subtitle="150 Curated Hero Selections with High-Dynamic Grading",
                    amount=200.00,
                ),
                InvoiceLineItem(
                    id="item_04",
                    invoice_id=inv.id,
                    title="Encrypted Cloud Vault & Fast CDN",
                    subtitle="1 Year Redundant Archival & Instant Google Drive API",
                    amount=100.00,
                ),
            ])

        # 4. Seed Artisans
        art_check = await db.execute(select(Artisan).limit(1))
        if not art_check.scalars().first():
            db.add_all([
                Artisan(
                    id="artisan_01",
                    name="Tahsin Rahman",
                    specialty="Wedding & Cinematography",
                    category="Wedding",
                    rating=4.98,
                    reviews_count=128,
                    starting_price="$1,800",
                    availability="Available This Week",
                    gear_kit="Sony FX6 • RED Komodo • G-Master 24-70mm f/2.8 GM II",
                    avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuCgJNwpYdqRETYmJHFJ2iXsIoMHhSSKBWkmyh0q5-s3TyzEOg_Ds1aCohUYqVzU1xciEtOdLw3-yIPoEzAewufP8K-aJM0Gf6CWxgNEtF3_dmpIIDkg12Z-v9tZCQ_ZZEjl7Co7OqdQTejhCjdeY-Uen8qVn_DcJFHeHSHi4gXQt37qHdsHb-zaP6cQfuBWevR4i7hDz55pezA-awZe_YHJgZEH9_8LALcGOxrRANAuIDlFlHy5ewbd",
                    cover_image_url="https://lh3.googleusercontent.com/aida-public/AB6AXuDTGZ7uNUZtDneGtBKvXVIwhtXINg3M1eGtn0ggI53LlxbO4GtHiIB3QcuJ_GcbYrVNSM6EYj8OWz6r3Wf-6b_0B-1iXqaXlMrAsMKRCRAzbYCLzQHQvkYNQBgNTSKKuAQlUSbsOVx4msn9r579r9eVlJR9R1wKDCGON8kS7jV_q9RCFE2jLDWTGVVWEZppnlXg3YT7s0MfXzkoXshMdOEIfbFckqvjE4GVNnZ-leBSCwxNMjprYfOq",
                    showreel_url="https://aperturetube.app/reels/tahsin_4k.mp4",
                ),
                Artisan(
                    id="artisan_02",
                    name="Samantha Croft",
                    specialty="Haute Couture & Editorial Fashion",
                    category="Editorial",
                    rating=4.95,
                    reviews_count=94,
                    starting_price="$2,200",
                    availability="Available Nov 15",
                    gear_kit="Hasselblad X2D 100C • XCD 90mm f/2.5 • Broncolor Studio Lighting",
                    avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuB_naCn2KyeVzS-iQCjwgX5TquEB09BivK6fiVQv7M7tgqMzwWclbW8KZp_Nc36P57LKYhiD1mbfZY_crwyCk88xiZuhTF-0jgcGrlk_cRb1ptLrwC5-KPWaWY66b6xiK8MK5TRXo2V6CUmr6e8xQIg0y69eCOj3BCaoOiMKk5Z1PPubnVjvxpd4Fm7RHiEvmR-cridS5Ve1RHgvGrTJmgNQeHTiG1tSwva2m8kfQx59jG3gp1sfsWH",
                    cover_image_url="https://lh3.googleusercontent.com/aida-public/AB6AXuDPqF5JWIPrQulRaFSfxzeaWN7_41BAHywyGQZJrw2nqhcwa9yvuGI19f8oq6GgJgGoFXC8OOd3j6pGejdtwsfws6XcLgMJo9Heps05k6cRA73sdRsTfREdfeGKkv9VGmLV9ag1IkThPN1a5IJKGVK6fXskuplshvlB9OckWZMIpo-NFkFb_LnC4xYUTLXhkeEKgoRvIY34OwUfsjq0Q1ZeCaLLbFqsR4u7sPy5sozusQX-PjwlOzuz",
                ),
                Artisan(
                    id="artisan_03",
                    name="Marcus Vance",
                    specialty="Cinema FPV & Heavy-Lift Aerial",
                    category="Drone",
                    rating=4.92,
                    reviews_count=76,
                    starting_price="$1,400",
                    availability="Immediate Booking",
                    gear_kit="DJI Inspire 3 • 8K ProRes RAW • Full FPV Chase Rig",
                    avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuAQ_-t6CqEl0Q0NiLbQ_ueg5ySA2U8SWxR2KbZjYkmm0GFm5PBZMSg4QlaYARz9UfY3AnL5oZLFuKvAUnqW4WA86Huy-71RNFN5ZFI9KuM3VJ_seYe9hGUba0BBxOyyr358cAntdmvYOWG0nvrSmXehDv6Dm2Cfhf0sjnShMPgF-xgvdKT2puSdrAfwUAGsf2Sug3gCh0qdWjd9VUTgH35JUI09IUgLE6ZJti6oPy-nLTlmO63iJ1KH",
                    cover_image_url="https://lh3.googleusercontent.com/aida-public/AB6AXuALorL7rXBotULSsIHGDks_HTVYCaT18XrQuK6GYNy45f6ialAxxmXMvSHsjLH89F4lXwM7fyzn07w7SJ0L3RAS5xI-DejCs8OtZgNPq88eA4nCXJ8btL_3qD3iaTwY1wSC05-DRqcBK55E6Z_eILJfcwPJEySxTqKpLojhu9v1jTnFe-I_EsNzC9b-CA-UH4RMtIIFxvWubqy5ICwkrSESlZj-a0e02ZIUIBy8keKhSVRXdNR-_EIy",
                ),
                Artisan(
                    id="artisan_04",
                    name="Farhana Chowdhury",
                    specialty="Fine-Art Floral & Macro Lenscraft",
                    category="Macro",
                    rating=4.99,
                    reviews_count=110,
                    starting_price="$950",
                    availability="Available Dec 01",
                    gear_kit="Canon R5 C • RF 100mm f/2.8L Macro IS USM • Focus Stacking Rig",
                    avatar_url="https://lh3.googleusercontent.com/aida-public/AB6AXuBcBP5iLsfiuzvaSfxO-LJ3jY3wb8dBqfYK63b7rhgcqW5Jeo18X2svLV00pbHTkzeqd-tLIKZzMAey_SSKiErlO0Sa2SP-GL_wMbno5VJ4Rr9uyjBml6Rifz9p-84a02o87JqcTo2sOCk_bXe7B99JV3FdTzWHzKvFVeF_gbEkh0ZaJLXpL5f1PTycHxNyp4qDvxp6XdddKTUUV9ZCEJnB2Qg4EJZiqMGnYMk2e4lbYhRAw0glY_9p",
                    cover_image_url="https://lh3.googleusercontent.com/aida-public/AB6AXuCgJNwpYdqRETYmJHFJ2iXsIoMHhSSKBWkmyh0q5-s3TyzEOg_Ds1aCohUYqVzU1xciEtOdLw3-yIPoEzAewufP8K-aJM0Gf6CWxgNEtF3_dmpIIDkg12Z-v9tZCQ_ZZEjl7Co7OqdQTejhCjdeY-Uen8qVn_DcJFHeHSHi4gXQt37qHdsHb-zaP6cQfuBWevR4i7hDz55pezA-awZe_YHJgZEH9_8LALcGOxrRANAuIDlFlHy5ewbd",
                ),
            ])

        await db.commit()
