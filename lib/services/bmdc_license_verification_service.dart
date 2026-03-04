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

  // Example blocked/suspended registrations (can be expanded from BMDC notices)
  static const Set<String> _blockedRegistrations = {
    'A-57882',
    'A-78864',
    'A-53065',
    'A-49675',
    'A-53658',
    'A-42757',
    'A-95890',
    'A-104355',
    'A-35620',
    'A-67372',
  };

  static BmdcLicenseVerificationResult verify(String rawLicense) {
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

    if (_blockedRegistrations.contains(normalized)) {
      return BmdcLicenseVerificationResult(
        isValid: false,
        normalizedLicense: normalized,
        message: 'This BMDC license appears suspended/blocked. Account cannot be created.',
      );
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
