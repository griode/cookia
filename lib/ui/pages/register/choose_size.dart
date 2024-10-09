import 'package:flutter/material.dart';
import 'package:cookia/ui/widgets/build_select_carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseSize extends StatefulWidget {
  final Function(int size) onChanged;
  final int size;


  const ChooseSize({super.key, required this.onChanged, required this.size});

  @override
  State<ChooseSize> createState() => _ChooseSizeState();
}

class _ChooseSizeState extends State<ChooseSize> {
  List<int> sizes = List.generate(275 - 130 + 1, (index) => 130 + index);
  int currentIndex = (275 - 130);
  late AppLocalizations _appLocalizations;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.size;
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(_appLocalizations.chooseSize, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: BuildSelectCarouselSlider(
                  items: sizes,
                  selectedItem: currentIndex,
                  onChanged: (index) {
                    setState(() {
                      currentIndex = sizes[index];
                      widget.onChanged(currentIndex);
                    });
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                  ),
                  child: Text(
                    _appLocalizations.sizeUnit,
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
                widget.onChanged(currentIndex);
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
