import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    // validation
    if (enteredTitle.isEmpty || enteredAmount <= 0){
      return;
    }

    widget.addTx(
      enteredTitle, 
      enteredAmount
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: !kIsWeb ? 5 : 0,
      child: Container(
        height: !kIsWeb ? 400 : null,
        constraints:  kIsWeb ? BoxConstraints(minWidth: 400, maxWidth: 500, maxHeight: 200, minHeight: 200) : null,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              // onChanged: (value) => amountInput = value,
              controller: amountController,
              // keyboardType: TextInputType.numberWithOptions(signed:true, decimal:true),
              keyboardType: TextInputType.numberWithOptions(decimal:true),
              onSubmitted: (_) => submitData(),
            ),
            FlatButton(
              child: Text('Add Transaction'), 
              onPressed: submitData,
              textColor: Colors.purple,
            ),
          ]
        ),
      ),
    );
  }
}