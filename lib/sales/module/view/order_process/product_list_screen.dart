import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petronas_project/sales/module/view/gift_promo_screen.dart';
import '../../../constant/colors.dart';
import '../../../constant/dimensions.dart';
import '../../../widget/big_text.dart';
import '../../../widget/small_text.dart';
import '../../controller/cart_controller.dart';
import '../../controller/dashboard_controller.dart';
import 'cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  String xcus;
  String xOrg;
  String xterritory;
  String xareaop;
  String xdivisionop;
  String xsubcat;
  String xgcus;

  ProductsScreen({
    Key? key,
    required this.xcus,
    required this.xOrg,
    required this.xterritory,
    required this.xareaop,
    required this.xdivisionop,
    required this.xsubcat,
    required this.xgcus,
  })
      : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  CartController cartController = Get.put(CartController());
  DashboardController dashboardController = Get.put(DashboardController());
  TextEditingController name = TextEditingController();

  //upload related work
  // uploading image
  File? pickedFile;
  String authDealerWiseImage = '';
  ImagePicker imagePicker = ImagePicker();
  //postUploadImage
  //Uri.parse("http://172.20.20.69/pick_kids/create_account/image.php"))
  Future postUploadImg(File imageFile) async {
    final request = http.MultipartRequest('POST',
        Uri.parse("http://172.20.20.69/salesforce/image.php"))
      ..files.add(await http.MultipartFile.fromPath('photo', imageFile.path));

    //for test
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print("image uploaded");
      } else {
        print("uploaded failed: ${response.statusCode}");
      }
    } catch (e) {
      print('my exception: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashboardController.getProductList(widget.xcus, widget.xgcus);
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
              )),
          title: BigText(
            text: "Products",
            color: AppColor.defWhite,
            size: 25,
          ),
          actions: [
            Obx(() => IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return bottomSheet(context);
                      });
                },
                icon: dashboardController.isConnected.value
                    ? Center(child: CircularProgressIndicator(color: Colors.white,),)
                    : const Icon(MdiIcons.checkBold,)),),
            IconButton(onPressed: (){
              // dashboardController.dropGiftPromoTable();
               Get.to(()=> GiftAndPromoScreen());
            }, icon: Icon(MdiIcons.giftOutline,))
          ],
        ),
        body: Obx(() =>dashboardController.isLoading2.value
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
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: dashboardController.productList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          cartController.addToCart(
                            dashboardController.productList[index]["xitem"],
                            dashboardController.productList[index]["xdesc"],
                            '${dashboardController.updatedProductList[index]}',
                            dashboardController.productList[index]["xunitsel"] ?? '',
                          );
                        },
                        highlightColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
                          child: Container(
                            height: Dimensions.height70 ,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 25,
                                  offset: Offset(5, 5), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: Dimensions.height50 + Dimensions.height20,
                                  width: double.maxFinite,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          BigText(text: '${dashboardController.productList[index]["xdesc"]}', size: 15,),
                                          SmallText(text: '${dashboardController.productList[index]["xitem"]}', size: 12, color: Colors.grey,)
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Icon(MdiIcons.currencyBdt, size: 20, color: Colors.red,),
                                              Text('${dashboardController.updatedProductList[index]}',style: GoogleFonts.roboto(color: Colors.black, fontSize: 18),),
                                            ],
                                          ),

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Get.to(() => CartScreen(
              xcus: widget.xcus,
              xOrg: widget.xOrg,
              xterritory: widget.xterritory,
              xareaop: widget.xareaop,
              xdivisionop: widget.xdivisionop,
              xsubcat: widget.xsubcat,
            ));
          },
          label: Row(
            children: [
              BigText(text: 'Total = ', color: Colors.white,),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.transparent),
                      child: const Icon(
                        Icons.shopping_cart_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Obx(() =>
                      Positioned(
                        right: 10,
                        top: -1,
                        child: BigText(
                          text: '${cartController.totalClick}',
                          color: Colors.white,
                        ),
                      ),
                  ),
                ],
              )
            ],
          ),
          backgroundColor: AppColor.appBarColor,
        ),
      ),
    );
  }

  //bottom sheet
  Widget bottomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.maxFinite,
      height: size.height * .2,
      decoration: const BoxDecoration(
        color: AppColor.appBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Choose profile photo",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  debugPrint('Image clicked');
                  takePhoto(ImageSource.camera);
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 40,
                    ),
                    Text(
                      'Camera',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //for checking out
  Future<void> takePhoto(ImageSource source) async {
    final pickedImage =
    await imagePicker.pickImage(source: source, imageQuality: 100);
    pickedFile = File(pickedImage!.path);
    authDealerWiseImage = pickedFile!.path.split('/').last;
    dashboardController.setDealerWiseImagePath(pickedFile!.path);
    await postUploadImg(pickedFile!);
    await dashboardController.internetCheck(authDealerWiseImage, widget.xOrg);
    print('================${pickedFile}');
    print('================${authDealerWiseImage}');
  }
}

/*
InkWell(
onTap: () {
cartController.addToCart(
dashboardController.productList[index]["xitem"],
dashboardController.productList[index]["xdesc"],
dashboardController.productList[index]["totrate"]);
},
highlightColor: Colors.white,
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
child: Visibility(
visible: true,
child: Container(
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(30.0),
boxShadow: [
BoxShadow(
color: Colors.lightBlueAccent.withOpacity(0.5),
spreadRadius: 1,
blurRadius: 2,
offset: const Offset(2, 2), // changes position of shadow
),
],
),
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 0),
child: Column(
children: [
Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
Container(
//height and width need to give dimensions for screen management
height: Dimensions.height50,
width: Dimensions.height50 ,
decoration: const BoxDecoration(
image: DecorationImage(
image: AssetImage(
'assets/images/lpg.png',
),
),
),
),
Expanded(
child: Container(
//height and width need to give dimensions for screen management
height: Dimensions.height150 + Dimensions.height20,
margin: EdgeInsets.only(right: 10),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
BigText(
text: '${dashboardController.productList[index]["xdesc"]}', size: 20,),
SmallText(
text: '${dashboardController.productList[index]["xitem"]}', size: 18),
Row(
mainAxisAlignment: MainAxisAlignment.end,
children: [
Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(MdiIcons.currencyBdt, size: 20, color: Colors.red,),
SmallText(text: '${dashboardController.productList[index]["totrate"]}', size: 20, color: Colors.red,),
],
)
],
),
],
),
),
)
],
),
Container(
height: 70,
width: double.maxFinite,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(30.0),
color: AppColor.appBlackColor
),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
CircleAvatar(child: Icon(MdiIcons.accountSettings),),
Column(
children: [
BigText(text: '2 Discount claimed', color: AppColor.defWhite,),
SmallText(text: 'Expiry date 20 January 2023', color: AppColor.defWhite,),
],
),
CircleAvatar(child: Icon(MdiIcons.sailBoat),),
],
),
)
],
),
),
),
),
),
)*/
