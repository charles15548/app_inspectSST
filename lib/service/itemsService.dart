import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class Itemsservice {
  static final supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> listItems(int idChecklist) async{
    try{
      final response = await supabase
      .from('checklist_items')
      .select('id_items, id_checklist, numero_item, descripcion')
      .eq('id_checklist', idChecklist)
      .order('numero_item', ascending: true);

      return List<Map<String,dynamic>>.from(response);

    }catch(e){
      throw Exception('Error al listar items: ${e}');
    }
  }


  // static Future<void> guardarEvidencias(List<Map<String, dynamic>> evidencias, int idChecklist) async {
  //   try{
  //     await supabase.from('evidencia').insert(evidencias);

  //     // await supabase.from('checklist').update({
  //     //   'estado':true,
  //     //   }).eq('id_checklist', idChecklist);
  //   }catch(e){
  //       throw Exception('Error al guardar: $e');
  //     }
  // }
  static Future<void> guardarEvidenciaItem(Map<String, dynamic> evidencia) async {
    try {
      await supabase.from('evidencia').insert([evidencia]);
    } catch (e) {
      throw Exception('Error al guardar item: $e');
    }
  }

  

  static Future<String?> subirImagen(File archivo, int idChecklist ) async{
    try{
      final extension = archivo.path.split('.').last;
       final String fileName =
          'checklist_${idChecklist}/${DateTime.now().millisecondsSinceEpoch}.$extension';

      await supabase.storage.from('imagen')
        .upload(
          fileName, 
          archivo,
          fileOptions: const FileOptions(upsert: true),
        );

      final String publicUrl = supabase.storage.from('imagen').getPublicUrl(fileName);
      print("Imagen subida correctamente: $publicUrl");
      return publicUrl;
    }catch(e){
      print('Error subiendo imagen: $e');
      return null;
    }
  }
 



 

}
 