import 'package:hive/hive.dart';

part 'TestModel.g.dart';

@HiveType(typeId: 30)
class TestModels extends HiveObject {
  int id = 0;
  String name = "";
}
