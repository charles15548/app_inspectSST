import 'package:flutter/material.dart';

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool tieneArchivo;
  final VoidCallback onTap;

  const ActionIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.tieneArchivo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: tieneArchivo ? Colors.green : Colors.blue,
            size: 30,
          ),
        ),
        Text(
          tieneArchivo ? "¡Capturado!" : label,
          style: TextStyle(
            fontSize: 12,
            color: tieneArchivo ? Colors.green : Colors.black54,
          ),
        ),
      ],
    );
  }
}