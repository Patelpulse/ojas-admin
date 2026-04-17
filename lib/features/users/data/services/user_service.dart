import 'package:ojas_admin/core/services/api_service.dart';

class UserService {
  final ApiService _apiService;

  UserService(this._apiService);

  Future<List<dynamic>> getUsers() async {
    try {
      final response = await _apiService.dio.get('/admin/users');
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserStatus(String id, String status) async {
    try {
      // Assuming we might need this later, adding as a placeholder
      // await _apiService.dio.put('/admin/user-status/$id', data: {'status': status});
    } catch (e) {
      rethrow;
    }
  }
}
