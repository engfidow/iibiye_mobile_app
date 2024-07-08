import 'package:flash_retail/screens/transaction_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flash_retail/providers/transaction_provider.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  String formatDate(String dateStr) {
    final DateTime dateTime = DateTime.parse(dateStr);
    final DateFormat formatter = DateFormat('MM/dd/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  Widget buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            leading: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            title: Container(
              width: 150,
              height: 20,
              color: Colors.white,
            ),
            subtitle: Container(
              width: 100,
              height: 20,
              color: Colors.white,
            ),
            trailing: Container(
              width: 50,
              height: 20,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Transaction History",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.isLoading) {
            return buildShimmer();
          }

          if (transactionProvider.transactions.isEmpty) {
            return const Center(child: Text("No transactions available."));
          }

          return ListView.builder(
            itemCount: transactionProvider.transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactionProvider.transactions[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionInfo(
                        transaction: transaction,
                      ),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                leading: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        transaction['paymentMethod'] == "EVC-PLUS"
                            ? 'assets/EVC-PLUS.png'
                            : 'assets/premier.png',
                      ),
                    ),
                  ),
                ),
                title: Text(
                  transaction['_id'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  formatDate(transaction['createdAt']),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  "\$${transaction['totalPrice']}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
