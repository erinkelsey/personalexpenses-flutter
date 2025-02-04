import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // Set device orientation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);

  runApp(MyApp());
}

/// Main entry point for app.
///
/// Creates the main MaterialApp widget and outlines
/// the theme for this app.
/// Assigns [MyHomePage] as the home page for the app.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

/// Main (and only!) page of the app.
///
/// Builds and returns the app page as a stateful widget.
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// Builds the stateful widget for MyHomePage.
///
/// Builds and returns the home page, based on the current state.
class _MyHomePageState extends State<MyHomePage> {
  /// List of Transaction objects as the user's transaction.
  final List<Transaction> _userTransactions = [];

  /// Only for Android and iOS in Landscape orientation.
  /// If set to true, shows chart, else shows transaction list.
  bool _showChart = false;

  /// Getter for the user's recent transactions.
  ///
  /// Gets the user's transaction that occurred in the past
  /// 7 days from [_recentTransactions] , and returns as a
  /// list of Transaction objects.
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  /// Adds a new Transaction to the user's current transaction.
  ///
  /// Adds a new Transaction to [_userTransactions]. The new transaction
  /// will have [txTitle] as title, [txAmount] as it's amount, and [txDate]
  /// as the date of the transaction.
  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: txDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  /// Start adding a new transaction by opening up a dialog (on web), or
  /// a modal bottom sheet (on Android or iOS).
  ///
  /// Returns the Dialog or ModalBottomSheet to be shown.
  void _startAddNewTransaction(BuildContext ctx) {
    if (kIsWeb) {
      showDialog(
          context: ctx,
          builder: (_) {
            return new AlertDialog(content: NewTransaction(_addNewTransaction));
          });
    } else {
      showModalBottomSheet(
          context: ctx,
          isScrollControlled: true,
          builder: (_) {
            return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(_addNewTransaction),
            );
          });
    }
  }

  /// Deletes one of the user's transactions.
  ///
  /// Removes transaction with identified [id] from the
  /// [_userTransactions] list
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = !kIsWeb && Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      constraints: BoxConstraints(minWidth: 400, maxWidth: 500),
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              if (isLandscape && !kIsWeb)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Show Chart',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      },
                    ),
                  ],
                ),
              if (!isLandscape || kIsWeb)
                Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  constraints: BoxConstraints(minWidth: 400, maxWidth: 400),
                  child: Chart(_recentTransactions),
                ),
              if (!isLandscape || kIsWeb) txListWidget,
              if (isLandscape && !kIsWeb)
                _showChart
                    ? Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.7,
                        constraints:
                            BoxConstraints(minWidth: 400, maxWidth: 400),
                        child: Chart(_recentTransactions),
                      )
                    : txListWidget
            ],
          ),
        ),
      ),
    );

    return !kIsWeb && Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation: !kIsWeb
                ? FloatingActionButtonLocation.centerFloat
                : FloatingActionButtonLocation.endFloat,
            floatingActionButton: !kIsWeb && Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
