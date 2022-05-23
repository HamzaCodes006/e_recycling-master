import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CalDistance{
  double totalDist=1;
  double calculateDistance(double lat1,double lon1){
    double lat2=33.8677;
    double lon2=72.433;
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    totalDist=12742* asin(sqrt(a));


    return   totalDist;
  }
}

