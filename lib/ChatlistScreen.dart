import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

class Chatlistscreen extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<Chatlistscreen> {
  late HubConnection _hubConnection;
  List<Map<String, String>> messages = [];
  int userId = 1; // Kullanıcı ID

  @override
  void initState() {
    super.initState();
    _connectSignalR();
  }

  Future<void> _connectSignalR() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl("http://localhost:5051/chatHub") // API URL'ni buraya yaz
        .build();

    // Bağlantıyı başlat
    await _hubConnection.start();

    print("SignalR bağlantısı başarılı!");

    // Sunucudan gelen mesajları dinle
    _hubConnection.on("ReceiveMessagess", (arguments) {
      if (arguments != null && arguments.length == 3) {
        final roomId = arguments[0].toString();
        final roomName = arguments[1].toString();
        final content = arguments[2].toString();

        setState(() {
          messages.add({
            "roomId": roomId,
            "roomName": roomName,
            "content": content,
          });
        });
      }
    });

    // Kullanıcının mesajlarını almak için GetLatestMessage çağrısı yap
    _hubConnection.invoke("GetLatestMessage", args: [userId]).catchError((err) {
      print("Hata: $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Son Mesajlar")),
        body: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return ListTile(
              title: Text(msg["roomName"] ?? "Bilinmeyen Oda",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(msg["content"] ?? "Mesaj Yok"),
            );
          },
        ),
      ),
    );
  }
}
