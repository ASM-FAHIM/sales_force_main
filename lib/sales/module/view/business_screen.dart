import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petronas_project/sales/module/controller/login_controller.dart';
import 'package:petronas_project/sales/module/view/tso_selection_screen.dart';
import '../../constant/colors.dart';
import '../../widget/big_text.dart';
import '../../widget/business_widget.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({Key? key}) : super(key: key);

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  LoginController loginController = Get.put(LoginController());
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
              text: 'Business',
              color: AppColor.defWhite,
              size: 25,
            ),
            actions: [
              Obx(() => IconButton(
                onPressed: () {
                  loginController.fetchTerritoryList();
                  //dashboardController.getProductInfo();
                },
                icon: loginController.isFetched.value
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.defWhite,
                      ),
                    )
                    : const Icon(
                    MdiIcons.syncIcon,
                    size: 30,
                  ),
                ),
              )
            ]
          ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BusinessWidget(
                      businessName: 'United Lube Oil Ltd.',
                      imgPath: 'assets/images/payslip.png',
                      onPressed: (){
                        Get.to(()=> TsoSelectionScreen(zid: '300210',));
                      },
                    ),
                    BusinessWidget(
                      businessName: 'UEPSL - Lube Trading',
                      imgPath: 'assets/images/payslip.png',
                      onPressed: (){
                        Get.to(() => TsoSelectionScreen(zid: '100090'));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}

