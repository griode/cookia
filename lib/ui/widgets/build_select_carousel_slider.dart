import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BuildSelectCarouselSlider extends StatelessWidget {
  final List<int> items;
  final int selectedItem;
  final double? width;
  final void Function(int) onChanged;

  const BuildSelectCarouselSlider(
      {super.key,
      required this.items,
      required this.selectedItem,
      required this.onChanged,
      this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      width: width,
      child: CarouselSlider(
        items: items.map((item) {
          bool isSelected = item == selectedItem;
          return Text(
            item < 10 ? "0$item" : item.toString(),
            style: TextStyle(
              fontSize: isSelected ? 36.0 : 24.0,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w100,
              color: isSelected ? null : Colors.grey,
            ),
            textAlign: TextAlign.center,
          );
        }).toList(),
        options: CarouselOptions(
          onPageChanged: (index, reason) => onChanged(index),
          initialPage: items.indexOf(selectedItem),
          scrollDirection: Axis.vertical,
          viewportFraction: 0.2,
        ),
      ),
    );
  }
}
