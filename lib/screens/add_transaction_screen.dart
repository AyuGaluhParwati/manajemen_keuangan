import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../services/receipt_ai.dart';
import '../services/ocr_service.dart';

import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {

  final TransactionModel? transaction;

  const AddTransactionScreen({
    super.key,
    this.transaction,
  });

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

  File? receiptImage;
  bool isScanning = false;
  String type = "expense";
  String category = "Kos & Makan";

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {

      titleController.text =
          widget.transaction!.title;

      merchantController.text =
          widget.transaction!.merchant;

      amountController.text =
          widget.transaction!.amount.toString();

      noteController.text =
          widget.transaction!.note;

      type =
          widget.transaction!.type;

      category =
          widget.transaction!.category;

      selectedDate =
          DateFormat("dd MMM yyyy")
              .parse(widget.transaction!.date);
    }
  }

  final List<String> categories = [
    "Kos & Makan",
    "Keperluan Kuliah",
    "Hiburan & Self Reward",
  ];

  Future<void> pickImage(ImageSource source) async {

    setState(() {
      isScanning = true;
    });

    final picker = ImagePicker();

    final file = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (file == null) return;

    setState(() {
      receiptImage = File(file.path);
    });

    final text =
    await OCRService.readText(receiptImage!);

    print(text);

    final result = ReceiptAI.parse(text);
    setState(() {

      merchantController.text =
      result["merchant"]!;

      amountController.text =
      result["amount"]!;

      if (result["date"]!.isNotEmpty) {
        noteController.text =
        "Tanggal Struk : ${result["date"]}";
      }

      if (result["merchant"]!
          .toLowerCase()
          .contains("indomaret")) {

        category = "Kos & Makan";
      }

      if (result["merchant"]!
          .toLowerCase()
          .contains("alfamart")) {

        category = "Kos & Makan";
      }
    });
    setState(() {
      isScanning = false;
    });
  }


  void showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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

  Future<void> saveTransaction() async {

    if (!_formKey.currentState!.validate()) return;

    final transaction = TransactionModel(
      id: widget.transaction?.id,
      title: titleController.text,
      merchant: merchantController.text,
      amount: double.parse(amountController.text),
      type: type,
      category: category,
      note: noteController.text,
      date: DateFormat('dd MMM yyyy').format(selectedDate),
      receipt: widget.transaction?.receipt,
      createdAt: widget.transaction?.createdAt ??
          DateTime.now().toString(),
    );

    if (widget.transaction == null) {

      await context
          .read<TransactionProvider>()
          .addTransaction(transaction);

    } else {

      await context
          .read<TransactionProvider>()
          .updateTransaction(transaction);

    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction == null
              ? "Tambah Transaksi"
              : "Edit Transaksi",
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              if (isScanning)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        "AI sedang membaca struk...",
                      ),
                    ],
                  ),
                ),

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

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: showImagePicker,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Scan Struk"),
                ),
              ),

              const SizedBox(height: 20),

              if (receiptImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    receiptImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                  child: Text(
                    widget.transaction == null
                        ? "SIMPAN"
                        : "UPDATE",
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