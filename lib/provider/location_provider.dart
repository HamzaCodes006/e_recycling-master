import 'package:e_recycling/user/choose_glass.dart';
import 'package:e_recycling/user/choose_metal.dart';
import 'package:e_recycling/user/choose_mix.dart';
import 'package:e_recycling/user/choose_organic.dart';
import 'package:e_recycling/user/choose_paper.dart';
import 'package:e_recycling/user/choose_plastic.dart';
import 'package:e_recycling/user/choose_swimming_pool_water.dart';
import 'package:flutter/material.dart';

class LocationProvider extends ChangeNotifier{

 String _class_name="";

 String get class_name=>_class_name;

 getClassName(String class_name){
   _class_name=class_name;
   notifyListeners();



 }
 navToClassName(BuildContext context){
   if(_class_name=="Plastic"){
     return ChoosePlasticAndCalculate();
   }

   if(_class_name=="Metal"){
     return ChooseMetalAndCalculate();
   }
   if(_class_name=="Paper"){
   return ChoosePaperAndCalculate();
   }
   if(_class_name=="Glass"){
 return ChooseGlassAndCalculate();
   }
   if(_class_name=="Organic"){
     return ChooseOrganicAndCalculate();
   }
   if(_class_name=="Swimming Pool"){
     return ChooseSwimmingPoolWater();
   }
   if(_class_name=="Mix"){
     return ChooseMix();
   }
 }


}