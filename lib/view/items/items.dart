import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movil_inspeccion/service/itemsservice.dart';
import 'package:movil_inspeccion/utils/colores.dart';
import 'package:movil_inspeccion/utils/sesion.dart';
import 'package:movil_inspeccion/view/inspecciones/inspecciones.dart';
import 'package:movil_inspeccion/view/items/formulario.dart';
import 'package:movil_inspeccion/view/items/widgets/acciones_captura.dart';
import 'package:movil_inspeccion/view/items/widgets/confirmar_salida.dart';
import 'package:movil_inspeccion/view/items/widgets/indicador_Ntarea.dart';
import 'package:movil_inspeccion/view/items/widgets/navegacion_footer.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

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
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  int? idAuth = ASession.getUserId();
  bool inspeccionFinalizada = false;
  final ScrollController _stepScrollController = ScrollController();

  final AudioRecorder recorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    recorder.dispose();
    _stepScrollController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    final data = await Itemsservice.listItems(widget.idChecklist);
    // setState(() {
    //   _items = data;
    //   _isLoading = false;
    // });
    setState(() {
      _items = data.map((item) {
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
          'avance': null
        };
      }).toList();
      _isLoading = false;
    });
  }

  Future<void> tomarFoto(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (photo != null) {
      setState(() {
        _items[index]['archivo_foto'] = File(photo.path);
      });
    }
  }

  Future<void> tomarVideo(int index) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Grabación de video"),
              content: const Text("La duración máxima es de 40 segundos."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Entendido",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ));

    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 40),
    );

    if (video != null) {
      setState(() {
        _items[index]['archivo_video'] = File(video.path);
      });
    }
  }

  Future<void> finalizarInspeccion() async {
    setState(() => _isLoading = true);
    try {
      if (await recorder.isRecording()) {
        final path = await recorder.stop();

        if (path != null && _recordingIndex != null) {
          _items[_recordingIndex!]['archivo_audio'] = File(path);
        }

        _isRecording = false;
        _recordingIndex = null;
      }

      List<Map<String, dynamic>> evidenciasFinales = [];
      for (var item in _items) {
        String? urlSuFoto;
        String? urlVideo;
        String? urlAudio;

        if (item['archivo_foto'] != null) {
          urlSuFoto = await Itemsservice.subirImagen(
              item['archivo_foto'], widget.idChecklist);
        }
        if (item['archivo_video'] != null) {
          urlVideo = await Itemsservice.subirImagen(
              item['archivo_video'], widget.idChecklist);
        }
        if (item['archivo_audio'] != null) {
          urlAudio = await Itemsservice.subirImagen(
              item['archivo_audio'], widget.idChecklist);
        }
        evidenciasFinales.add({
          'id_items': item['id_items'],
          'id_auth': idAuth,
          'foto_url': urlSuFoto,
          'video_url': urlVideo,
          'audio_url': urlAudio,
          'observacion': item['observacion'],
          'fecha': DateTime.now().toIso8601String(),
          'estado': item['estado_seleccionado'] ?? true,
          'avance': item['avance'],
        });
      }
      await Itemsservice.guardarEvidencias(
          evidenciasFinales, widget.idChecklist);

      if (mounted) {
        inspeccionFinalizada = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Inspecciones(titulo: 'Inspecciones de seguridad')));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Inspección y fotos guardadas correctamente")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _isRecording = false;
  int? _recordingIndex;

  Future<String> getAudioPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> grabarAudio(int index) async {
    try {
      if (!await recorder.hasPermission()) {
        print("Permiso de micrófono no concedido");
        return;
      }
      if (_isRecording && _recordingIndex == index) {
        final path = await recorder.stop();
        if (path != null) {
          setState(() {
            _isRecording = false;
            _items[index]['archivo_audio'] = File(path);
          });
        }
      } else {
        final path = await getAudioPath();
        await recorder.start(
          const RecordConfig(),
          path: path,
        );
        setState(() {
          _isRecording = true;
          _recordingIndex = index;
        });
      }
    } catch (e) {
      print("Error grabando audio: $e");
    }
  }

  // VER LOS ITEMS SELECCIONADOS
  void _scrollToCurrentStep() {
    double itemWidth = 48;
    double screenWidth = MediaQuery.of(context).size.width;

    double targetOffset =
        (_currentIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
    if (targetOffset < 0) targetOffset = 0;

    _stepScrollController.animateTo(targetOffset,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return WillPopScope(
      onWillPop: () => confirmarSalida(context, inspeccionFinalizada),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 216, 216),
        appBar: AppBar(
          title: Text(widget.nombreChecklist),
          backgroundColor: COLORAPPBAR,
          elevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              bool salir = await confirmarSalida(context, inspeccionFinalizada);
              if (salir) {
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ),
        body: Column(
          children: [
            // 1. Indicador de progreso (Barra superior de números)
            StepIndicator(
              items: _items,
              currentIndex: _currentIndex,
              pageController: _pageController,
              stepScrollController: _stepScrollController,
            ),

            // 2. El contenido de la inspección (Cuerpo deslizable)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                  _scrollToCurrentStep();
                },
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ItemFormWidget(
                    item: _items[index],
                    index: index,
                    isRecording: _isRecording,
                    recordingIndex: _recordingIndex,
                    onTomarFoto: tomarFoto,
                    onTomarVideo: tomarVideo,
                    onGrabarAudio: grabarAudio,
                    onChangeAvance: (i, value) {
                      setState(() {
                        _items[i]['avance'] = value;
                      });
                    },
                    onChangeObservacion: (i, value) {
                      _items[i]['observacion'] = value;
                    },
                  );
                },
              ),
            ),

            // 3. Botones de navegación inferiores

            NavButtons(
                currentIndex: _currentIndex,
                totalItems: _items.length,
                pageController: _pageController,
                onFinalizar: finalizarInspeccion)
          ],
        ),
      ),
    );
  }
}
