import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState
    extends State<AddTransactionScreen> {

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final merchantController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String type = "expense";

  String category = "Kos & Makan";

  DateTime selectedDate = DateTime.now();

  final List<String> categories = [
    "Kos & Makan",
    "Keperluan Kuliah",
    "Hiburan & Self Reward",
  ];

  @override
  void dispose() {
    titleController.dispose();
    merchantController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void saveTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final transaction = TransactionModel(
      title: titleController.text,
      merchant: merchantController.text,
      amount: double.parse(amountController.text),
      type: type,
      category: category,
      note: noteController.text,
      date: DateFormat('dd MMM yyyy').format(selectedDate),
      receipt: null,
      createdAt: DateTime.now().toString(),
    );

    context
        .read<TransactionProvider>()
        .addTransaction(transaction);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Transaksi"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              Card(
                child: Column(
                  children: [

                    RadioListTile(
                      value: "income",
                      groupValue: type,
                      title: const Text("Pemasukan"),
                      onChanged: (value) {
                        setState(() {
                          type = value!;
                        });
                      },
                    ),

                    RadioListTile(
                      value: "expense",
                      groupValue: type,
                      title: const Text("Pengeluaran"),
                      onChanged: (value) {
                        setState(() {
                          type = value!;
                        });
                      },
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Judul",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Judul wajib diisi" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: merchantController,
                decoration: const InputDecoration(
                  labelText: "Merchant",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nominal",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nominal wajib diisi" : null,
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Kategori",
                ),
                items: categories.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Catatan",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                tileColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text("Tanggal"),
                subtitle: Text(
                  DateFormat('dd MMM yyyy')
                      .format(selectedDate),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: pickDate,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "SIMPAN",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}