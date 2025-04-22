import 'package:flutter/material.dart';
import 'payment_summary_screen.dart'; // Halaman berikutnya setelah form transfer

class TransferFormScreen extends StatefulWidget {
  final String bankName;

  const TransferFormScreen({super.key, required this.bankName});

  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
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
              'Jumlah transfer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Rp0',
                errorText: _errorText,
              ),
              onChanged: (value) {
                setState(() {
                  final amount = double.tryParse(value) ?? 0.0;
                  if (amount < 100000) {
                    _errorText = 'Minimal transaksi Rp100.000';
                  } else if (amount > 20000000) {
                    _errorText = 'Maksimal transaksi Rp20.000.000';
                  } else {
                    _errorText = null;
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text) ?? 0.0;
                if (_errorText == null && amount > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentSummaryScreen(
                        bankName: widget.bankName,
                        amount: amount,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Masukkan jumlah yang valid!')),
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
                'Lanjut',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
