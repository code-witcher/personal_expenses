import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTx;

  const NewTransaction(
    this.addNewTx, {
    Key? key,
  }) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountControler = TextEditingController();
  DateTime? _selectedDate;

  void submitData() {
    if (amountControler.text.isEmpty) return;

    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountControler.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addNewTx(
      titleController.text,
      double.parse(amountControler.text),
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsetsDirectional.only(
            top: 10,
            start: 10,
            end: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Card(
          elevation: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsetsDirectional.all(8),
                child: Platform.isAndroid
                    ? CupertinoTextField(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(30)),
                        placeholder: 'Title',
                        padding: const EdgeInsets.all(16),
                      )
                    : TextField(
                        controller: titleController,
                        autocorrect: true,
                        autofocus: true,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => submitData(),
                      ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.all(8),
                child: TextField(
                  controller: amountControler,
                  autocorrect: true,
                  autofocus: true,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => submitData(),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: const Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: Platform.isAndroid
                    ? CupertinoButton(
                        child: Text(
                          'Add Transaction',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        onPressed: submitData,
                        color: Theme.of(context).primaryColor,
                      )
                    : ElevatedButton(
                        onPressed: submitData,
                        child: Text(
                          'Add Transaction',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
