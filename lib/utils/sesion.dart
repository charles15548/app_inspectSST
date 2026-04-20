class ASession{
  static int? userId;
  
  static void setUserid(int id){
    userId = id;
  }

  static int? getUserId(){
    return userId;
  }

  static void clear(){
    userId = null;
  }
}