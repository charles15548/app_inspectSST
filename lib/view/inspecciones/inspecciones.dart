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

  @override
  Widget build(BuildContext context) {
    String estado = 'Pendiente';
    if (item['estado'] == true) {
      estado = 'Completado';
    }
    final int totalItems = item['checklist_items'][0]['count'] ?? 0;
    return InkWell(
      onTap: () {
        item['estado']
            ? ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Esta inspección ya ha sido completada.")),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Items(
                          idChecklist: item['id_checklist'],
                          nombreChecklist: item['nombre'],
                        )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: item['estado']
                  ? Colors.green.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2)), // Borde sutil
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
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
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assignment_outlined,
                        color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['nombre'] ?? 'Sin nombre',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.warning_amber_rounded,
                      color:
                          item['estado'] ? Colors.green : Colors.orange[800]),
                ],
              ),
              const Divider(height: 24),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text("Se reinicia el:",
              //         style: TextStyle(color: Colors.grey)),
              //     Text(
              //       fechaFormateada,
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: item['estado'] ? Colors.green :  Colors.red[400],
              //       ),
              //     ),
              //   ],
              // ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          item['estado'] ? Colors.green[50] : Colors.orange[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      estado,
                      style: TextStyle(
                          color: item['estado']
                              ? Colors.green
                              : Colors.orange[800],
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "$totalItems items",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
