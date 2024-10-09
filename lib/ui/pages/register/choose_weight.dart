import 'package:flutter/material.dart';
import 'package:cookia/ui/widgets/build_select_carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseWeight extends StatefulWidget {
  final Function(double weight) onChanged;
  final double weight;

  const ChooseWeight({super.key, required this.onChanged, required this.weight});

  @override
  State<ChooseWeight> createState() => _ChooseWeightState();
}

class _ChooseWeightState extends State<ChooseWeight> {
  List<int> weight = List.generate(275 - 20 + 1, (index) => 20 + index);
  List<int> weightDot = List.generate(10 - 0, (index) => 0 + index);
  int currentIndex = 50;
  int currentIndexDot = 0;
  late AppLocalizations _appLocalizations;

  @override
  void initState() {
    super.initState();
    var str = widget.weight.toString();
    currentIndex = int.parse(str.split('.')[0]);
    currentIndexDot = int.parse(str.split('.')[1]);
  }

  void _onChanged() {
    widget.onChanged(double.parse('$currentIndex.$currentIndexDot'));
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            _appLocalizations.chooseWeight,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BuildSelectCarouselSlider(
                width: 80,
                items: weight,
                selectedItem: currentIndex,
                onChanged: (index) {
                  setState(() {
                    currentIndex = weight[index];
                    _onChanged();
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 4.0,
                  left: 8,
                  right: 8,
                ),
                child: Text(
                  ",",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BuildSelectCarouselSlider(
                width: 64,
                items: weightDot,
                selectedItem: currentIndexDot,
                onChanged: (index) {
                  setState(() {
                    currentIndexDot = weightDot[index];
                    _onChanged();
                  });
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                  ),
                  child: Text(
                    _appLocalizations.weightUnit,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: () {
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
}