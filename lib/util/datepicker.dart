import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //this is an external package for formatting date and time

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _selectedDate;

  //Method for showing the date picker
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime.now(),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
            onPressed: _pickDateDialog, child: const Text('Add Date')),
        const SizedBox(height: 20),
        Text(_selectedDate == null //ternary expression to check if date is null
            ? 'No date was chosen!'
            : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate!)}'),
      ],
    );
  }
}
