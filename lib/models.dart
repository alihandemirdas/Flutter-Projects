import 'package:flutter/material.dart';
import 'dart:convert';

class WeatherResponse {
  final String cityName;
  final double sifir, bir, iki, uc;

  WeatherResponse({required this.cityName, required this.sifir, required this.bir, required this.iki, required this.uc});

  factory WeatherResponse.fromJson(Map<String, dynamic> json){
    final cityName = json['city']['name'];
    final sifir = json['list'][0]['main']['temp'];
    final bir = json['list'][10]['main']['temp'];
    final iki = json['list'][20]['main']['temp'];
    final uc = json['list'][30]['main']['temp'];
    return WeatherResponse(cityName: cityName, sifir:sifir, bir: bir, iki:iki, uc:uc);
  }

}