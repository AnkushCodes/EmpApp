import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/employee.dart';
import '../routes/app_routes.dart';
import '../widgets/common_app_bar.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('employees') ?? [];
    setState(() {
      employees = data.map((e) => Employee.fromJson(jsonDecode(e))).toList();
    });
  }

  Future<void> _saveEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final data = employees.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('employees', data);
  }

  Future<void> _deleteEmployee(int index) async {
    final deletedEmployee = employees[index];
    setState(() {
      employees.removeAt(index);
    });
    await _saveEmployees();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Employee data has been deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setState(() {
              employees.insert(index, deletedEmployee);
            });
            await _saveEmployees();
          },
        ),
      ),
    );
  }

  Future<void> _addOrEditEmployee({Employee? employee, int? index}) async {
    final routeName = employee == null ? AppRoutes.addEmployee : AppRoutes.editEmployee;
    final args = employee == null ? null : {'employee': employee, 'index': index};

    final result = await Navigator.pushNamed(context, routeName, arguments: args);

    if (result != null && result is Employee) {
      setState(() {
        if (index != null) {
          employees[index] = result;
        } else {
          employees.add(result);
        }
      });
      await _saveEmployees();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy');

    return Scaffold(
      appBar:  CommonAppBar(title: 'Employee List'),

      body: employees.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image1.png',
              width: 180,
            ),
            const SizedBox(height: 12),

          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final e = employees[index];
          final endDateText = e.endDate == null ? 'No date' : dateFormat.format(e.endDate!);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Slidable(
              key: ValueKey(e.name),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (_) => _deleteEmployee(index),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    e.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '${e.role}\n${dateFormat.format(e.startDate)} → $endDateText',
                  ),
                  isThreeLine: true,
                  onTap: () => _addOrEditEmployee(employee: e, index: index),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _addOrEditEmployee(),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
