import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'keuangan_screen.dart';

class DetailTransaksiScreen extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final String transactionId;
  final String status;
  final String recipientName;
  final String recipientAccount;
  final String message;

  const DetailTransaksiScreen({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
    required this.transactionId,
    required this.status,
    required this.recipientName,
    required this.recipientAccount,
    this.message = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF050C9C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.upload_file,
                    size: 50,
                    color: Color(0xFF050C9C),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Rp $amount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF050C9C),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            _buildDetailRow('Waktu transaksi', date),
            const SizedBox(height: 10),
            _buildDetailRowWithCopy(
              context,
              'Transaksi ID',
              transactionId,
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Status Transaksi', status),
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            _buildDetailRow('Detail Penerima', recipientName),
            const SizedBox(height: 10),
            _buildDetailRow('Nomor Rekening', recipientAccount),
            const SizedBox(height: 10),
            if (message.isNotEmpty)
              _buildDetailRow('Pesan (opsional)', message),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KeuanganPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF050C9C),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Center(
                child: Text(
                  'Kembali',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
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

  Widget _buildDetailRowWithCopy(
      BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 16, color: Color(0xFF050C9C)),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                Fluttertoast.showToast(
                  msg: "ID transaksi disalin!",
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
      ],
    );
  }
}
