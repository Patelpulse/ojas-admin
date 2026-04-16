import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';

class OrderController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic> _orders = [];
  bool _isLoading = false;

  List<dynamic> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchAllOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.dio.get('/order/all');
      if (response.statusCode == 200) {
        _orders = response.data['orders'] ?? [];
      }
    } catch (e) {
      debugPrint('Fetch all orders error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _apiService.dio.put('/order/status', data: {
        'orderId': orderId,
        'status': status,
      });
      if (response.statusCode == 200) {
        await fetchAllOrders();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Update order status error: $e');
      return false;
    }
  }
}
