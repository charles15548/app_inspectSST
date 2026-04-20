import 'package:flutter/material.dart';
import 'package:movil_inspeccion/utils/colores.dart'; 

class NavButtons extends StatelessWidget {
  final int currentIndex;
  final int totalItems;
  final PageController pageController;
  final VoidCallback onFinalizar;

  const NavButtons({
    super.key,
    required this.currentIndex,
    required this.totalItems,
    required this.pageController,
    required this.onFinalizar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Botón Anterior: Solo se muestra si no estamos en el primer item
          if (currentIndex > 0)
            Expanded(
              child: TextButton(
                onPressed: () => pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: const Text(
                  "< Anterior",
                  style: TextStyle(color: COLORFONDO),
                ),
              ),
            ),
          
          if (currentIndex > 0) const SizedBox(width: 10),

          // Botón Siguiente / Finalizar
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (currentIndex < totalItems - 1) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                 
                  onFinalizar();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: COLORFONDO,
                foregroundColor: Colors.white,
              ),
              child: Text(
                currentIndex == totalItems - 1 ? "Finalizar" : "Siguiente >",
              ),
            ),
          ),
        ],
      ),
    );
  }
}