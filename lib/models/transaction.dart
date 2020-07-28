import 'package:flutter/foundation.dart';

/// Model for a single transaction.
class Transaction {
  /// String id for this transaction.
  final String id;

  /// Title of this transaction.
  final String title;

  /// Amount (as a double) of this transaction.
  final double amount;

  /// Date this transaction took place.
  final DateTime date;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
  });
}
