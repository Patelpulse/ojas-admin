import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ojas_admin/features/layout/presentation/widgets/admin_layout.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _selectedStatus = 'All Status';
  String _selectedPayment = 'All Payments';
  String _searchQuery = '';

  final List<String> _statusOptions = ['All Status', 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];
  final List<String> _paymentOptions = ['All Payments', 'Paid', 'Unpaid', 'Refunded'];

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: '/orders',
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
                Text('Admin Orders', style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
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
                            'Orders Management',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage and track all customer orders',
                            style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14),
                          ),
                        ],
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_outlined, size: 16),
                        label: Text('Export Orders', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.grey.shade300),
                          foregroundColor: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Filters
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        // Search
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey.shade400, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    onChanged: (v) => setState(() => _searchQuery = v),
                                    decoration: InputDecoration(
                                      hintText: 'Search by order number, customer name or email...',
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
                        const SizedBox(width: 16),

                        // Status Dropdown
                        _buildDropdown(
                          value: _selectedStatus,
                          items: _statusOptions,
                          onChanged: (v) => setState(() => _selectedStatus = v!),
                        ),
                        const SizedBox(width: 12),

                        // Payment Dropdown
                        _buildDropdown(
                          value: _selectedPayment,
                          items: _paymentOptions,
                          onChanged: (v) => setState(() => _selectedPayment = v!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Table
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                          ),
                          child: Row(
                            children: [
                              _tableHeader('ORDER', flex: 2),
                              _tableHeader('CUSTOMER', flex: 3),
                              _tableHeader('VENDOR', flex: 2),
                              _tableHeader('ITEMS', flex: 1),
                              _tableHeader('TOTAL', flex: 2),
                              _tableHeader('PAYMENT', flex: 2),
                              _tableHeader('DATE', flex: 2),
                              _tableHeader('ACTIONS', flex: 2),
                            ],
                          ),
                        ),

                        // Empty State
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 80),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(Icons.shopping_bag_outlined, color: Colors.grey.shade400, size: 32),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No orders found',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Try adjusting your filters',
                                style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
                              ),
                            ],
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
