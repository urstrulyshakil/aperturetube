enum DisplayLutMode { darkCinema, daylightStudio }

class StudioSettings {
  final String photographerName;
  final String roleTitle;
  final double rating;
  final int reviewsCount;
  final String avatarUrl;
  final bool isVerified;
  final bool isActivePro;

  DisplayLutMode lutMode;
  bool isDriveConnected;
  String driveSyncPath;
  double storageUsedTb;
  double storageTotalTb;
  bool autoSyncRawOnTether;
  String defaultCurrency;
  String payoutGateway;

  StudioSettings({
    this.photographerName = 'Tanvir Hasan',
    this.roleTitle = 'Lead Cinematographer & Portrait Artist',
    this.rating = 4.99,
    this.reviewsCount = 342,
    this.avatarUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuDYq7lGGZj2M0wpOff01RhG5M1aRUc7knR18-JiWaAjPR0qtoqdQDbKVZ3h8Nq-3IDaVQ1hbqE4EpnxBwYzxmGFFecZ48bjWq-QRd4BlexTeYEgywh1JkCJt7Sg9IuzCyc4Irikf8FuQx2blOJJA1xTirqRWt5671AOEbeMN-uXW-4Wa-_72QO4D3G0vqewwT8su9fgy_6hjSpLh2E3xgJdW601b3pbhfrX45KgZT4HyV-WLwXnn204',
    this.isVerified = true,
    this.isActivePro = true,
    this.lutMode = DisplayLutMode.darkCinema,
    this.isDriveConnected = true,
    this.driveSyncPath = '/ApertureTube_Vault/2025/Master_RAW',
    this.storageUsedTb = 1.84,
    this.storageTotalTb = 2.00,
    this.autoSyncRawOnTether = true,
    this.defaultCurrency = 'USD (\$)',
    this.payoutGateway = 'bKash Merchant (017•••••89)',
  });

  double get storagePercentage =>
      storageTotalTb == 0 ? 0 : (storageUsedTb / storageTotalTb).clamp(0.0, 1.0);
}
