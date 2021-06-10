import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

// Remove Ads
// Non consumable
const String REMOVE_ADS = 'remove_ads';

// Auto-Renewable Subscriptions
const String SUBSCRIPTION_WEEK = 'subscription_week';

// Consumable
const String COINS_SET_SMALL = 'coins_set_small';

List<String> nonConsumableProducts = [
  REMOVE_ADS,
];
List<String> consumableProducts = [
  COINS_SET_SMALL,
];
List<String> subscriptionProducts = [
  SUBSCRIPTION_WEEK,
];

class PurchaseService {
  final Set<String> _kIds = {
    ...nonConsumableProducts,
    ...consumableProducts,
    ...subscriptionProducts,
  };

  /// Is the API available on the device
  bool? _isInAppPurchasesAvailable;

  /// The In App Purchase plugin
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Check availability of In App Purchases
  void isInAppPurchasesAvailable() async {
    _isInAppPurchasesAvailable = await _iap.isAvailable();
  }

  void cancelSubscription() {
    _subscription?.cancel();
  }

  bool isConsumable(PurchaseDetails purchase) => consumableProducts.contains(purchase.productID);

  bool isSubscription(PurchaseDetails purchase) =>
      subscriptionProducts.contains(purchase.productID);

  bool isNonConsumable(PurchaseDetails purchase) =>
      nonConsumableProducts.contains(purchase.productID);

  void listenToPurchaseStream({required Function(List<PurchaseDetails>) onNewPurchases}) {
    _subscription = _iap.purchaseStream.listen((purchases) {
      onNewPurchases(purchases);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      print('listenToPurchaseStream onError error: $error');
      // handle error here.
    });
  }

  Future<List<ProductDetails>> loadProducts() async {
    final response = await _iap.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      /// Handle the error.
    }
    return response.productDetails;
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void buyPurchase(ProductDetails productDetails) {
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    if (nonConsumableProducts.contains(productDetails.id)) {
      _iap.buyConsumable(purchaseParam: purchaseParam);
    } else {
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }
}
