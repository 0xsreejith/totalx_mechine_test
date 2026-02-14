import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserLocalDatasource {
  static const boxName = "users";

  /// Get box name specific to phone number
  String _getBoxName(String phoneNumber) {
    return "${boxName}_$phoneNumber";
  }

  Future<void> addUser(UserModel user, String phoneNumber) async {
    final box = await Hive.openBox<UserModel>(_getBoxName(phoneNumber));
    await box.put(user.id, user);
  }

  Future<List<UserModel>> getUsers(int limit, String phoneNumber) async {
    final box = await Hive.openBox<UserModel>(_getBoxName(phoneNumber));
    return box.values.take(limit).toList();
  }

  Future<List<UserModel>> search(String query, String phoneNumber) async {
    final box = await Hive.openBox<UserModel>(_getBoxName(phoneNumber));

    return box.values
        .where((u) =>
            u.name.toLowerCase().contains(query.toLowerCase()) ||
            u.phone.contains(query))
        .toList();
  }
}
