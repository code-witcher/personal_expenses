import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/widgets/chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  const Chart(this.currentTransaction, {Key? key}) : super(key: key);

  final List<Transaction> currentTransaction;

  List<Map<String, Object>> get groubedTransaction {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < currentTransaction.length; i++) {
        if (currentTransaction[i].date.day == weekDay.day &&
            currentTransaction[i].date.month == weekDay.month &&
            currentTransaction[i].date.year == weekDay.year) {
          totalSum += currentTransaction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    });
  }

  double get weeklySpending {
    return groubedTransaction.fold(0.0, (sum, item) {
      return sum += (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groubedTransaction);
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      color: Theme.of(context).accentColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 8.0
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...groubedTransaction.map((element) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  amount: (element['amount'] as double),
                  label: '${element['day']}',
                  totalPCTamount: weeklySpending == 0
                      ? 0.0
                      : (element['amount'] as double) / weeklySpending,
                ),
              );
            }).toList().reversed,
          ],
        ),
      ),
    );
  }
}
