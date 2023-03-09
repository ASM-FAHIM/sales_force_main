import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:petronas_project/sales/constant/app_constants.dart';
import 'dart:convert';
import 'package:petronas_project/sales/databaseHelper/login_repo.dart';
import '../model/login_model.dart';
import '../model/tsolist_model.dart';
import '../view/dashboard_screen.dart';

class LoginController extends GetxController {
  Box? box1;

  //ei 3 ta value home screen a dhukar por database theke value get kore eikhane diye dicci
  RxString xposition = ''.obs;
  RxString xsid = ''.obs;
  RxString xstaff = ''.obs;

  //getTso info te ami xsp and xterritory er value set kore rakhsi
  RxString xsp = ''.obs;
  RxString xwh = ''.obs;
  RxString xterritory = ''.obs;

  //xterritory loginMethod a value save kore rakhtesi for further use
  AppConstants appConstants = AppConstants();
  RxBool isLoading1 = false.obs;
  List<TsoInfoListModel>? tsoInfoListModel;
  Future<void> loginMethod() async {
    try{
      isLoading1(true);
      DateTime now = DateTime.now();
      String month = DateFormat.M().format(now);
      String year = DateFormat.y().format(now);
      //print('http://172.20.20.69/salesforce/tsoinfo.php?xstaff=${xpreparer.value}&month_per=$month&xyear=$year');
      var response = await http.get(Uri.parse('http://${AppConstants.baseurl}/salesforce/tsoinfo.php?xstaff=${xstaff.value}&month_per=$month&xyear=$year'));
      if (response.statusCode == 404) {
        isLoading1(false);
        Get.snackbar(
            'Error',
            'Something went wrong',
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)
        );
      } else if (response.statusCode == 200) {
        tsoInfoListModel = tsoInfoListModelFromJson(response.body);
        await dropTsoInfoTable();
        (json.decode(response.body) as List).map((tsoInfoList) {
          LoginRepo().insertToTsoInfoTable(TsoInfoListModel.fromJson(tsoInfoList));
        }).toList();
        //await LoginRepo().insertToTsoInfoTable(tsoInfoModelFromJson(response.body));
        print('Tso information : $tsoInfoListModel');
        isLoading1(false);
      }
    }catch(e){
      print('There is a issue occured when tesoInfo fetching: $e');
    }
  }
  //delete tso_info table first
  Future dropTsoInfoTable() async{
    LoginRepo().deleteFromtsoInfoTable();
    print('Table deleted successfully');
  }

  //get tso info
  List tsoInfoList = [];
  Future getTsoInfo(String tsoId, String xTerritory) async{
    try{
      xsp.value = tsoId;
      xterritory.value = xTerritory;
      tsoInfoList = await LoginRepo().getTsoInfo(zID.value);
      xwh.value = tsoInfoList[0]["xwh"].toString();
      print('------XWH value from tsoInfo field  : $xwh');
      print('------Tso Information : ${tsoInfoList[0]["xname"].toString()}');
      print('------Tso Information : ${tsoInfoList[0]["xsp"].toString()}');
    }catch(error){
      print('There are some issue: $error');
    }
    Get.to(() => DashboardScreen());
  }
  
  // tsoList_fetch in loginScreen
  RxBool isFetched = false.obs;
  List<TerritoryListModel>? territoryListModel;
  Future<Object> fetchTerritoryList() async{
    try{
      isFetched(true);
      //tsoInfo for petronas http://172.20.20.69/salesforce/tso_ID.php?staff=EID-0057
      // await deleteDealerVisitTable();
      var responseTerritoryList = await http.get(Uri.parse('http://${AppConstants.baseurl}/salesforce/tso_ID.php?staff=${xstaff.value}'));
      if(responseTerritoryList.statusCode == 200){
        territoryListModel = territoryListModelFromJson(responseTerritoryList.body);
        await dropTerritoryTable();
        (json.decode(responseTerritoryList.body) as List).map((territoryList) {
          LoginRepo().insertToTerritoryTable(TerritoryListModel.fromJson(territoryList));
        }).toList();
        Get.snackbar(
            'Success',
            'Data Fetched successfully',
            backgroundColor: Colors.white,
            duration: const Duration(seconds: 1)
        );
        await loginMethod();
        isFetched(false);
        return 'Territory list fetched Successfully';
      }else{
        Get.snackbar(
            'Error',
            'Something went wrong',
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)
        );
        print('Error occurred: ${responseTerritoryList.statusCode}');
        isFetched(false);
        return 'Error in fetching data';
      }
    }catch(error){
      print('There is a issue occured when territory fetching: $error');
      isFetched(false);
      return 'Error in the method';
    }
  }

  //delete territory table first
  Future dropTerritoryTable() async{
    LoginRepo().deleteFromTerritoryTable();
    print('Table deleted successfully');
  }
/*  //delete cuc wise product first
  Future deleteDealerVisitTable() async{
    LoginRepo().deleteFromDealerVisitTable();
    print('Table deleted successfully');
  }*/

  //get territory list
  //for territory screen and go on
  RxString zID = ''.obs;
  List territoryList = [];
  RxBool territoryFetched = false.obs;
  Future getTerritory(String zid) async{
    try{
      territoryFetched(true);
      zID.value = zid;
      territoryList = await LoginRepo().getTerritoryList(zid);
      print('------Territory List : $territoryList');
      territoryFetched(false);
    }catch(error){
      territoryFetched(false);
      print('There are some issue: $error');
    }
  }

  //For obscure text
  var obscureText = true.obs;
  void toggle() {
    obscureText.value = !obscureText.value;
  }

  RxDouble curntLong = 0.0.obs;
  RxDouble curntLat = 0.0.obs;
  double? distance;
  Position? position;
  Future<void> periodicallyLocationTracking() async{
    await getGeoLocationPosition();
    await getAddressFromLatLong();
  }

  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    curntLat.value = position!.latitude;
    curntLong.value = position!.longitude;
    print('Actual position is : $position');
    print('Actual Current Latitude is : ${curntLat.value}');
    print('Actual Current Longitude is : ${curntLong.value}');
    return position!;
  }

  RxString addressInOut = ''.obs;
  Future<void> getAddressFromLatLong() async {
    List<Placemark> placeMarks =
    await placemarkFromCoordinates(position!.latitude, position!.longitude);
    curntLat.value = position!.latitude;
    curntLong.value = position!.longitude;
    Placemark place = placeMarks[1];
    addressInOut.value = '${place.name}, ${place.locality}, ${place.country}';
    print('My exact location is : $addressInOut');
  }
}