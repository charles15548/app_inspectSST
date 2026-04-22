import 'package:flutter/material.dart';
import 'package:movil_inspeccion/service/inspeccionesService.dart'; // Ajusta la ruta a tu service
import 'package:movil_inspeccion/service/itemsService.dart';
import 'package:movil_inspeccion/utils/colores.dart';
import 'package:movil_inspeccion/view/items/items.dart';

class Inspecciones extends StatefulWidget {
  final String titulo;
  Inspecciones({super.key, required this.titulo});

  @override
  State<Inspecciones> createState() => _InspeccionesState();
}

class _InspeccionesState extends State<Inspecciones> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.titulo, style: const TextStyle(color: Colors.white)),
          backgroundColor: COLORAPPBAR,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: ListaInspeccionesPorPeriodo());
  }
}

// Widget separado para manejar la carga de inspecciones por cada tab
class ListaInspeccionesPorPeriodo extends StatelessWidget {
  const ListaInspeccionesPorPeriodo({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: InspeccionesService.listarInspections(),
      builder: (context, snapshot) {
        print('Estado: ${snapshot.connectionState}');
        print('Error: ${snapshot.error}');
        print('Data: ${snapshot.data}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay inspecciones pendientes"));
        }

        final inspecciones = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: inspecciones.length,
          itemBuilder: (context, index) {
            final item = inspecciones[index];
            return CardInspeccion(item: item);
          },
        );
      },
    );
  }
}

// El diseño de la tarjeta (Card) basado en tu imagen
class CardInspeccion extends StatelessWidget {
  final Map<String, dynamic> item;
  const CardInspeccion({super.key, required this.item});

  bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString())?.toLocal();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }

  ({String label, Color color, IconData icon}) _estadoTemporal({
    required bool completado,
    required DateTime? inicio,
    required DateTime? fin,
  }) {
    final ahora = DateTime.now();

    if (completado) {
      return (label: 'Completado', color: Colors.green, icon: Icons.check_circle);
    }
    if (inicio == null || fin == null) {
      return (label: 'Sin fechas', color: Colors.grey, icon: Icons.help_outline);
    }
    if (ahora.isBefore(inicio)) {
      return (label: 'Aun no inicia', color: Colors.blue, icon: Icons.schedule);
    }
    if (ahora.isAfter(fin)) {
      return (label: 'Vencido', color: Colors.red, icon: Icons.warning_amber_rounded);
    }
    return (label: 'En ejecucion', color: Colors.orange, icon: Icons.play_circle_fill);
  }

  @override
  Widget build(BuildContext context) {
    final completado = _toBool(item['estado']);
    final fechaInicio = _parseDate(item['fecha_inicio']);
    final fechaFin = _parseDate(item['fecha_fin']);
    final estado = _estadoTemporal(
      completado: completado,
      inicio: fechaInicio,
      fin: fechaFin,
    );

    final checklistItems = item['checklist_items'];
    final int totalItems = (checklistItems is List && checklistItems.isNotEmpty)
        ? ((checklistItems.first['count'] ?? 0) as num).toInt()
        : 0;

    return InkWell(
      onTap: () {
       

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Items(
              idChecklist: item['id_checklist'],
              nombreChecklist: item['nombre'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: estado.color.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: estado.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.assignment_outlined, color: estado.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['nombre'] ?? 'Sin nombre',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Icon(estado.icon, color: estado.color),
                ],
              ),
              const Divider(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Inicio:', style: TextStyle(color: Colors.grey)),
                  Text(
                    _formatDate(fechaInicio),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fin:', style: TextStyle(color: Colors.grey)),
                  Text(
                    _formatDate(fechaFin),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: estado.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      estado.label,
                      style: TextStyle(
                        color: estado.color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$totalItems items',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

