import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';


class User {
  final String accessToken;
  final String refreshToken;

  const User({required this.accessToken, required this.refreshToken});

  factory User.fromJson(Map<String, dynamic> json) {

    return User(
      accessToken: json['body']['AccessToken'],
      refreshToken: json['body']['RefreshToken']
    );
  }
}