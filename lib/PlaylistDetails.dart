import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlaylistDetails extends StatefulWidget {
  final String playlistId;

  const PlaylistDetails({Key? key, required this.playlistId})
      : super(key: key); // Parametreyi alıyoruz

  @override
  _PlaylistDetailsState createState() => _PlaylistDetailsState();
}

class _PlaylistDetailsState extends State<PlaylistDetails> {
  List<dynamic> tracks = []; // Verileri tutmak için bir liste oluşturuyoruz.

  @override
  void initState() {
    super.initState();
    fetchPlaylistTracks();
  }

  Future<void> fetchPlaylistTracks() async {
    try {
      // Playlist ID'yi URL'ye ekliyoruz
      final response = await Dio().get(
        'http://31.57.156.116:44430/api/GetPlaylistTracks/1/${widget.playlistId}',
      );
      print(widget.playlistId);

      setState(() {
        tracks = response.data; // Gelen veriyi 'tracks' listesine alıyoruz
      });
    } catch (e) {
      print('Error fetching playlist tracks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF191414),
      appBar: AppBar(
        backgroundColor: Color(0xFF191414),
        foregroundColor: Colors.white,
        title: Text('Playlist Details'),
      ),
      body: FutureBuilder(
        future: fetchPlaylistTracks(),
        builder: (context, snapshot) {
          return Skeletonizer(
            enabled: tracks.isEmpty,
            child: ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return ListTile(
                  textColor: Colors.white,
                  title: Text(track['trackName']), // Şarkı adı
                  subtitle: Text(track['artists']), // Sanatçı adı
                  leading: Image.network(track['image'] ??
                      'https://via.placeholder.com/150'), // Şarkı resmi
                );
              },
            ),
          );
        },
      ),
    );
  }
}
