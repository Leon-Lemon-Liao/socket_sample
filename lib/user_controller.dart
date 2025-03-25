// controllers/user_controller.dart

import 'package:first_flutter/user_model.dart';
import 'package:first_flutter/web_socket_controller.dart';

class UserController extends WebSocketController<UserModel> {
  UserController() : super(fromJson: UserModel.fromJson);

  void sendUser(UserModel user) => sendJson(user.toJson());

  void sendUserList(List<UserModel> users) {
    final jsonList = users.map((user) => user.toJson()).toList();
    sendJson({'data': jsonList});
  }
}
