import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../utils/constans.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<Map<String, dynamic>?> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return doc.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Profil', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: bPrimaryColor,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading profile data.'));
          }

          final userData = snapshot.data!;
          return SingleChildScrollView(
            // Membuat halaman scrollable
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                color: Colors.grey[100],
                elevation: 0,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              child: Icon(Icons.person, size: 40),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              userData["username"] ?? "Nama Tidak Ditemukan",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _profileDetailRow('Tingkat', 'Madrasah Ibtidaiyah'),
                      _profileDetailRow('Kelas', '-'),
                      _profileDetailRow('NSM', '123456789001'),
                      _profileDetailRow('NISN', '0987654320'),
                      _profileDetailRow(
                          'Tempat, tanggal lahir', 'Yogyakarta, 21 April 2008'),
                      _profileDetailRow('Jenis Kelamin', 'Laki-Laki'),
                      _profileDetailRow('Alamat', 'Jl. Jalan No. 01'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false);
                              await authService.logout(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFE32A2A),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            child: const Text(
                              'Keluar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Tambahkan logika untuk QR Code
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF050C9C),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Atur radius sesuai kebutuhan
                              ),
                            ),
                            child: const Text(
                              'QR Code',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _profileDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
