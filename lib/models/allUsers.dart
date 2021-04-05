import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users {
  String id;
  String email;
  String name;
  String phone;
  double homeLatitude;
  double homeLongitude;
  double educationLatitude;
  double educationLongitude;
  double workLatitude;
  double workLongitude;

  Users(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.homeLongitude,
      this.homeLatitude,
      this.educationLongitude,
      this.educationLatitude,
      this.workLongitude,
      this.workLatitude});

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    phone = dataSnapshot.value["phone"];
    homeLongitude = dataSnapshot.value["places"]["home"]["longitude"];
    homeLatitude = dataSnapshot.value["places"]["home"]["latitude"];
    educationLongitude = dataSnapshot.value["places"]["education"]["longitude"];
    educationLatitude = dataSnapshot.value["places"]["education"]["latitude"];
    workLongitude = dataSnapshot.value["places"]["work"]["longitude"];
    workLatitude = dataSnapshot.value["places"]["work"]["latitude"];
  }
}
