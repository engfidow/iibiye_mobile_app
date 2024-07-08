import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_retail/providers/transaction_provider.dart';
import 'package:flash_retail/providers/user_provider.dart';
import 'package:flash_retail/providers/product_provider.dart';
import 'package:flash_retail/models/product.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shimmer/shimmer.dart';

class PaymentsScreen extends StatefulWidget {
  final String? total;
  final List<String> uids;

  const PaymentsScreen({Key? key, this.total, required this.uids})
      : super(key: key);

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String _userId = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = context.read<UserProvider>();
      setState(() {
        _userId = userProvider.user?.id ?? "";
      });

      // Fetch product details
      final productProvider = context.read<ProductProvider>();
      await productProvider.fetchProducts(widget.uids);

      if (productProvider.products.isNotEmpty) {
        final transactionProvider = context.read<TransactionProvider>();
        transactionProvider.setProducts(productProvider.products);
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Failed to load products. Please try again.',
          btnOkOnPress: () {},
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
      ],
      child: Scaffold(
        backgroundColor: Color(0xFFF6F7FB),
        appBar: AppBar(
          title: const Text('Payment'),
          backgroundColor: Colors.white,
        ),
        body: Consumer2<TransactionProvider, ProductProvider>(
          builder: (context, transactionProvider, productProvider, child) {
            if (productProvider.isLoading) {
              return Column(
                children: [
                  Expanded(child: ShimmerLoadingList()),
                  _buildTotalSection(context, transactionProvider,
                      isLoading: true),
                ],
              );
            }
            return Stack(
              children: [
                Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 20),
                              const Text('Choose Payment Method:',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xFFDC143C))),
                              const SizedBox(height: 20),
                              PaymentMethodChooser(),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  label: const Text('Phone Number'),
                                  hintText: 'Enter your phone number',
                                  hintStyle:
                                      const TextStyle(color: Colors.black26),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixText: '+252 ',
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 15.0),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  transactionProvider.setPhoneNumber(value);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a phone number';
                                  } else if (value.length < 6) {
                                    return 'Phone number must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              ...transactionProvider.products
                                  .map((product) =>
                                      ProductCard(product: product))
                                  .toList(),
                              const SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildTotalSection(context, transactionProvider),
                  ],
                ),
                if (transactionProvider.isLoading)
                  Center(
                    child: SpinKitCircle(
                      color: Colors.red,
                      size: 50.0,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTotalSection(
      BuildContext context, TransactionProvider transactionProvider,
      {bool isLoading = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sub-Total'),
              isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 50,
                        height: 10.0,
                        color: Colors.white,
                      ),
                    )
                  : Text('${transactionProvider.totalPrice}'),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Cost',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 50,
                        height: 10.0,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      '${transactionProvider.totalPrice}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        transactionProvider.setLoading(true);
                      });
                      await transactionProvider.processCheckout(
                          _userId, context);
                      setState(() {
                        transactionProvider.setLoading(false);
                      });
                    }
                  },
            child: transactionProvider.isLoading
                ? SpinKitCircle(
                    color: Colors.white,
                    size: 25.0,
                  )
                : Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerLoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    Container(
                      width: double.infinity,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    Container(
                      width: 40.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productName = product.name;
    final maxLength = 10; // Set the desired maximum length
    String shortenedName = productName.length > maxLength
        ? productName.substring(0, maxLength) + '...'
        : productName;

    return Dismissible(
      key: Key(product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<TransactionProvider>(context, listen: false)
            .removeProduct(product.id);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 0,
        color: Colors.white,
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: "https://retailflash.up.railway.app/${product.image}",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(shortenedName),
          subtitle: Text('Price: \$${product.sellingPrice}'),
        ),
      ),
    );
  }
}

class PaymentMethodChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        PaymentMethodButton(
          imageAsset: 'assets/EVC-PLUS.png',
          label: 'EvcPLUS Service',
          selected: provider.paymentMethod == 'EVC-PLUS',
          onSelect: () {
            provider.setPaymentMethod('EVC-PLUS');
          },
        ),
        PaymentMethodButton(
          imageAsset: 'assets/premier.png',
          label: 'Premier Wallet',
          selected: provider.paymentMethod == 'Premier Wallet',
          onSelect: () {
            provider.setPaymentMethod('Premier Wallet');
          },
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
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Image.asset(imageAsset, width: 50, height: 50),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ), // Change text color on selection
          ],
        ),
      ),
    );
  }
}
