import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ojas_admin/features/layout/presentation/widgets/admin_layout.dart';

class DashboardPage extends StatelessWidget {
  final String currentRoute;
  const DashboardPage({super.key, this.currentRoute = '/admin-overview'});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: currentRoute,
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
                Text('Custom Dashboard', style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Dashboard',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Overview of platform performance and key metrics',
                    style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  // Top Stats Cards
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('Total Revenue', '₹0', 12.5, Icons.attach_money, Colors.green)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildStatCard('Total Orders', '0', 8.2, Icons.shopping_cart_outlined, Colors.blue)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildStatCard('Active Vendors', '0', 15.3, Icons.storefront_outlined, Colors.purple)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildStatCard('Total Customers', '0', -2.4, Icons.group_outlined, Colors.orange)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row 1: Charts
                  Row(
                    children: [
                      Expanded(child: _buildChartCard('Weekly Revenue', 'Last 7 days from database orders', Icons.bar_chart, Colors.purple, _buildBarChartPlaceholder())),
                      const SizedBox(width: 20),
                      Expanded(child: _buildChartCard('Sales Trend', 'Last 6 months from database orders', Icons.trending_up, Colors.green, _buildLineChartPlaceholder())),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row 2: Products & Vendors
                  Row(
                    children: [
                      Expanded(child: _buildEmptyCard('Trending Products', 'Top selling items this month', Icons.widgets_outlined, Colors.blue)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildEmptyCard('Top Revenue Vendors', 'Top 0 highest earning sellers', Icons.store_outlined, Colors.purple)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row 3: Categories
                  Row(
                    children: [
                      Expanded(child: _buildNoDataCard('Categories', 'Product categories overview', Icons.category_outlined, Colors.purple, 'No categories found')),
                      const SizedBox(width: 20),
                      Expanded(child: _buildNoDataCard('Subcategories', 'Latest subcategories', Icons.account_tree_outlined, Colors.blue, 'No subcategories found')),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row 4: Recent Activity
                  Row(
                    children: [
                      Expanded(child: _buildEmptyCard('Recent Orders', 'Latest transactions', Icons.shopping_cart_outlined, Colors.green)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildEmptyCard('Platform Activity', 'Recent updates', Icons.show_chart, Colors.blue)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, double percentage, IconData icon, MaterialColor color) {
    final isPositive = percentage >= 0;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color.shade400, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(isPositive ? Icons.north_east : Icons.south_east, 
                  color: isPositive ? Colors.green : Colors.red, 
                  size: 14),
              Text(
                ' ${percentage.abs()}% ',
                style: GoogleFonts.inter(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'vs last month',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, String subtitle, IconData icon, MaterialColor color, Widget content) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
              Icon(icon, color: color.shade400, size: 20),
            ],
          ),
          const Spacer(),
          content,
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String title, String subtitle, IconData icon, MaterialColor color) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 4),
              Text(subtitle, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
            ],
          ),
          Icon(icon, color: color.shade400, size: 20),
        ],
      ),
    );
  }

  Widget _buildNoDataCard(String title, String subtitle, IconData icon, MaterialColor color, String emptyText) {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
              Icon(icon, color: color.shade400, size: 20),
            ],
          ),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Icon(Icons.widgets_outlined, color: Colors.grey.shade300, size: 40),
                const SizedBox(height: 12),
                Text(emptyText, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14)),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBarChartPlaceholder() {
    final days = ['Wed', 'Thu', 'Fri', 'Sat', 'Sun', 'Mon', 'Tue'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) => Column(
          children: [
            Text('₹0k', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade400)),
            const SizedBox(height: 12),
            Text(day, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildLineChartPlaceholder() {
    final months = ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: months.map((month) => Column(
          children: [
            Text('0', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade400)),
            const SizedBox(height: 4),
            Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.green.shade400, shape: BoxShape.circle)),
            const SizedBox(height: 8),
            Text(month, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
          ],
        )).toList(),
      ),
    );
  }
}
