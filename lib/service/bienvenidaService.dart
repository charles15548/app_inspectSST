
import 'package:supabase_flutter/supabase_flutter.dart';

class BienvenidaService {
  static  final supabase = Supabase.instance.client;

  static Future<List<Map<String,dynamic>>> getAll() async{
    final result = await supabase
      .from('bienvenida')
      .select('*')
      .order('fecha_publicacion',ascending: false);

      return List<Map<String, dynamic>>.from(result);
  }
}