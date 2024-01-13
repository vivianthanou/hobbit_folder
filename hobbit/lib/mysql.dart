import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'localhost',
                user = 'root',
                password ='',
                db = 'hobbit';
  static int port = 48286;

  Mysql();

  Future<MySqlConnection> getConnection() async{
    var settings = ConnectionSettings(
      host : host,
      port : port,
      user : user,
      password : password,
      db : db
    );
    return await MySqlConnection.connect(settings);
  }
}