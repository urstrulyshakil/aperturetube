enum ProjectStatus { selection, inProgress, delivered }

class ProjectItem {
  final String id;
  final String title;
  final String clientName;
  final String packageDescription;
  final String cameraGear;
  final ProjectStatus status;
  final int selectedPhotos;
  final int totalPhotos;
  final String driveSyncSize;
  final String dueDate;
  final String imageUrl;
  final bool isEscrowSecured;
  final String escrowAmount;

  const ProjectItem({
    required this.id,
    required this.title,
    required this.clientName,
    required this.packageDescription,
    required this.cameraGear,
    required this.status,
    required this.selectedPhotos,
    required this.totalPhotos,
    required this.driveSyncSize,
    required this.dueDate,
    required this.imageUrl,
    this.isEscrowSecured = true,
    this.escrowAmount = '\$2,450',
  });

  double get progressPercentage =>
      totalPhotos == 0 ? 0.0 : (selectedPhotos / totalPhotos).clamp(0.0, 1.0);

  String get statusLabel {
    switch (status) {
      case ProjectStatus.selection:
        return 'Selection Pending';
      case ProjectStatus.inProgress:
        return 'In-Progress';
      case ProjectStatus.delivered:
        return 'Delivered';
    }
  }
}
