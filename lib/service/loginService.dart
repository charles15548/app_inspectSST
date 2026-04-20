import 'package:supabase_flutter/supabase_flutter.dart';

class Loginservice {
  static final supabase = Supabase.instance.client;

  static Future<Map<String,dynamic>> login(String correo, String password  )async{
    try{
      final result = await supabase
          .from('auth')
          .select('id_auth,correo,password')
          .eq('correo', correo)
          .maybeSingle();
      print("Haciendo login: $result ");

      if (result == null) {
        return {"success": false, "message": "Usuario no encontrado. $correo"};
      }
      if (result['password'] != password) {
        return {'success': false, "message": "Contraseña incorrecta"};
      }
      return {"success": true, "id": result["id_auth"], "message": "Login exitoso"};
    }catch(e){
      return{
        "success":false,
        "message": "Error de conexión"
      };
    }
  }
}