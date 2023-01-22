
class Location {

  final String address;
  final double latitude, longitude;
  Location({
    this.address,
    this.latitude,
    this.longitude,
  });

  @override
  String toString() {
    print("address :"+ this.address + "latitude"+ this.latitude.toString() + "longitude" + this.longitude.toString());
  }
}


