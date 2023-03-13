import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petronas_project/sales/module/controller/qr_controller.dart';
import 'package:petronas_project/sales/module/view/incentive_collect/qr_screen.dart';
import '../../../constant/colors.dart';
import '../../../constant/dimensions.dart';
import '../../../widget/big_text.dart';
import '../../../widget/small_text.dart';

class IncentiveScreen extends StatefulWidget {
  String xcus;
  IncentiveScreen({required this. xcus,Key? key}) : super(key: key);

  @override
  State<IncentiveScreen> createState() => _IncentiveScreenState();
}

class _IncentiveScreenState extends State<IncentiveScreen> {
  QrController qrController = Get.put(QrController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qrController.fetchMechanicList(widget.xcus);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.appBarColor,
            leading: GestureDetector(
              onTap: () {
                qrController.resetMechanicList();
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_outlined,
                size: 25,
              ),
            ),
            title: BigText(
              text: 'Incentive',
              color: AppColor.defWhite,
              size: 25,
            ),
            /*actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(MdiIcons.syncIcon, size: 30,),)
            ],*/
          ),
          body: Obx(() =>
          qrController.isLoading.value
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
              : ListView.builder(
              itemCount: qrController.mechanicList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: Dimensions.height50 + Dimensions.height20,
                    child: ListTile(
                      onTap: () {
                        Get.to(() =>QrScreen(
                            xSid: qrController.mechanicList[index].xid,
                            xCus: widget.xcus,
                            tsoId: qrController.mechanicList[index].xtso,
                            mobileNum: qrController.mechanicList[index].xmobile,
                        ));
                      },
                      tileColor: AppColor.appBarColor,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(
                            text: qrController.mechanicList[index].xnamem,
                            size: 20,
                            color:
                            AppColor.defWhite,
                          )
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmallText(text: qrController.mechanicList[index].xmobile, color: AppColor.defWhite, size: 15,),
                          SmallText(text: qrController.mechanicList[index].xid, color: AppColor.defWhite),
                        ],
                      ),
                    ),
                  ),
                );
              })
          ),
        )
    );
  }
}
