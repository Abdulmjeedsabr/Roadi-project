import 'dart:convert';
import 'package:flutter/material.dart';

//model for users
class UserModel {
  String? id;
  String? username;
  String? email;
  String? date;
  bool? isVerfied = false;
  String? image;

  UserModel({
    this.username,
    this.email,
    this.date,
    this.isVerfied,
    this.image,
  });

  UserModel.withId({
    this.id,
    this.username,
    this.email,
    this.date,
    this.isVerfied,
    this.image,
  });

//convert text to map to be stored
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['date'] = date;
    map['isVerfied'] = isVerfied;
    map['image'] = image;
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel.withId(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      date: map['date'],
      isVerfied: map['isVerfied'],
      image: map['image'],
    );
  }
}
