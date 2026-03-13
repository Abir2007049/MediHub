import 'package:supabase_flutter/supabase_flutter.dart';

class BmdcLicenseVerificationResult {
  final bool isValid;
  final String normalizedLicense;
  final String message;

  const BmdcLicenseVerificationResult({
    required this.isValid,
    required this.normalizedLicense,
    required this.message,
  });
}

class BmdcLicenseVerificationService {
  // BMDC notices often use format like A-57882, A-104355 etc.
  static final RegExp _bmdcPattern = RegExp(r'^[A-Z]-\d{4,6}$');

  /// Verifies a BMDC license: validates format, then checks the
  /// `blocked_licenses` Supabase table for suspensions.
  static Future<BmdcLicenseVerificationResult> verify(String rawLicense) async {
    final normalized = _normalize(rawLicense);

    if (normalized.isEmpty) {
      return const BmdcLicenseVerificationResult(
        isValid: false,
        normalizedLicense: '',
        message: 'BMDC license is required.',
      );
    }

    if (!_bmdcPattern.hasMatch(normalized)) {
      return BmdcLicenseVerificationResult(
        isValid: false,
        normalizedLicense: normalized,
        message: 'Invalid BMDC format. Use format like A-12345.',
      );
    }

    // Check blocked_licenses table in Supabase
    try {
      final row = await Supabase.instance.client
          .from('blocked_licenses')
          .select('license')
          .eq('license', normalized)
          .maybeSingle();

      if (row != null) {
        return BmdcLicenseVerificationResult(
          isValid: false,
          normalizedLicense: normalized,
          message:
              'This BMDC license appears suspended/blocked. Account cannot be created.',
        );
      }
    } catch (_) {
      // If the query fails (e.g. offline), fall through to valid —
      // the server-side RLS will still protect actual operations.
    }

    return BmdcLicenseVerificationResult(
      isValid: true,
      normalizedLicense: normalized,
      message: 'BMDC license format validated.',
    );
  }

  static String _normalize(String value) {
    var cleaned = value.trim().toUpperCase().replaceAll(' ', '');

    if (cleaned.isEmpty) return '';

    cleaned = cleaned.replaceAll(RegExp(r'[^A-Z0-9-]'), '');

    if (!cleaned.contains('-')) {
      final m = RegExp(r'^([A-Z])(\d{4,6})$').firstMatch(cleaned);
      if (m != null) {
        cleaned = '${m.group(1)}-${m.group(2)}';
      }
    }

    return cleaned;
  }
}
