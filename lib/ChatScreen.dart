import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<Chatscreen> {
  late HubConnection _connection;
  late TextEditingController _messageController;
  late TextEditingController _roomController;
  List<String> messages = [];
  late String roomName;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _roomController = TextEditingController();
    _initializeSignalR();
  }

  // SignalR bağlantısını başlatma
  void _initializeSignalR() {
    _connection = HubConnectionBuilder()
        .withUrl("http://31.57.156.116:44430/chatHub") // SignalR Hub URL
        .build();

    // Mesaj alma
    _connection.on("ReceiveMessage", (args) {
      _onReceiveMessage(
          args); // Mesaj alındığında işleme fonksiyonu çağırıyoruz.
    });

    // Bağlantıyı başlat
    _connection.start();
  }

  void _onReceiveMessage(args) {
    if (args != null && args.isNotEmpty) {
      setState(() {
        // args[0] ve args[1]'in türlerine uygun biçimde mesajları ekliyoruz.
        messages.add("${args[0].toString()}: ${args[1].toString()}");
      });
    }
  }

  // Odaya katılma
  void _joinRoom() {
    roomName = _roomController.text;
    if (roomName.isNotEmpty) {
      _connection.invoke("JoinRoom", args: [roomName]).catchError((err) {
        print("Error joining room: $err");
      });
      _getRoomMessages();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter a room name."),
      ));
    }
  }

  // Oda mesajlarını almak
  void _getRoomMessages() {
    if (roomName.isNotEmpty) {
      _connection.invoke("GetRoomMessages", args: [roomName]).catchError((err) {
        print("Error getting room messages: $err");
      });
    }
  }

  // Mesaj gönderme
  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty && roomName.isNotEmpty) {
      _connection.invoke("SendMessage",
          args: [roomName, message, 2]).catchError((err) {
        print("Error sending message: $err");
      });
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter a message and join a room."),
      ));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _roomController.dispose();
    _connection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SignalR Chat")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Room Name Input
            TextField(
              controller: _roomController,
              decoration: InputDecoration(labelText: "Room Name"),
            ),
            ElevatedButton(
              onPressed: _joinRoom,
              child: Text("Join Room"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index]),
                  );
                },
              ),
            ),
            // Message Input
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: "Enter Message"),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text("Send Message"),
            ),
          ],
        ),
      ),
    );
  }
}
