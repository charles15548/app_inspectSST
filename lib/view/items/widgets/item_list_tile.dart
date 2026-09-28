import 'package:flutter/material.dart';
import 'package:movil_inspeccion/utils/colores.dart';

class ItemListTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  final VoidCallback onTap;

  const ItemListTile({
    super.key,
    required this.item,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemNumber = item['numero_item'] ?? index + 1;

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: COLORFONDO.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.assignment_turned_in_outlined,
            color: COLORFONDO,
          ),
        ),
        title: Text(
          'Tarea $itemNumber',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            item['descripcion'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF5F6C7B),
              height: 1.3,
            ),
          ),
        ),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 20,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
