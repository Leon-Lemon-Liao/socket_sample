import 'dart:convert';
import 'package:first_flutter/user_controller.dart';
import 'package:first_flutter/user_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: _title,
      // home: Scaffold(
      //   appBar: AppBar(title: Text(_title)),
      //   backgroundColor: Colors.blueGrey,
      //   body: const MyWidget(),
      // ),
      initialRoute: '/sign_in',
      getPages: [
        GetPage(name: '/sign_in', page: () => const MyWidget(), binding: MyControllerBinding() //GetPage
            ),
      ],
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // late WebSocketChannel channel;
  // UserModel? receivedUser;
  final UserController _controller = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    // connectToSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                UserModel user = UserModel(id: '1', name: 'Alice', age: 25);
                // channel.sink.add(user.toJson().toString());
                _controller.sendUser(user);
              },
              child: const Text('Send User1'),
            ),
            ElevatedButton(
              onPressed: () {
                UserModel user = UserModel(id: '2', name: 'Bob', age: 30);
                // channel.sink.add(jsonEncode(user));
                _controller.sendUser(user);
              },
              child: const Text('Send User2'),
            ),
            ElevatedButton(
              onPressed: () {
                UserModel user = UserModel(id: '3', name: 'Cat', age: 5);
                // channel.sink.add(jsonEncode(user.toJson()));
                _controller.sendUser(user);
              },
              child: const Text('Send User3'),
            ),
            _buildResponseDisplay(),
            // StreamBuilder(
            //   stream: channel.stream,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       try {
            //         Map<String, dynamic> data = jsonDecode(snapshot.data);
            //         receivedUser = UserModel.fromJson(data);
            //       } catch (e) {
            //         return Text('Error decoding JSON: $e');
            //       }
            //       return Text('Received: ${receivedUser?.name}, Age: ${receivedUser?.age}');
            //     } else if (snapshot.hasError) {
            //       return Text('Error: ${snapshot.error}');
            //     } else {
            //       return Column(
            //         children: [
            //           Text('Waiting for data...'),
            //           CircularProgressIndicator(),
            //         ],
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseDisplay() {
    return Obx(() {
      if (_controller.error.isNotEmpty) {
        return Text('錯誤: ${_controller.error}');
      }
      return _controller.data != null
          ? Column(
              children: [
                Text('姓名: ${_controller.data!.name}'),
                Text('年齡: ${_controller.data!.age}'),
              ],
            )
          : const CircularProgressIndicator();
    });
  }

// void connectToSocket() {
//   channel = WebSocketChannel.connect(
//     Uri.parse('ws://$ip:$port'),
//   );
// }
}