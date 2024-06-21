import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../screens/ShopScreen/shops/Model/shopModel.dart';




final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) => LocationNotifier());

class LocationState {
  double? latUser;
  double? longUser;
  String address;
  double? latMerchant;
  double? longMerchant;
  double distanceInMeters;
  String? distance;

  LocationState({
    this.latUser,
    this.longUser,
    this.address = "",
    this.latMerchant,
    this.longMerchant,
    this.distanceInMeters = 0,
    this.distance,
  });

  LocationState copyWith({
    double? latUser,
    double? longUser,
    String? address,
    double? latMerchant,
    double? longMerchant,
    double? distanceInMeters,
    String? distance,
  }) {
    return LocationState(
      latUser: latUser ?? this.latUser,
      longUser: longUser ?? this.longUser,
      address: address ?? this.address,
      latMerchant: latMerchant ?? this.latMerchant,
      longMerchant: longMerchant ?? this.longMerchant,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
      distance: distance ?? this.distance,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  void setMerchantLocation(ShopModel shop) {
    state = state.copyWith(
      latMerchant: shop.latitude,
      longMerchant: shop.longitude,
    );
  }

  Future<void> getLatLong() async {
    final Position position = await determinePosition();

    double? distanceInMeters;
    String? distanceInKm;

    if (state.latMerchant != null && state.longMerchant != null) {
      distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        state.latMerchant!,
        state.longMerchant!,
      );
      distanceInKm = (distanceInMeters / 1000).toStringAsFixed(1);

      // int distanceInM = distanceInMeters.round();

    }

    state = state.copyWith(
      latUser: position.latitude,
      longUser: position.longitude,
      distanceInMeters: distanceInMeters,
      distance: distanceInKm.toString(),
    );

    _getAddress(position.latitude, position.longitude);
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }

  Future<void> _getAddress(double lat, double long) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    if (placemarks.isNotEmpty) {
      state = state.copyWith(address: placemarks[0].subLocality ?? "");
    }
  }
}
