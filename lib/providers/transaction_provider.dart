import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  TransactionProvider() {
    loadTransactions();
  }

  // ===========================
  // LOAD SQLITE
  // ===========================
  Future<void> loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();

    _transactions =
        data.map((e) => TransactionModel.fromMap(e)).toList();

    notifyListeners();
  }

  // ===========================
  // INSERT
  // ===========================
  Future<void> addTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.insertTransaction(
      transaction.toMap(),
    );

    await loadTransactions();
  }

  // ===========================
  // DELETE
  // ===========================
  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);

    await loadTransactions();
  }

  // ===========================
  // UPDATE
  // ===========================
  Future<void> updateTransaction(
      TransactionModel transaction) async {
    await DatabaseHelper.instance.updateTransaction(
      transaction.toMap(),
    );

    await loadTransactions();
  }

  // ===========================
  // FILTER
  // ===========================
  List<TransactionModel> getFilteredTransactions(
      String filter,
      DateTimeRange? range,
      ) {
    if (filter == "Realtime") {
      return _transactions;
    }

    if (filter == "Bulanan") {
      final now = DateTime.now();

      return _transactions.where((trx) {
        final date = DateTime.parse(trx.createdAt);

        return date.month == now.month &&
            date.year == now.year;
      }).toList();
    }

    if (filter == "Custom" && range != null) {
      return _transactions.where((trx) {
        final date = DateTime.parse(trx.createdAt);

        return date.isAfter(
          range.start.subtract(
            const Duration(days: 1),
          ),
        ) &&
            date.isBefore(
              range.end.add(
                const Duration(days: 1),
              ),
            );
      }).toList();
    }

    return _transactions;
  }

  // ===========================
  // TOTAL PEMASUKAN
  // ===========================
  double get totalIncome => _transactions
      .where((e) => e.type == "income")
      .fold(0.0, (sum, e) => sum + e.amount);

  // ===========================
  // TOTAL PENGELUARAN
  // ===========================
  double get totalExpense => _transactions
      .where((e) => e.type == "expense")
      .fold(0.0, (sum, e) => sum + e.amount);

  // ===========================
  // SALDO
  // ===========================
  double get balance => totalIncome - totalExpense;
}