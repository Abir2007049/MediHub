import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_state.dart';
import 'package:medihub/features/doctor/presentation/cubit/doctor_list_cubit.dart';
import 'package:medihub/features/doctor/presentation/cubit/doctor_list_state.dart';
import 'package:medihub/models/doctor_profile.dart';
import 'package:medihub/features/patient/presentation/widgets/patient_drawer.dart';
import 'package:medihub/features/patient/presentation/widgets/patient_home_header.dart';
import 'package:medihub/features/patient/presentation/widgets/category_selector.dart';
import 'package:medihub/features/patient/presentation/widgets/location_filter_dropdown.dart';
import 'package:medihub/features/patient/presentation/widgets/doctor_card.dart';
import 'package:medihub/features/patient/presentation/widgets/doctor_search_delegate.dart';

const Map<String, IconData> _categoryIcons = {
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

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  String _selectedLocation = 'All';
  String _selectedSpecialization = 'All';
  int _displayedDoctorCount = 4;

  @override
  void initState() {
    super.initState();
    context.read<DoctorListCubit>().loadDoctors();
  }

  List<DoctorProfile> _filterDoctors(List<DoctorProfile> doctors) {
    return doctors.where((d) {
      final matchesSpec =
          _selectedSpecialization == 'All' ||
          d.specialization == _selectedSpecialization;
      final matchesLoc =
          _selectedLocation == 'All' || d.location == _selectedLocation;
      return matchesSpec && matchesLoc;
    }).toList();
  }

  String? get _patientName {
    final s = context.read<AuthCubit>().state;
    if (s is AuthenticatedAsPatient) return s.profile.fullName;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
        foregroundColor: colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: PatientDrawer(patientName: _patientName),
      body: BlocBuilder<DoctorListCubit, DoctorListState>(
        builder: (context, state) {
          if (state is DoctorListLoading || state is DoctorListInitial) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
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
                    style: ElevatedButton.styleFrom(elevation: 0),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is DoctorListLoaded) {
            final categories = ['All', ...state.specializations];
            final locations = state.locations;
            final doctorCount = state.doctors.length;
            final specCount = state.specializations.length;
            final filteredDoctors = _filterDoctors(state.doctors);

            double avgRating = 0;
            if (state.doctorRatings.isNotEmpty) {
              avgRating =
                  state.doctorRatings.values.reduce((a, b) => a + b) /
                  state.doctorRatings.length;
            }

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PatientHomeHeader(
                      doctorCount: doctorCount,
                      specCount: specCount,
                      averageRating: avgRating,
                      onSearchTapped: () {
                        showSearch(
                          context: context,
                          delegate: DoctorSearchDelegate(
                            doctors: state.doctors,
                            doctorRatings: state.doctorRatings,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
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
                    CategorySelector(
                      categories: categories,
                      selectedSpecialization: _selectedSpecialization,
                      categoryIcons: _categoryIcons,
                      onCategorySelected: (val) =>
                          setState(() => _selectedSpecialization = val),
                    ),
                    const SizedBox(height: 24),
                    LocationFilterDropdown(
                      locations: locations,
                      selectedLocation: _selectedLocation,
                      onLocationSelected: (val) =>
                          setState(() => _selectedLocation = val),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            filteredDoctors.isEmpty
                                ? 'No Doctors Found'
                                : 'Available Doctors',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          if (filteredDoctors.isNotEmpty)
                            Text(
                              '${_displayedDoctorCount > filteredDoctors.length ? filteredDoctors.length : _displayedDoctorCount}/${filteredDoctors.length} shown',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredDoctors.length > _displayedDoctorCount
                          ? _displayedDoctorCount
                          : filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = filteredDoctors[index];
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
                          child: DoctorCard(
                            doctor: doctor,
                            index: index,
                            doctorRatings: state.doctorRatings,
                          ),
                        );
                      },
                    ),
                    if (filteredDoctors.length > _displayedDoctorCount)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                setState(() => _displayedDoctorCount += 4),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              elevation: 0,
                              side: BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.5),
                                width: 1,
                              ),
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
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
