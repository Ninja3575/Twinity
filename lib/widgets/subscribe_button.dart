import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscribeButton extends StatefulWidget {
  const SubscribeButton({super.key});

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  bool _isAvailable = false;
  bool _loading = true;
  List<ProductDetails> _products = const [];

  static const String _kSubId = 'premium_subscription';

  @override
  void initState() {
    super.initState();
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(_onPurchaseUpdated, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {});
    _initStoreInfo();
  }

  Future<void> _initStoreInfo() async {
    final bool isAvailable = await _iap.isAvailable();
    setState(() => _isAvailable = isAvailable);
    if (!isAvailable) {
      setState(() => _loading = false);
      return;
    }
    const Set<String> ids = {_kSubId};
    final ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    setState(() {
      _products = response.productDetails;
      _loading = false;
    });
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();
    if (!_isAvailable) return const Text('Store not available');
    final ProductDetails? sub = _products.isNotEmpty ? _products.first : null;
    return ElevatedButton(
      onPressed: sub == null
          ? null
          : () async {
              final PurchaseParam purchaseParam = PurchaseParam(productDetails: sub);
              await _iap.buyNonConsumable(purchaseParam: purchaseParam);
            },
      child: Text(sub?.title ?? 'Subscribe'),
    );
  }
}


