import 'package:flutter/material.dart';
import 'package:cookia/data/model/message.dart';
import 'package:cookia/data/provider/message_provider.dart';
import 'package:cookia/ui/widgets/back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late AppLocalizations lang = AppLocalizations.of(context)!;

  late Future<List<Message>> messages;

  @override
  void initState() {
    super.initState();
    messages = MessageProvider.getMessages();
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(lang.notificationText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: messages,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              return Column(
                children: snapshot.data!
                    .map(
                      (message) => ListTile(
                        title: Text(message.subject),
                        subtitle: Text(message.message),
                      ),
                    )
                    .toList(),
              );
            }
            return AspectRatio(
              aspectRatio: 0.8,
              child: Center(
                child: Text(lang.youHaveNoMessages),
              ),
            );
          },
        ),
      ),
    );
  }
}
