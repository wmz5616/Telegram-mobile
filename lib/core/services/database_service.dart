// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../features/chat/data/models/chat.dart';
// import '../../features/chat/data/models/message.dart';

class DatabaseService {
  // 暂时禁用数据库服务，以便在 Web/Chrome 上运行纯 UI 模式
  
  // late Future<Isar> db;

  DatabaseService() {
    // db = _initDB();
  }

  // Future<Isar> _initDB() async {
  //   if (Isar.instanceNames.isEmpty) {
  //     final dir = await getApplicationDocumentsDirectory();
  //     return await Isar.open(
  //       [ChatSchema, MessageSchema], // 报错是因为这里引用了不存在的 Schema
  //       directory: dir.path,
  //       inspector: true, 
  //     );
  //   }
  //   return Future.value(Isar.getInstance());
  // }
}