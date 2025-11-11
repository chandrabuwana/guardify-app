// ignore_for_file: uri_does_not_exist, undefined_class, undefined_identifier
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocationService {
  Future<bool> _ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return false;
    }
    return true;
  }

  Future<({double lat, double lng})?> getCurrentLatLng() async {
    final ok = await _ensurePermission();
    if (!ok) return null;
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    return (lat: pos.latitude, lng: pos.longitude);
  }
}

