import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ojas_admin/features/layout/presentation/widgets/admin_layout.dart';

class VendorsPage extends StatefulWidget {
  const VendorsPage({super.key});

  @override
  State<VendorsPage> createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: '/vendors',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            color: Colors.white,
            child: Row(
              children: [
                Text('Master Admin', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
                const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                Text('Vendors', style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Text(
                    'Vendor Management',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Approve storefronts, monitor performance, and take actions.',
                    style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  // Metrics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Active Vendors',
                          value: '0',
                          icon: Icons.check_circle_outline,
                          iconBgColor: const Color(0xFFD1FAE5), // Light green
                          iconColor: const Color(0xFF10B981), // Green
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Pending Approvals',
                          value: '0',
                          icon: Icons.filter_alt_outlined,
                          iconBgColor: const Color(0xFFFEF3C7), // Light yellow
                          iconColor: const Color(0xFFF59E0B), // Orange-yellow
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Total Vendors',
                          value: '0',
                          icon: Icons.store_outlined,
                          iconBgColor: const Color(0xFFDBEAFE), // Light blue
                          iconColor: const Color(0xFF3B82F6), // Blue
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Table Container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search vendor, owner, or email',
                                      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Table Headers
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            border: Border.symmetric(horizontal: BorderSide(color: Colors.grey.shade200)),
                          ),
                          child: Row(
                            children: [
                              _tableHeader('BUSINESS', flex: 2),
                              _tableHeader('OWNER', flex: 2),
                              _tableHeader('CATEGORIES', flex: 2),
                              _tableHeader('STATUS', flex: 2),
                              _tableHeader('JOINED', flex: 2),
                              _tableHeader('ACTIONS', flex: 1, align: TextAlign.right),
                            ],
                          ),
                        ),

                        // Empty State
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Text(
                              'No vendor applications yet.',
                              style: GoogleFonts.inter(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(value, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(String title, {required int flex, TextAlign align = TextAlign.start}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
