import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petronas_project/sales/widget/small_text.dart';
import '../../constant/colors.dart';
import '../../constant/dimensions.dart';
import '../../widget/big_text.dart';
import '../controller/login_controller.dart';

class TsoSelectionScreen extends StatefulWidget {
  String zid;
  TsoSelectionScreen({
    required this.zid,
    Key? key
  }) : super(key: key);

  @override
  State<TsoSelectionScreen> createState() => _TsoSelectionScreenState();
}

class _TsoSelectionScreenState extends State<TsoSelectionScreen> {
  final GlobalKey<FormState> loginKey = GlobalKey();
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
    loginController.getTerritory(widget.zid);
    super.initState();
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
            text: 'Territory List',
            color: AppColor.defWhite,
            size: 25,
          ),
          /*actions: [
            IconButton(
              onPressed: () {
               loginController.fetchTerritoryList();
            },
              icon: const Icon(MdiIcons.syncIcon, size: 30,),)
          ],*/
        ),
        body: Obx((){
         return  loginController.territoryFetched.value
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
              itemCount: loginController.territoryList.length,
              itemBuilder: (context, index) {
                return loginController.territoryList == []
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: Dimensions.height50 + Dimensions.height20,
                          child: ListTile(
                            onTap: () {
                              print('Tso selected list: ${loginController.territoryList[index]["xterritory"]}');
                              loginController.getTsoInfo('${loginController.territoryList[index]["xsp"]}', '${loginController.territoryList[index]["xterritory"]}');
                            },
                            tileColor: AppColor.appBarColor,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(
                                  text: loginController.territoryList[index]["xterritory"],
                                  size: 20,
                                  color:
                                  AppColor.defWhite,
                                ),
                                SmallText(
                                  text: loginController.territoryList[index]["xsp"],
                                  size: 12,
                                  color:
                                  AppColor.defWhite,
                                ),
                              ],
                            ),
                          ),
                        ),
                    );
              });
        }),
      ),
    );
  }
}
