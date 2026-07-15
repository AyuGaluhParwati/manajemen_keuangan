import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(int index) {
    _transactions.removeAt(index);
    notifyListeners();
  }

  double get totalIncome => _transactions
      .where((e) => e.type == "income")
      .fold(0.0, (sum, e) => sum + e.amount);

  double get totalExpense => _transactions
      .where((e) => e.type == "expense")
      .fold(0.0, (sum, e) => sum + e.amount);

  double get balance => totalIncome - totalExpense;
}