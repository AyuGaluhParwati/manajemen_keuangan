import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../utils/currency_formatter.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  String selectedFilter = "Realtime";
  DateTimeRange? selectedRange;

  @override
  Widget build(BuildContext context) {

    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {

        final filtered = provider.getFilteredTransactions(
          selectedFilter,
          selectedRange,
        );

        double income = 0;
        double expense = 0;

        for (var trx in filtered) {
          if (trx.type == "income") {
            income += trx.amount;
          } else {
            expense += trx.amount;
          }
        }

        final balance = income - expense;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const Text(
                "REKAP KEUANGAN",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Wrap(
                spacing: 10,
                children: [

                  ChoiceChip(
                    label: const Text("Realtime"),
                    selected: selectedFilter == "Realtime",
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = "Realtime";
                        selectedRange = null;
                      });
                    },
                  ),

                  ChoiceChip(
                    label: const Text("Bulanan"),
                    selected: selectedFilter == "Bulanan",
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = "Bulanan";
                        selectedRange = null;
                      });
                    },
                  ),

                  ChoiceChip(
                    label: const Text("Custom"),
                    selected: selectedFilter == "Custom",
                    onSelected: (_) async {

                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2035),
                      );

                      if (picked != null) {
                        setState(() {
                          selectedFilter = "Custom";
                          selectedRange = picked;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      const Text(
                        "Saldo",
                        style: TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        CurrencyFormatter.format(balance),
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.arrow_downward,
                    color: Colors.blue,
                  ),
                  title: const Text("Total Pemasukan"),
                  trailing: Text(
                    CurrencyFormatter.format(income),
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.arrow_upward,
                    color: Colors.red,
                  ),
                  title: const Text("Total Pengeluaran"),
                  trailing: Text(
                    CurrencyFormatter.format(expense),
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}