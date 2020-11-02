import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class GeoService {
  /// Get Latitude and Longitude with Geolocator
  /// Get Address with GeoCoder
  Future<String> getPos() async {
    final Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final Coordinates coord = Coordinates(position.latitude, position.longitude);
    final List<Address> adress = await Geocoder.local.findAddressesFromCoordinates(coord);
    final Address first = adress.first;
    final String value = first.addressLine;
    return value;
  }
}
