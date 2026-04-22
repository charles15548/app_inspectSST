import 'package:supabase_flutter/supabase_flutter.dart';

class InspeccionesService {
  static final SupabaseClient supabase = Supabase.instance.client;


  static Future<List<Map<String, dynamic>>> listarPeriodos() async {
    try {
      final response = await supabase
          .from('periodo_checklist')
          .select('id_periodo, nombre')
          .order('id_periodo',ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al listar periodos: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> listarInspections() async {
    try {
       
      //await actualizarEstados();
       final response = await supabase
        .from('checklist')
        .select('''
          id_checklist,
          nombre,
          estado,
          fecha_inicio,
          fecha_fin,
          checklist_items (count)
        ''');

      print('Checklist $response');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al listar inspecciones: $e');
    }
  }

  static Future<void> actualizarEstados() async {
  try {
    print("🔵 Llamando RPC actualizar_estado_checklists...");
    final response = await supabase.rpc('actualizar_estado_checklists');
    print("🟢 RPC ejecutado correctamente: $response");
  } catch (e) {
    print("🔴 Error en RPC: $e");
  }
}


}
