import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'ChatScreen.dart';

class ListenersScreen extends StatefulWidget {
  final String track;
  final String artist;

  const ListenersScreen({Key? key, required this.track, required this.artist})
      : super(key: key);

  @override
  _ListenersScreenState createState() => _ListenersScreenState();
}

class _ListenersScreenState extends State<ListenersScreen> {
  List<Listener> listeners = []; // Dinleyici objelerini saklayacak liste
  bool isLoading = true; // Veri yüklenme durumunu kontrol etmek için
  String errorMessage = ''; // Hata mesajlarını göstermek için

  @override
  void initState() {
    super.initState();
    fetchListeners();
  }

  Future<void> fetchListeners() async {
    try {
      final response = await Dio().get(
          'http://31.57.156.116:44430/api/GetUsersBySong/${widget.track}/${widget.artist}');

      // Veriyi Listener modeline dönüştür
      setState(() {
        listeners = (response.data as List)
            .map((listenerData) => Listener.fromJson(listenerData))
            .toList();
        isLoading = false; // Yükleme tamamlandı
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching listeners: $error';
        isLoading = false; // Hata durumunda yükleme tamamlanır
      });
    }
  }

  void onListenerTap(Listener listener) {
    // Dinleyiciye tıklanınca yapılacak işlemler
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chatscreen(),
      ),
    );
    print('Tapped on listener: ${listener.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF191414), // Arka plan rengi
      appBar: AppBar(
        title:
            Text('${widget.track} Listeners'), // Parça adı başlıkta görünecek
        backgroundColor: Color(0xFF191414),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green, // Yükleme göstergesi rengi
              ),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage, // Hata mesajını göster
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : listeners.isEmpty
                  ? Center(
                      child: Text(
                        'No listeners found.', // Dinleyici bulunamadığında mesaj
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(16),
                      itemCount: listeners.length,
                      itemBuilder: (context, index) {
                        final listener = listeners[index];
                        return ListTile(
                          title: Text(
                            listener.username, // Dinleyici adını göster
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          subtitle: Text(
                            'ID: ${listener.id}', // Dinleyici id'sini de gösterebiliriz
                            style: TextStyle(color: Colors.white70),
                          ),
                          onTap: () => onListenerTap(
                              listener), // Tıklama özelliği eklendi
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey.shade800,
                      ),
                    ),
    );
  }
}

class Listener {
  final String username;
  final String id;

  Listener({required this.username, required this.id});

  // JSON'dan Listener objesi oluşturmak için factory constructor
  factory Listener.fromJson(Map<String, dynamic> json) {
    return Listener(
      username: json['username'],
      id: json['id'],
    );
  }
}
