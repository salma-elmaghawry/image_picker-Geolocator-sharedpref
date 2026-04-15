import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/widgets/custom_text_field.dart';

class PersonalDetailsWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController jobController;

  const PersonalDetailsWidget({
    required this.nameController,
    required this.emailController,
    required this.jobController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Personal Details:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: nameController,
          hint: 'Enter your name',
          icon: Icons.person,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: emailController,
          hint: 'Enter your email',
          icon: Icons.email,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: jobController,
          hint: 'Enter your job title',
          icon: Icons.work,
        ),
      ],
    );
  }
}
