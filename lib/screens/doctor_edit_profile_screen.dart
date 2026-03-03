import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  final Map<String, String> doctorData;

  const DoctorEditProfileScreen({Key? key, required this.doctorData}) : super(key: key);

  @override
  State<DoctorEditProfileScreen> createState() => _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _specializationController;
  late TextEditingController _degreeController;
  late TextEditingController _medicalCollegeController;
  late TextEditingController _hospitalController;
  late TextEditingController _departmentController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _consultationFeeController;
  late TextEditingController _diagnosticController;
  late TextEditingController _licenseController;
  late TextEditingController _experienceController;

  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctorData['name'] ?? '');
    _specializationController = TextEditingController(text: widget.doctorData['specialization'] ?? '');
    _degreeController = TextEditingController(text: widget.doctorData['degree'] ?? '');
    _medicalCollegeController = TextEditingController(text: widget.doctorData['medicalCollege'] ?? '');
    _hospitalController = TextEditingController(text: widget.doctorData['hospital'] ?? '');
    _departmentController = TextEditingController(text: widget.doctorData['department'] ?? '');
    _locationController = TextEditingController(text: widget.doctorData['location'] ?? '');
    _descriptionController = TextEditingController(text: widget.doctorData['description'] ?? '');
    _consultationFeeController = TextEditingController(text: widget.doctorData['consultationFee'] ?? '500');
    _diagnosticController = TextEditingController(text: widget.doctorData['diagnostic'] ?? '');
    _licenseController = TextEditingController(text: widget.doctorData['license'] ?? '');
    _experienceController = TextEditingController(text: widget.doctorData['experience'] ?? '12');
    _profileImagePath = widget.doctorData['profileImage'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _degreeController.dispose();
    _medicalCollegeController.dispose();
    _hospitalController.dispose();
    _departmentController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _consultationFeeController.dispose();
    _diagnosticController.dispose();
    _licenseController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveProfileChanges() async {
    if (_nameController.text.trim().isEmpty ||
        _specializationController.text.trim().isEmpty ||
        _degreeController.text.trim().isEmpty ||
        _medicalCollegeController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _consultationFeeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate consultation fee is a number
    if (int.tryParse(_consultationFeeController.text.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consultation fee must be a valid number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      // Update doctor session data
      await prefs.setString('doctor_name', _nameController.text.trim());
      await prefs.setString('doctor_specialization', _specializationController.text.trim());
      await prefs.setString('doctor_degree', _degreeController.text.trim());
      await prefs.setString('doctor_college', _medicalCollegeController.text.trim());
      await prefs.setString('doctor_hospital', _hospitalController.text.trim());
      await prefs.setString('doctor_department', _departmentController.text.trim());

      // Save additional profile fields (as JSON or separate entries)
      await prefs.setString('doctor_location', _locationController.text.trim());
      await prefs.setString('doctor_description', _descriptionController.text.trim());
      await prefs.setString('doctor_consultation_fee', _consultationFeeController.text.trim());
      await prefs.setString('doctor_diagnostic', _diagnosticController.text.trim());
      await prefs.setString('doctor_license', _licenseController.text.trim());
      await prefs.setString('doctor_experience', _experienceController.text.trim());

      // Save profile image path
      if (_profileImagePath != null) {
        await prefs.setString('doctor_profile_image', _profileImagePath!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context, true); // Return true to indicate data was updated
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 3),
                        color: Colors.grey.shade100,
                      ),
                      child: _profileImagePath != null
                          ? ClipOval(
                              child: Image.file(
                                File(_profileImagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey.shade400,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickProfileImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Change Photo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Personal Information Section
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Full Name', _nameController, Icons.person, 'Dr. Name'),
            const SizedBox(height: 12),
            _buildTextField('Specialization', _specializationController, Icons.healing, 'e.g., Cardiologist'),
            const SizedBox(height: 24),

            // Professional Qualifications
            Text(
              'Professional Qualifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Degree', _degreeController, Icons.school, 'e.g., MBBS, FCPS'),
            const SizedBox(height: 12),
            _buildTextField('Medical College', _medicalCollegeController, Icons.apartment, 'College name'),
            const SizedBox(height: 12),
            _buildTextField('License Number', _licenseController, Icons.card_membership, 'Medical License No.'),
            const SizedBox(height: 24),

            // Work Information
            Text(
              'Work Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Hospital/Diagnostic Centre', _diagnosticController, Icons.local_hospital, 'Centre name'),
            const SizedBox(height: 12),
            _buildTextField('Current Hospital', _hospitalController, Icons.domain, 'Optional'),
            const SizedBox(height: 12),
            _buildTextField('Department', _departmentController, Icons.flag, 'Optional'),
            const SizedBox(height: 12),
            _buildTextField('Years of Experience', _experienceController, Icons.timeline, 'e.g., 12', keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            _buildTextField('Location', _locationController, Icons.location_on, 'City/Area'),
            const SizedBox(height: 24),

            // Services
            Text(
              'Services & Fees',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Consultation Fee (৳)', _consultationFeeController, Icons.attach_money, 'Amount per appointment', keyboardType: TextInputType.number),
            const SizedBox(height: 24),

            // About Section
            Text(
              'About You',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Professional Bio',
                hintText: 'Write about your experience, approach, and specialties...',
                prefixIcon: const Icon(Icons.description),
                prefixIconColor: Colors.green,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _saveProfileChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 56),
                elevation: 4,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cancel Button
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            prefixIconColor: Colors.green,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }
}
