import 'package:flutter/material.dart';
import 'package:movil_inspeccion/utils/colores.dart';
import 'package:movil_inspeccion/view/items/widgets/acciones_captura.dart';

class ItemFormWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;

  final int? recordingIndex;
  final bool isRecording;

  final Function(int) onTomarFoto;
  final Function(int) onTomarVideo;
  final Function(int) onGrabarAudio;
  final Function(int, int) onChangeAvance;
  final Function(int, String) onChangeObservacion;

  const ItemFormWidget({
    super.key,
    required this.item,
    required this.index,
    required this.recordingIndex,
    required this.isRecording,
    required this.onTomarFoto,
    required this.onTomarVideo,
    required this.onGrabarAudio,
    required this.onChangeAvance,
    required this.onChangeObservacion,
  });

  @override
  Widget build(BuildContext context) {
    final avance = (item['avance'] ?? 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['descripcion'] ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text(
              "Porcentaje de Avance:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Nulo",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500)),
                Text("Completado",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500)),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: avance.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    activeColor: getColorByAvance(avance),
                    onChanged: (val) {
                      onChangeAvance(index, val.toInt());
                    },
                  ),
                ),
                Container(
                  width: 56,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getColorByAvance(avance).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: getColorByAvance(avance).withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    "$avance%",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getColorByAvance(avance),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text("Evidencias:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionIcon(
                  icon: Icons.camera_alt,
                  label: "Foto",
                  tieneArchivo: item['archivo_foto'] != null,
                  onTap: () => onTomarFoto(index),
                ),
                ActionIcon(
                  icon: Icons.videocam,
                  label: "Video",
                  tieneArchivo: item['archivo_video'] != null,
                  onTap: () => onTomarVideo(index),
                ),
                ActionIcon(
                  icon: isRecording && recordingIndex == index
                      ? Icons.stop
                      : Icons.mic,
                  label: "Audio",
                  tieneArchivo: item['archivo_audio'] != null,
                  onTap: () => onGrabarAudio(index),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text("Observaciones:"),
            TextField(
              maxLines: 3,
              onChanged: (valor) {
                onChangeObservacion(index, valor);
              },
              decoration: InputDecoration(
                hintText: "Escribe aquí...",
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}