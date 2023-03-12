import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:petronas_project/sales/constant/app_constants.dart';
import '../model/dealer_model.dart';
import '../model/mechanic_list_model.dart';
import '../model/qr_return_model.dart';

class QrController extends GetxController {
  RxString qrScannedCode = ''.obs;
  RxString firstChar = ' '.obs;
  RxString sku = ' '.obs;
  RxString batch = ' '.obs;
  RxDouble result = 0.0.obs;

/*  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }*/
  var isLoading = true.obs;
  List<MechanicModel> mechanicList = [];
  Future fetchMechanicList() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse("http://${AppConstants.baseurl}/salesforce/scanner/machanic_list.php?tso=2665"));
      mechanicList = mechanicModelFromJson(response.body);
      print('MechanicList = $mechanicList');
    } finally {
      isLoading(false);
    }
  }

  RxBool isDataFetched = false.obs;
  QrReturnModel? qrValues;
  Future<void> scanQRCode() async {
    try {
      isDataFetched(true);
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      // qrScannedCode.value = qrCode;
      // firstChar.value = qrCode[0];
      var response = await http.get(Uri.parse("http://${AppConstants.baseurl}/salesforce/scanner/QRcodeCheck.php?code=$qrCode"));
      if(response.statusCode == 200){
        qrValues = qrReturnModelFromJson(response.body);
        qrScannedCode.value = qrValues!.code;
        firstChar.value = qrCode[0];
        sku.value = qrValues!.squ;
        batch.value = qrValues!.batch;
        isDataFetched(false);
        print('=================${qrValues!.code} =================');
      }else{
        qrScannedCode.value = 'Product already Scanned';
        Get.snackbar(
            'Error',
            'Product already scanned',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 1)
        );
        isDataFetched(false);
      }
    } on PlatformException {
      qrScannedCode.value = 'Failed to get platform version.';
    }
  }


  // for calculate total value
  Future totalValueCalculate() async{
    print('=================${qrScannedCode.value} =================');
    print('=================${firstChar.value}=================');
    if(firstChar.value == 'A'){
      result.value = 1 * double.parse(sku.value);
      print('-----------------$result----------');
    }else if(firstChar.value == 'B'){
      result.value  = 5 * double.parse(sku.value);
      print('-----------------$result----------');
    }else if(firstChar.value == 'C'){
      result.value  = 10 * double.parse(sku.value);
      print('-----------------$result----------');
    }else if(firstChar.value == 'D'){
      result.value  = 18 * double.parse(sku.value);

      print('-----------------$result----------');
    }else if(firstChar.value == 'E'){
      result.value  = 30 * double.parse(sku.value);
      print('-----------------$result----------');
    }else{
      Get.snackbar('title', 'message');
    }
    var response = await http.post(Uri.parse('http://${AppConstants.baseurl}/salesforce/scanner/QR_submit.php'),
        body: jsonEncode(<String, dynamic>{
          "code": qrScannedCode.value,
          "user": "2665",
          "tso_bp_name": "K. M. Zohir Rayhan",
          "machanic_bkash": "8801742090667",
          "batch": batch.value,
          "tso_bp_id": result.toString(),
          "area": "Dhaka 4",
          "territory": "DHK-08",
          "dealer_name": "Babu Engineering Works",
        })
    );
    print('------------${response.body}');
  }


  //Dealer list fetching for mechanic and qr scanner
  ///dealer fetch and insert to local db
  RxBool isLoading1 = false.obs;
  final dealerList = <DealerModel>[].obs;
  void getDealerInfo(String xsp) async{
    try{
      isLoading1(true);
      //new dealer api for petronas http://${AppConstants.baseurl}/salesforce/dealerinfo.php?user=1000
      var response = await http.get(Uri.parse('http://${AppConstants.baseurl}/salesforce/dealerinfo.php?xsp=$xsp'));
      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final dealers = <DealerModel>[];
        for(var dealersList in jsonData){
          dealers.add(DealerModel.fromJson(dealersList));
        }
        dealerList.assignAll(dealers);
        isLoading1(false);
        print('List of Dealers: $dealers');
      }else{
        isLoading1(false);
        print("There is an Error ${response.statusCode}");
      }
    }catch(e){
      print("Something went wrong $e");
    }
  }

  /*RxBool isNameFound = false.obs;
  List foundedDealerList = [];
  // RxBool enableDealerList = false.obs;
  void runFilter(String keyword) async{
    try{
      isNameFound(true);
      List result = [];
      if(keyword.isEmpty){
        result = dealerList;
        print('====================================0000000000000000000000000$result');
        isNameFound(false);
      }else{
        result = dealerList.where((name) => name.xorg.toLowerCase().contains(keyword.toLowerCase())).toList();
        isNameFound(false);
        print('Actual list : $result');
      }
      foundedDealerList = result;
      print('Founded Dealer List: $foundedDealerList');
      isNameFound(false);
    }catch(e){
      isNameFound(false);
      print('Error Occured: $e');
    }
  }*/
  RxString searchQuery = ''.obs;
  List<DealerModel> get filteredDeals {
    if (searchQuery.value.isEmpty) {
      return dealerList;
    } else {
      return dealerList.where((dealer) =>
          dealer.xorg.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }
  }

  void search(String query) {
    searchQuery.value = query;
  }
}