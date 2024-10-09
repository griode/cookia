import 'package:flutter/material.dart';
import 'package:cookia/ui/widgets/build_select_carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseDate extends StatefulWidget {
  final Function(DateTime date) onDateSelected;
  final DateTime initialDate;

  const ChooseDate(
      {super.key, required this.onDateSelected, required this.initialDate});

  @override
  State<ChooseDate> createState() => _ChooseDateState();
}

class _ChooseDateState extends State<ChooseDate> {
  late AppLocalizations _appLocalizations;
  List<int> days = List.generate(31, (index) => index + 1);
  List<int> months = List.generate(12, (index) => index + 1);
  List<int> years =
      List.generate(100, (index) => 2024 - index); // De 1924 à 2024

  int selectedDay = 1;
  int selectedMonth = 1;
  int selectedYear = 2024;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDate.day;
    selectedMonth = widget.initialDate.month;
    selectedYear = widget.initialDate.year;
    _updateDays();
  }

  void _updateDays() {
    setState(() {
      int daysInMonth = _daysInMonth(selectedMonth, year: selectedYear);
      if (selectedDay > daysInMonth) {
        selectedDay = daysInMonth;
      }
      days = List.generate(daysInMonth, (index) => index + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(_appLocalizations.dateBirth,
                style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(_appLocalizations.monthW),
                    BuildSelectCarouselSlider(
                      items: months,
                      selectedItem: selectedMonth,
                      onChanged: (index) {
                        setState(() {
                          selectedMonth = index + 1;
                          _updateDays();
                          returnDate();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text(_appLocalizations.dayW),
                    BuildSelectCarouselSlider(
                      items: days,
                      selectedItem: selectedDay,
                      onChanged: (index) {
                        setState(() {
                          selectedDay = index + 1;
                          returnDate();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text(_appLocalizations.yearW),
                    BuildSelectCarouselSlider(
                      items: years,
                      selectedItem: selectedYear,
                      onChanged: (index) {
                        setState(() {
                          selectedYear = years[index];
                          _updateDays();
                          returnDate();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: () {
                returnDate();
                Navigator.of(context).pop();
              },
              child: Text(_appLocalizations.doneBtn),
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  void returnDate() {
    widget.onDateSelected(DateTime(selectedYear, selectedMonth, selectedDay));
  }

  int _daysInMonth(int month, {int year = 2024}) {
    // Nombre de jours par mois pour les mois de 31 jours, 30 jours et février
    const Map<int, int> daysPerMonth = {
      1: 31, // Janvier
      2: 28, // Février
      3: 31, // Mars
      4: 30, // Avril
      5: 31, // Mai
      6: 30, // Juin
      7: 31, // Juillet
      8: 31, // Août
      9: 30, // Septembre
      10: 31, // Octobre
      11: 30, // Novembre
      12: 31, // Décembre
    };

    if (month == 2 && _isLeapYear(year)) {
      return 29;
    }
    return daysPerMonth[month]!;
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
