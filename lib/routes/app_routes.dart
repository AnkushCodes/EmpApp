import 'package:flutter/material.dart';
import '../pages/add_employee_details_page.dart';
import '../pages/EditEmployeePage.dart';
import '../pages/employee_details_page.dart';
import '../models/employee.dart';

class AppRoutes {
  static const String employeeList = '/';
  static const String addEmployee = '/add';
  static const String editEmployee = '/edit';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case addEmployee:
        return MaterialPageRoute(builder: (_) => const AddEmployeeDetailsPage());

      case editEmployee: {
        final args = settings.arguments as Map<String, dynamic>?;
        final Employee? employee = args != null ? args['employee'] as Employee? : null;

        if (employee != null) {
          return MaterialPageRoute(builder: (_) => EditEmployeePage(employee: employee));
        }
        // fallthrough to error
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Missing employee data for edit route')),
          ),
        );
      }

      case employeeList:
      default:
        return MaterialPageRoute(builder: (_) => const EmployeeListPage());
    }
  }
}
