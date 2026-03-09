import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/doctor_profile.dart';
import '../models/doctor_schedule.dart';
import '../models/review.dart';
import '../repositories/doctor_repository.dart';

class DoctorProfileScreen extends StatefulWidget {
  final DoctorProfile doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DoctorRepository _doctorRepo = DoctorRepository();

  List<Review> _reviews = [];
  List<DoctorSchedule> _schedules = [];
  double _avgRating = 0.0;
  int _reviewCount = 0;
  bool _loadingExtras = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadExtras();
  }

  Future<void> _loadExtras() async {
    try {
      final results = await Future.wait([
        _doctorRepo.getDoctorReviews(widget.doctor.id),
        _doctorRepo.getDoctorAverageRating(widget.doctor.id),
        _doctorRepo.getDoctorReviewCount(widget.doctor.id),
        _doctorRepo.getDoctorSchedules(widget.doctor.id),
      ]);
      if (!mounted) return;
      setState(() {
        _reviews = results[0] as List<Review>;
        _avgRating = results[1] as double;
        _reviewCount = results[2] as int;
        _schedules = results[3] as List<DoctorSchedule>;
        _loadingExtras = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingExtras = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.doctor;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ── App Bar with Doctor image ──
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.green.shade700,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.green.shade900],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white24,
                        backgroundImage:
                            d.profileImage != null && d.profileImage!.isNotEmpty
                            ? NetworkImage(d.profileImage!)
                            : null,
                        child: d.profileImage == null || d.profileImage!.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white70,
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        d.fullName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        d.specialization ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Quick stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _quickStatChip(
                            Icons.star,
                            _avgRating.toStringAsFixed(1),
                            Colors.amber,
                          ),
                          const SizedBox(width: 12),
                          _quickStatChip(
                            Icons.reviews,
                            '$_reviewCount reviews',
                            Colors.blue,
                          ),
                          if (d.experience != null &&
                              d.experience!.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            _quickStatChip(
                              Icons.work_outline,
                              '${d.experience} yrs',
                              Colors.orange,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Tabs ──
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.green.shade700,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.green.shade700,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'About'),
                  Tab(text: 'Reviews'),
                  Tab(text: 'Availability'),
                ],
              ),
            ),
          ),

          // ── Tab content ──
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAboutTab(d),
                _buildReviewsTab(),
                _buildAvailabilityTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(d),
    );
  }

  // ── Quick stat chip ──
  Widget _quickStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── About Tab ──
  Widget _buildAboutTab(DoctorProfile d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (d.description != null && d.description!.isNotEmpty) ...[
            _sectionTitle('About'),
            Text(
              d.description!,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
          ],
          _sectionTitle('Information'),
          _infoRow(Icons.local_hospital, 'Hospital', d.hospital ?? 'N/A'),
          _infoRow(Icons.category, 'Department', d.department ?? 'N/A'),
          _infoRow(Icons.school, 'Degree', d.degree ?? 'N/A'),
          _infoRow(
            Icons.account_balance,
            'Medical College',
            d.medicalCollege ?? 'N/A',
          ),
          _infoRow(Icons.location_on, 'Location', d.location),
          _infoRow(Icons.medical_information, 'Diagnostic', d.diagnostic),
          _infoRow(Icons.badge, 'License', d.license ?? 'N/A'),
          const SizedBox(height: 20),
          _sectionTitle('Consultation'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade50, Colors.green.shade100],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      color: Colors.green.shade700,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Consultation Fee',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '৳${d.consultationFee}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.green.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Reviews Tab ──
  Widget _buildReviewsTab() {
    if (_loadingExtras) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }
    if (_reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 60,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'No reviews yet',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _reviews.length,
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final r = _reviews[index];
        return _buildReviewCard(r);
      },
    );
  }

  Widget _buildReviewCard(Review r) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Text(
            (r.patientName ?? 'A').substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    r.patientName ?? 'Anonymous',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < r.rating.round() ? Icons.star : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              if (r.comment != null && r.comment!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  r.comment!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
              if (r.createdAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${r.createdAt!.day}/${r.createdAt!.month}/${r.createdAt!.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ── Availability Tab ──
  Widget _buildAvailabilityTab() {
    if (_loadingExtras) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }
    if (_schedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 60,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'No schedule available',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _schedules.length,
      itemBuilder: (context, index) {
        final s = _schedules[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.green.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.dayOfWeek,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.timeRange,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${s.totalSeats} seats',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Bottom book button ──
  Widget _buildBottomBar(DoctorProfile d) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consultation Fee',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                  Text(
                    '৳${d.consultationFee}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  context.push('/patient/doctor-profile/book', extra: d),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Book Appointment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── TabBar delegate ──
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
