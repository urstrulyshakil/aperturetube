import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/project_item.dart';
import '../models/invoice_detail.dart';
import '../models/artisan_profile.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Default local development URL for FastAPI
  static String baseUrl = kIsWeb
      ? 'http://localhost:8000/api/v1'
      : (defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:8000/api/v1'
          : 'http://localhost:8000/api/v1');

  String get _baseUrl => baseUrl;



  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Health check to detect if FastAPI is reachable
  Future<bool> isBackendReachable() async {
    try {
      final rootUrl = _baseUrl.replaceAll('/api/v1', '');
      final response = await http
          .get(Uri.parse('$rootUrl/health'))
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// 1. Fetch Projects
  Future<List<ProjectItem>?> fetchProjects({String? status}) async {
    try {
      final uri = status != null && status != 'all'
          ? Uri.parse('$_baseUrl/projects?status=$status')
          : Uri.parse('$_baseUrl/projects');

      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((item) => _mapJsonToProject(item)).toList();
      }
    } catch (e) {
      debugPrint('ApiService.fetchProjects fallback: $e');
    }
    return null;
  }

  /// 2. Fetch 2x2 Bento Metrics
  Future<Map<String, String>?> fetchBentoMetrics() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/projects/metrics/summary'), headers: _headers)
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {
          'live_shoots': data['live_shoots']?.toString() ?? '04',
          'client_curations': data['client_curations']?.toString() ?? '02',
          'ready_for_handoff': data['ready_for_handoff']?.toString() ?? '01',
          'secured_balance': data['secured_balance']?.toString() ?? '\$2,450',
        };
      }
    } catch (e) {
      debugPrint('ApiService.fetchBentoMetrics fallback: $e');
    }
    return null;
  }

  /// 3. Update Photo Curation Status (Favorite, Retouch, Selection)
  Future<bool> updatePhotoStatus({
    required String projectId,
    required String photoId,
    bool? isSelected,
    bool? isFavorite,
    bool? isRetouchRequested,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/projects/$projectId/photos/$photoId');
      final body = <String, dynamic>{};
      if (isSelected != null) body['is_selected'] = isSelected;
      if (isFavorite != null) body['is_favorite'] = isFavorite;
      if (isRetouchRequested != null) body['is_retouch_requested'] = isRetouchRequested;

      final response = await http
          .patch(uri, headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('ApiService.updatePhotoStatus error: $e');
      return false;
    }
  }

  /// 4. Fetch Active Escrow Invoice
  Future<InvoiceDetail?> fetchActiveInvoice() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/invoices/active'), headers: _headers)
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return _mapJsonToInvoice(data);
      }
    } catch (e) {
      debugPrint('ApiService.fetchActiveInvoice fallback: $e');
    }
    return null;
  }

  /// 5. bKash Checkout
  Future<Map<String, dynamic>> initiateBkashPayment({
    required String invoiceId,
    required String amount,
    String payerReference = '01711223344',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payments/bkash/create'),
        headers: _headers,
        body: jsonEncode({
          'invoice_id': invoiceId,
          'amount': amount,
          'payer_reference': payerReference,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> executeBkashPayment(String paymentId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payments/bkash/execute'),
        headers: _headers,
        body: jsonEncode({'payment_id': paymentId}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 6. Stripe PaymentIntent
  Future<Map<String, dynamic>> createStripeIntent({
    required String invoiceId,
    required double amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payments/stripe/create-intent'),
        headers: _headers,
        body: jsonEncode({
          'invoice_id': invoiceId,
          'amount': amount,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> confirmStripePayment(String paymentIntentId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payments/stripe/confirm?payment_intent_id=$paymentIntentId'),
        headers: _headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 7. Google Pay Process
  Future<Map<String, dynamic>> processGooglePay({
    required String invoiceId,
    required double amount,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payments/google-pay/process'),
        headers: _headers,
        body: jsonEncode({
          'invoice_id': invoiceId,
          'amount': amount,
          'payment_token': token,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 8. Google Drive Vault Sync
  Future<Map<String, dynamic>> syncDriveVault({
    required String projectId,
    required double sizeGb,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/drive/sync'),
        headers: _headers,
        body: jsonEncode({
          'project_id': projectId,
          'size_gb': sizeGb,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 9. Fetch Artisans
  Future<List<ArtisanProfile>?> fetchArtisans({String? discipline}) async {
    try {
      final uri = discipline != null && discipline != 'All'
          ? Uri.parse('$_baseUrl/community/artisans?discipline=$discipline')
          : Uri.parse('$_baseUrl/community/artisans');

      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((item) => _mapJsonToArtisan(item)).toList();
      }
    } catch (e) {
      debugPrint('ApiService.fetchArtisans fallback: $e');
    }
    return null;
  }

  // --- JSON Mappers ---

  ProjectItem _mapJsonToProject(Map<String, dynamic> json) {
    ProjectStatus status = ProjectStatus.inProgress;
    if (json['status'] == 'selection') status = ProjectStatus.selection;
    if (json['status'] == 'delivered') status = ProjectStatus.delivered;

    return ProjectItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      clientName: json['client_name'] ?? '',
      packageDescription: json['package_description'] ?? '',
      cameraGear: json['camera_gear'] ?? '',
      status: status,
      selectedPhotos: json['selected_photos'] ?? 0,
      totalPhotos: json['total_photos'] ?? 0,
      driveSyncSize: json['drive_sync_size'] ?? '',
      dueDate: json['due_date'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isEscrowSecured: json['is_vault_synced'] ?? true,
    );
  }

  InvoiceDetail _mapJsonToInvoice(Map<String, dynamic> json) {
    final List itemsJson = json['line_items'] ?? [];
    final items = itemsJson
        .map((i) => InvoiceLineItem(
              title: i['title'] ?? '',
              subtitle: i['subtitle'] ?? '',
              amount: (i['amount'] as num?)?.toDouble() ?? 0.0,
            ))
        .toList();

    return InvoiceDetail(
      invoiceNumber: json['invoice_number'] ?? '#AT-2025-0891',
      tokenCode: json['token_code'] ?? 'AT-891-XK94',
      targetDriveEmail: json['target_drive_email'] ?? 'farhan.archive@gmail.com',
      rawStorageSize: json['raw_storage_size'] ?? '128 GB RAW',
      masterCapturesCount: json['master_captures_count'] ?? '1,420 High-Res Masters',
      dueDate: json['due_date'] ?? 'DUE NOV 12, 2025',
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 90.0,
      totalUsd: (json['total_usd'] as num?)?.toDouble() ?? 1890.0,
      totalBdt: json['total_bdt'] ?? '৳225,750 BDT',
      isEscrowLocked: !(json['is_settled'] ?? false),
      lineItems: items,
    );
  }

  ArtisanProfile _mapJsonToArtisan(Map<String, dynamic> json) {
    return ArtisanProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewsCount: json['reviews_count'] ?? 0,
      startingPrice: json['starting_price'] ?? '\$1,000',
      availability: json['availability'] ?? 'Available',
      gearKit: json['gear_kit'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      coverImageUrl: json['cover_image_url'] ?? '',
    );
  }

}
