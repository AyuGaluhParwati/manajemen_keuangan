import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Dashboard"),

        backgroundColor: Colors.green,

        foregroundColor: Colors.white,

        actions: [

          IconButton(

            onPressed: () async {

              await context.read<AuthProvider>().logout();

              if (context.mounted) {
                Navigator.pushReplacementNamed(context, "/");
              }

            },

            icon: const Icon(Icons.logout),

          )

        ],

      ),

      body: const Center(

        child: Text(

          "Selamat Datang 👋",

          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),

        ),

      ),

    );

  }

}