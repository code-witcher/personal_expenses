import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:personal_expenses/widgets/chart.dart';
import 'models/transaction.dart';
import 'widgets/tx_list.dart';
import 'widgets/new_transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      title: 'Personal Expense',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.redAccent,
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          titleLarge:
              TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
          titleMedium: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        appBarTheme: AppBarTheme(
            centerTitle: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge),
        // colorScheme: ColorScheme(
        //   surface: null,
        //   secondary: null,
        //   primary: null,
        //   background: null,
        //   brightness: null,
        //   error: null,
        //   onBackground: null,
        //   onError: null,
        //   onSecondary: null,
        //   onPrimary: null,
        //   onSurface: null,
        // ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transcation(
    //   id: '1',
    //   title: 'New Shose',
    //   amount: 149.90,
    //   date: DateTime.now(),
    // ),
  ];

  void _addTransaction(String txTitle, double txAmount, DateTime date) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: date,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => GestureDetector(
        child: NewTransaction(_addTransaction),
        behavior: HitTestBehavior.opaque,
        onTap: () {},
      ),
    );
  }

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(
            days: 7,
          ),
        ),
      );
    }).toList();
  }

  bool _showChart = false;

  List<Widget> _buildPortraitStyle(list, appBarAndroid) {
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                appBarAndroid.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.3,
        child: Chart(_userTransactions),
      ),
      list
    ];
  }

  List<Widget> _buildLandscapStyle(list, appBarAndroid) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_showChart ? 'Show List' : 'Show Chart'),
          Switch.adaptive(
              value: _showChart,
              onChanged: (value) {
                setState(() {
                  _showChart = value;
                });
              }),
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appBarAndroid.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: Chart(_userTransactions),
            )
          : list,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBarIOS = CupertinoNavigationBar(
      middle: const Text('Personal Expense'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => startAddNewTransaction(context),
          )
        ],
      ),
    );
    final appBarAndroid = AppBar(
      title: const Text('Personal Expense'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => startAddNewTransaction(context),
        )
      ],
    );

    var list = Container(
      height: (MediaQuery.of(context).size.height -
              appBarAndroid.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TxList(
        transactions: _userTransactions,
        deleteItem: _deleteTransaction,
      ),
    );

    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (!isLandscape) ..._buildPortraitStyle(list, appBarAndroid),
            if (isLandscape) ..._buildLandscapStyle(list, appBarAndroid),
          ],
        ),
      ),
    );

    return Platform.isAndroid
        ? CupertinoPageScaffold(
            navigationBar: appBarIOS,
            child: appBody,
          )
        : Scaffold(
            appBar: appBarAndroid,
            body: appBody,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => startAddNewTransaction(context),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
