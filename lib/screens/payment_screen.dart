import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  final String? total;
  final String? uids;

  const PaymentsScreen({Key? key, this.total, this.uids}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text('Choose Payment Method:',
                style: TextStyle(fontSize: 18, color: Color(0xFFDC143C))),
            const SizedBox(height: 20),
            PaymentMethodChooser(), // Interactive payment method chooser
            const SizedBox(height: 20),

            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                prefixText: '+252 ', // Fixed country code
              ),
              keyboardType: TextInputType.number, // Set keyboard type to number
              // readOnly: true,
            ),
            const SizedBox(height: 30),
            Text('Total Price: $total',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement payment logic here
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15.0),
                    backgroundColor: Color(0xFFDC143C),
                  ),
                  child: const Text('Confirm Payment',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodChooser extends StatefulWidget {
  @override
  _PaymentMethodChooserState createState() => _PaymentMethodChooserState();
}

class _PaymentMethodChooserState extends State<PaymentMethodChooser> {
  String selectedMethod = 'EVC-PLUS';

  void selectMethod(String method) {
    setState(() {
      selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        PaymentMethodButton(
          imageAsset: 'assets/EVC-PLUS.png',
          label: 'EvcPLUS Service',
          selected: selectedMethod == 'EVC-PLUS',
          onSelect: () => selectMethod('EVC-PLUS'),
        ),
        PaymentMethodButton(
          imageAsset: 'assets/premier.png',
          label: 'Premier Wallet',
          selected: selectedMethod == 'Premier Wallet',
          onSelect: () => selectMethod('Premier Wallet'),
        ),
      ],
    );
  }
}

class PaymentMethodButton extends StatelessWidget {
  final String imageAsset;
  final String label;
  final bool selected;
  final VoidCallback onSelect;

  const PaymentMethodButton({
    Key? key,
    required this.imageAsset,
    required this.label,
    required this.selected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.transparent, // Change background color on selection
          borderRadius:
              BorderRadius.circular(5), // Rounded corners for a better UI
          boxShadow: [
            BoxShadow(
              color: selected
                  ? Colors.blue
                  : Colors.transparent, // Blue shadow color
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Image.asset(imageAsset, width: 50, height: 50),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black)), // Change text color on selection
          ],
        ),
      ),
    );
  }
}
