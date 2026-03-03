import 'package:flutter/material.dart';
import 'dart:io';

class RegisterDoctorStep2 extends StatefulWidget {
  final String name;
  final String email;
  final String bmdc;
  final String specialization;
  final String medicalCollege;
  final String degree;
  final File? profileImage;

  const RegisterDoctorStep2({
    Key? key,
    required this.name,
    required this.email,
    required this.bmdc,
    required this.specialization,
    required this.medicalCollege,
    required this.degree,
    this.profileImage,
  }) : super(key: key);

  @override
  State<RegisterDoctorStep2> createState() => _RegisterDoctorStep2State();
}

class _RegisterDoctorStep2State extends State<RegisterDoctorStep2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _diagnosticCentreController = TextEditingController();
  final TextEditingController _diagnosticLocationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Registration - Step 2')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diagnosticCentreController,
                decoration: InputDecoration(
                  labelText: 'Current Diagnostic Centre',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter diagnostic centre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diagnosticLocationController,
                decoration: InputDecoration(
                  labelText: 'Location of Diagnostic Centre',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter location' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                obscureText: true,
                validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Handle doctor registration submission
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
