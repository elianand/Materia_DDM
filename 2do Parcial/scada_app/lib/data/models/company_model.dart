import 'package:cloud_firestore/cloud_firestore.dart';


class CompanyModel {

  final int idComp;
  final String name;
  final String email;
  final String country;
  final String phoneNum;
  final String city;
  final String streetAddress;

  final String locationLat;
  final String locationLong;

  CompanyModel({
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

  static CompanyModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return CompanyModel(
      idComp: data?['idComp'] ?? 0,
      name: data?['name'] ?? 0,
      email: data?['email'] ?? "",
      country: data?['country'] ?? "none",
      phoneNum: data?['phoneNum'] ?? "none",
      locationLat: data?['locationLat'] ?? "none",
      locationLong: data?['locationLong'] ?? "none",
      city: data?['city'] ?? "none",
      streetAddress: data?['streetAddress'] ?? "none",
    );
  }
}