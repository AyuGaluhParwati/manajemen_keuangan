import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/profile_provider.dart';

import 'screens/splash_screen.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: const MoneyManager(),
    ),
  );
}

class MoneyManager extends StatelessWidget {
  const MoneyManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Money Manager",

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),

      home: const SplashScreen(),
    );
  }
}
