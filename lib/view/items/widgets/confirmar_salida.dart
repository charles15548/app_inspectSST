import 'package:flutter/material.dart';
import 'package:movil_inspeccion/utils/colores.dart';
 
 
   Future<bool> confirmarSalida(BuildContext context, bool inspeccionFinalizada) async {
    // Si ya terminó, permitimos la salida sin preguntar
    if (inspeccionFinalizada) return true;

    bool? salir = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Seguro que deseas volver?"),
        content: const Text("Aún no has finalizado la inspección.\nSe perderá el progreso."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: COLORFONDO),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Salir de todas formas", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );

    return salir ?? false;
  }
 


 