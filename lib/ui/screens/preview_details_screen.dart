import 'package:flutter/material.dart';
import 'package:employee_management_app/models/employee_model.dart';
import 'package:employee_management_app/repos/employee_repo.dart';

class PreviewScreen extends StatefulWidget {
  final int? employeeId;
  final Employee employee;

  const PreviewScreen({Key? key, required this.employeeId, required this.employee}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final EmployeeRepo _employeeRepo = EmployeeRepo();
  late Employee _currentEmployee;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.employeeId != null) {
      _fetchCurrentEmployee();
    } else {
      _currentEmployee = widget.employee;
      _isLoading = false;
    }
  }

  Future<void> _fetchCurrentEmployee() async {
    try {
      final employee = await _employeeRepo.getCurrentEmployee(widget.employeeId!);
      setState(() {
        _currentEmployee = employee;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${_currentEmployee.employee_name}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Age: ${_currentEmployee.employee_age}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Salary: \$${_currentEmployee.employee_salary}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
    );
  }
}
