import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cookia/data/model/user_model.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/data/services/vertex_ai.dart';
import 'package:cookia/ui/pages/register/choose_date.dart';
import 'package:cookia/ui/pages/register/choose_size.dart';
import 'package:cookia/ui/pages/register/choose_weight.dart';
import 'package:cookia/ui/pages/settings/components/change_language.dart';
import 'package:cookia/utils/router/app_route_name.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var user = FirebaseAuth.instance.currentUser;
  AppLocalizations? _appLocalizations;
  final _weightController = TextEditingController();
  final _dateTextController = TextEditingController();
  final _sizeTextController = TextEditingController();
  final _genderController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _sizeTextController.text = "170";
    _weightController.text = "70";
    _selectedDate = DateTime(2005);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _dateTextController.dispose();
    _sizeTextController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.personalInfo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: AppLocalizations.of(context)!.weight,
              controller: _weightController,
              hintText: AppLocalizations.of(context)!.weight,
              suffix: "Kg",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return ChooseWeight(
                      weight: double.parse(_weightController.text),
                      onChanged: (weight) {
                        setState(() {
                          _weightController.text = weight.toString();
                        });
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 12.0),
            _buildTextField(
              label: "Size",
              controller: _sizeTextController,
              hintText: "Size",
              suffix: "Cm",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return ChooseSize(
                      size: int.parse(_sizeTextController.text),
                      onChanged: (size) {
                        setState(() {
                          _sizeTextController.text = size.toString();
                        });
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 12.0),
            _buildTextField(
              label: AppLocalizations.of(context)!.gender,
              controller: _genderController,
              hintText: AppLocalizations.of(context)!.gender,
              onTap: () {
                _showGenderSelector();
              },
            ),
            const SizedBox(height: 12.0),
            _buildTextField(
              label: AppLocalizations.of(context)!.birthDate,
              controller: _dateTextController,
              hintText: AppLocalizations.of(context)!.ddMmYyyy,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return ChooseDate(
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                          _dateTextController.text =
                              DateFormat('dd/MM/yyyy').format(date);
                        });
                      },
                      initialDate: DateTime(2005),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: FilledButton(
          onPressed: _register,
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    String? suffix,
    void Function()? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          readOnly: true,
          onTap: onTap,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            suffix: suffix != null ? Text(suffix) : null,
          ),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showGenderSelector() {
    final genders = [
      _appLocalizations!.gendersList("male"),
      _appLocalizations!.gendersList("female"),
      _appLocalizations!.gendersList("other"),
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: genders.map((e) {
                return ListTile(
                  title: Text(e),
                  leading: Radio<String>(
                    value: e,
                    groupValue: _genderController.text,
                    onChanged: (value) {
                      setState(() {
                        _genderController.text = e;
                        context.pop();
                      });
                    },
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Future<void> _register() async {
    if (_weightController.text.isNotEmpty &&
        _selectedDate != null &&
        _sizeTextController.text.isNotEmpty &&
        _genderController.text.isNotEmpty) {
      var userAuth = UserAuth(
        id: user!.uid,
        fullName: user!.displayName ?? "",
        email: user!.email,
        birth: Timestamp.fromDate(_selectedDate!),
        allergens: [],
        diet: "other",
        weight: double.parse(_weightController.text),
        size: int.parse(_sizeTextController.text),
        gender: _genderController.text,
        info: AppLocalizations.of(context)!.hiFollowMe,
        language: appLocale.value.toString(),
        numberAuthorizedRequest: 0,
        isPremium: false,
        numberRequest: 0,
      );
      var response = await UserProvider.add(userAuth);
      if (response) {
        await VertexAI.createMenu();
        context.goNamed(AppRouteName.home.name);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseEnterDetail),
        ),
      );
    }
  }
}
