import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Text(
                "Hallo, Galuh 👋",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 5),

              Text(
                DateTime.now().toString().substring(0, 10),
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              /// Card Saldo
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "Saldo Saat Ini",
                        style: TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Rp ${provider.balance.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const Divider(height: 35),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text("Pemasukan"),

                              const SizedBox(height: 5),

                              Text(
                                "Rp ${provider.totalIncome.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            children: [
                              const Text("Pengeluaran"),

                              const SizedBox(height: 5),

                              Text(
                                "Rp ${provider.totalExpense.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Riwayat Transaksi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),

              const SizedBox(height: 15),

              provider.transactions.isEmpty
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.receipt_long,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Belum ada transaksi",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: provider.transactions.length,
                      itemBuilder: (context, index) {
                        final trx = provider.transactions[index];

                        return Card(
                          elevation: 2,
                          margin:
                              const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            onLongPress: () async {
                              final confirm =
                                  await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text(
                                      "Hapus Transaksi"),
                                  content: const Text(
                                      "Apakah Anda yakin ingin menghapus transaksi ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(
                                              context, false),
                                      child:
                                          const Text("Batal"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton
                                          .styleFrom(
                                        backgroundColor:
                                            Colors.red,
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(
                                              context, true),
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(
                                            color:
                                                Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true &&
                                  trx.id != null) {
                                await provider
                                    .deleteTransaction(
                                        trx.id!);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(
                                    const SnackBar(
                                      backgroundColor:
                                          Colors.red,
                                      content: Text(
                                        "Transaksi berhasil dihapus",
                                      ),
                                    ),
                                  );
                                }
                              }
                            },

                            leading: CircleAvatar(
                              backgroundColor:
                                  trx.type == "income"
                                      ? Colors.blue
                                      : Colors.red,
                              child: Icon(
                                trx.type == "income"
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: Colors.white,
                              ),
                            ),

                            title: Text(trx.title),

                            subtitle: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(trx.category),
                                Text(
                                  trx.date,
                                  style: const TextStyle(
                                      fontSize: 12),
                                ),
                              ],
                            ),

                            trailing: Text(
                              "Rp ${trx.amount.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    trx.type == "income"
                                        ? Colors.blue
                                        : Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}