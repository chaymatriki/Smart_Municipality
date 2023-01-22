// To parse this JSON data, do
//
//     final fraudModel = fraudModelFromJson(jsonString);

import 'dart:convert';

List<FraudModel> fraudModelFromJson(String str) => List<FraudModel>.from(json.decode(str).map((x) => FraudModel.fromJson(x)));

String fraudModelToJson(List<FraudModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FraudModel {
  FraudModel({
    this.id,
    this.title,
    this.body,
    this.location,
    this.photo,
    this.postedBy,
    this.date,
    this.v,
  });

  String id;
  String title;
  String body;
  Location location;
  String photo;
  PostedBy postedBy;
  String date;
  int v;

  factory FraudModel.fromJson(Map<String, dynamic> json) => FraudModel(
    id: json["_id"],
    title: json["title"],
    body: json["body"],
    location: Location.fromJson(json["location"]),
    photo: json["photo"],
    postedBy: PostedBy.fromJson(json["postedBy"]),
    date: json["date"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "body": body,
    "location": location.toJson(),
    "photo": photo,
    "postedBy": postedBy.toJson(),
    "date": date,
    "__v": v,
  };
}

class Location {
  Location({
    this.type,
    this.address,
    this.latitude,
    this.longitude,
  });

  String type;
  String address;
  String latitude;
  String longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
  };
}

class PostedBy {
  PostedBy({
    this.id,
    this.lastName,
    this.firstName,
  });

  String id;
  String lastName;
  String firstName;

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
    id: json["_id"],
    lastName: json["lastName"],
    firstName: json["firstName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "lastName": lastName,
    "firstName": firstName,
  };
}
