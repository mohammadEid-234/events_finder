import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  final String text;
  const Title(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    );
  }
}



class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,

          style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.black54, letterSpacing: .8),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final String label;
  final Widget leading;
  final VoidCallback? onPressed;

  const SocialButton({super.key,
    required this.label,
    required this.leading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: border,
          side: const BorderSide(color: Color(0xFFE2E6EA)),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

class CircleBadge extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width,height;
  const CircleBadge({super.key, required this.child,this.color=Colors.black87,this.width=26,this.height=26});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height:height,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color:color),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Colors.white),
        child: child,
      ),
    );
  }
}