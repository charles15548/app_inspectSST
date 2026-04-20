import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:movil_inspeccion/service/bienvenidaService.dart';
import 'package:movil_inspeccion/utils/botones.dart';
import 'package:movil_inspeccion/utils/colores.dart';
import 'package:movil_inspeccion/view/inspecciones/inspecciones.dart';
import 'package:movil_inspeccion/view/login/login.dart';

class Menuprincipal extends StatefulWidget {
  const Menuprincipal({super.key});

  @override
  State<Menuprincipal> createState() => _MenuprincipalState();
}

class _MenuprincipalState extends State<Menuprincipal> {
  Map<String, dynamic> bienvenida = {};
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarBienvenida();
  }

  Future<void> cargarBienvenida() async {
    final data = await BienvenidaService.getAll();
    if (mounted) {
      setState(() {
        bienvenida = data.first;
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
          0xFFF5F7FB), // Un gris muy claro para resaltar las tarjetas
      appBar: AppBar(
        title: const Text(
          "Inspect",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: COLORFONDO, // Tu color rojizo/oscuro
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false,
              );
            },
          )
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Card de Bienvenida
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título dinámico
                        Center(
                          child: Text(
                            bienvenida['titulo'] ?? "Bienvenido",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: COLORFONDO,
                            ),
                          ),
                        ),
                        const Divider(height: 30),
                        // Contenido Markdown
                        MarkdownBody(
                          data: (bienvenida['descripcion'] ?? "")
                              .replaceAll("\\n", "\n")
                              .trim(),
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Sección de Acciones
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      " Menú Principal",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),

                  const SizedBox(height: 15),

                  BotonOpcion(
                    texto: 'Consejos Prácticos',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text( 
                                "En construcción")),
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  BotonOpcion(
                    texto: 'Testimonios',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text( 
                                "En construcción")),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  BotonOpcion(
                    texto: 'Inspecciones',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Inspecciones(
                                  titulo: 'Inspecciones')));
                    },
                  ),

                  const SizedBox(height: 12),

                  BotonOpcion(
                    texto: 'Historial',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text( 
                                "En construcción")),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
