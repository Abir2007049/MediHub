import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_state.dart';
import 'package:medihub/features/appointments/presentation/cubit/booking_cubit.dart';
import 'package:medihub/features/appointments/presentation/cubit/booking_state.dart';
import 'package:medihub/models/doctor_profile.dart';

class PaymentScreen extends StatefulWidget {
  final DoctorProfile doctor;
  final String selectedDay;
  final int selectedSerialNumber;
  final String? approximateTime;

  const PaymentScreen({
    super.key,
    required this.doctor,
    required this.selectedDay,
    required this.selectedSerialNumber,
    this.approximateTime,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  ColorScheme get _colors => Theme.of(context).colorScheme;
  Color get _primary => _colors.primary;
  Color get _primaryContainer => _colors.primaryContainer;

  String _paymentMethod = 'bkash';
  final _accountController = TextEditingController();
  bool _confirmed = false;

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    final authState = context.read<AuthCubit>().state;
    String? patientId;
    String? patientName;
    String? patientMobile;

    if (authState is AuthenticatedAsPatient) {
      patientId = authState.profile.id;
      patientName = authState.profile.fullName;
      patientMobile = authState.profile.phone;
    } else {
      patientId = context.read<AuthCubit>().currentUserId;
    }

    if (patientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not authenticated'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final d = widget.doctor;

    context.read<BookingCubit>().confirmBooking(
      patientId: patientId,
      doctorId: d.id,
      patientName: patientName,
      patientMobile: patientMobile,
      doctorName: d.fullName,
      specialization: d.specialization,
      location: d.location,
      selectedDay: widget.selectedDay,
      serialNumber: widget.selectedSerialNumber,
      approximateTime: widget.approximateTime,
      consultationFee: d.consultationFee,
      paymentMethod: _paymentMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.doctor;

    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingConfirmed) {
          setState(() => _confirmed = true);
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Payment'),
          backgroundColor: _colors.surface,
          foregroundColor: _primary,
          elevation: 0,
        ),
        body: _confirmed ? _buildSuccess() : _buildPaymentForm(d),
      ),
    );
  }

  // ── Success state ──
  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _primaryContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _primary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(Icons.check_circle, size: 80, color: _primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Serial #${widget.selectedSerialNumber} on ${widget.selectedDay}',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            if (widget.approximateTime != null) ...[
              const SizedBox(height: 4),
              Text(
                'Approximate time: ${widget.approximateTime}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/patient'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Go to Home',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Payment form ──
  Widget _buildPaymentForm(DoctorProfile d) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const Divider(height: 24),
                  _summaryRow('Doctor', d.fullName),
                  _summaryRow('Specialization', d.specialization ?? ''),
                  _summaryRow('Day', widget.selectedDay),
                  _summaryRow('Serial', '#${widget.selectedSerialNumber}'),
                  if (widget.approximateTime != null)
                    _summaryRow('Time', widget.approximateTime!),
                  _summaryRow('Location', d.location),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '৳${d.consultationFee}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment method
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'bkash',
              'bKash',
              Icons.phone_android,
              Colors.pink.shade600,
            ),
            _buildPaymentOption(
              'nagad',
              'Nagad',
              Icons.phone_android,
              Colors.orange.shade700,
            ),
            _buildPaymentOption(
              'rocket',
              'Rocket',
              Icons.phone_android,
              Colors.purple,
            ),
            _buildPaymentOption(
              'card',
              'Credit/Debit Card',
              Icons.credit_card,
              Colors.blue,
            ),
            _buildPaymentOption(
              'cash',
              'Cash on Visit',
              Icons.payments_outlined,
              _primary,
            ),
            const SizedBox(height: 16),

            // Account/card input (if not cash)
            if (_paymentMethod != 'cash') ...[
              TextField(
                controller: _accountController,
                decoration: InputDecoration(
                  labelText: _paymentMethod == 'card'
                      ? 'Card Number'
                      : 'Account Number',
                  prefixIcon: Icon(
                    _paymentMethod == 'card' ? Icons.credit_card : Icons.phone,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
            ],

            // Confirm button
            BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                final isLoading = state is BookingConfirming;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Confirm Payment  •  ৳${d.consultationFee}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _paymentMethod == value;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _paymentMethod = value),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? _primaryContainer : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _primary : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? _primary : Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(Icons.check_circle, color: _primary, size: 24)
                else
                  Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
