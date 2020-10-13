import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class GeoService {
  /**
   * Get Latitude and Longitude with Geolocator
   * Get Address with GeoCoder
   */
  Future<String> getPos() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Coordinates coord = new Coordinates(position.latitude, position.longitude);
    var adress = await Geocoder.local.findAddressesFromCoordinates(coord);
    var first = adress.first;
    String value = first.addressLine;
    return value;
  }
}
