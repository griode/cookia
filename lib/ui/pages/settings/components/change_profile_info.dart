import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cookia/data/provider/user_provider.dart';

class ChangeProfileInfo extends StatefulWidget {
  final String info;

  const ChangeProfileInfo({super.key, required this.info});

  @override
  State<ChangeProfileInfo> createState() => _ChangeProfileInfoState();
}

class _ChangeProfileInfoState extends State<ChangeProfileInfo> {
  late TextEditingController _infoTextController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _infoTextController = TextEditingController(text: widget.info);
  }

  Future<void> _saveInfo() async {
    if (_infoTextController.text.isEmpty ||
        widget.info == _infoTextController.text) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await UserProvider.update({
        'info': _infoTextController.text,
      });

      if (context.mounted) context.pop();
    } catch (e) {
      // Handle error (e.g., show a snackbar or dialog)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update info: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _infoTextController.dispose();
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
            'Enter your info',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _infoTextController,
            keyboardType: TextInputType.text,
            maxLines: 3,
            maxLength: 100,
            decoration: const InputDecoration(
              hintText: 'Hi, follow me to discover my cooking skills',
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
                onPressed: _isLoading ? null : _saveInfo,
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
