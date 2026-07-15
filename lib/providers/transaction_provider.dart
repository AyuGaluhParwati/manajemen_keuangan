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
  // LOAD DATA DARI SQLITE
  // ===========================
  Future<void> loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();

    _transactions =
        data.map((e) => TransactionModel.fromMap(e)).toList();

    notifyListeners();
  }

  // ===========================
  // TAMBAH TRANSAKSI
  // ===========================
  Future<void> addTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.insertTransaction(
      transaction.toMap(),
    );

    await loadTransactions();
  }

  // ===========================
  // HAPUS TRANSAKSI
  // ===========================
  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);

    await loadTransactions();
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