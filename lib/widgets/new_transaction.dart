import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty){
      return;
    }

    final enteredTitle = _titleController.text;
    double enteredAmount = double.parse(_amountController.text);

    // validation
    if (enteredTitle.isEmpty 
          || enteredAmount <= 0
          || _selectedDate == null){
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

  void _presentDatePicker(){
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2020), 
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null){
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: !kIsWeb ? 5 : 0,
      child: Container(
        height: !kIsWeb ? 400 : null,
        constraints:  kIsWeb ? BoxConstraints(minWidth: 400, maxWidth: 500, maxHeight: 260, minHeight: 260) : null,
        padding: EdgeInsets.all(10),
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
              keyboardType: TextInputType.numberWithOptions(decimal:true),
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
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold,),
                    ),
                    onPressed: _presentDatePicker,
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
          ]
        ),
      ),
    );
  }
}