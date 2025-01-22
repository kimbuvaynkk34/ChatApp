import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

ValueNotifier<List<dynamic>> messageList = ValueNotifier<List<dynamic>>([]);

class ChatListScreen extends StatefulWidget {
  final String userId;

  const ChatListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final String _hubUrl = "http://localhost:5051";
  final String _hubName = "chatHub";
  late HubConnection _hubConnection;

  @override
  void initState() {
    super.initState();
    signalRConnection();
  }

  Future<void> signalRConnection() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl("$_hubUrl/$_hubName")
        .withAutomaticReconnect(retryDelays: [0, 1000, 5000, 10000]).build();

    _hubConnection.on("ReceiveUserLastMessages", (message) {
      setState(() {
        messageList.value = (message?.first as List<dynamic>);
      });
      print(messageList.value);
    });

    try {
      await _hubConnection.start();
      print("Connected to SignalR Hub");
      await _hubConnection.invoke("GetUserLastMessages", args: [widget.userId]);
    } catch (error) {
      print("Error while connecting: $error");
    }
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Rooms"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<List<dynamic>>(
          valueListenable: messageList,
          builder: (context, messages, child) {
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final roomId = message['roomId']; // Odanın ID'sini alın

                return GestureDetector(
                  onTap: () {
                    // Odaya geçiş yapabilirsiniz, örneğin:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          roomId: roomId,
                          userId: widget.userId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['senderUsername'] ?? "Unknown User",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            message['content'] ?? "No message",
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String roomId;
  final String userId;

  const ChatScreen({Key? key, required this.roomId, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room: $roomId"),
      ),
      body: Center(
        child: Text("Chat with $roomId"),
      ),
    );
  }
}
