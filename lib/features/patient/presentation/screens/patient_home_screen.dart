import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medihub/core/di/service_locator.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_state.dart';
import 'package:medihub/features/doctor/presentation/cubit/doctor_list_cubit.dart';
import 'package:medihub/features/doctor/presentation/cubit/doctor_list_state.dart';
import 'package:medihub/models/doctor_profile.dart';
import 'package:medihub/features/auth/data/services/supabase_auth_service.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  ColorScheme get _colors => Theme.of(context).colorScheme;
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _secondary => Theme.of(context).colorScheme.secondary;
  Color get _primaryContainer => Theme.of(context).colorScheme.primaryContainer;

  String _searchQuery = '';
  String _selectedLocation = 'All';
  String _selectedSpecialization = 'All';
  int _displayedDoctorCount = 4;

  static final Map<String, IconData> _categoryIcons = {
    'All': Icons.medical_services,
    'Cardiologist': Icons.favorite,
    'Dermatologist': Icons.face,
    'Neurologist': Icons.psychology,
    'Pediatrician': Icons.child_care,
    'Orthopedist': Icons.accessibility_new,
    'Ophthalmologist': Icons.visibility,
    'ENT': Icons.hearing,
    'Gynecologist': Icons.pregnant_woman,
    'Urologist': Icons.water_drop,
    'Dentist': Icons.sentiment_satisfied,
    'Psychiatrist': Icons.self_improvement,
  };

  @override
  void initState() {
    super.initState();
    context.read<DoctorListCubit>().loadDoctors();
  }

  List<DoctorProfile> _filterDoctors(List<DoctorProfile> doctors) {
    final query = _searchQuery.toLowerCase();
    return doctors.where((d) {
      final matchesName =
          d.fullName.toLowerCase().contains(query) ||
          (d.specialization?.toLowerCase().contains(query) ?? false);
      final matchesSpec =
          _selectedSpecialization == 'All' ||
          d.specialization == _selectedSpecialization;
      final matchesLoc =
          _selectedLocation == 'All' || d.location == _selectedLocation;
      return matchesName && matchesSpec && matchesLoc;
    }).toList();
  }

  String? get _patientName {
    final s = context.read<AuthCubit>().state;
    if (s is AuthenticatedAsPatient) return s.profile.fullName;
    return null;
  }

  Future<void> _clearPatientSession() async {
    await sl<SupabaseAuthService>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MediHub',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (_patientName != null)
              Text(
                'Hello, $_patientName!',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: _primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Appointment History',
            onPressed: () => context.push('/patient/history'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _clearPatientSession();
                        if (mounted) context.go('/auth');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DoctorListCubit, DoctorListState>(
        builder: (context, state) {
          if (state is DoctorListLoading || state is DoctorListInitial) {
            return Center(child: CircularProgressIndicator(color: _primary));
          }
          if (state is DoctorListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load doctors',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<DoctorListCubit>().loadDoctors(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is DoctorListLoaded) {
            return _buildBody(state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(DoctorListLoaded state) {
    final categories = ['All', ...state.specializations];
    final locations = state.locations;
    final filtered = _filterDoctors(state.doctors);
    final doctorCount = state.doctors.length;
    final specCount = state.specializations.length;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryContainer, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_primary, _secondary],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.waving_hand,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Find Your Doctor',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Book appointments easily',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search doctors, specializations...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(Icons.search, color: _primary),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey.shade400,
                                ),
                                onPressed: () =>
                                    setState(() => _searchQuery = ''),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '$doctorCount',
                          'Doctors',
                          Icons.people_outline,
                          _primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '$specCount',
                          'Specialists',
                          Icons.local_hospital_outlined,
                          _secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          state.doctorRatings.isNotEmpty
                              ? (state.doctorRatings.values.reduce(
                                          (a, b) => a + b,
                                        ) /
                                        state.doctorRatings.length)
                                    .toStringAsFixed(1)
                              : '--',
                          'Rating',
                          Icons.star_outline,
                          Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Categories section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = _selectedSpecialization == cat;
                  final icon = _categoryIcons[cat] ?? Icons.medical_services;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSpecialization = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(colors: [_primary, _secondary])
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? _primary : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.25)
                                  : _primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              size: 28,
                              color: isSelected ? Colors.white : _primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              cat,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Location filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButtonFormField<String>(
                initialValue: _selectedLocation,
                decoration: InputDecoration(
                  hintText: 'Select Location',
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: _primary,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                isExpanded: true,
                items: [
                  const DropdownMenuItem(
                    value: 'All',
                    child: Text(
                      'All Locations',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ...locations.map(
                    (loc) => DropdownMenuItem(
                      value: loc,
                      child: Text(loc, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
                onChanged: (val) =>
                    setState(() => _selectedLocation = val ?? 'All'),
              ),
            ),
            const SizedBox(height: 24),

            // Doctors list header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    filtered.isEmpty ? 'No Doctors Found' : 'Available Doctors',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  if (filtered.isNotEmpty)
                    Text(
                      '${_displayedDoctorCount > filtered.length ? filtered.length : _displayedDoctorCount}/${filtered.length} shown',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Doctor cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filtered.length > _displayedDoctorCount
                  ? _displayedDoctorCount
                  : filtered.length,
              itemBuilder: (context, index) {
                final doctor = filtered[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + index * 50),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: _buildDoctorCard(doctor, index, state.doctorRatings),
                );
              },
            ),

            // Load More
            if (filtered.length > _displayedDoctorCount)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _displayedDoctorCount += 4),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryContainer,
                      foregroundColor: _primary,
                      side: BorderSide(color: _primary, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Load More Doctors',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(
    DoctorProfile doctor,
    int index,
    Map<String, double> doctorRatings,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primary.withOpacity(0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/patient/doctor-profile', extra: doctor),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor image
                Stack(
                  children: [
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [_primaryContainer, _colors.surface],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child:
                            doctor.profileImage != null &&
                                doctor.profileImage!.isNotEmpty
                            ? Image.network(
                                doctor.profileImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _doctorPlaceholder(),
                              )
                            : _doctorPlaceholder(),
                      ),
                    ),
                    if (index == 0)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Doctor info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doctor.fullName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (index == 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [_primary, _secondary],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.white,
                                    size: 6,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Available',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _colors.outlineVariant,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.medical_services,
                              size: 14,
                              color: _primary,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                doctor.specialization ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              doctor.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  doctorRatings.containsKey(doctor.id)
                                      ? doctorRatings[doctor.id]!
                                            .toStringAsFixed(1)
                                      : 'New',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '৳${doctor.consultationFee}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: _primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _doctorPlaceholder() {
    final lightShade =
        Color.lerp(_primaryContainer, _primary, 0.2) ?? _primaryContainer;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [_primaryContainer, lightShade]),
      ),
      child: Icon(Icons.person, size: 45, color: _primary),
    );
  }
}
