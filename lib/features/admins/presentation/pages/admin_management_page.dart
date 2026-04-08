import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ojas_admin/features/layout/presentation/widgets/admin_layout.dart';

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({super.key});

  @override
  State<AdminManagementPage> createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  String _selectedStatus = 'All Statuses';
  String _searchQuery = '';

  final List<String> _statusOptions = ['All Statuses', 'Pending', 'Approved', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: '/admin-management',
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
                Text('Admin Management', style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin Management',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Approve or reject admin applications and manage existing admins.',
                            style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text('Refresh', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6), // Purple
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Metrics Cards
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('Pending Applications', '0', Icons.access_time, const Color(0xFFFEF08A), const Color(0xFFEAB308))),
                      const SizedBox(width: 20),
                      Expanded(child: _buildMetricCard('Approved Admins', '1', Icons.check_circle_outline, const Color(0xFFDCFCE7), const Color(0xFF22C55E))),
                      const SizedBox(width: 20),
                      Expanded(child: _buildMetricCard('Rejected', '0', Icons.highlight_off, const Color(0xFFFEE2E2), const Color(0xFFEF4444))),
                      const SizedBox(width: 20),
                      Expanded(child: _buildMetricCard('Total Admins', '1', Icons.verified_user_outlined, const Color(0xFFF3E8FF), const Color(0xFFA855F7))),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Table Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Filter Bar
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              // Search
                              Expanded(
                                child: Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          onChanged: (v) => setState(() => _searchQuery = v),
                                          decoration: InputDecoration(
                                            hintText: 'Search admin name or email',
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
                              const SizedBox(width: 24),

                              // Status Filter
                              _buildDropdown(
                                value: _selectedStatus,
                                items: _statusOptions,
                                onChanged: (v) => setState(() => _selectedStatus = v!),
                              ),
                            ],
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
                              _tableHeader('ADMIN DETAILS', flex: 3),
                              _tableHeader('DEPARTMENT', flex: 2),
                              _tableHeader('ROLE', flex: 1),
                              _tableHeader('STATUS', flex: 2),
                              _tableHeader('APPLIED DATE', flex: 2),
                              _tableHeader('LAST LOGIN', flex: 2),
                              _tableHeader('ACTIONS', flex: 1),
                            ],
                          ),
                        ),

                        // Empty State
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Text(
                              'No admin applications found.',
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

  Widget _buildMetricCard(String title, String value, IconData icon, Color iconBgColor, Color textColor) {
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
              Text(value, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: textColor, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items
              .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700)),
                  ))
              .toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          isDense: true,
        ),
      ),
    );
  }

  Widget _tableHeader(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
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
