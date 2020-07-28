import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import './adaptive_flat_button.dart';

/// Widget for handling a user entering new transaction details.
class NewTransaction extends StatefulWidget {
  /// Function to handle adding a transaction to list
  /// of user's transactions.
  ///
  /// Called when user presses submit, and is done entering
  /// their transaction information.
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // Controller for handling the title text field.
  final _titleController = TextEditingController();

  // Controller for handling the amount text field.
  final _amountController = TextEditingController();

  // Field for the date selected on a date picker.
  DateTime _selectedDate;

  /// Submit data from this widget to the main stateful widget.
  ///
  /// Data is only submitted if it passes validation. Validation includes
  /// making sure that all of the fields have values.
  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    double enteredAmount = double.parse(_amountController.text);

    // validation
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    // close modal/bottom sheet
    Navigator.of(context).pop();
  }

  /// Present the date picker to the user.
  ///
  /// Can only pick dates from current date, to beginning
  /// of year 2020 from calendar.
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: !kIsWeb ? 5 : 0,
        child: Container(
          constraints: kIsWeb
              ? BoxConstraints(
                  minWidth: 400, maxWidth: 500, maxHeight: 260, minHeight: 260)
              : null,
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  // onChanged: (value) => amountInput = value,
                  controller: _amountController,
                  // keyboardType: TextInputType.numberWithOptions(signed:true, decimal:true),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submitData(),
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Chosen!'
                              : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                        ),
                      ),
                      AdaptiveFlatButton(
                        'Choose Date',
                        _presentDatePicker,
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text('Add Transaction'),
                  onPressed: _submitData,
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color,
                ),
              ]),
        ),
      ),
    );
  }
}
