import 'package:flutter/material.dart';
import 'package:movil_inspeccion/utils/colores.dart';

class NavButtons extends StatelessWidget {
  final bool canEnviar;
  final bool enviado;
  final bool enviando;
  final VoidCallback onEnviar;

  const NavButtons({
    super.key,
    required this.canEnviar,
    required this.enviado,
    required this.enviando,
    required this.onEnviar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: (canEnviar && !enviando) ? onEnviar : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: COLORFONDO,
            foregroundColor: Colors.white,
          ),
          child: Text(
            enviando
                ? "Enviando..."
                : enviado
                    ? "Reenviar Tarea"
                    : "Enviar Tarea",
          ),
        ),
      ),
    );
  }
}
