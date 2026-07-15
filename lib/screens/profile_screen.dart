import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/currency_formatter.dart';

import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final transactionProvider = context.watch<TransactionProvider>();

    final remainingBudget = profileProvider.remainingBudget(
      transactionProvider.totalExpense,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              profileProvider.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "Mahasiswa PNB",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Budget Bulanan",
                      style: TextStyle(fontSize: 18),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      CurrencyFormatter.format(profileProvider.budget),
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sudah Dipakai"),
                        Text(
                          CurrencyFormatter.format(
                            transactionProvider.totalExpense,
                          ),
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sisa Budget"),
                        Text(
                          CurrencyFormatter.format(remainingBudget),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.arrow_downward,
                      color: Colors.blue,
                    ),
                    title: const Text("Total Pemasukan"),
                    trailing: Text(
                      CurrencyFormatter.format(
                        transactionProvider.totalIncome,
                      ),
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.arrow_upward,
                      color: Colors.red,
                    ),
                    title: const Text("Total Pengeluaran"),
                    trailing: Text(
                      CurrencyFormatter.format(
                        transactionProvider.totalExpense,
                      ),
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.green,
                    ),
                    title: const Text("Saldo"),
                    trailing: Text(
                      CurrencyFormatter.format(
                        transactionProvider.balance,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text("Edit Profil"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: const Text("Export PDF"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Export PDF Segera Hadir!"),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.table_chart),
                    title: const Text("Export Excel"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Export Excel Segera Hadir!"),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      await context.read<AuthProvider>().logout();

                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                              (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}