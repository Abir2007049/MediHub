import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for fetching medicines and diagnostic tests
/// Uses OpenFDA API - Completely FREE with API key for higher limits!
/// 
/// 📋 API Details:
/// - Provider: US Food and Drug Administration (FDA)
/// - API: OpenFDA Drug Labels API
/// - Authentication: API Key (from open.fda.gov)
/// - Rate Limit: 240 requests/minute, 120,000 requests/day (WITH KEY)
/// - Documentation: https://open.fda.gov/apis/drug/label/
class MedicineTestService {
  // OpenFDA API endpoint (FREE with API key for higher limits)
  static const String openFdaBaseUrl = 'https://api.fda.gov/drug';
  // Your OpenFDA API Key (get free from https://open.fda.gov/apis/authentication/)
  static const String openFdaApiKey = 'ZIqVThaNpSGtcdtRCjhCiqo1R9TYJwnbZtWzjVoj';
  static const int _targetMedicineCount = 30;
  
  // Cache medicines to avoid repeated API calls
  static List<Map<String, String>>? _cachedMedicines;
  static DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(hours: 24);
  
  /// Fetch medicines from OpenFDA API
  /// Real-time data from FDA drug database with authentication
  static Future<List<Map<String, String>>> fetchMedicines() async {
    try {
      // Check cache first (valid for 24 hours)
      if (_cachedMedicines != null && _cacheTime != null) {
        if (DateTime.now().difference(_cacheTime!).inSeconds < _cacheDuration.inSeconds) {
          print('✅ Using cached medicines (${_cachedMedicines!.length} items)');
          return _cachedMedicines!;
        }
      }
      
      print('🔄 Fetching medicines from OpenFDA API (with API key)...');
      
      // Query OpenFDA for common drug labels with API key
      // API key enables 120,000 requests per day
      final response = await http.get(
        Uri.parse('$openFdaBaseUrl/label.json?search=openfda.brand_name:*&limit=200&api_key=$openFdaApiKey'),
      ).timeout(const Duration(seconds: 15));

      print('📡 OpenFDA API Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Map<String, String>> medicines = [];
        
        print('📊 Response received from FDA');
        
        // OpenFDA returns results array with drug information
        if (data is Map && data.containsKey('results')) {
          final results = data['results'];
          if (results is List) {
            print('✅ Found ${results.length} drug records from FDA');
            
            // Extract unique medicine names
            Set<String> uniqueMedicines = {};
            
            for (var result in results) {
              if (result is Map) {
                // Try to get brand name first
                String? medicineName;
                
                if (result.containsKey('openfda')) {
                  final openfda = result['openfda'];
                  if (openfda is Map) {
                    // Try brand_name
                    if (openfda.containsKey('brand_name') && openfda['brand_name'] is List) {
                      final brandNames = openfda['brand_name'] as List;
                      if (brandNames.isNotEmpty) {
                        medicineName = brandNames.first.toString();
                      }
                    }
                    // Try generic_name if no brand name
                    if (medicineName == null && openfda.containsKey('generic_name') && openfda['generic_name'] is List) {
                      final genericNames = openfda['generic_name'] as List;
                      if (genericNames.isNotEmpty) {
                        medicineName = genericNames.first.toString();
                      }
                    }
                  }
                }
                
                if (medicineName != null && medicineName.isNotEmpty && !uniqueMedicines.contains(medicineName)) {
                  uniqueMedicines.add(medicineName);
                  medicines.add({
                    'name': medicineName,
                    'dose': '500mg',
                    'timing': 'As prescribed',
                  });
                  
                  if (medicines.length >= _targetMedicineCount) break;
                }
              }
            }

            final hasParacetamol = medicines.any(
              (medicine) => (medicine['name'] ?? '').toLowerCase() == 'paracetamol',
            );
            if (!hasParacetamol) {
              if (medicines.length >= _targetMedicineCount) {
                medicines.removeLast();
              }
              medicines.insert(0, {
                'name': 'Paracetamol',
                'dose': '500mg',
                'timing': 'As prescribed',
              });
            }

            medicines.sort(
              (a, b) => (a['name'] ?? '').toLowerCase().compareTo((b['name'] ?? '').toLowerCase()),
            );
            
            if (medicines.isNotEmpty) {
              print('✅ Successfully loaded ${medicines.length} medicines from OpenFDA API');
              print('📊 Rate limit: 120,000 requests/day (with your API key)');
              
              // Cache the results
              _cachedMedicines = medicines;
              _cacheTime = DateTime.now();
              
              return medicines;
            }
          }
        }
      } else {
        print('⚠️ OpenFDA API returned status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ OpenFDA API error: $e');
    }
    
    // Fallback to demo data if API fails
    print('📚 Loading demo medicines as fallback...');
    return _getDemoMedicines();
  }

  /// Fetch diagnostic tests - using demo data
  static Future<List<String>> fetchTests() async {
    try {
      // Simulate network delay for consistency
      await Future.delayed(const Duration(milliseconds: 500));
      return _getDemoTests();
    } catch (e) {
      return _getDemoTests();
    }
  }

  /// Demo medicines data (fallback when API fails or not available)
  static List<Map<String, String>> _getDemoMedicines() {
    final medicines = [
      {'name': 'Paracetamol', 'dose': '500mg', 'timing': 'After meal'},
      {'name': 'Amoxicillin', 'dose': '500mg', 'timing': 'After meal'},
      {'name': 'Metformin', 'dose': '500mg', 'timing': 'Before meal'},
      {'name': 'Omeprazole', 'dose': '20mg', 'timing': 'Before meal'},
      {'name': 'Atenolol', 'dose': '50mg', 'timing': 'Morning'},
      {'name': 'Azithromycin', 'dose': '500mg', 'timing': 'Once daily'},
      {'name': 'Cetirizine', 'dose': '10mg', 'timing': 'At night'},
      {'name': 'Amlodipine', 'dose': '5mg', 'timing': 'Morning'},
      {'name': 'Metronidazole', 'dose': '400mg', 'timing': 'After meal'},
      {'name': 'Ibuprofen', 'dose': '400mg', 'timing': 'After meal'},
      {'name': 'Aspirin', 'dose': '75mg', 'timing': 'Morning'},
      {'name': 'Losartan', 'dose': '50mg', 'timing': 'Morning'},
      {'name': 'Pantoprazole', 'dose': '40mg', 'timing': 'Before meal'},
      {'name': 'Cefuroxime', 'dose': '500mg', 'timing': 'Twice daily'},
      {'name': 'Salbutamol', 'dose': '4mg', 'timing': 'As needed'},
      {'name': 'Acetaminophen', 'dose': '500mg', 'timing': 'As prescribed'},
      {'name': 'Ciprofloxacin', 'dose': '500mg', 'timing': 'Twice daily'},
      {'name': 'Doxycycline', 'dose': '100mg', 'timing': 'Twice daily'},
      {'name': 'Levocetirizine', 'dose': '5mg', 'timing': 'At night'},
      {'name': 'Montelukast', 'dose': '10mg', 'timing': 'At night'},
      {'name': 'Ranitidine', 'dose': '150mg', 'timing': 'Before meal'},
      {'name': 'Esomeprazole', 'dose': '40mg', 'timing': 'Before meal'},
      {'name': 'Rabeprazole', 'dose': '20mg', 'timing': 'Before meal'},
      {'name': 'Clopidogrel', 'dose': '75mg', 'timing': 'Morning'},
      {'name': 'Atorvastatin', 'dose': '20mg', 'timing': 'At night'},
      {'name': 'Rosuvastatin', 'dose': '10mg', 'timing': 'At night'},
      {'name': 'Telmisartan', 'dose': '40mg', 'timing': 'Morning'},
      {'name': 'Valsartan', 'dose': '80mg', 'timing': 'Morning'},
      {'name': 'Furosemide', 'dose': '40mg', 'timing': 'Morning'},
      {'name': 'Spironolactone', 'dose': '25mg', 'timing': 'Morning'},
    ];

    medicines.sort(
      (a, b) => (a['name'] ?? '').toLowerCase().compareTo((b['name'] ?? '').toLowerCase()),
    );

    return medicines;
  }

  /// Demo tests data (fallback when API fails or not available)
  static List<String> _getDemoTests() {
    return [
      'Complete Blood Count (CBC)',
      'Blood Glucose (Fasting)',
      'Blood Glucose (Random)',
      'HbA1c',
      'Lipid Profile',
      'Thyroid Function Test (TFT)',
      'Liver Function Test (LFT)',
      'Kidney Function Test (KFT)',
      'Urine Routine Examination',
      'ECG (Electrocardiogram)',
      'Chest X-Ray',
      'Echocardiography',
      'Ultrasound Abdomen',
      'Blood Pressure Monitoring',
      'Serum Creatinine',
      'Serum Electrolytes',
      'SGPT / SGOT',
      'Hemoglobin',
      'COVID-19 PCR Test',
      'Stool Routine Examination',
    ];
  }
}
