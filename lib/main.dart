import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:websok_ex/enum/action.dart';
import 'package:websok_ex/model/action.dart';
import 'package:websok_ex/model/message.dart';

void main() {
  final jsonData = jsonDecode(
      '{"action":"get_messages","data":[{"id":0,"message":"hello"}]}');
  final receivedAction = ReceivedAction.fromJson(jsonData);
  if (receivedAction.action == ActionEnum.getMessages.value) {
    final data = receivedAction.data as List;
    final _ = data.map((item) => Message.fromJson(item)).toList();
  }

  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.1.127:5009/ws'),
  );

  late TextEditingController _controller;
  late Stream _broadcast;
  late List<Message> messages;

  @override
  void initState() {
    _broadcast = _channel.stream.asBroadcastStream();
    _controller = TextEditingController();
    messages = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WEB_Soket'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
          ),
          StreamBuilder(
            stream: _broadcast,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          ),
          const SizedBox(height: 24),
          Expanded(
            child: StreamBuilder(
              stream: _broadcast,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text('Нет подключения к серверу');
                } else if (snapshot.hasData) {
                  final jsonData = jsonDecode(snapshot.data as String);
                  final receivedAction = ReceivedAction.fromJson(jsonData);
                  final action = toEnum(receivedAction.action);
                  if (action != null) {
                    switch (action) {
                      case ActionEnum.getMessages:
                        messages.clear();

                        final data = receivedAction.data as List;
                        final dbMessages =
                            data.map((item) => Message.fromJson(item)).toList();
                        messages.addAll(dbMessages);
                        break;
                      case ActionEnum.addMessage:
                        final data =
                            receivedAction.data as Map<String, dynamic>;
                        final dbMessage = Message.fromJson(data);
                        messages.add(dbMessage);
                        break;
                    }
                  }
                  if (receivedAction.action == ActionEnum.getMessages.value) {}

                  //messages.add(snapshot.data as String);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message.message),
                      );
                    },
                  );
                }
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            ),
          ),
        ],
      ),
      floatingActionButton: TextButton(
        onPressed: () {
          final sendMessage = ReceivedAction(
            action: ActionEnum.addMessage.value,
            data: _controller.text,
          );

          String json = jsonEncode(sendMessage);
          print(json);

          _channel.sink.add(json);
        },
        child: const Text('Отправить'),
      ),
    );
  }
}
