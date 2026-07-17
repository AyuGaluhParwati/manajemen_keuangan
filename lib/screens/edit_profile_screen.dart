import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController budgetController;

  @override
  void initState() {
    super.initState();

    final profile =
    context.read<ProfileProvider>();

    nameController =
        TextEditingController(text: profile.name);

    budgetController =
        TextEditingController(
          text: profile.budget.toStringAsFixed(0),
        );
  }

  @override
  void dispose() {
    nameController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  Future<void> save() async {

    if (!_formKey.currentState!.validate()) return;

    await context.read<ProfileProvider>().saveProfile(
      name: nameController.text,
      budget: double.parse(
        budgetController.text,
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v!.isEmpty ? "Nama wajib diisi" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: budgetController,
                keyboardType:
                TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Budget Bulanan",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: save,
                  child: const Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}