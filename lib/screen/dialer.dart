import 'package:flutter/material.dart';

class PhoneBookPage extends StatefulWidget {
  const PhoneBookPage({Key? key}) : super(key: key);

  @override
  State<PhoneBookPage> createState() => _PhoneBookPageState();
}

class _PhoneBookPageState extends State<PhoneBookPage> {
  final List<String> contacts = [
    "Alice Johnson",
    "Aaron Smith",
    "Ben Williams",
    "Bella Davis",
    "Charles Brown",
    "Cynthia Clark",
    "Daniel Garcia",
    "Diana Evans",
    "Edward Martinez",
    "Eva Wilson",
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filter contacts
    final filteredContacts = contacts
        .where((c) => c.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList()
      ..sort();

    // Group contacts by first letter
    final grouped = <String, List<String>>{};
    for (var contact in filteredContacts) {
      final letter = contact[0].toUpperCase();
      grouped.putIfAbsent(letter, () => []);
      grouped[letter]!.add(contact);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Contacts",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() => searchQuery = val);
              },
            ),
          ),

          // Contact list
          Expanded(
            child: ListView(
              children: grouped.keys.map((letter) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header (A, B, C...)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 16),
                      child: Text(letter,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    ...grouped[letter]!.map(
                          (contact) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade300,
                          child: Text(contact[0],
                              style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(contact,
                            style: const TextStyle(fontSize: 16)),
                        onTap: () {
                          // Open contact details
                        },
                      ),
                    )
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new contact
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
