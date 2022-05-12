import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  ChartBar(
      {required this.amount,
      required this.label,
      required this.totalPCTamount,
      Key? key})
      : super(key: key);

  String label;
  double amount;
  double totalPCTamount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                '\$${amount.toStringAsFixed(0)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(
            height: 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.65,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(220, 220, 220, 220),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: totalPCTamount,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                label,
              ),
            ),
          ),
        ],
      );
    });
  }
}
