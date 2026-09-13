import 'package:flutter/material.dart';
import '../models/artisan_profile.dart';
import '../theme/app_palette.dart';
import '../theme/app_typography.dart';
import '../widgets/app_header.dart';
import '../widgets/status_pills.dart';

class CommunityScreen extends StatefulWidget {
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLogoTap;

  const CommunityScreen({
    super.key,
    this.onAvatarTap,
    this.onLogoTap,
  });

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String selectedDiscipline = 'All';
  final Set<String> bookmarkedIds = {};

  final List<String> disciplines = const [
    'All',
    'Wedding',
    'Editorial',
    'Drone',
    'Macro',
    'Commercial',
  ];

  final List<ArtisanProfile> artisans = const [
    ArtisanProfile(
      id: 'artisan_01',
      name: 'Tahsin Rahman',
      specialty: 'Wedding & Cinematography',
      category: 'Wedding',
      rating: 4.98,
      reviewsCount: 128,
      startingPrice: '\$1,800',
      availability: 'Available This Week',
      gearKit: 'Sony FX6 • RED Komodo • G-Master 24-70mm f/2.8 GM II',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCgJNwpYdqRETYmJHFJ2iXsIoMHhSSKBWkmyh0q5-s3TyzEOg_Ds1aCohUYqVzU1xciEtOdLw3-yIPoEzAewufP8K-aJM0Gf6CWxgNEtF3_dmpIIDkg12Z-v9tZCQ_ZZEjl7Co7OqdQTejhCjdeY-Uen8qVn_DcJFHeHSHi4gXQt37qHdsHb-zaP6cQfuBWevR4i7hDz55pezA-awZe_YHJgZEH9_8LALcGOxrRANAuIDlFlHy5ewbd',
      coverImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDTGZ7uNUZtDneGtBKvXVIwhtXINg3M1eGtn0ggI53LlxbO4GtHiIB3QcuJ_GcbYrVNSM6EYj8OWz6r3Wf-6b_0B-1iXqaXlMrAsMKRCRAzbYCLzQHQvkYNQBgNTSKKuAQlUSbsOVx4msn9r579r9eVlJR9R1wKDCGON8kS7jV_q9RCFE2jLDWTGVVWEZppnlXg3YT7s0MfXzkoXshMdOEIfbFckqvjE4GVNnZ-leBSCwxNMjprYfOq',
    ),
    ArtisanProfile(
      id: 'artisan_02',
      name: 'Samantha Croft',
      specialty: 'Haute Couture & Editorial Fashion',
      category: 'Editorial',
      rating: 4.95,
      reviewsCount: 94,
      startingPrice: '\$2,200',
      availability: 'Available Nov 15',
      gearKit: 'Hasselblad X2D 100C • XCD 90mm f/2.5 • Broncolor Studio Lighting',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB_naCn2KyeVzS-iQCjwgX5TquEB09BivK6fiVQv7M7tgqMzwWclbW8KZp_Nc36P57LKYhiD1mbfZY_crwyCk88xiZuhTF-0jgcGrlk_cRb1ptLrwC5-KPWaWY66b6xiK8MK5TRXo2V6CUmr6e8xQIg0y69eCOj3BCaoOiMKk5Z1PPubnVjvxpd4Fm7RHiEvmR-cridS5Ve1RHgvGrTJmgNQeHTiG1tSwva2m8kfQx59jG3gp1sfsWH',
      coverImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDPqF5JWIPrQulRaFSfxzeaWN7_41BAHywyGQZJrw2nqhcwa9yvuGI19f8oq6GgJgGoFXC8OOd3j6pGejdtwsfws6XcLgMJo9Heps05k6cRA73sdRsTfREdfeGKkv9VGmLV9ag1IkThPN1a5IJKGVK6fXskuplshvlB9OckWZMIpo-NFkFb_LnC4xYUTLXhkeEKgoRvIY34OwUfsjq0Q1ZeCaLLbFqsR4u7sPy5sozusQX-PjwlOzuz',
    ),
    ArtisanProfile(
      id: 'artisan_03',
      name: 'Marcus Vance',
      specialty: 'Cinema FPV & Heavy-Lift Aerial',
      category: 'Drone',
      rating: 4.92,
      reviewsCount: 76,
      startingPrice: '\$1,400',
      availability: 'Immediate Booking',
      gearKit: 'DJI Inspire 3 • 8K ProRes RAW • Full FPV Chase Rig',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAQ_-t6CqEl0Q0NiLbQ_ueg5ySA2U8SWxR2KbZjYkmm0GFm5PBZMSg4QlaYARz9UfY3AnL5oZLFuKvAUnqW4WA86Huy-71RNFN5ZFI9KuM3VJ_seYe9hGUba0BBxOyyr358cAntdmvYOWG0nvrSmXehDv6Dm2Cfhf0sjnShMPgF-xgvdKT2puSdrAfwUAGsf2Sug3gCh0qdWjd9VUTgH35JUI09IUgLE6ZJti6oPy-nLTlmO63iJ1KH',
      coverImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuALorL7rXBotULSsIHGDks_HTVYCaT18XrQuK6GYNy45f6ialAxxmXMvSHsjLH89F4lXwM7fyzn07w7SJ0L3RAS5xI-DejCs8OtZgNPq88eA4nCXJ8btL_3qD3iaTwY1wSC05-DRqcBK55E6Z_eILJfcwPJEySxTqKpLojhu9v1jTnFe-I_EsNzC9b-CA-UH4RMtIIFxvWubqy5ICwkrSESlZj-a0e02ZIUIBy8keKhSVRXdNR-_EIy',
    ),
    ArtisanProfile(
      id: 'artisan_04',
      name: 'Farhana Chowdhury',
      specialty: 'Fine-Art Floral & Macro Lenscraft',
      category: 'Macro',
      rating: 4.99,
      reviewsCount: 110,
      startingPrice: '\$950',
      availability: 'Available Dec 01',
      gearKit: 'Canon R5 C • RF 100mm f/2.8L Macro IS USM • Focus Stacking Rig',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBcBP5iLsfiuzvaSfxO-LJ3jY3wb8dBqfYK63b7rhgcqW5Jeo18X2svLV00pbHTkzeqd-tLIKZzMAey_SSKiErlO0Sa2SP-GL_wMbno5VJ4Rr9uyjBml6Rifz9p-84a02o87JqcTo2sOCk_bXe7B99JV3FdTzWHzKvFVeF_gbEkh0ZaJLXpL5f1PTycHxNyp4qDvxp6XdddKTUUV9ZCEJnB2Qg4EJZiqMGnYMk2e4lbYhRAw0glY_9p',
      coverImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCgJNwpYdqRETYmJHFJ2iXsIoMHhSSKBWkmyh0q5-s3TyzEOg_Ds1aCohUYqVzU1xciEtOdLw3-yIPoEzAewufP8K-aJM0Gf6CWxgNEtF3_dmpIIDkg12Z-v9tZCQ_ZZEjl7Co7OqdQTejhCjdeY-Uen8qVn_DcJFHeHSHi4gXQt37qHdsHb-zaP6cQfuBWevR4i7hDz55pezA-awZe_YHJgZEH9_8LALcGOxrRANAuIDlFlHy5ewbd',
    ),
  ];

  List<ArtisanProfile> get filteredArtisans {
    if (selectedDiscipline == 'All') return artisans;
    return artisans.where((a) => a.category == selectedDiscipline).toList();
  }

  void _showBookingSheet(ArtisanProfile artisan) {
    final p = context.palette;
    showModalBottomSheet(
      context: context,
      backgroundColor: p.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: p.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(artisan.avatarUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artisan.name,
                      style: AppTypography.headlineSmall.copyWith(
                        color: p.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      artisan.specialty,
                      style: AppTypography.bodySmall.copyWith(
                        color: p.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: p.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.borderSubtle, width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ApertureTube Escrow Protection',
                    style: AppTypography.labelMedium.copyWith(
                      color: p.textGold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your deposit is securely held in escrow until raw deliverables and curated edits are approved in your Google Drive Vault.',
                    style: AppTypography.bodySmall.copyWith(
                      color: p.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Session booking request sent to ${artisan.name} with Escrow Protection!'),
                    backgroundColor: p.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: p.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Confirm Booking with Escrow (${artisan.startingPrice})',
                style: AppTypography.labelLarge.copyWith(
                  color: p.onPrimaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareSheet(ArtisanProfile artisan) {
    final p = context.palette;
    showModalBottomSheet(
      context: context,
      backgroundColor: p.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: p.borderSubtle, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Share ${artisan.name}\'s Profile',
              style: AppTypography.headlineSmall.copyWith(fontSize: 17, color: p.textPrimary),
            ),
            const SizedBox(height: 14),
            _buildShareOption(ctx, Icons.link, 'Copy Profile Link', 'aperturetube.app/artisan/${artisan.id}'),
            const SizedBox(height: 10),
            _buildShareOption(ctx, Icons.message, 'Share via Message', 'Copied link for messaging apps'),
            const SizedBox(height: 10),
            _buildShareOption(ctx, Icons.email_outlined, 'Share via Email', 'Draft email with profile summary'),
            const SizedBox(height: 10),
            _buildShareOption(ctx, Icons.share, 'Share to Instagram Story', 'Optimized story card generated'),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(BuildContext ctx, IconData icon, String label, String feedback) {
    final p = context.palette;
    return InkWell(
      onTap: () {
        Navigator.pop(ctx);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: p.surfaceElevated,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.check_circle, color: p.statusSuccess, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(feedback, style: AppTypography.bodySmall.copyWith(color: p.textPrimary))),
              ],
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: p.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: p.borderSubtle, width: 0.8),
        ),
        child: Row(
          children: [
            Icon(icon, color: p.primary, size: 20),
            const SizedBox(width: 12),
            Text(label, style: AppTypography.labelMedium.copyWith(color: p.textPrimary)),
            const Spacer(),
            Icon(Icons.chevron_right, color: p.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }

  void _showReelDialog(ArtisanProfile artisan) {
    final p = context.palette;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: p.primary, width: 1.5),
        ),
        title: Row(
          children: [
            Icon(Icons.play_circle, color: p.primary, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${artisan.name} — 4K Showreel',
                style: AppTypography.headlineSmall.copyWith(fontSize: 16, color: p.textPrimary),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(artisan.coverImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.7),
                    border: Border.all(color: p.primary, width: 2),
                  ),
                  child: Icon(Icons.play_arrow, color: p.primary, size: 28),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Gear: ${artisan.gearKit}',
              style: AppTypography.monoSmall.copyWith(color: p.textSecondary, fontSize: 10),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: AppTypography.labelMedium.copyWith(color: p.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showBookingSheet(artisan);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: p.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Book Session', style: AppTypography.labelMedium.copyWith(color: p.onPrimaryDark)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.surfaceCanvas,
      appBar: AppHeader(
        titleTag: 'Community',
        onAvatarTap: widget.onAvatarTap,
        onLogoTap: widget.onLogoTap,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search & Filter Ribbon
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: p.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: p.borderSubtle, width: 0.8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Icon(Icons.search, color: p.textSecondary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: AppTypography.bodyMedium.copyWith(color: p.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Search master cinematographers, gigs...',
                              hintStyle: AppTypography.bodySmall.copyWith(
                                color: p.textTertiary,
                                fontSize: 12,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: p.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.borderSubtle, width: 0.8),
                  ),
                  child: Icon(Icons.tune, color: p.textGold, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Discipline Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: disciplines.map((discipline) {
                  final isSelected = selectedDiscipline == discipline;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedDiscipline = discipline),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                        decoration: BoxDecoration(
                          color: isSelected ? p.primary : p.surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? p.primary : p.borderSubtle,
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          discipline.toUpperCase(),
                          style: AppTypography.monoSmall.copyWith(
                            color: isSelected ? p.onPrimaryDark : p.textSecondary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Curated Showcase Spotlight Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.surfaceCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: p.borderSubtle, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: p.primary.withValues(alpha: 0.08),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified, color: p.primary, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'GUILD SPOTLIGHT',
                        style: AppTypography.monoSmall.copyWith(
                          color: p.textGold,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Capturing Memories',
                    style: AppTypography.headlineSmall.copyWith(
                      fontSize: 18,
                      color: p.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Book elite visual storytellers worldwide with escrow protection and RAW color grading pipeline.',
                    style: AppTypography.bodySmall.copyWith(
                      color: p.textSecondary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Overlapping Avatars Stack
                      Row(
                        children: [
                          _buildStackedAvatar(artisans[0].avatarUrl, 0),
                          Transform.translate(offset: const Offset(-8, 0), child: _buildStackedAvatar(artisans[1].avatarUrl, 1)),
                          Transform.translate(offset: const Offset(-16, 0), child: _buildStackedAvatar(artisans[2].avatarUrl, 2)),
                          Transform.translate(
                            offset: const Offset(-24, 0),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: p.surfaceElevated,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '+48',
                                  style: AppTypography.monoSmall.copyWith(
                                    fontSize: 8,
                                    color: p.textGold,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Top Rated',
                            style: AppTypography.labelSmall.copyWith(
                              color: p.textGold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward, color: p.textGold, size: 14),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Featured Artisans Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(color: p.primary, borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Featured Artisans',
                      style: AppTypography.headlineSmall.copyWith(fontSize: 17, color: p.textPrimary),
                    ),
                  ],
                ),
                Text(
                  '${filteredArtisans.length} VERIFIED ONLINE',
                  style: AppTypography.monoSmall.copyWith(color: p.textGold, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Artisans Vertical Feed
            ListView.separated(
              itemCount: filteredArtisans.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildArtisanCard(filteredArtisans[index]);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedAvatar(String url, int index) {
    final p = context.palette;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: p.surfaceCard, width: 2),
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(color: p.surfaceElevated),
        ),
      ),
    );
  }

  Widget _buildArtisanCard(ArtisanProfile artisan) {
    final p = context.palette;
    final isBookmarked = bookmarkedIds.contains(artisan.id);

    return Container(
      decoration: BoxDecoration(
        color: p.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image Carousel
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                    artisan.coverImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: p.surfaceContainer),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        p.surfaceCard.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),
              ),
              // Top Badges
              Positioned(
                top: 10,
                left: 12,
                child: StatusPill(
                  label: artisan.availability,
                  backgroundColor: p.surfaceContainerLowest.withValues(alpha: 0.85),
                  textColor: p.statusSuccess,
                  hasPulseDot: true,
                ),
              ),
              Positioned(
                top: 8,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isBookmarked) {
                        bookmarkedIds.remove(artisan.id);
                      } else {
                        bookmarkedIds.add(artisan.id);
                      }
                    });
                  },
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: p.surfaceContainerLowest.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? p.primary : p.textPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ),
              // Bottom Header Float with Avatar
              Positioned(
                bottom: 8,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: p.primary, width: 1.5),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              artisan.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(color: p.surfaceElevated),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  artisan.name,
                                  style: AppTypography.labelLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: p.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.stars, color: p.textGold, size: 15),
                              ],
                            ),
                            Text(
                              artisan.specialty,
                              style: AppTypography.bodySmall.copyWith(
                                color: p.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'STARTING AT',
                          style: AppTypography.monoSmall.copyWith(
                            fontSize: 8.5,
                            color: p.textTertiary,
                          ),
                        ),
                        Text(
                          artisan.startingPrice,
                          style: AppTypography.monoLarge.copyWith(
                            color: p.textGold,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Card Details
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: p.primary, size: 15),
                        const SizedBox(width: 4),
                        Text(
                          artisan.rating.toString(),
                          style: AppTypography.monoSmall.copyWith(color: p.textGold, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${artisan.reviewsCount} reviews)',
                          style: AppTypography.bodySmall.copyWith(
                            color: p.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      artisan.category,
                      style: AppTypography.monoSmall.copyWith(color: p.textGold, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: p.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: p.borderSubtle, width: 0.6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt, color: p.textSecondary, size: 13),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          artisan.gearKit,
                          style: AppTypography.monoSmall.copyWith(fontSize: 10, color: p.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Action CTA Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showReelDialog(artisan),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: p.surfaceElevated,
                          side: BorderSide(color: p.borderSubtle, width: 0.8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, color: p.textGold, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'View Reel',
                              style: AppTypography.labelSmall.copyWith(
                                color: p.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Share icon button — use GestureDetector to avoid mouse_tracker assertion
                    GestureDetector(
                      onTap: () => _showShareSheet(artisan),
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: p.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: p.borderSubtle, width: 0.8),
                        ),
                        child: Center(
                          child: Icon(Icons.share_outlined, color: p.textSecondary, size: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showBookingSheet(artisan),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          'Book with Escrow',
                          style: AppTypography.labelSmall.copyWith(
                            color: p.onPrimaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
