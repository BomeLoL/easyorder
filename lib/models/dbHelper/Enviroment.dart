// ignore: file_names
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment{
  static String get fileName {

    return '.env.development';
  }

  static String get bdKey{
    return dotenv.env['MONGO_URL']?? "";
  }
}