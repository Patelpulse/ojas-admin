import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ojas_admin/features/layout/presentation/widgets/admin_layout.dart';
import 'package:ojas_admin/features/products/data/models/product_model.dart';
import 'package:ojas_admin/core/services/product_service.dart';
import 'package:ojas_admin/core/services/service_locator.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final productService = sl<ProductService>();
      final products = await productService.getAllProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching products: $e')),
        );
      }
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((p) {
        final vendorName = p.vendor?.name?.toLowerCase() ?? '';
        final shopName = p.vendor?.shopName?.toLowerCase() ?? '';
        return p.name.toLowerCase().contains(query) ||
               vendorName.contains(query) ||
               shopName.contains(query);
      }).toList();
    });
  }

  Future<void> _handleDelete(ProductModel product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${product.name}"? This will remove it from the user app.'),
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
        await sl<ProductService>().deleteProduct(product.id);
        _fetchProducts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: '/products',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            color: Colors.white,
            child: Row(
              children: [
                Text('Master Admin', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
                const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                Text('Admin Products', style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
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
                    'Products Management',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage all products across vendors',
                    style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
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
                                hintText: 'Search products or vendors...',
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
                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                          ),
                          child: Row(
                            children: [
                              _tableHeader('S.N', flex: 1),
                              _tableHeader('PRODUCT', flex: 3),
                              _tableHeader('VENDOR', flex: 2),
                              _tableHeader('CATEGORY', flex: 2),
                              _tableHeader('PRICE', flex: 1),
                              _tableHeader('STOCK', flex: 1),
                              _tableHeader('STATUS', flex: 1),
                              _tableHeader('ACTIONS', flex: 1, align: TextAlign.end),
                            ],
                          ),
                        ),

                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(),
                          )
                        else if (_filteredProducts.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 80),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.widgets_outlined, color: Colors.grey.shade300, size: 48),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No products found',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Try adjusting your filters',
                                    style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filteredProducts.length,
                            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade100, height: 1),
                            itemBuilder: (context, index) => _buildProductRow(_filteredProducts[index], index + 1),
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

  Widget _buildProductRow(ProductModel p, int sn) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('$sn', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    p.image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) => Container(color: Colors.grey.shade100, child: const Icon(Icons.image_not_supported)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text(p.title, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
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
                Text(p.vendor?.shopName ?? 'Unknown Shop', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13)),
                Text(p.vendor?.name ?? 'Admin Upload', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 11)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(p.category, style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
          ),
          Expanded(
            flex: 1,
            child: Text('₹${p.price.toStringAsFixed(0)}', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          Expanded(
            flex: 1,
            child: Text('${p.stock}', style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: p.status == 'Active' ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                p.status,
                style: GoogleFonts.inter(color: p.status == 'Active' ? Colors.green.shade700 : Colors.orange.shade700, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () => _handleDelete(p),
                ),
              ],
            ),
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
