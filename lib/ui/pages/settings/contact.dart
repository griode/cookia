import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cookia/data/provider/help_message.dart';
import 'package:cookia/ui/widgets/back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  late AppLocalizations lang = AppLocalizations.of(context)!;

  void _sendMessage() {
    if (_formKey.currentState?.validate() ?? false) {
      final message = _messageController.text;

      HelpMessage(
              email: FirebaseAuth.instance.currentUser!.email!,
              message: message,
              name: FirebaseAuth.instance.currentUser!.displayName!)
          .sendMessage()
          .then((value) {
        if (value) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(lang.tankMessageTitle),
              content: Text(lang.takesMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(lang.okBtn),
                ),
              ],
            ),
          );
        }
      });

      // Réinitialiser le formulaire après l'envoi
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(lang.messageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.messageInfo,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: _messageController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: lang.inputMessage,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _messageController.text.isNotEmpty
                        ? _sendMessage
                        : null,
                    child: Text(lang.send),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
