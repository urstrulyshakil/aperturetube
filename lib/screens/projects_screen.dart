import 'package:flutter/material.dart';
import '../models/project_item.dart';
import '../theme/app_palette.dart';
import '../theme/app_typography.dart';
import '../widgets/app_header.dart';
import '../widgets/photo_lightbox.dart';
import '../widgets/status_pills.dart';

class ProjectsScreen extends StatefulWidget {
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLogoTap;

  const ProjectsScreen({
    super.key,
    this.onAvatarTap,
    this.onLogoTap,
  });

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String selectedFilter = 'all';

  final List<ProjectItem> projects = const [
    ProjectItem(
      id: 'proj_01',
      title: 'Royal Bengal Wedding • Curation Batch',
      clientName: 'Farhan & Anika',
      packageDescription: 'Full-Day 4K Masters + Uncompressed RAW Footage',
      cameraGear: 'Sony FX6 • RED Komodo • G-Master 50mm f/1.2',
      status: ProjectStatus.selection,
      selectedPhotos: 128,
      totalPhotos: 140,
      driveSyncSize: '128 GB RAW',
      dueDate: 'Due Nov 12',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDTGZ7uNUZtDneGtBKvXVIwhtXINg3M1eGtn0ggI53LlxbO4GtHiIB3QcuJ_GcbYrVNSM6EYj8OWz6r3Wf-6b_0B-1iXqaXlMrAsMKRCRAzbYCLzQHQvkYNQBgNTSKKuAQlUSbsOVx4msn9r579r9eVlJR9R1wKDCGON8kS7jV_q9RCFE2jLDWTGVVWEZppnlXg3YT7s0MfXzkoXshMdOEIfbFckqvjE4GVNnZ-leBSCwxNMjprYfOq',
    ),
    ProjectItem(
      id: 'proj_02',
      title: 'Sommer & Julian Editorial • Tuscany',
      clientName: 'Sommer & Julian',
      packageDescription: 'Golden Hour Ceremony & Intimate Fine-Art Reception',
      cameraGear: 'Leica M11 • 50mm Summilux • 35mm Summicron',
      status: ProjectStatus.inProgress,
      selectedPhotos: 278,
      totalPhotos: 320,
      driveSyncSize: '64 GB RAW',
      dueDate: 'Due in 2d',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDPqF5JWIPrQulRaFSfxzeaWN7_41BAHywyGQZJrw2nqhcwa9yvuGI19f8oq6GgJgGoFXC8OOd3j6pGejdtwsfws6XcLgMJo9Heps05k6cRA73sdRsTfREdfeGKkv9VGmLV9ag1IkThPN1a5IJKGVK6fXskuplshvlB9OckWZMIpo-NFkFb_LnC4xYUTLXhkeEKgoRvIY34OwUfsjq0Q1ZeCaLLbFqsR4u7sPy5sozusQX-PjwlOzuz',
    ),
    ProjectItem(
      id: 'proj_03',
      title: 'Clara Vance Studio Portrait & Editorial',
      clientName: 'Clara Vance',
      packageDescription: 'Haute Couture Studio Shoot with Calibrated Display LUT',
      cameraGear: 'Hasselblad X2D 100C • XCD 90mm f/2.5',
      status: ProjectStatus.delivered,
      selectedPhotos: 94,
      totalPhotos: 94,
      driveSyncSize: '42 GB RAW',
      dueDate: 'Completed Oct 28',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuALorL7rXBotULSsIHGDks_HTVYCaT18XrQuK6GYNy45f6ialAxxmXMvSHsjLH89F4lXwM7fyzn07w7SJ0L3RAS5xI-DejCs8OtZgNPq88eA4nCXJ8btL_3qD3iaTwY1wSC05-DRqcBK55E6Z_eILJfcwPJEySxTqKpLojhu9v1jTnFe-I_EsNzC9b-CA-UH4RMtIIFxvWubqy5ICwkrSESlZj-a0e02ZIUIBy8keKhSVRXdNR-_EIy',
    ),
    ProjectItem(
      id: 'proj_04',
      title: 'Monaco Grand Prix VIP Yacht Gala',
      clientName: 'Aston Martin Racing',
      packageDescription: 'High-Speed Telephoto RAWs + Night Gala Curation',
      cameraGear: 'Sony A1 • FE 400mm f/2.8 GM • FX3 Rig',
      status: ProjectStatus.inProgress,
      selectedPhotos: 412,
      totalPhotos: 550,
      driveSyncSize: '190 GB RAW',
      dueDate: 'Due Nov 20',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBcBP5iLsfiuzvaSfxO-LJ3jY3wb8dBqfYK63b7rhgcqW5Jeo18X2svLV00pbHTkzeqd-tLIKZzMAey_SSKiErlO0Sa2SP-GL_wMbno5VJ4Rr9uyjBml6Rifz9p-84a02o87JqcTo2sOCk_bXe7B99JV3FdTzWHzKvFVeF_gbEkh0ZaJLXpL5f1PTycHxNyp4qDvxp6XdddKTUUV9ZCEJnB2Qg4EJZiqMGnYMk2e4lbYhRAw0glY_9p',
    ),
  ];

  List<ProjectItem> get filteredProjects {
    if (selectedFilter == 'all') return projects;
    if (selectedFilter == 'selection') {
      return projects.where((p) => p.status == ProjectStatus.selection).toList();
    }
    if (selectedFilter == 'in-progress') {
      return projects.where((p) => p.status == ProjectStatus.inProgress).toList();
    }
    if (selectedFilter == 'delivered') {
      return projects.where((p) => p.status == ProjectStatus.delivered).toList();
    }
    return projects;
  }

  void _showNotifications() {
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
                Icon(Icons.notifications_active, color: p.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Vault Notifications',
                  style: AppTypography.headlineSmall.copyWith(
                    color: p.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              icon: Icons.cloud_done,
              iconColor: p.statusSuccess,
              title: 'Drive Vault Synced',
              subtitle: '128 GB RAW masters ready for Farhan & Anika',
              time: '12m ago',
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              icon: Icons.verified,
              iconColor: p.primary,
              title: 'Escrow Milestone Released',
              subtitle: '\$1,150 unlocked for Full-Day Cinematography',
              time: '1h ago',
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              icon: Icons.photo_library,
              iconColor: p.textGold,
              title: 'Client Selections Ready',
              subtitle: 'Sommer & Julian submitted 278 favorites',
              time: '3h ago',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.borderSubtle, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(
                    color: p.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: p.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTypography.monoSmall.copyWith(
              color: p.textTertiary,
              fontSize: 10,
            ),
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
        titleTag: 'Projects',
        onAvatarTap: widget.onAvatarTap,
        onLogoTap: widget.onLogoTap,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subheader & Notification Bell
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.camera_roll, color: p.primary, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'VAULT DIRECTORY',
                          style: AppTypography.monoSmall.copyWith(
                            color: p.textGold,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Projects & Master Vault',
                      style: AppTypography.headlineMedium.copyWith(
                        color: p.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: _showNotifications,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: p.surfaceElevated,
                      shape: BoxShape.circle,
                      border: Border.all(color: p.borderSubtle, width: 0.8),
                    ),
                    child: Icon(Icons.notifications_none, color: p.textSecondary, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Capturing Memories with optical precision. Track high-res masters, curations, and client vault handoffs.',
              style: AppTypography.bodySmall.copyWith(
                color: p.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // 2x2 Bento Quick Metrics Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                _buildBentoMetric(
                  icon: Icons.photo_library,
                  iconColor: p.primary,
                  pill: StatusPill.goldBadge('ACTIVE'),
                  value: '04',
                  label: 'Live Shoots',
                ),
                _buildBentoMetric(
                  icon: Icons.touch_app,
                  iconColor: p.statusWarning,
                  pill: StatusPill.action(label: 'Action'),
                  value: '02',
                  label: 'Client Curations',
                ),
                _buildBentoMetric(
                  icon: Icons.verified,
                  iconColor: p.statusSuccess,
                  pill: StatusPill.verified(label: 'TIER 1'),
                  value: '01',
                  label: 'Ready for Handoff',
                ),
                _buildBentoMetric(
                  icon: Icons.lock_clock,
                  iconColor: p.textGold,
                  pill: StatusPill.escrow(label: 'ESCROW'),
                  value: '\$2,450',
                  label: 'Secured Balance',
                  isGoldTinted: true,
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Filter Pills Carousel
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterPill('all', 'All (4)'),
                  const SizedBox(width: 8),
                  _buildFilterPill('in-progress', 'In-Progress (2)'),
                  const SizedBox(width: 8),
                  _buildFilterPill('selection', 'Selection (1)'),
                  const SizedBox(width: 8),
                  _buildFilterPill('delivered', 'Delivered (1)'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Project Cards Stack
            ListView.separated(
              itemCount: filteredProjects.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return _buildProjectCard(filteredProjects[index]);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoMetric({
    required IconData icon,
    required Color iconColor,
    required Widget pill,
    required String value,
    required String label,
    bool isGoldTinted = false,
  }) {
    final p = context.palette;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isGoldTinted
              ? p.primary.withValues(alpha: 0.4)
              : p.borderSubtle,
          width: 1,
        ),
        gradient: isGoldTinted
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  p.surfaceCard,
                  p.primary.withValues(alpha: 0.12),
                ],
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 18),
              pill,
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isGoldTinted ? p.textGold : p.textPrimary,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: p.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String filterKey, String title) {
    final p = context.palette;
    final isSelected = selectedFilter == filterKey;

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = filterKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? p.primary : p.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? p.primary : p.borderSubtle,
            width: 0.8,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: p.primary.withValues(alpha: 0.28),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? p.onPrimaryDark : p.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(ProjectItem project) {
    final p = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: p.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Banner & Badge Overlays (Clickable Lightbox trigger)
          GestureDetector(
            onTap: () {
              PhotoLightbox.show(
                context,
                photoId: '${project.id}_hero',
                title: '${project.clientName} • Master RAW 01',
                imageUrl: project.imageUrl,
                camera: 'Sony FX6 Cinema',
                lens: 'FE 50mm f/1.2 GM',
                aperture: 'ƒ/1.2',
                shutter: '1/800s',
                iso: 'ISO 100',
              );
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: Image.network(
                      project.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: p.surfaceContainer,
                        child: Icon(Icons.broken_image, color: p.textSecondary),
                      ),
                    ),
                  ),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: p.surfaceCanvas.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: p.borderSubtle, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_done, color: p.statusSuccess, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          project.driveSyncSize,
                          style: AppTypography.monoSmall.copyWith(
                            fontSize: 9.5,
                            color: p.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: _buildStatusTag(project.status),
                ),
                // Darkroom Inspect Pill
                Positioned(
                  bottom: 42,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: p.primary.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fullscreen, color: p.textGold, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Darkroom HUD',
                          style: AppTypography.monoSmall.copyWith(
                            fontSize: 9,
                            color: p.textGold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom Title Overlay
                Positioned(
                  bottom: 8,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: AppTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: p.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Client: ${project.clientName} • ${project.dueDate}',
                        style: AppTypography.bodySmall.copyWith(
                          color: p.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Details Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.packageDescription,
                  style: AppTypography.bodySmall.copyWith(
                    color: p.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.camera, color: p.textGold, size: 13),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        project.cameraGear,
                        style: AppTypography.monoSmall.copyWith(
                          fontSize: 10,
                          color: p.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Curation Progress Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${project.selectedPhotos} of ${project.totalPhotos} Master Captures Selected',
                      style: AppTypography.monoSmall.copyWith(
                        fontSize: 10,
                        color: p.textPrimary,
                      ),
                    ),
                    Text(
                      '${(project.progressPercentage * 100).toInt()}%',
                      style: AppTypography.monoSmall.copyWith(
                        fontSize: 11,
                        color: p.textGold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: project.progressPercentage,
                    backgroundColor: p.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(p.primary),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 14),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Synced to Drive: ${project.driveSyncSize} for ${project.clientName}',
                                style: TextStyle(color: p.textPrimary),
                              ),
                              backgroundColor: p.surfaceElevated,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: p.surfaceElevated,
                          side: BorderSide(color: p.borderSubtle, width: 0.8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          'Drive Vault',
                          style: AppTypography.labelSmall.copyWith(
                            color: p.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          PhotoLightbox.show(
                            context,
                            photoId: '${project.id}_curation',
                            title: '${project.clientName} • Curation Batch',
                            imageUrl: project.imageUrl,
                            camera: 'Hasselblad X2D 100C',
                            lens: 'XCD 90mm f/2.5 V',
                            aperture: 'ƒ/2.5',
                            shutter: '1/1000s',
                            iso: 'ISO 64',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          'Review Curation',
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

  Widget _buildStatusTag(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.selection:
        return StatusPill.action(label: 'Action Required');
      case ProjectStatus.inProgress:
        return StatusPill.goldBadge('In-Progress');
      case ProjectStatus.delivered:
        return StatusPill.verified(label: 'Delivered');
    }
  }
}
