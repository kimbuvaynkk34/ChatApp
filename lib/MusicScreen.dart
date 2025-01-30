import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:matchapp/Listeners.dart';
import 'package:matchapp/PlaylistDetails.dart';

class MusicScreen extends StatefulWidget {
  final String? id;

  const MusicScreen({Key? key, required this.id}) : super(key: key);

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  List<dynamic> musicData = [];
  List<dynamic> featuredPlaylists = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchMusicData();
    fetchFeaturedPlaylists();

    // 10 saniyede bir veri yenilemek için interval ayarlandı
    _timer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => fetchMusicData());
  }

  Future<void> fetchMusicData() async {
    try {
      final musicResponse = await Dio().get(
          'http://31.57.156.116:44430/api/GetCurrentlyPlayRealtime/${widget.id}');
      final music = musicResponse.data;
      print(music);

      setState(() {
        musicData = [
          {
            'id': '1',
            'track': music['track'],
            'artist': music['artist'],
            'image': music['imageUrl'] ??
                'https://via.placeholder.com/150', // Fallback image
          },
        ];
      });
    } catch (error) {
      print('Error fetching music data: $error');
    }
  }

  Future<void> fetchFeaturedPlaylists() async {
    try {
      final playlistsResponse = await Dio()
          .get('http://31.57.156.116:44430/api/GetUserPlaylists/${widget.id}');
      setState(() {
        featuredPlaylists = playlistsResponse.data;
      });
    } catch (error) {
      print('Error fetching featured playlists: $error');
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Timer'ı temizle
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF191414),
      appBar: AppBar(
        title: Text('Music & Playlists'),
        backgroundColor: Color(0xFF191414),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Currently Playing Section
              Text('Currently Playing',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: musicData.length,
                  itemBuilder: (context, index) {
                    final item = musicData[index];
                    return GestureDetector(
                      onTap: () {
                        // Track'e tıklandığında Listeners sayfasına git
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListenersScreen(
                              track: item['track'],
                              artist: item['artist'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16),
                        width: 150,
                        child: Column(
                          children: [
                            Image.network(item['image']),
                            Text(item['track'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text(item['artist'],
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Featured Playlists Section
              Text('Featured Playlists',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredPlaylists.length,
                  itemBuilder: (context, index) {
                    final playlist = featuredPlaylists[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaylistDetails(
                              playlistId: playlist[
                                  'id'], // id'yi parametre olarak gönderiyoruz
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16),
                        width: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 145,
                              child: Image.network(
                                playlist['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              playlist['name'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              playlist['description'] ?? playlist['owner'],
                              style: TextStyle(color: Colors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
