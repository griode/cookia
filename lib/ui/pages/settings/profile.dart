import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cookia/data/function/compress_image.dart';
import 'package:cookia/data/function/upload_file.dart';
import 'package:cookia/data/model/user_model.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/ui/pages/register/choose_date.dart';
import 'package:cookia/ui/pages/register/choose_size.dart';
import 'package:cookia/ui/pages/register/choose_weight.dart';
import 'package:cookia/ui/pages/settings/components/change_profile_info.dart';
import 'package:cookia/ui/pages/settings/components/changer_name.dart';
import 'package:cookia/ui/widgets/back_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userAuth = FirebaseAuth.instance.currentUser;
  String? photoUrl;
  UserAuth? user;
  late AppLocalizations lang;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    photoUrl ??= userAuth!.photoURL;
    userAuth = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(lang.profileText),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: CachedNetworkImageProvider(photoUrl ?? ""),
                    child: isLoading ? const CircularProgressIndicator() : null,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: _changeProfileImage,
                    icon: const Icon(HugeIcons.strokeRoundedCamera01),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).canvasColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24.0),
            FutureBuilder(
              future: UserProvider.get(),
              builder: (context, snapshot) {
                user = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () => _changeName(context),
                        leading: const Icon(HugeIcons.strokeRoundedUser),
                        title: Text(lang.fullName),
                        subtitle: Text(userAuth!.displayName ?? ""),

                      ),
                      const Divider(height: 1),
                      ListTile(
                        onTap: () => _changeInfo(context),
                        leading: const Icon(
                            HugeIcons.strokeRoundedInformationDiamond),
                        title: Text(lang.infoWord),

                        subtitle: const Text("..."),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    ListTile(
                      onTap: () => _changeName(context),
                      leading: const Icon(HugeIcons.strokeRoundedUser),
                      title: Text(lang.fullName),
                      subtitle: Text(user!.fullName),

                    ),
                    const Divider(height: 1),
                    ListTile(
                      onTap: () => _changeInfo(context),
                      leading:
                          const Icon(HugeIcons.strokeRoundedInformationDiamond),
                      title: Text(lang.infoWord),
                      subtitle: Text(user!.info ?? ""),

                    ),
                    const Divider(height: 1),
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return ChooseWeight(
                              weight: user!.weight,
                              onChanged: (weight) {
                                UserProvider.update({
                                  "weight": weight,
                                }).then((_) => setState(() {}));
                              },
                            );
                          },
                        );
                      },
                      leading: const Icon(HugeIcons.strokeRoundedWeightScale),
                      title: Text(lang.weight),
                      subtitle: Text("${user!.weight} Kg"),

                    ),
                    const Divider(height: 1),
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return ChooseSize(
                              size: user!.size,
                              onChanged: (size) async {
                                await UserProvider.update({
                                  "size": size,
                                }).then((_) => setState(() {}));
                              },
                            );
                          },
                        );
                      },
                      leading: const Icon(HugeIcons.strokeRoundedRuler),
                      title: Text(lang.size),
                      subtitle: Text("${user!.size} Cm"),

                    ),
                    const Divider(height: 1),
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return ChooseDate(
                              initialDate: user!.birth.toDate(),
                              onDateSelected: (date) {
                                UserProvider.update({
                                  "birth": Timestamp.fromDate(date),
                                }).then((_) => setState(() {}));
                              },
                            );
                          },
                        );
                      },
                      leading: const Icon(HugeIcons.strokeRoundedCalendar03),
                      title: Text(lang.birthDate),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(user!.birth.toDate()),
                      ),

                    ),
                  ],
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () => _logOut(context),
              leading: const Icon(HugeIcons.strokeRoundedLogout01),
              title: Text(lang.logOutWord),
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  void _changeName(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => ChangerName(name: userAuth!.displayName ?? ""),
    ).then((value) => setState(() {}));
  }

  void _changeInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ChangeProfileInfo(info: user?.info ?? ""),
    ).then((value) => setState(() {}));
  }

  Future<void> _changeProfileImage() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Start process
      final XFile? response =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      // End process
      if (response == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      // Save file
      try {
        await FirebaseStorage.instance.refFromURL(photoUrl!).delete();
      } catch (_) {
        debugPrint("File not found in storage");
      }
      var file = await compressImage(File(response.path), "");
      var url = await uploadFile(file, 'profile');
      userAuth!.updatePhotoURL(url);
      setState(() {
        photoUrl = url;
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      rethrow;
    }
  }

  void _logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(lang.logoutext),
        content: Text(lang.doyoureally),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(lang.cancel),
          ),
          TextButton(
              onPressed: () {
                GoogleSignIn().signOut().then((value) {
                  FirebaseAuth.instance
                      .signOut()
                      .then((value) => context.go('/login'));
                });
              },
              child: Text(lang.yes))
        ],
      ),
    );
  }
}
