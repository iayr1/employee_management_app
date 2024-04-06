import 'package:flutter/material.dart';
import 'package:employee_management_app/networking/dio_client.dart';
import 'package:employee_management_app/models/employee_model.dart';

class UpdateEmployeeScreen extends StatefulWidget {
  final int? employeeId;
  final Employee employee;

  const UpdateEmployeeScreen({super.key, required this.employeeId, required this.employee});

  @override
  _UpdateEmployeeScreenState createState() => _UpdateEmployeeScreenState();
}

class _UpdateEmployeeScreenState extends State<UpdateEmployeeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _salaryController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _salaryController = TextEditingController();
    _initFields();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _initFields() {
    _nameController.text = widget.employee.employee_name ?? '';
    _ageController.text = widget.employee.employee_age?.toString() ?? '';
    _salaryController.text = widget.employee.employee_salary?.toString() ?? '';
  }

  Future<void> _updateEmployee() async {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty || _salaryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> data = {
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'salary': double.tryParse(_salaryController.text) ?? 0.0,
      };
      final response = await DioClient().put(path: 'updateEmployeeDetails/${widget.employeeId}', data: data);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employee updated successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update employee')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Employee'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Age'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an age';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Salary'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a salary';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _updateEmployee,
                    child: const Text('Update Employee'),
                  ),
                ],
              ),
            ),
    );
  }
}
