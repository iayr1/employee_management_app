import 'package:flutter/material.dart';
import 'package:employee_management_app/models/employee_model.dart';
import 'package:employee_management_app/repos/employee_repo.dart';
import 'package:employee_management_app/ui/screens/add_employee_screen.dart';
import 'package:employee_management_app/ui/screens/preview_details_screen.dart';
import 'package:employee_management_app/ui/screens/update_employee_screen.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final EmployeeRepo employeeRepo = EmployeeRepo();
  List<Employee> allEmployees = [];
  List<Employee> filteredEmployees = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  String? error;

  final ScrollController _scrollController = ScrollController();
  final List<String> _alphabets =
      List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

  @override
  void initState() {
    super.initState();
    getAllEmployees();
  }

  Future<void> getAllEmployees() async {
    setState(() {
      isLoading = true;
    });
    int retryDelay = 1000; // Start with 1 second delay
    int retryCount = 0;
    const maxRetryCount = 5;
    while (retryCount < maxRetryCount) {
      try {
        final employees = await employeeRepo.getAllEmployees();
        setState(() {
          allEmployees = employees;
          allEmployees.sort((a, b) => a.employee_name!.compareTo(b.employee_name!));
          filteredEmployees = allEmployees;
          isLoading = false;
        });
        return;
      } on DioError catch (e) {
        if (e.response?.statusCode == 429) {
          // If status code is 429 (Too Many Requests), retry with exponential backoff
          await Future.delayed(Duration(milliseconds: retryDelay));
          retryDelay *= 2; // Double the delay for next retry
          retryCount++;
        } else {
          // Handle other Dio errors
          setState(() {
            isLoading = false;
            error = 'Error fetching employees: ${e.message}';
          });
          return;
        }
      } catch (e) {
        // Handle other exceptions
        setState(() {
          isLoading = false;
          error = 'Error fetching employees: $e';
        });
        return;
      }
    }
    // Max retry count reached, show error message
    setState(() {
      isLoading = false;
      error = 'Max retry count reached. Unable to fetch employees.';
    });
  }

  void filterEmployees(String query) {
    List<Employee> searchResult = allEmployees
        .where((employee) =>
            employee.employee_name?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
    setState(() {
      filteredEmployees = searchResult;
    });
  }

  void navigateToDetailsScreen(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PreviewScreen(employee: employee, employeeId: null,)),
    );
  }

  Future<void> addEmployee(Employee newEmployee) async {
    try {
      await employeeRepo.addEmployee(newEmployee);
      await getAllEmployees();
    } catch (e) {
      setState(() {
        error = 'Error adding employee: $e';
      });
    }
  }

  Future<void> deleteEmployee(Employee employee) async {
    try {
      await employeeRepo.deleteEmployee(employee.id!);
      await getAllEmployees();
    } catch (e) {
      setState(() {
        error = 'Error deleting employee: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterEmployees,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search employees...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(child: Text(error!))
                    : filteredEmployees.isNotEmpty
                        ? Stack(
                            children: [
                              ListView.builder(
                                controller: _scrollController,
                                itemCount: filteredEmployees.length,
                                itemBuilder: (context, index) {
                                  final employee = filteredEmployees[index];
                                  return GestureDetector(
                                    onLongPress: () {
                                      _showEmployeeOptionsDialog(employee);
                                    },
                                    child: ListTile(
                                      onTap: () => navigateToDetailsScreen(employee),
                                      leading: const Icon(Icons.person),
                                      title: Text(employee.employee_name!),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  color: Colors.grey.withOpacity(0.5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: _alphabets
                                        .map((letter) => InkWell(
                                              onTap: () {
                                                final int startIndex = filteredEmployees.indexWhere(
                                                    (employee) => employee.employee_name!.startsWith(letter));
                                                if (startIndex != -1) {
                                                  _scrollController.jumpTo(
                                                      _scrollController.position.minScrollExtent +
                                                          startIndex * 60.0);
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  letter,
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Center(child: Text("No Employee found!")),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployeeScreen(
                onEmployeeAdded: addEmployee,
                addEmployee: (Employee newEmployee) async {
                  await addEmployee(newEmployee);
                },
              ),
            ),
          ).then((_) {
            getAllEmployees();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
      

  void _showEmployeeOptionsDialog(Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Employee Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Employee'),
                onTap: () {
                  Navigator.pop(context);
                  _editEmployee(employee);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Employee'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteEmployeeConfirmation(employee);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editEmployee(Employee employee) async {
    final updatedEmployee = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateEmployeeScreen(employeeId: employee.id!, employee: employee),
      ),
    );
    if (updatedEmployee != null) {
      final index = allEmployees.indexWhere((e) => e.id == updatedEmployee.id);
      if (index != -1) {
        setState(() {
          allEmployees[index] = updatedEmployee;
          filteredEmployees = List.from(allEmployees);
        });
      }
    }
  }

  void _deleteEmployeeConfirmation(Employee employee) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${employee.employee_name}?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteEmployee(employee);
                setState(() {
                  allEmployees.removeWhere((e) => e.id == employee.id);
                  filteredEmployees = List.from(allEmployees);
                });
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
