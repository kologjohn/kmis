import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/routes.dart';

class Evictionshading extends StatefulWidget {
  const Evictionshading({super.key});

  @override
  State<Evictionshading> createState() => _EvictionshadingState();
}

class _EvictionshadingState extends State<Evictionshading> {
  final _formKey = GlobalKey<FormState>();
  final markController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<Myprovider>();
     // await provider.loadMark();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (context, markProvider, _) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF2D2F45),
              title: const Text(
                "Eviction Shading",
                style: TextStyle(color: Colors.white60),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white60),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.go(Routes.dashboard),
              ),
            ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: markController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Eviction Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Number";
                      }
                      if (int.tryParse(value) == null) {
                        return "Enter a valid number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Submit button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final enteredMark =
                        int.parse(markController.text.trim());

                        //context.read<Myprovider>().setMark(enteredMark);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Mark submitted!")),
                        );

                        markController.clear(); // ✅ clear after submit
                      }
                    },
                    child: const Text("Submit"),
                  ),
                  const SizedBox(height: 20),

                  // Show saved mark
                  Text(
                    "Eviction Number: ${markProvider.evictnumber}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
