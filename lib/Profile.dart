import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final String username;
  final String email;

  const ProfileScreen(
      {Key? key,
      required this.onLogout,
      required this.username,
      required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF191414),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profil Fotoğrafı
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150', // Profil resmi için bir URL
                ),
              ),
              SizedBox(height: 16.0),

              // Kullanıcı Adı
              Text(
                username, // Kullanıcı adı
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.0),

              // E-posta
              Text(
                email, // Kullanıcı e-postası
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24.0),

              // Profil Ayarları
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () {
                  // Profil düzenleme sayfasına git
                },
              ),
              Divider(color: Colors.grey),

              ListTile(
                leading: Icon(Icons.lock, color: Colors.white),
                title: Text(
                  'Privacy Settings',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () {
                  // Gizlilik ayarları sayfasına git
                },
              ),
              Divider(color: Colors.grey),

              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: onLogout, // Call the onLogout callback
              ),
              SizedBox(height: 24.0),

              // Ek Butonlar (isteğe bağlı)
              ElevatedButton(
                onPressed: () {
                  // Ek bir işlem yap
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1DB954),
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text('Custom Action'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFF191414), // Arkaplan rengi
    );
  }
}
