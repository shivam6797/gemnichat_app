import 'package:flutter/material.dart';

class WelcomeCardWidget extends StatelessWidget {
  final VoidCallback onStartChat;

  const WelcomeCardWidget({super.key, required this.onStartChat});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome to ChatApp 👋",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Ask anything, we’re here to help!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onStartChat,
                child: const Text("Start Chat"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
