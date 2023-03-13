import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petronas_project/sales/module/view/incentive_collect/dealer_list.dart';
import 'package:petronas_project/sales/module/view/incentive_collect/incentive_screen.dart';
import 'package:petronas_project/sales/widget/small_text.dart';
import '../../screen/login_page.dart';
import '../constant/colors.dart';
import '../constant/dimensions.dart';
import '../module/controller/login_controller.dart';
import '../module/view/dashboard_screen.dart';
import '../module/view/gift_promo_screen.dart';
import '../module/view/history/order_history_screen.dart';
import '../module/view/notification_screen.dart';
import '../module/view/order_process/order_process_screen.dart';
import '../module/view/work_note_screen.dart';
import 'big_text.dart';
import 'custom_back.dart';

class CusDrawer extends StatelessWidget {
  CusDrawer({
    Key? key,
  }) : super(key: key);

  LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          //personal info
          Container(
            width: _width,
            height: _height / 3.3,
            decoration: const BoxDecoration(
              color: AppColor.appBarColor
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ///backButton
                    CustomDrawerCloseButton(),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          'assets/images/user.png',
                        ),
                        radius: Dimensions.radius30 + Dimensions.radius20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BigText(text: '${loginController.tsoInfoList[0]["xname"].toString()}', color: Colors.white,),
                      SmallText(text: '${loginController.tsoInfoList[0]["xsp"].toString()}', color: Colors.white,),
                    ],
                  ),
                )
              ],
            ),
          ),

          ///List of screens
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                        onTap: () {
                          Get.back();
                          Get.back();
                          Get.back();
                        },
                        leading: const Icon(
                          MdiIcons.home,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'Home', size: 20,),
                      ),
                      const CusDivider(),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                        onTap: () {
                          Get.back();
                          Get.to(() => DashboardScreen());
                        },
                        leading: const Icon(
                          MdiIcons.monitorDashboard,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'Dashboard', size: 20,),
                      ),
                      const CusDivider(),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                        onTap: () {
                          Get.back();
                          Get.to(() => OrderScreen());
                        },
                        leading: const Icon(
                          MdiIcons.orderAlphabeticalAscending,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'Order Process', size: 20,),
                      ),
                      const CusDivider(),
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                        onTap: () {
                          Get.back();
                          Get.to(() => OrderHistoryScreen());
                        },
                        leading: const Icon(
                          MdiIcons.history,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'Order History', size: 20,),
                      ),
                      const CusDivider(),
                      ListTile(
                        onTap: () {
                          Get.back();
                          Get.to(() => GiftAndPromoScreen());
                        },
                        leading: const Icon(
                          MdiIcons.giftOutline,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'Gift & Promo', size: 20,),
                      ),
                      const CusDivider(),
                      ListTile(
                        onTap: () {
                          Get.back();
                          Get.to(() => WorkNoteScreen());
                        },
                        leading: const Icon(
                          MdiIcons.formatListCheckbox,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'Work note', size: 20,),
                      ),
                      /*const CusDivider(),
                      ListTile(
                        onTap: () {
                          Get.back();
                          Get.to(() => EODReportScreen());
                        },
                        leading: const Icon(
                          MdiIcons.chartAreaspline,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'EOD Report', size: 20,),
                      ),*/
                      const CusDivider(),
                      ListTile(
                        onTap: () {
                          Get.back();
                          Get.to(() => NotificationScreen());
                        },
                        leading: const Icon(
                          MdiIcons.notificationClearAll,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'Notifications', size: 20,),
                      ),
                      /*const CusDivider(),
                      ListTile(
                        onTap: () {
                          Get.back();
                          Get.to(() => OutletsLocScreen());
                        },
                        leading: const Icon(
                          MdiIcons.mapMarker,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'Around Me', size: 20,),
                      ),*/
                      /*if(loginController.zID.value == '300210')...[
                        const CusDivider(),
                        ListTile(
                          onTap: () {
                            Get.back();
                            Get.to(() => DealerListScreen());
                          },
                          leading: const Icon(
                            MdiIcons.orderAlphabeticalAscending,
                            color: AppColor.appBarColor,
                            size: 25,
                          ),
                          title: SmallText(text: 'Incentive', size: 20,),
                        ),
                      ]else...[],*/
                      const CusDivider(),
                      ListTile(
                        onTap: () {
                          Get.back();
                          Get.to(() => DealerListScreen());
                        },
                        leading: const Icon(
                          MdiIcons.orderAlphabeticalAscending,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'Incentive', size: 20,),
                      ),
                      const CusDivider(),
                      ListTile(
                        onTap: () {
                          Get.offAll(() => Login_page());
                        },
                        leading: const Icon(
                          MdiIcons.logout,
                          color: AppColor.appBarColor,
                          size: 25,
                        ),
                        title: SmallText(text: 'Logout', size: 20,),
                      ),
                      const CusDivider(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Is used for customizing the app for faster execution.
class CusDivider extends StatelessWidget {
  const CusDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Colors.black54,
    );
  }
}
