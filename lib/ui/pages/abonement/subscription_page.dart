import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart'; // Pour les achats in-app

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializePurchase();
  }

  // Initialiser les achats intégrés et charger les produits disponibles
  Future<void> _initializePurchase() async {
    final isAvailable = await _iap.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
    });
    if (_isAvailable) {
      const Set<String> _kIds = <String>{
        'monthly_subscription'
      }; // ID produit dans votre store
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        // Gérer le cas où certains produits ne sont pas trouvés
      }
      setState(() {
        _products = response.productDetails;
        _loading = false;
      });
    }
  }

  // Effectuer l'achat d'un abonnement
  void _buySubscription(ProductDetails productDetails) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abonnement Premium'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _headerSection(),
                _benefitsSection(),
                _products.isNotEmpty ? _subscriptionOptions() : _errorSection(),
              ],
            ),
    );
  }

  // Header avec titre et description
  Widget _headerSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: const [
          Text(
            'Passez à Premium',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Supprimez les publicités et accédez à des fonctionnalités illimitées en vous abonnant maintenant.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Section montrant les avantages de l'abonnement
  Widget _benefitsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.remove_circle_outline),
            title: Text('Supprimez toutes les publicités'),
          ),
          const ListTile(
            leading: Icon(Icons.lock_open),
            title: Text('Accédez à des fonctionnalités illimitées'),
          ),
          const ListTile(
            leading: Icon(Icons.update),
            title: Text('Renouvellement automatique chaque mois'),
          ),
        ],
      ),
    );
  }

  // Section pour les options d'abonnement
  Widget _subscriptionOptions() {
    return Expanded(
      child: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product.title),
            subtitle: Text(product.description),
            trailing: Text(product.price),
            onTap: () {
              _buySubscription(product);
            },
          );
        },
      ),
    );
  }

  // Section en cas d'erreur de chargement des produits
  Widget _errorSection() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Erreur lors du chargement des options d\'abonnement.',
          style: TextStyle(fontSize: 16, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}