import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter_template_app/service/purchase_service.dart';
import 'package:flutter_template_app/service/service_locator.dart';

class PurchaseProvider extends ChangeNotifier {
  late PurchaseService _purchaseService;
  bool isLoading = false;
  bool isError = false;
  bool isSuccess = false;

  List<PurchaseDetails> previousPurchases = [];
  List<ProductDetails> productsForSale = [];

  PurchaseProvider() {
    _purchaseService = serviceLocator.get<PurchaseService>();
  }

  /// Set up listener in a specific screen that will always be present in the widgets tree
  void listenToPurchaseStream({
    required Function(PurchaseDetails) onSuccessPurchase,
    required Function onSuccessRestore,
  }) {
    _purchaseService.listenToPurchaseStream(onNewPurchases: (
      List<PurchaseDetails> purchasesList,
    ) async {
      for (final purchaseDetails in purchasesList) {
        await completeAndConsumePurchases(purchaseDetails);

        if (purchaseDetails.status == PurchaseStatus.pending) {
          setLoadingState();
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
            // show error
            isError = true;
            isSuccess = false;
            setNormalState();
          } else if (purchaseDetails.status == PurchaseStatus.purchased) {
            // show success message and deliver the product.
            previousPurchases.add(purchaseDetails);
            onSuccessPurchase(purchaseDetails);
          } else if (purchaseDetails.status == PurchaseStatus.restored) {
            // todo: verify restored purchase with the backend first
            // todo: replace with the real value from backend
            final isVerified = true;
            if (isVerified) {
              onSuccessRestore();
            }
          }
          isError = false;
          isSuccess = true;
          setNormalState();
        }
      }
    });
  }

  Future<void> loadProductsForSale() async {
    productsForSale = await _purchaseService.loadProducts();
  }

  Future<void> restorePurchases() async {
    await _purchaseService.restorePurchases();
  }

  void makeSubscriptionWeekPurchase() {
    final productDetails = productsForSale.firstWhereOrNull((p) => p.id == SUBSCRIPTION_WEEK);
    _makePurchase(productDetails);
  }

  void makeRemoveAdsPurchase() {
    final productDetails = productsForSale.firstWhereOrNull((p) => p.id == REMOVE_ADS);
    _makePurchase(productDetails);
  }

  void _makePurchase(ProductDetails? productDetails) {
    print('makeFinderBundlePurchase: ${productDetails?.id}');
    if (productDetails != null) {
      return _purchaseService.buyPurchase(productDetails);
    }
  }

  void cancelSubscription() {
    _purchaseService.cancelSubscription();
  }

  Future<void> completeAndConsumePurchases(PurchaseDetails purchaseDetails) async {
    if (Platform.isAndroid) {
      if (isConsumable(purchaseDetails)) {
        final androidAddition =
            InAppPurchase.instance.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        await androidAddition.consumePurchase(purchaseDetails);
      }
    }
    if (purchaseDetails.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    }
  }

  bool isConsumable(PurchaseDetails purchase) => _purchaseService.isConsumable(purchase);

  bool isNonConsumable(PurchaseDetails purchase) => _purchaseService.isNonConsumable(purchase);

  bool isSubscription(PurchaseDetails purchase) => _purchaseService.isSubscription(purchase);

  void setLoadingState() {
    isLoading = true;
    notifyListeners();
  }

  void setNormalState() {
    isLoading = false;
    notifyListeners();
  }
}
