import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionInfo extends StatelessWidget {
  final Map<String, dynamic> transaction;
  static const String baseUrl =
      'https://retailflash.up.railway.app/'; // Replace with your server's base URL

  const TransactionInfo({Key? key, required this.transaction})
      : super(key: key);

  String formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    final DateTime dateTime = DateTime.parse(dateStr);
    final DateFormat formatter = DateFormat('MM/dd/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/50';
    }
    return '$baseUrl$path';
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Transaction data in TransactionInfo: $transaction'); // Debug print to inspect transaction data

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text('Transaction Info', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Details',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    Divider(color: Colors.grey),
                    Text(
                      'Transaction ID: ${transaction['_id'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Product List:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ...?transaction['productsList']?.map<Widget>((product) {
                      final productUid = product['productUid'];
                      if (productUid is Map<String, dynamic>) {
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                getImageUrl(productUid['image']),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(productUid['name'] ?? 'Unknown Product',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                '\$${(productUid['sellingPrice']?.toStringAsFixed(3) ?? '0.00')}'),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }).toList(),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Method:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          transaction['paymentMethod'] ?? 'N/A',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Phone:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          transaction['paymentPhone'].toString() ?? 'N/A',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${transaction['totalPrice']?.toStringAsFixed(3) ?? '0.00'}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatDate(transaction['createdAt']),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
