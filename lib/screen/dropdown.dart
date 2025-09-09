import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool isLoading;
  final String? Function(String?)? validator;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputFill = Color(0xFF2C2C3C);
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
      dropdownColor: inputFill,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        filled: true,
        fillColor: inputFill,
      ),
      validator:
          validator ??
          (val) {
            if (val == null || val.isEmpty) {
              return 'Please select $label';
            }
            return null;
          },
    );
  }
}
