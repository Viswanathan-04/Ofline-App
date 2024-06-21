import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Model/shopModel.dart';


class ShopFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream <List<ShopModel>> fetchShops()  {
   return _firestore.collection('Shop').snapshots().map((snapshop){
     return snapshop.docs.map((doc)=> ShopModel.fromFirestore(doc)).toList();
   });
  }
}


final shopRepositoryProvider = Provider<ShopFirebase>((ref) {
  return ShopFirebase();
});

final shopListProvider = StreamProvider<List<ShopModel>>((ref)  {
  final shopRepository = ref.watch(shopRepositoryProvider);
  return shopRepository.fetchShops();
});