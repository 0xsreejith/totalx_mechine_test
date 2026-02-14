import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserLocalDatasource {
  static const boxName = "users";

  Future<void> addUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(boxName);
    await box.put(user.id, user);
  }

  Future<List<UserModel>> getUsers(int limit) async {
    final box = await Hive.openBox<UserModel>(boxName);
    return box.values.take(limit).toList();
  }

  Future<List<UserModel>> search(String query) async {
    final box = await Hive.openBox<UserModel>(boxName);

    return box.values
        .where((u) =>
            u.name.toLowerCase().contains(query.toLowerCase()) ||
            u.phone.contains(query))
        .toList();
  }
}
