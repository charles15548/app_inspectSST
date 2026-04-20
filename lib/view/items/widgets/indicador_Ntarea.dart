import 'package:flutter/material.dart';
import 'package:movil_inspeccion/utils/colores.dart';
 
class StepIndicator extends StatelessWidget {
  final List<dynamic> items;
  final int currentIndex;
  final PageController pageController;
  final ScrollController stepScrollController;

  const StepIndicator({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.pageController,
    required this.stepScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListView.separated(
        controller: stepScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          bool isCurrent = currentIndex == index;
          return GestureDetector(
            onTap: () {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCurrent ? COLORFONDO : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    color: isCurrent ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}