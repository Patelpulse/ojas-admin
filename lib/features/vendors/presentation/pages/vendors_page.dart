import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ojas_admin/features/layout/presentation/widgets/admin_layout.dart';
import 'package:ojas_admin/core/services/service_locator.dart';
import 'package:ojas_admin/features/vendors/data/services/vendor_service.dart';
import 'package:intl/intl.dart';

import 'package:ojas_admin/core/services/global_search_service.dart';

class VendorsPage extends StatefulWidget {
  const VendorsPage({super.key});

  @override
  State<VendorsPage> createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalSearchService _globalSearchService = sl<GlobalSearchService>();
  List<dynamic> _vendors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVendors();
    _searchController.addListener(() => setState(() {}));
    _globalSearchService.searchQuery.addListener(_onGlobalSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _globalSearchService.searchQuery.removeListener(_onGlobalSearchChanged);
    super.dispose();
  }

  void _onGlobalSearchChanged() {
    _searchController.text = _globalSearchService.searchQuery.value;
  }

  List<dynamic> get _filteredVendors {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _vendors;
    return _vendors.where((v) {
      final bizName = v['businessName']?.toString().toLowerCase() ?? '';
      final ownerName = v['user']?['name']?.toString().toLowerCase() ?? '';
      final email = v['user']?['email']?.toString().toLowerCase() ?? '';
      return bizName.contains(query) || ownerName.contains(query) || email.contains(query);
    }).toList();
  }

  Future<void> _fetchVendors() async {
    setState(() => _isLoading = true);
    try {
      final vendors = await sl<VendorService>().getVendorRequests();
      setState(() {
        _vendors = vendors;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch vendors: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String id, String status) async {
    try {
      await sl<VendorService>().updateVendorStatus(id, status);
      await _fetchVendors();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vendor ${status == 'inactive' ? 'deactivated' : (status == 'approved' ? 'activated' : status)} successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $e')),
        );
      }
    }
  }

  Future<void> _deleteVendor(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vendor'),
        content: const Text('Are you sure you want to delete this vendor? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await sl<VendorService>().deleteVendor(id);
        await _fetchVendors();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vendor deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete vendor: $e')),
          );
        }
      }
    }
  }

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
                          value: _vendors.where((v) => v['status'] == 'active').length.toString(),
                          icon: Icons.check_circle_outline,
                          iconBgColor: const Color(0xFFD1FAE5), // Light green
                          iconColor: const Color(0xFF10B981), // Green
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Pending Approvals',
                          value: _vendors.where((v) => v['status'] == 'pending').length.toString(),
                          icon: Icons.filter_alt_outlined,
                          iconBgColor: const Color(0xFFFEF3C7), // Light yellow
                          iconColor: const Color(0xFFF59E0B), // Orange-yellow
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Total Vendors',
                          value: _vendors.length.toString(),
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

                        // Table Rows
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 60),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_filteredVendors.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Center(
                              child: Text(
                                _searchController.text.isEmpty ? 'No vendor applications yet.' : 'No vendors match your search.',
                                style: GoogleFonts.inter(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filteredVendors.length,
                            itemBuilder: (context, index) {
                              final vendor = _filteredVendors[index];
                              return _buildVendorRow(vendor);
                            },
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

  Widget _buildVendorRow(Map<String, dynamic> vendor) {
    final status = vendor['status'] ?? 'pending';
    final user = vendor['user'] ?? {};
    final statusColor = status == 'approved' ? const Color(0xFF10B981) : (status == 'rejected' ? Colors.red : (status == 'inactive' ? Colors.grey : const Color(0xFFF59E0B)));
    final statusBg = status == 'approved' ? const Color(0xFFD1FAE5) : (status == 'rejected' ? Colors.red.shade50 : (status == 'inactive' ? Colors.grey.shade100 : const Color(0xFFFEF3C7)));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.storefront_outlined, size: 20, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    vendor['businessName'] ?? 'No Name',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name'] ?? 'Unknown', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF0F172A))),
                Text(user['email'] ?? '', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text((vendor['categories'] as List?)?.join(', ') ?? 'General', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              vendor['createdAt'] != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse(vendor['createdAt'])) : 'N/A',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == 'pending') ...[
                  IconButton(
                    onPressed: () => _updateStatus(vendor['_id'], 'approved'),
                    icon: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
                    tooltip: 'Approve',
                  ),
                  IconButton(
                    onPressed: () => _updateStatus(vendor['_id'], 'rejected'),
                    icon: const Icon(Icons.cancel, color: Colors.red, size: 20),
                    tooltip: 'Reject',
                  ),
                ] else ...[
                  if (status == 'approved')
                    IconButton(
                      onPressed: () => _updateStatus(vendor['_id'], 'inactive'),
                      icon: const Icon(Icons.pause_circle_outline, color: Colors.orange, size: 20),
                      tooltip: 'Deactivate',
                    )
                  else if (status == 'inactive')
                    IconButton(
                      onPressed: () => _updateStatus(vendor['_id'], 'approved'),
                      icon: const Icon(Icons.play_circle_outline, color: Color(0xFF10B981), size: 20),
                      tooltip: 'Activate',
                    ),
                  IconButton(
                    onPressed: () => _deleteVendor(vendor['_id']),
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    tooltip: 'Delete',
                  ),
                ],
              ],
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
