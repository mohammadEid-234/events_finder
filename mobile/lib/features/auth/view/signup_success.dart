import 'package:finder/main.dart';
import 'package:flutter/material.dart';

class ReadyProfileScreen extends StatelessWidget {
  const ReadyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const cardRadius = 20.0;
    const dark = Color(0xFF0B0D17);        // near-black for primary button
    const bg = Color(0xFFF1F5FF);          // soft blue/gray background
    const accent = Color(0xFF22C55E);      // green check
    final textTheme = Theme.of(context).textTheme;

    return
      PopScope(
          canPop: false,
          child:Scaffold(
        //appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Green check icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: accent, size: 32),
                ),
                const SizedBox(height: 18),

                // Title
                Text(
                  'Everything is Ready!',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Would you like to upload a profile image?',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Avatar placeholder
                CircleAvatar(
                  radius: 68,
                  backgroundColor: const Color(0xFFF2F4F7),
                  child: Icon(
                    Icons.person,
                    size: 56,
                    color: Colors.black26,
                  ),
                ),
                const SizedBox(height: 28),

                // Upload Photo (outlined)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Upload Photo tapped')),
                      );
                    },
                    icon: const Icon(Icons.upload_rounded, size: 20),
                    label: const Text('Upload Photo'),
                  ),
                ),
                const SizedBox(height: 12),


                // Skip for now (text button)
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black54,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Skip for now tapped')),
                    );
                  },
                  child: const Text('Skip for now'),
                ),
              ],
            ),
          ),

        ),
      ) )
      ;
  }
}
