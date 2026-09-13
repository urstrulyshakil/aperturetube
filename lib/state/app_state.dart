import 'package:flutter/material.dart';
import '../models/studio_settings.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  final ApiService _api = ApiService();

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
  ApiService get api => _api;

  // Actions with Backend Synchronization
  void togglePhotoSelection(String photoId) {
    final willSelect = !_selectedPhotoIds.contains(photoId);
    if (willSelect) {
      _selectedPhotoIds.add(photoId);
    } else {
      _selectedPhotoIds.remove(photoId);
    }
    notifyListeners();

    // Sync to FastAPI backend asynchronously
    _api.updatePhotoStatus(
      projectId: 'proj_01',
      photoId: photoId,
      isSelected: willSelect,
    );
  }

  void toggleFavorite(String photoId) {
    final willFav = !_favoriteIds.contains(photoId);
    if (willFav) {
      _favoriteIds.add(photoId);
    } else {
      _favoriteIds.remove(photoId);
    }
    notifyListeners();

    // Sync to FastAPI backend asynchronously
    _api.updatePhotoStatus(
      projectId: 'proj_01',
      photoId: photoId,
      isFavorite: willFav,
    );
  }

  void toggleRetouch(String photoId) {
    final willRetouch = !_retouchRequestedIds.contains(photoId);
    if (willRetouch) {
      _retouchRequestedIds.add(photoId);
    } else {
      _retouchRequestedIds.remove(photoId);
    }
    notifyListeners();

    // Sync to FastAPI backend asynchronously
    _api.updatePhotoStatus(
      projectId: 'proj_01',
      photoId: photoId,
      isRetouchRequested: willRetouch,
    );
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

