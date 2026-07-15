import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
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
                        "Rp ${provider.balance.toStringAsFixed(0)}",
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

              const SizedBox(height: 30),

              const Text(
                "Pemasukan vs Pengeluaran",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: [

                      PieChartSectionData(
                        value: provider.totalIncome,
                        color: Colors.blue,
                        title: "Masuk",
                        radius: 80,
                      ),

                      PieChartSectionData(
                        value: provider.totalExpense,
                        color: Colors.red,
                        title: "Keluar",
                        radius: 80,
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.arrow_downward,
                    color: Colors.blue,
                  ),
                  title: const Text("Total Pemasukan"),
                  trailing: Text(
                    "Rp ${provider.totalIncome.toStringAsFixed(0)}",
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
                    "Rp ${provider.totalExpense.toStringAsFixed(0)}",
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