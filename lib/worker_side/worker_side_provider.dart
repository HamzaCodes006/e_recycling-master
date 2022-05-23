import 'package:e_recycling/worker_side/History.dart';
import 'package:e_recycling/worker_side/HomeScreen.dart';
import 'package:e_recycling/worker_side/requests.dart';
import 'package:e_recycling/worker_side/worker_profile.dart';
import 'package:flutter/material.dart';


class WorkerSideProvider extends ChangeNotifier{
  int _selectedIndex = 0;
  int _previousindex=0;

  double _user_lat=0;
  double _user_long=0;
  double _worker_lat=0;
  double _worker_long=0;
  String _worker_name="";
  String _worker_img="";
  String get worker_img=>_worker_img;
  String get worker_name=>_worker_name;

  setWorkerImg(String image){
    _worker_img=image;
    print("worker image in providerrrrr isssssssssssss $_worker_img");
    notifyListeners();
  }

  setWorkerName(String name){
    _worker_name=name;
    notifyListeners();
  }

  String _userId="";
  String get userId=>_userId;

  setUserId(String id){
    _userId=id;
    notifyListeners();
  }

  String _document_id="";

  String get document_id=>_document_id;

  setDocumentId(String id){
    _document_id=id;
    notifyListeners();
  }

  double get worker_lat=>_worker_lat;
  double get worker_long=>_worker_long;

  double get userLat=>_user_lat;
  double get userLong=>_user_long;

  setWorkerLoc(double lat,double lon){
    _worker_lat=lat;
    _worker_long=lon;
    notifyListeners();
  }

  getLoc(String lat,String lon){
    _user_lat=double.parse(lat);
    _user_long=double.parse(lon);
    notifyListeners();
  }

  double _price=0;

  int _distance=0;

  int get distance=>_distance;

  updateDistance(int distance){
    _distance=distance;
    notifyListeners();
  }

  double get price=>_price;

  updatePrice(double price){
    _price=price;
    notifyListeners();
  }

  var _color=Colors.grey;

  int get selectedIndex=>_selectedIndex;

  int get previousIndex=>_previousindex;


  Color get colorss=>_color;



  onItemTapped(int index) {
    //_previousindex=_selectedIndex;

      _selectedIndex = index;
      _color=Colors.lightGreen;
      notifyListeners();

  }
  navTo(BuildContext context){

    if(_selectedIndex==0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkerHomePage()),
      );

    }
    if(_selectedIndex==1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Requests()),
      );
    }
    if(_selectedIndex==2){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => History()),
      );
    }
    if(_selectedIndex==3){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkerProfile()),
      );
    }
  }
  navBack(BuildContext context) {
   _selectedIndex=0;

     Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => WorkerHomePage()),
     );



    notifyListeners();
  }



}