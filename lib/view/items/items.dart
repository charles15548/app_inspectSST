import 'package:flutter/material.dart';
import 'package:movil_inspeccion/service/itemsservice.dart';
import 'package:movil_inspeccion/utils/colores.dart';
import 'package:movil_inspeccion/utils/sesion.dart';
import 'package:movil_inspeccion/view/items/item_detalle_page.dart';
import 'package:movil_inspeccion/view/items/widgets/item_list_tile.dart';

class Items extends StatefulWidget {
  final int idChecklist;
  final String nombreChecklist;

  const Items({
    super.key,
    required this.idChecklist,
    required this.nombreChecklist,
  });

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  final int? _idAuth = ASession.getUserId();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final data = await Itemsservice.listItems(widget.idChecklist);

    setState(() {
      _items = data.map(_initItemState).toList();
      _isLoading = false;
    });
  }

  Map<String, dynamic> _initItemState(Map<String, dynamic> item) {
    return {
      ...item,
      'estado_seleccionado': null,
      'observacion': '',
      'archivo_foto': null,
      'foto_url': null,
      'archivo_video': null,
      'video_url': null,
      'archivo_audio': null,
      'audio_url': null,
      'avance': null,
      'enviado': false,
      'enviando': false,
    };
  }

  Future<void> _abrirFormulario(int index) async {
    final updatedItem = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ItemDetallePage(
          item: Map<String, dynamic>.from(_items[index]),
          index: index,
          idChecklist: widget.idChecklist,
          idAuth: _idAuth,
        ),
      ),
    );

    if (updatedItem == null) return;

    setState(() {
      _items[index] = updatedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 216, 216),
      appBar: AppBar(
        title: Text(widget.nombreChecklist),
        backgroundColor: COLORAPPBAR,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = _items[index];
          return ItemListTile(
            item: item,
            index: index,
            onTap: () => _abrirFormulario(index),
          );
        },
      ),
    );
  }
}
