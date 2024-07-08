import 'package:flash_retail/models/product.dart';
import 'package:flash_retail/screens/succes_transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TransactionProvider with ChangeNotifier {
  List<dynamic> transactions = [];
  List<Product> products = [];
  String paymentMethod = 'EVC-PLUS';
  String phoneNumber = '';
  double totalPrice = 0.0;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setProducts(List<Product> newProducts) {
    products = newProducts;
    totalPrice =
        newProducts.fold(0, (sum, product) => sum + product.sellingPrice);
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    notifyListeners();
  }

  void setPhoneNumber(String number) {
    phoneNumber = number;
    notifyListeners();
  }

  void removeProduct(String productId) {
    products.removeWhere((product) => product.id == productId);
    totalPrice = products.fold(0, (sum, product) => sum + product.sellingPrice);
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> processCheckout(String userId, BuildContext context) async {
    if (phoneNumber.length != 9) {
      Fluttertoast.showToast(msg: "Phone number must be 9 digits long.");
      return;
    }

    setLoading(true);

    final url =
        Uri.parse('https://retailflash.up.railway.app/api/transactions');
    final headers = {'Content-Type': 'application/json'};
    print(
        ".........................................................hello world.........................................................");
    products.map((p) => {'productUid': p.id}).toList();
    final body = json.encode({
      'userCustomerId': userId,
      'productsList': products.map((p) => {'productUid': p.id}).toList(),
      'paymentMethod': paymentMethod,
      'paymentPhone': phoneNumber,
      'totalPrice': totalPrice,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final transaction = json.decode(response.body);

        // Include product details in the transaction data
        transaction['productsList'] = products
            .map((product) => {
                  'productUid': {
                    'name': product.name,
                    'image': product.image,
                    'sellingPrice': product.sellingPrice,
                  }
                })
            .toList();

        showSuccessDialog(context, transaction);
      } else {
        showErrorDialog(response.body, context);
      }
    } catch (error) {
      showErrorDialog(error.toString(), context);
    } finally {
      setLoading(false);
    }
  }

  void showSuccessDialog(
      BuildContext context, Map<String, dynamic> transaction) {
    print(
        'Transaction: $transaction'); // Print the transaction data for debugging
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Congratulations!',
      desc: 'You have successfully completed the transaction.',
      btnOkOnPress: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TransactionInfo(transaction: transaction),
          ),
        );
      },
    ).show();
  }

  void showErrorDialog(String des, BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Sorry, man...',
      desc: des,
      btnOkOnPress: () {},
    ).show();
  }

  Future<void> fetchTransactionsByUserId(String userId) async {
    setLoading(true);

    final url = Uri.parse(
        'https://retailflash.up.railway.app/api/transactions/user/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        transactions = json.decode(response.body);
      } else {
        // Handle error response
        Fluttertoast.showToast(msg: "Failed to fetch transactions.");
      }
    } catch (error) {
      // Handle network error
      Fluttertoast.showToast(msg: "Error fetching transactions: $error");
    } finally {
      setLoading(false);
    }
    notifyListeners();
  }
}
