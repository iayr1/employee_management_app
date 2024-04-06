class ApiEndpoints { // This is a class named "ApiEndpoints".
  static const String baseUrl = 'https://dummy.restapiexample.com'; // This is where our API lives on the internet.

  static const getEmployees =  '/api/v1/employees'; // This is the endpoint for getting a list of employees.
  static const addEmployee =  '/api/v1/create'; // This is the endpoint for adding a new employee.
  static const updateEmployee =  '/api/v1/update/'; // This is the endpoint for updating an existing employee.
  static const deleteEmployee =  '/api/v1/delete/'; // This is the endpoint for deleting an existing employee.
  static const getCurrentEmployee =  '/api/v1/employee/'; // This is the endpoint for getting information about a specific employee.
}
