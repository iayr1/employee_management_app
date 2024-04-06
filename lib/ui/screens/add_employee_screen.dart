import 'package:flutter/material.dart';
import 'package:employee_management_app/models/employee_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Function(Employee) onEmployeeAdded;
  final Future<void> Function(Employee newEmployee) addEmployee;

  const AddEmployeeScreen({
    Key? key,
    required this.onEmployeeAdded,
    required this.addEmployee,
  }) : super(key: key);

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: _salaryController,
              decoration: const InputDecoration(labelText: 'Salary'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Employee newEmployee = Employee(
                  employee_name: _nameController.text,
                  employee_age: int.tryParse(_ageController.text) ?? 0,
                  employee_salary: int.tryParse(_salaryController.text) ?? 0,
                );
                try {
                  await widget.addEmployee(newEmployee);
                  widget.onEmployeeAdded(newEmployee);
                  Navigator.pop(context);
                } catch (e) {
                  print('Error adding employee: $e');
                }
              },
              child: const Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }
}
