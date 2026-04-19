import 'package:flutter/material.dart';

class BioWidget extends StatelessWidget {
  final TextEditingController bioController;

  const BioWidget({required this.bioController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Short Bio:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: bioController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Enter your bio',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
