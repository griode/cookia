import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cookia/data/provider/user_provider.dart';

class ChangerName extends StatefulWidget {
  final String name;

  const ChangerName({super.key, required this.name});

  @override
  State<ChangerName> createState() => _ChangerNameState();
}

class _ChangerNameState extends State<ChangerName> {
  final user = FirebaseAuth.instance.currentUser;
  late TextEditingController _nameTextController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(text: widget.name);
  }

  Future<void> _saveName() async {
    if (_nameTextController.text.isEmpty ||
        user!.displayName == _nameTextController.text) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await user!.updateDisplayName(_nameTextController.text);
      await UserProvider.update({
        'fullName': _nameTextController.text,
      });

      if (context.mounted) context.pop();
    } catch (e) {
      // Handle error (e.g., show a snackbar or dialog)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update name: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter your name',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _nameTextController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              hintText: 'Name',
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: _isLoading ? null : _saveName,
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Save"),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}