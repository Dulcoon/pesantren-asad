import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pesantren_asad/utils/constans.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal dan waktu
import '../keuangan/keuangan_screen.dart';
import '../profile/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const KeuanganPage(),
    const ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 0
                  ? 'assets/images/home_fill.png' // Ikon dengan fill
                  : 'assets/images/home_stroke.png', // Ikon dengan stroke
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 1
                  ? 'assets/images/keuangan_fill.png' // Ikon dengan fill
                  : 'assets/images/keuangan_stroke.png', // Ikon dengan stroke
              width: 24,
              height: 24,
            ),
            label: 'Keuangan',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 2
                  ? 'assets/images/profile_fill.png' // Ikon dengan fill
                  : 'assets/images/profile_stroke.png', // Ikon dengan stroke
              width: 24,
              height: 24,
            ),
            label: 'Profil',
          ),
        ],
        selectedItemColor: const Color(0xFF050C9C), // Warna teks terpilih
        unselectedItemColor: Colors.grey, // Warna teks tidak terpilih
        showUnselectedLabels:
            true, // Tampilkan label untuk item yang tidak terpilih
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  Future<double> _getBalance() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      return data?['balance']?.toDouble() ?? 0.0;
    }
    return 0.0;
  }

  String _getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now()); // Format jam dan menit
  }

  String _getCurrentDate() {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
        .format(DateTime.now()); // Format hari, tanggal, bulan, tahun
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 170,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/homepage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Selamat Datang',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getCurrentDate(), // Tanggal otomatis
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _getCurrentTime(), // Jam otomatis
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/imageBanner.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 140,
                left: 20,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/wallet.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 5),
                          FutureBuilder<double>(
                            future: _getBalance(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                  'Loading...',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal),
                                );
                              }
                              if (snapshot.hasError) {
                                return const Text(
                                  'Error',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal),
                                );
                              }
                              final balance = snapshot.data ?? 0.0;
                              return Text(
                                'Rp ${balance.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal),
                              );
                            },
                          ),
                        ],
                      ),
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/keuangan');
                        },
                        child: Row(
                          children: const [
                            Text(
                              'Lihat Keuangan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: bPrimaryColor,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: bPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Berita & Artikel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman "Lihat Semua"
                          Navigator.pushNamed(context, '/lihatSemuaBerita');
                        },
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: bPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      _buildArticleCard(
                        context,
                        image: 'assets/images/program pendidikan.png',
                        title: 'Program Pendidikan Standarisasi Da’i MUI Ke-36',
                        date: '18/12/2024',
                      ),
                      const SizedBox(height: 10),
                      _buildArticleCard(
                        context,
                        image: 'assets/images/ayo nyantri.png',
                        title: 'Ayo Nyantri di Pondok Pesantren As’ad',
                        date: '03/12/2024',
                      ),
                      const SizedBox(height: 10),
                      _buildArticleCard(
                        context,
                        image: 'assets/images/hari santri.png',
                        title: 'Perayaan Hari Santri tampak berbeda',
                        date: '31/10/2023',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context,
      {required String image, required String title, required String date}) {
    return Card(
      color: const Color(0xFFF7F7F7), // Background color #F7F7F7
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300], // Background warna abu-abu
                    child: const Icon(
                      Icons.broken_image, // Ikon fallback
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
