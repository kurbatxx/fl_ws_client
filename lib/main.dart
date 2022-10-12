import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
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

  final _controller = TextEditingController();
  late Stream _broadcast;
  late List<String> messages;

  @override
  void initState() {
    _broadcast = _channel.stream.asBroadcastStream();
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
          StreamBuilder(
            stream: _broadcast,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Text('Нет подключения к серверу');
              } else if (snapshot.hasData) {
                messages.add(snapshot.data as String);
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final text = messages[index];
                      return ListTile(
                        title: Text(text),
                      );
                    },
                  ),
                );
              }
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          ),
        ],
      ),
      floatingActionButton: TextButton(
        onPressed: () {
          _channel.sink.add(_controller.text);
        },
        child: const Text('Отправить'),
      ),
    );
  }
}
