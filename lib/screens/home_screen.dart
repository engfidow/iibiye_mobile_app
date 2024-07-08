import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_retail/providers/transaction_provider.dart';
import 'package:flash_retail/providers/user_provider.dart';
import 'package:flash_retail/screens/transaction_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user?.id ?? '';
      Provider.of<TransactionProvider>(context, listen: false)
          .fetchTransactionsByUserId(userId);
    });
  }

  void _showProfilePhoto(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(
                  'https://retailflash.up.railway.app/$imageUrl'),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFDC143C),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade300, // Red shadow color
                  blurRadius: 10, // Adjust the blur radius as needed
                  offset: const Offset(2, 1), // Adjust the offset as needed
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row(
                //   children: [
                //     Image.asset(
                //       'assets/logo.png', // Path to your logo image
                //       width: 50,
                //       height: 50,
                //     ),
                //     Text(
                //       "Retail Flash", // Your company name
                //       style: GoogleFonts.roboto(
                //         textStyle: const TextStyle(
                //           fontWeight: FontWeight.bold,
                //           fontSize: 20,
                //           color: Colors.black,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        return Text(
                          "Hello, ${userProvider.user?.name ?? 'Guest'}\n${getGreetingMessage()}",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC143C),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38, // Red shadow color
                            blurRadius: 10, // Adjust the blur radius as needed
                            offset: Offset(2, 1), // Adjust the offset as needed
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0),
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                        ),
                      ),
                      width: 60,
                      height: 60,
                      child: Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          var kEndpoint = "https://retailflash.up.railway.app/";
                          String imageUrl =
                              userProvider.user?.image ?? 'default_image_url';

                          return GestureDetector(
                            onTap: () => _showProfilePhoto(context, imageUrl),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: CachedNetworkImageProvider(
                                  'https://retailflash.up.railway.app/$imageUrl'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, transactionProvider, child) {
                if (transactionProvider.isLoading) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
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

                if (transactionProvider.transactions.isEmpty) {
                  return const Center(
                      child: Text("No transactions available."));
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
          ),
        ],
      ),
    );
  }

  String formatDate(String dateStr) {
    final DateTime dateTime = DateTime.parse(dateStr);
    final DateFormat formatter = DateFormat('MM/dd/yyyy HH:mm');
    return formatter.format(dateTime);
  }
}
