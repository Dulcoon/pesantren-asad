import 'package:flutter/material.dart';
import 'transfer_form_screen.dart';

class BankListScreen extends StatelessWidget {
  const BankListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setor Keuangan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF050C9C), // Warna biru utama
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildBankItem(
            context,
            bankName: 'Bank BRI',
            minTransaction: 'Minimal transaksi Rp100.000',
          ),
          const SizedBox(height: 10),
          _buildBankItem(
            context,
            bankName: 'Bank BNI',
            minTransaction: 'Minimal transaksi Rp100.000',
          ),
          const SizedBox(height: 10),
          _buildBankItem(
            context,
            bankName: 'Bank BCA',
            minTransaction: 'Minimal transaksi Rp50.000',
          ),
        ],
      ),
    );
  }

  Widget _buildBankItem(BuildContext context,
      {required String bankName, required String minTransaction}) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman berikutnya (form transfer)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransferFormScreen(bankName: bankName),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  minTransaction,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
