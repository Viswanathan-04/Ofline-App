import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Model/productModel.dart';

class ProductFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ProductModel>> fetchProducts(String shopId) {
    return _firestore.collection('Shop').doc(shopId).collection('Product').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    });
  }
}

// The repository provider does not need shopId as it doesn't depend on it
final productRepositoryProvider = Provider<ProductFirebase>((ref) {
  return ProductFirebase();
});

// The product list provider requires the shopId to fetch the products
final productListProvider = StreamProvider.family<List<ProductModel>, String>((ref, shopId) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.fetchProducts(shopId);
});
