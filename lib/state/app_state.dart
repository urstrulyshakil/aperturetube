import 'package:flutter/material.dart';
import '../models/studio_settings.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // Selected Photos for Curation
  final Set<String> _selectedPhotoIds = {
    'photo_01',
    'photo_02',
    'photo_03',
    'photo_04',
    'photo_05',
    'photo_06',
    'photo_07',
    'photo_08',
  };

  final Set<String> _retouchRequestedIds = {'photo_03'};
  final Set<String> _favoriteIds = {'photo_01', 'photo_02', 'photo_05'};

  // Bookmarked Artisans
  final Set<String> _bookmarkedArtisanIds = {'artisan_01'};

  // Invoice & Vault Escrow State
  bool _isVaultSettled = false;
  DateTime? _settlementDate;
  String _settlementMethod = 'Google Pay';

  // Studio Settings
  DisplayLutMode _lutMode = DisplayLutMode.darkCinema;
  bool _autoSyncRaw = true;
  String _defaultCurrency = 'USD (\$)';
  String _payoutGateway = 'bKash Merchant (017•••••89)';

  // Getters
  Set<String> get selectedPhotoIds => _selectedPhotoIds;
  Set<String> get retouchRequestedIds => _retouchRequestedIds;
  Set<String> get favoriteIds => _favoriteIds;
  Set<String> get bookmarkedArtisanIds => _bookmarkedArtisanIds;
  bool get isVaultSettled => _isVaultSettled;
  DateTime? get settlementDate => _settlementDate;
  String get settlementMethod => _settlementMethod;
  DisplayLutMode get lutMode => _lutMode;
  bool get autoSyncRaw => _autoSyncRaw;
  String get defaultCurrency => _defaultCurrency;
  String get payoutGateway => _payoutGateway;

  // Actions
  void togglePhotoSelection(String photoId) {
    if (_selectedPhotoIds.contains(photoId)) {
      _selectedPhotoIds.remove(photoId);
    } else {
      _selectedPhotoIds.add(photoId);
    }
    notifyListeners();
  }

  void toggleFavorite(String photoId) {
    if (_favoriteIds.contains(photoId)) {
      _favoriteIds.remove(photoId);
    } else {
      _favoriteIds.add(photoId);
    }
    notifyListeners();
  }

  void toggleRetouch(String photoId) {
    if (_retouchRequestedIds.contains(photoId)) {
      _retouchRequestedIds.remove(photoId);
    } else {
      _retouchRequestedIds.add(photoId);
    }
    notifyListeners();
  }

  void toggleArtisanBookmark(String artisanId) {
    if (_bookmarkedArtisanIds.contains(artisanId)) {
      _bookmarkedArtisanIds.remove(artisanId);
    } else {
      _bookmarkedArtisanIds.add(artisanId);
    }
    notifyListeners();
  }

  void settleVault({required String method}) {
    _isVaultSettled = true;
    _settlementDate = DateTime.now();
    _settlementMethod = method;
    notifyListeners();
  }

  void setLutMode(DisplayLutMode mode) {
    _lutMode = mode;
    notifyListeners();
  }

  void setAutoSyncRaw(bool value) {
    _autoSyncRaw = value;
    notifyListeners();
  }

  void setDefaultCurrency(String currency) {
    _defaultCurrency = currency;
    notifyListeners();
  }

  void setPayoutGateway(String gateway) {
    _payoutGateway = gateway;
    notifyListeners();
  }
}
