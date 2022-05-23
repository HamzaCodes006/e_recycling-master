import 'package:e_recycling/model/package_modal.dart';
import 'package:flutter/material.dart';

class PackagesProvider extends ChangeNotifier {
  String _descp = "";
  String _name = "";
  double _price = 0.0;
  int _valid_for = 30;

  String get descp => _descp;
  String get name => _name;
  double get price => _price;
  int get valid_for => _valid_for;

  List<Packages> li = [
    Packages(
        '2 Day package',
        700,
        30,
        'Included Things are'
            '1) upto 15 kg of disposal'
            '2) 40% less than normal Cost'
            '3) Dont need to weight everything',
        'images/2_days.jpg'),
    Packages(
        '3 Day package',
        500,
        30,
        'Included Things are'
            '1) upto 30 kg of disposal'
            '2) 30% less than normal Cost'
            '3) Dont need to weight everything',
        'images/3_days.jpg'),
    Packages(
        '5 Day package',
        400,
        30,
        'Included Things are'
            '1) upto 50 kg of disposal'
            '2) 20% less than normal Cost'
            '3) Dont need to weight everything',
        'images/5_days.jpg'),
    Packages(
        '7 Day package',
        300,
        30,
        'Included Things are'
            '1) upto 50 kg of disposal'
            '2) 20% less than normal Cost'
            '3) Dont need to weight everything',
        'images/7_days.png'),
  ];
}
