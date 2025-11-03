import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/employee.dart';
import '../widgets/common_app_bar.dart';

class EditEmployeePage extends StatefulWidget {
  final Employee employee;

  const EditEmployeePage({super.key, required this.employee});

  @override
  State<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  late TextEditingController _nameController;
  late String _selectedRole;
  late DateTime _startDate;
  late DateTime? _endDate;

  final List<String> roles = [
    'Flutter Developer',
    'Backend Developer',
    'UI Designer',
    'Project Manager',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _selectedRole = widget.employee.role;
    _startDate = widget.employee.startDate;
    _endDate = widget.employee.endDate;
  }

  DateTime getNextWeekday(int weekday) {
    final now = DateTime.now();
    int daysToAdd = (weekday - now.weekday + 7) % 7;
    if (daysToAdd == 0) {
      daysToAdd = 7;
    }
    return now.add(Duration(days: daysToAdd));
  }

  Future<void> _showStartDatePicker() async {
    DateTime tempDate = _startDate;
    String? selectedQuick;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setSheetState) {
          void applyQuick(String label) {
            final now = DateTime.now();
            setSheetState(() {
              selectedQuick = label;
              if (label == 'Today') {
                tempDate = now;
              } else if (label == 'Next Monday') {
                tempDate = getNextWeekday(DateTime.monday);
              } else if (label == 'Next Tuesday') {
                tempDate = getNextWeekday(DateTime.tuesday);
              } else if (label == 'After 1 week') {
                tempDate = now.add(const Duration(days: 7));
              }
            });
          }

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8.w,
                  children: [
                    _quickButton('Today', selectedQuick, applyQuick),
                    _quickButton('Next Monday', selectedQuick, applyQuick),
                    _quickButton('Next Tuesday', selectedQuick, applyQuick),
                    _quickButton('After 1 week', selectedQuick, applyQuick),
                  ],
                ),
                SizedBox(height: 12.h),
                CalendarDatePicker(
                  initialDate: tempDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateChanged: (picked) {
                    setSheetState(() => tempDate = picked);
                  },
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    SizedBox(width: 10.w),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3)),
                      onPressed: () {
                        setState(() {
                          _startDate = tempDate;
                          if (_endDate != null && _startDate.isAfter(_endDate!)) {
                            _endDate = null;
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> _showEndDatePicker() async {
    DateTime tempDate = _endDate ?? DateTime(1800);
    String? selectedQuick;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setSheetState) {
          void applyQuick(String label) {
            setSheetState(() {
              selectedQuick = label;
              if (label == 'Today') {
                tempDate = DateTime.now();
              } else if (label == 'No date') {
                tempDate = DateTime(1800);
              }
            });
          }

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8.w,
                  children: [
                    _quickButton('No date', selectedQuick, applyQuick),
                    _quickButton('Today', selectedQuick, applyQuick),
                  ],
                ),
                SizedBox(height: 12.h),
                CalendarDatePicker(
                  initialDate:  _startDate ?? tempDate,
                  firstDate: _startDate,
                  lastDate: DateTime(2100),
                  onDateChanged: (picked) {
                    setSheetState(() => tempDate = picked);
                  },
                ),
                SizedBox(height: 8.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    SizedBox(width: 10.w),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF2196F3)),
                      onPressed: () {
                        setState(() {
                          _endDate = tempDate.year < 1900 ? null : tempDate;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showRolePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250.h,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40.h,
                onSelectedItemChanged: (index) {
                  setState(() => _selectedRole = roles[index]);
                },
                children: roles.map((e) => Center(child: Text(e))).toList(),
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickButton(
      String label, String? selected, void Function(String) onTap) {
    bool isSelected = selected == label;
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2196F3),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _saveAndReturn() {
    final updatedEmployee = Employee(
      name: _nameController.text,
      role: _selectedRole,
      startDate: _startDate,
      endDate: _endDate,
    );
    Navigator.pop(context, updatedEmployee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Edit Employee Details"),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Employee name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: _showRolePicker,
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: 'Select role',
                    prefixIcon: const Icon(Icons.work_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text(_selectedRole),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: _dateBox(
                      label: DateFormat('d MMM yyyy').format(_startDate),
                      onTap: _showStartDatePicker,
                    ),
                  ),
                  Icon(Icons.arrow_right_alt, size: 30.w, color: Colors.blueGrey),
                  Expanded(
                    child: _dateBox(
                      label: _endDate == null
                          ? 'No date'
                          : DateFormat('d MMM yyyy').format(_endDate!),
                      onTap: _showEndDatePicker,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(

                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              SizedBox(width: 10.w),
              ElevatedButton(

                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),

                  ),
                ),
                onPressed: _saveAndReturn,
                child: const Text("Save"),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _dateBox({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Colors.blue, size: 18),
            SizedBox(width: 8.w),
            Text(label, style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }
}
