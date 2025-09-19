// This is a placeholder for Google Play Billing / iOS in_app_purchase setup.
// In production, use the `in_app_purchase` Flutter package.

import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  final InAppPurchase _iap = InAppPurchase.instance;

  Future<void> initStoreInfo() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;

    const Set<String> ids = {"premium_monthly", "premium_yearly"};
    final ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle missing products
    }
  }

  void buy(ProductDetails productDetails) {
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }
}
