import 'package:flutter/material.dart';
import 'package:movil_inspeccion/utils/colores.dart';

class BotonOpcion extends StatelessWidget {
  final String texto;
   
  final VoidCallback onPressed;

  const BotonOpcion({
    super.key,
    required this.texto,
   
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: COLORFONDO, // Fondo blanco para botones
          foregroundColor: Colors.white, // Texto e icono con el color de la marca
          elevation: 2,
          shadowColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: COLORFONDO.withOpacity(0.3)), // Borde sutil
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
             
            Expanded(
              child: Text(
                texto,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white), // Indicador de navegación
          ],
        ),
      ),
    );
  }
}