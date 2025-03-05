class Company {

  final int idComp;
  final String name;
  final String email;
  final String country;
  final String phoneNum;
  final String city;
  final String streetAddress;

  final String locationLat;
  final String locationLong;

  Company({
      required this.idComp,
      required this.name,
      required this.email,
      required this.country,
      required this.phoneNum,
      required this.locationLat,
      required this.locationLong,
      required this.city,
      required this.streetAddress,
  });

}