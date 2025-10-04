import 'package:finder/core/validation/user_input_validation.dart';
import 'package:flutter/material.dart';

class PasswordFieldWithValidation extends StatefulWidget {
  final String password;
  final Widget field;
  const PasswordFieldWithValidation({super.key, required this.password,required this.field});

  @override
  State<PasswordFieldWithValidation> createState() => _PasswordFieldWithValidationState();
}

class _PasswordFieldWithValidationState extends State<PasswordFieldWithValidation> {



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
          _buildRule("At least 1 lowercase letter", hasLower(widget.password)),
          _buildRule("At least 1 uppercase letter", hasUpper(widget.password)),
          _buildRule("At least 1 number", hasDigit(widget.password)),
          _buildRule("At least 1 special character", hasSpecial(widget.password)),
          _buildRule("Length 8–20 characters", validLength(widget.password)),
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
