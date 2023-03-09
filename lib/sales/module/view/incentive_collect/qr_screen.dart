import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petronas_project/sales/module/controller/qr_controller.dart';
import '../../../constant/colors.dart';
import '../../../constant/dimensions.dart';
import '../../../widget/big_text.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  QrController qrController = Get.put(QrController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qrController.scanQRCode();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.appBarColor,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_outlined,
                size: 25,
              ),
            ),
            title: BigText(
              text: 'Qr Scanner',
              color: AppColor.defWhite,
              size: 25,
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(MdiIcons.syncIcon, size: 30,),)
            // ],
          ),
          body: Obx(() =>
            qrController.isDataFetched.value
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(color: AppColor.appBarColor,),
                  ),
                  Text('Loading...'),
                ],
              ),
            )
            : Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Generated Code: ${qrController.qrScannedCode}'),
                  Text('SKU : ${qrController.sku}'),
                  Text('Batch: ${qrController.batch}'),
                  Container(
                    height: Dimensions.height50,
                    width:  Dimensions.height150 - Dimensions.height20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey, //New
                              blurRadius: 5,
                              offset: Offset(0, 0)
                          )
                        ]
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.appBarColor,
                      ),
                      onPressed: () async{
                        qrController.totalValueCalculate();
                      },
                      child: BigText(text: 'Ok', color: AppColor.defWhite,),
                    ),
                  ),
                ],
              ),
            )
          ),
        )
    );
  }
}
