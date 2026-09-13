import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'status_pills.dart';

class PhotoLightbox extends StatefulWidget {
  final String photoId;
  final String imageUrl;
  final String title;
  final String camera;
  final String lens;
  final String aperture;
  final String shutter;
  final String iso;
  final String focalLength;

  const PhotoLightbox({
    super.key,
    required this.photoId,
    required this.imageUrl,
    this.title = '#EM-0142 • Tuscany Sunset Master',
    this.camera = 'Leica M11',
    this.lens = '50mm Summilux-M f/1.4 ASPH.',
    this.aperture = 'ƒ/1.4',
    this.shutter = '1/1250s',
    this.iso = 'ISO 64',
    this.focalLength = '50mm',
  });

  static void show(
    BuildContext context, {
    required String photoId,
    required String imageUrl,
    String? title,
    String? camera,
    String? lens,
    String? aperture,
    String? shutter,
    String? iso,
    String? focalLength,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.92),
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) => PhotoLightbox(
          photoId: photoId,
          imageUrl: imageUrl,
          title: title ?? '#EM-0142 • Tuscany Sunset Master',
          camera: camera ?? 'Leica M11',
          lens: lens ?? '50mm Summilux-M f/1.4 ASPH.',
          aperture: aperture ?? 'ƒ/1.4',
          shutter: shutter ?? '1/1250s',
          iso: iso ?? 'ISO 64',
          focalLength: focalLength ?? '50mm',
        ),
      ),
    );
  }

  @override
  State<PhotoLightbox> createState() => _PhotoLightboxState();
}

class _PhotoLightboxState extends State<PhotoLightbox> {
  final AppState _appState = AppState();
  bool showHud = true;
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        final isSelected = _appState.selectedPhotoIds.contains(widget.photoId);
        final isFavorite = _appState.favoriteIds.contains(widget.photoId);
        final isRetouch = _appState.retouchRequestedIds.contains(widget.photoId);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Interactive Zoomable Photo Stage
              GestureDetector(
                onTap: () => setState(() => showHud = !showHud),
                onDoubleTap: _resetZoom,
                child: SizedBox.expand(
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.8,
                    maxScale: 4.5,
                    child: Center(
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.broken_image, color: AppColors.textSecondary, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Top HUD Navigation Bar
              if (showHud)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 16,
                      right: 16,
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close, color: AppColors.textPrimary, size: 22),
                              onPressed: () => Navigator.of(context).pop(),
                              tooltip: 'Close Darkroom',
                            ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: AppTypography.labelLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${widget.camera} • ${widget.lens}',
                                  style: AppTypography.monoSmall.copyWith(
                                    fontSize: 10,
                                    color: AppColors.textGold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            StatusPill.verified(label: 'DCI 4K RAW'),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.refresh, color: AppColors.textSecondary, size: 20),
                              onPressed: _resetZoom,
                              tooltip: 'Reset Zoom',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // Bottom Optical Telemetry HUD & Action Toolbar
              if (showHud)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: MediaQuery.of(context).padding.bottom + 14,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.92),
                          Colors.black.withValues(alpha: 0.70),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // EXIF & Histogram Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderSubtle, width: 0.8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // EXIF Readouts
                              Row(
                                children: [
                                  _buildExifPill(widget.aperture, 'APERTURE'),
                                  const SizedBox(width: 8),
                                  _buildExifPill(widget.shutter, 'SHUTTER'),
                                  const SizedBox(width: 8),
                                  _buildExifPill(widget.iso, 'SENSOR'),
                                  const SizedBox(width: 8),
                                  _buildExifPill(widget.focalLength, 'FOCAL'),
                                ],
                              ),
                              // Mock RGB Histogram
                              CustomPaint(
                                size: const Size(60, 24),
                                painter: _HistogramPainter(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Action Controls Toolbar
                        Row(
                          children: [
                            // Selection Toggle Button
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _appState.togglePhotoSelection(widget.photoId),
                                icon: Icon(
                                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                                  size: 18,
                                  color: isSelected ? AppColors.onPrimaryDark : AppColors.textPrimary,
                                ),
                                label: Text(
                                  isSelected ? 'Selected' : 'Select Photo',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: isSelected ? AppColors.onPrimaryDark : AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected ? AppColors.primary : AppColors.surfaceElevated,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Favorite Toggle Button
                            Container(
                              decoration: BoxDecoration(
                                color: isFavorite
                                    ? AppColors.primary.withValues(alpha: 0.2)
                                    : AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isFavorite ? AppColors.primary : AppColors.borderSubtle,
                                  width: 0.8,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? AppColors.primary : AppColors.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () => _appState.toggleFavorite(widget.photoId),
                                tooltip: 'Favorite',
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Retouch Request Toggle Button
                            Container(
                              decoration: BoxDecoration(
                                color: isRetouch
                                    ? AppColors.secondary.withValues(alpha: 0.2)
                                    : AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isRetouch ? AppColors.secondary : AppColors.borderSubtle,
                                  width: 0.8,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.auto_fix_high,
                                  color: isRetouch ? AppColors.secondary : AppColors.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () => _appState.toggleRetouch(widget.photoId),
                                tooltip: 'Request Retouch',
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Download RAW button
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderSubtle, width: 0.8),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.file_download, color: AppColors.textGold, size: 20),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Downloading 14-bit DNG RAW master for ${widget.title}...'),
                                      backgroundColor: AppColors.surfaceElevated,
                                    ),
                                  );
                                },
                                tooltip: 'Download RAW',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExifPill(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.monoSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
        Text(
          label,
          style: AppTypography.monoSmall.copyWith(
            fontSize: 7.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _HistogramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x += 4) {
      final normX = x / size.width;
      final y = size.height - (math.sin(normX * math.pi) * size.height * 0.85 + (x % 8) * 1.5);
      path.lineTo(x, y.clamp(2.0, size.height));
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
