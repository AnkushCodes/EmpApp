import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/employee.dart';
import '../widgets/common_app_bar.dart';

class AddEmployeeDetailsPage extends StatefulWidget {
  const AddEmployeeDetailsPage({Key? key}) : super(key: key);

  @override
  State<AddEmployeeDetailsPage> createState() => _AddEmployeeDetailsPageState();
}

class _AddEmployeeDetailsPageState extends State<AddEmployeeDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedRole;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> roles = [
    'Full-stack Developer',
    'Senior Software developer',
    'UI/UX Designer',
    'QA Engineer',
    'Project Manager',
  ];


  DateTime getNextWeekday(int weekday) {
    final now = DateTime.now();
    int daysToAdd = (weekday - now.weekday + 7) % 7;
    daysToAdd = daysToAdd == 0 ? 7 : daysToAdd;
    return now.add(Duration(days: daysToAdd));
  }


  Future<void> _showStartDatePicker() async {
    DateTime tempDate = _startDate ?? DateTime.now();
    String? selectedQuick;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setSheetState) {
          void applyQuick(String label) {
            final now = DateTime.now();
            setSheetState(() {
              selectedQuick = label;
              switch (label) {
                case 'Today':
                  tempDate = now;
                  break;
                case 'Next Monday':
                  tempDate = getNextWeekday(DateTime.monday);
                  break;
                case 'Next Tuesday':
                  tempDate = getNextWeekday(DateTime.tuesday);
                  break;
                case 'After 1 week':
                  tempDate = now.add(const Duration(days: 7));
                  break;
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
                  runSpacing: 8.h,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF2196F3),
                      ),
                      onPressed: () {
                        setState(() => _startDate = tempDate);
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
    DateTime tempDate = _endDate ?? DateTime.now();
    String? selectedQuick;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setSheetState) {
          void applyQuick(String label) {
            final now = DateTime.now();
            setSheetState(() {
              selectedQuick = label;
              if (label == 'Today') tempDate = now;
              if (label == 'No date') tempDate = DateTime(1800);
            });
          }

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _quickButton('No date', selectedQuick, applyQuick),
                    _quickButton('Today', selectedQuick, applyQuick),
                  ],
                ),
                SizedBox(height: 12.h),

                CalendarDatePicker(
                  initialDate: tempDate.year < 1900
                      ? DateTime.now()
                      : tempDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateChanged: (picked) {
                    setSheetState(() => tempDate = picked);
                  },
                ),

                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF2196F3),
                      ),
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
        color: Colors.white,
        height: 250.h,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Add Employee Details"),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Employee name',
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
                    labelText: 'Select role',
                    prefixIcon: const Icon(Icons.work_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text(
                    _selectedRole ?? 'Select role',
                    style: TextStyle(
                        color:
                        _selectedRole == null ? Colors.grey : Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20.h),


              Row(
                children: [
                  Expanded(
                    child: _dateBox(
                      label: _startDate == null
                          ? 'No date'
                          : DateFormat('d MMM yyyy').format(_startDate!),
                      onTap: _showStartDatePicker,
                    ),
                  ),
                  Icon(Icons.arrow_right_alt, size: 30.w, color: Colors.grey),
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
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [

        Row(
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


              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter employee name')),
                  );
                  return;
                }
                final role = _selectedRole ?? roles.first;
                final start = _startDate ?? DateTime.now();
                final end = _endDate ?? start;
                final emp = Employee(name: name, role: role, startDate: start, endDate: end);
                Navigator.pop(context, emp);
              },
              child: const Text("Save"),
            ),
          ],
        )
      ],
    );
  }

  Widget _dateBox({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: Color(0xFF2196F3), size: 18),
            SizedBox(width: 8.w),
            Text(label, style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }
}
