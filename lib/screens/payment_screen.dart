import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'patient_history_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final String selectedDay;
  final int selectedSerialNumber;
  final String? approximateTime;

  const PaymentScreen({
    Key? key,
    required this.doctor,
    required this.selectedDay,
    required this.selectedSerialNumber,
    this.approximateTime,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  // Demo consultation fee - will come from backend
  late final double _consultationFee;

  @override
  void initState() {
    super.initState();
    _consultationFee = (widget.doctor['consultationFee'] ?? 500).toDouble();
  }

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'bKash',
      'icon': Icons.account_balance_wallet,
      'color': Colors.pink,
      'gradient': [Color(0xFFE91E63), Color(0xFFC2185B)],
    },
    {
      'name': 'Nagad',
      'icon': Icons.payment,
      'color': Colors.orange,
      'gradient': [Color(0xFFFF6F00), Color(0xFFE65100)],
    },
    {
      'name': 'Rocket',
      'icon': Icons.rocket_launch,
      'color': Colors.purple,
      'gradient': [Color(0xFF7B1FA2), Color(0xFF6A1B9A)],
    },
    {
      'name': 'Debit Card',
      'icon': Icons.credit_card,
      'color': Colors.blue,
      'gradient': [Color(0xFF1976D2), Color(0xFF1565C0)],
    },
  ];

  @override
  void dispose() {
    _accountNumberController.dispose();
    _cardNumberController.dispose();
    _cvvController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _saveAppointmentHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final patientMobile = prefs.getString('patient_mobile') ?? '';
    final patientName = prefs.getString('patient_name') ?? 'Patient';
    final doctorEmail = widget.doctor['email'] ?? '';

    // Create appointment object
    final appointment = {
      'timestamp': DateTime.now().toIso8601String(),
      'selectedDay': widget.selectedDay,
      'serialNumber': widget.selectedSerialNumber,
      'approximateTime': widget.approximateTime ?? 'N/A',
      'consultationFee': _consultationFee,
      'paymentMethod': _selectedPaymentMethod,
      'patientMobile': patientMobile,
      'patientName': patientName,
      'doctorName': widget.doctor['name'] ?? 'Doctor',
      'doctorEmail': doctorEmail,
      'specialization': widget.doctor['specialization'] ?? 'Specialist',
      'location': widget.doctor['location'] ?? 'N/A',
    };

    // Save to patient history
    final patientHistoryJson = prefs.getString('patient_history_$patientMobile');
    List<dynamic> patientHistory = patientHistoryJson != null ? jsonDecode(patientHistoryJson) : [];
    patientHistory.add(appointment);
    await prefs.setString('patient_history_$patientMobile', jsonEncode(patientHistory));

    // Save to doctor history
    if (doctorEmail.isNotEmpty) {
      final doctorHistoryJson = prefs.getString('doctor_history_$doctorEmail');
      List<dynamic> doctorHistory = doctorHistoryJson != null ? jsonDecode(doctorHistoryJson) : [];
      doctorHistory.add(appointment);
      await prefs.setString('doctor_history_$doctorEmail', jsonEncode(doctorHistory));
    }
  }

  void _processPayment() {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate input based on payment method
    if (_selectedPaymentMethod == 'Debit Card') {
      if (_cardNumberController.text.isEmpty ||
          _cvvController.text.isEmpty ||
          _expiryController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all card details'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      if (_accountNumberController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter your account number'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing payment...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.pop(context); // Close processing dialog
      
      // Save appointment to history
      await _saveAppointmentHistory();
      
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 8),
              Text('Payment Successful!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Doctor: ${widget.doctor['name']}'),
              Text('Qualification: ${widget.doctor['degree'] ?? 'MBBS'}'),
              Text('Medical College: ${widget.doctor['medicalCollege'] ?? 'Medical College'}'),
              const SizedBox(height: 8),
              Text('Day: ${widget.selectedDay}'),
              Text('Serial Number: #${widget.selectedSerialNumber}'),
              if (widget.approximateTime != null)
                Text('Approximate Time: ${widget.approximateTime}'),
              const Divider(),
              Text('Consultation Fee: ৳${_consultationFee.toStringAsFixed(2)}/appointment'),
              Text('Method: $_selectedPaymentMethod'),
              const SizedBox(height: 8),
              const Text(
                'Your appointment has been confirmed!',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          actions: [
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(context); // Close success dialog
                final prefs = await SharedPreferences.getInstance();
                final patientMobile = prefs.getString('patient_mobile') ?? '';

                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PatientHistoryScreen(patientMobile: patientMobile),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text('Go to History'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close success dialog
                Navigator.pop(context); // Go back to appointment screen
                Navigator.pop(context); // Go back to doctor profile
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment booked successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['name'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method['name'];
        });
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: method['gradient'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: method['color'].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(method['icon'], color: Colors.white, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    method['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.check_circle, color: Colors.white, size: 24),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    if (_selectedPaymentMethod == null) return const SizedBox.shrink();

    if (_selectedPaymentMethod == 'Debit Card') {
      return Column(
        children: [
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Card Number',
              hintText: '1234 5678 9012 3456',
              prefixIcon: const Icon(Icons.credit_card),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'MM/YY',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return TextField(
        controller: _accountNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: '$_selectedPaymentMethod Account Number',
          hintText: '01XXXXXXXXX',
          prefixIcon: const Icon(Icons.phone),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appointment Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appointment Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: widget.doctor['image'] != null
                              ? NetworkImage(widget.doctor['image'])
                              : null,
                          radius: 30,
                          backgroundColor: Colors.green.shade100,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.doctor['name'] ?? 'Doctor',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.doctor['specialization'] ?? ''),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Day:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.selectedDay),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Serial Number:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('#${widget.selectedSerialNumber}'),
                      ],
                    ),
                    if (widget.approximateTime != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Approximate Time:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.approximateTime!),
                        ],
                      ),
                    ],
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Consultation Fee:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '৳${_consultationFee.toStringAsFixed(2)}/appointment',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Payment Methods
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                return _buildPaymentMethodCard(_paymentMethods[index]);
              },
            ),
            const SizedBox(height: 24),
            // Payment Form
            _buildPaymentForm(),
            const SizedBox(height: 24),
            // Pay Button
            ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Pay ৳${_consultationFee.toStringAsFixed(2)}/appointment',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
