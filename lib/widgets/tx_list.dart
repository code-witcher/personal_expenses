import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TxList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteItem;

  const TxList({
    Key? key,
    required this.transactions,
    required this.deleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: transactions.isEmpty
          ? LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No transtacion yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxHeight * 0.7,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                );
              },
            )
          : ListView.builder(
              itemBuilder: (context, index) => Card(
                elevation: 7,
                // color: Colors.teal,
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    // style: ListTileStyle.list,
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      radius: 30,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            '\$${transactions[index].amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    title: Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        transactions[index].title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('E MMM dd, yyyy hh:mma')
                          .format(transactions[index].date),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: MediaQuery.of(context).size.width >= 450
                        ? TextButton.icon(
                            label: Text(
                              'Delete',
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                            icon: Icon(
                              Icons.delete_rounded,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () => deleteItem(transactions[index].id),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.delete_rounded,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () => deleteItem(transactions[index].id),
                          ),
                  ),
                ),
              ),
              itemCount: transactions.length,
            ),
    );
  }
}

// TxElement(
//                         amount: tx.amount,
//                         date: tx.date,
//                         title: tx.title,
//                       )
