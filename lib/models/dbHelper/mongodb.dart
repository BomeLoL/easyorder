import 'dart:developer';

import 'package:easyorder/models/dbHelper/constant.dart';

import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
//    var status = db.serverStatus();
//    var collection = db.collection(COLLECTION_NAME);
  }
}