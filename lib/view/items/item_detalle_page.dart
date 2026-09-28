import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movil_inspeccion/service/itemsservice.dart';
import 'package:movil_inspeccion/utils/colores.dart';
import 'package:movil_inspeccion/view/items/formulario.dart';
import 'package:movil_inspeccion/view/items/widgets/navegacion_footer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ItemDetallePage extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index;
  final int idChecklist;
  final int? idAuth;

  const ItemDetallePage({
    super.key,
    required this.item,
    required this.index,
    required this.idChecklist,
    required this.idAuth,
  });

  @override
  State<ItemDetallePage> createState() => _ItemDetallePageState();
}

class _ItemDetallePageState extends State<ItemDetallePage> {
  late Map<String, dynamic> _item;
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _item = Map<String, dynamic>.from(widget.item);
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  bool _itemListoParaEnviar() {
    return _item['avance'] != null;
  }

  Future<String> _getAudioPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> _tomarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (photo == null) return;

    setState(() {
      _item['archivo_foto'] = File(photo.path);
    });
  }

  Future<void> _tomarVideo() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Grabacion de video'),
        content: const Text('La duracion maxima es de 40 segundos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Entendido',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );

    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 40),
    );

    if (video == null) return;

    setState(() {
      _item['archivo_video'] = File(video.path);
    });
  }

  Future<void> _grabarAudio() async {
    try {
      if (!await _recorder.hasPermission()) return;

      if (_isRecording) {
        final path = await _recorder.stop();
        if (path != null) {
          setState(() {
            _isRecording = false;
            _item['archivo_audio'] = File(path);
          });
        }
      } else {
        final path = await _getAudioPath();
        await _recorder.start(
          const RecordConfig(),
          path: path,
        );
        setState(() {
          _isRecording = true;
        });
      }
    } catch (_) {}
  }

  Future<void> _enviarItem() async {
    if (!_itemListoParaEnviar()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa la tarea antes de enviarlo.')),
      );
      return;
    }

    setState(() => _item['enviando'] = true);

    try {
      if (_isRecording) {
        final path = await _recorder.stop();
        if (path != null) {
          _item['archivo_audio'] = File(path);
        }
        _isRecording = false;
      }

      String? urlFoto;
      String? urlVideo;
      String? urlAudio;

      if (_item['archivo_foto'] != null) {
        urlFoto = await Itemsservice.subirImagen(
          _item['archivo_foto'],
          widget.idChecklist,
        );
      }
      if (_item['archivo_video'] != null) {
        urlVideo = await Itemsservice.subirImagen(
          _item['archivo_video'],
          widget.idChecklist,
        );
      }
      if (_item['archivo_audio'] != null) {
        urlAudio = await Itemsservice.subirImagen(
          _item['archivo_audio'],
          widget.idChecklist,
        );
      }

      final payload = {
        'id_items': _item['id_items'],
        'id_auth': widget.idAuth,
        'foto_url': urlFoto,
        'video_url': urlVideo,
        'audio_url': urlAudio,
        'observacion': _item['observacion'],
        'fecha': DateTime.now().toIso8601String(),
        'estado': true,
        'avance': _item['avance'],
      };

      await Itemsservice.guardarEvidenciaItem(payload);

      if (!mounted) return;

      setState(() {
        _item['enviado'] = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item ${widget.index + 1} enviado correctamente'),
        ),
      );

      Navigator.pop(context, _item);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error enviando item: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _item['enviando'] = false);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_isRecording) {
      await _recorder.stop();
      _isRecording = false;
    }
    if (!mounted) return false;
    Navigator.pop(context, _item);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 216, 216),
        appBar: AppBar(
          title: Text('Item ${widget.index + 1}'),
          backgroundColor: COLORAPPBAR,
          elevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _onWillPop,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ItemFormWidget(
                item: _item,
                index: widget.index,
                isRecording: _isRecording,
                recordingIndex: _isRecording ? widget.index : null,
                onTomarFoto: (_) => _tomarFoto(),
                onTomarVideo: (_) => _tomarVideo(),
                onGrabarAudio: (_) => _grabarAudio(),
                onChangeAvance: (_, value) {
                  setState(() {
                    _item['avance'] = value;
                  });
                },
                onChangeObservacion: (_, value) {
                  _item['observacion'] = value;
                },
              ),
            ),
            NavButtons(
              canEnviar: _itemListoParaEnviar(),
              enviado: _item['enviado'] == true,
              enviando: _item['enviando'] == true,
              onEnviar: _enviarItem,
            ),
          ],
        ),
      ),
    );
  }
}
