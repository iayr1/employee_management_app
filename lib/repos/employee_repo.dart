import 'package:employee_management_app/models/employee_model.dart';
import 'package:employee_management_app/networking/api_endpoints.dart';
import 'package:employee_management_app/networking/dio_client.dart';

class EmployeeRepo {
  final DioClient _dioClient = DioClient();

  Future<List<Employee>> getAllEmployees() async {
    try {
      final response = await _dioClient.get(path: ApiEndpoints.getEmployees);
      if (response.statusCode == 200) {
        if (response.data['status'] == 'success') {
          final List<Employee> allEmployees = (response.data['data'] as List)
              .map((json) => Employee.fromJson(json))
              .toList();
          return allEmployees;
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error in getAllEmployees: $e');
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      final response = await _dioClient.post(path: ApiEndpoints.addEmployee, data: employee.toJson());
      if (response.statusCode == 200) {
        if (response.data['status'] == 'success') {
        } else {
          throw Exception('Failed to add employee: ${response.data['message']}');
        }
      } else {
        throw Exception('Failed to add employee');
      }
    } catch (e) {
      throw Exception('Error in addEmployee: $e');
    }
  }

  Future<void> deleteEmployee(int employeeId) async {
    try {
      final response = await _dioClient.delete(path: ApiEndpoints.deleteEmployee, data: null);
      if (response.statusCode == 200) {
        if (response.data['status'] == 'success') {
        } else {
          throw Exception('Failed to delete employee: ${response.data['message']}');
        }
      } else {
        throw Exception('Failed to delete employee');
      }
    } catch (e) {
      throw Exception('Error in deleteEmployee: $e');
    }
  }

  Future<Employee> getCurrentEmployee(int employeeId) async {
    try {
      final response = await _dioClient.get(path: '${ApiEndpoints.getCurrentEmployee}$employeeId');
      if (response.statusCode == 200) {
        if (response.data['status'] == 'success') {
          final employee = Employee.fromJson(response.data['data']);
          return employee;
        } else {
          throw Exception('Failed to fetch current employee: ${response.data['message']}');
        }
      } else {
        throw Exception('Failed to fetch current employee');
      }
    } catch (e) {
      throw Exception('Error in getCurrentEmployee: $e');
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      final response = await _dioClient.put(path: '${ApiEndpoints.updateEmployee}${employee.id}', data: employee.toJson());
      if (response.statusCode == 200) {
        if (response.data['status'] == 'success') {
        } else {
          throw Exception('Failed to update employee: ${response.data['message']}');
        }
      } else {
        throw Exception('Failed to update employee');
      }
    } catch (e) {
      throw Exception('Error in updateEmployee: $e');
    }
  }
}
