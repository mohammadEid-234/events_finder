import 'package:flutter/material.dart';

class PasswordFieldWithValidation extends StatefulWidget {
  final String password;
  final Widget field;
  const PasswordFieldWithValidation({super.key, required this.password,required this.field});

  @override
  State<PasswordFieldWithValidation> createState() => _PasswordFieldWithValidationState();
}

class _PasswordFieldWithValidationState extends State<PasswordFieldWithValidation> {


  bool get hasLower => RegExp(r'[a-z]').hasMatch(widget.password);
  bool get hasUpper => RegExp(r'[A-Z]').hasMatch(widget.password);
  bool get hasDigit => RegExp(r'\d').hasMatch(widget.password);
  bool get hasSpecial => RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(widget.password);
  bool get validLength => widget.password.length >= 8 && widget.password.length <= 20;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.field,
        const SizedBox(height: 12),
        if(widget.password.isNotEmpty)...[
          _buildRule("At least 1 lowercase letter", hasLower),
          _buildRule("At least 1 uppercase letter", hasUpper),
          _buildRule("At least 1 number", hasDigit),
          _buildRule("At least 1 special character", hasSpecial),
          _buildRule("Length 8–20 characters", validLength),
        ]

      ],
    );
  }

  Widget _buildRule(String text, bool ok) {
    return Row(
      children: [
        Icon(ok ? Icons.check_circle : Icons.cancel,
            color: ok ? Colors.green : Colors.red, size: 18),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: ok ? Colors.green : Colors.red)),
      ],
    );
  }
}
