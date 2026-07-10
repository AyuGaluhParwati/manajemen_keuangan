import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {

  double totalIncome = 0;

  double totalExpense = 0;

  double get balance => totalIncome - totalExpense;

}