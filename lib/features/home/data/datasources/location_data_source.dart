abstract class LocationDataSource {
  Future<String> getCurrentLocation();
}

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<String> getCurrentLocation() async {
    // Simulate getting location
    await Future.delayed(const Duration(seconds: 1));

    // Return mock location
    return "Jakarta, Indonesia (-6.2088, 106.8456)";
  }
}
