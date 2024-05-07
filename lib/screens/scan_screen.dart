import 'dart:ffi';

import 'package:flash_retail/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert'; // For JSON handling

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  String? total;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();

      // Decode the JSON data from the QR code
      Map<String, dynamic> data = jsonDecode(scanData.code!);
      List<dynamic> uids = data['uids']; // Now 'uids' is treated as a List
      total = data['total'];

      _showPaymentScreen(uids.join(
          ", ")); // Join the list for display, or pass as List to the next screen
    });
  }

  void _showPaymentScreen(String uids) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => PaymentsScreen(
                total: total,
                uids: uids,
              )),
    );
    // Navigate to the payment screen with total price
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scan a QR code',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
