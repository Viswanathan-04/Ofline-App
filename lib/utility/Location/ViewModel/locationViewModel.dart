import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../screens/ShopScreen/shops/ViewModel/shopViewModel.dart';
import '../Model/locationModel.dart';

Future<void> fetchShopAndUpdateLocation(String shopId, WidgetRef ref) async {
  // Fetch the list of shops
  final shopList = await ref.watch(shopListProvider.future);

  // Select a specific shop (for example, the first shop)
  // You might need to implement a proper selection mechanism based on your use case
  final selectedShop = shopList.firstWhere((shop) => shop.id == shopId);

  // Update the LocationNotifier with the selected shop's location
  final locationNotifier = ref.read(locationProvider.notifier);
  locationNotifier.setMerchantLocation(selectedShop);

  // Get the user's location and calculate the distance
  await locationNotifier.getLatLong();
}
