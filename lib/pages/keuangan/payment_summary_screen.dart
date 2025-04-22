import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pesantren_asad/pages/keuangan/keuangan_screen.dart';
import 'package:flutter/services.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final String bankName;
  final double amount;

  const PaymentSummaryScreen({
    super.key,
    required this.bankName,
    required this.amount,
  });

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> saveTransaction(String bankName, double amount) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

      await userDoc.collection('transactions').add({
        'bankName': bankName,
        'type': 'Setoran',
        'amount': amount,
        'date': FieldValue.serverTimestamp(),
        'proof': _selectedImage != null ? _selectedImage!.path : null,
      });

      final userData = await userDoc.get();
      final currentBalance = userData.data()?['balance']?.toDouble() ?? 0.0;
      final newBalance = currentBalance + amount;

      await userDoc.update({'balance': newBalance});
    }
  }

  @override
  Widget build(BuildContext context) {
    final double biaya = 1000;
    final double totalSetoran = widget.amount + biaya;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setor Keuangan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF050C9C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bank yang dipilih',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance,
                        size: 30, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      widget.bankName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Detail Pembayaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF5F7FB), // Warna latar belakang biru muda
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFB6C2D6)), // Warna border biru
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Jumlah transfer',
                        'Rp${widget.amount.toStringAsFixed(0)}'),
                    const SizedBox(height: 10),
                    _buildDetailRow('Biaya', 'Rp${biaya.toStringAsFixed(0)}'),
                    const Divider(
                      color: Color(0xFFB6C2D6), // Warna divider biru
                      thickness: 1,
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total setoran',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rp${totalSetoran.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Informasi Bank',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nomor akun bank',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.copy, color: Color(0xFF050C9C)),
                          onPressed: () {
                            Clipboard.setData(
                                const ClipboardData(text: '098123486759020'));
                            Fluttertoast.showToast(
                              msg: "Nomor akun bank disalin!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 14.0,
                            );
                          },
                        ),
                      ],
                    ),
                    const Text(
                      '098123486759020',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 20,
                    ),
                    const Text(
                      'Nama akun bank',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Text(
                      'PESANTREN',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bukti Pembayaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedImage != null
                            ? _selectedImage!.path.split('/').last
                            : 'Tambah foto',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Icon(Icons.upload_file, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await saveTransaction(widget.bankName, widget.amount);

                    Fluttertoast.showToast(
                      msg: "Transaksi berhasil disimpan!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 14.0,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KeuanganPage()),
                    );
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: "Gagal menyimpan transaksi: $e",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 14.0,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF050C9C),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Saya sudah transfer',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
