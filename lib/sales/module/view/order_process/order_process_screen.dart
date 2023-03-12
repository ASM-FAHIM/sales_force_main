import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petronas_project/sales/module/view/order_process/product_list_screen.dart';
import '../../../constant/colors.dart';
import '../../../constant/dimensions.dart';
import '../../../widget/big_text.dart';
import '../../../widget/small_text.dart';
import '../../controller/dashboard_controller.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  DashboardController dashboardController = Get.put(DashboardController());
  TextEditingController name = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashboardController.getDealerList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.appBarColor,
          leading: GestureDetector(
              onTap: () {
                dashboardController.getVisitedDealerList();
                dashboardController.countDealerVisitTable();
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_outlined,
                size: 25,
              )),
          title: BigText(
            text: "Dealers",
            color: AppColor.defWhite,
            size: 25,
          ),
        ),
        body: Obx((){
          return dashboardController.isLoading1.value
              ? Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: const CircularProgressIndicator(
                        color: AppColor.appBarColor,
                      ),
                    ),
                    const Text('Loading...')
                  ],
                ),
              )
              : Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                /*Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Autocomplete(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    } else {
                      List<String> matches = <String>[];
                      matches.addAll(dashboardController.dealerName);

                      matches.retainWhere((s) {
                        return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                      return matches;
                    }
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onEditingComplete: onFieldSubmitted,
                      decoration: InputDecoration(
                          hintText: 'Search by name',
                          suffixIcon: IconButton(
                              onPressed: () async {
                                textEditingController.text.isEmpty
                                    ? await dashboardController.getDealerList()
                                    : await dashboardController.getDealerListByName();
                              },
                              icon: Icon(Icons.search))),
                    );
                  },
                  onSelected: (String selection) {
                    dashboardController.dealersName.value = selection;
                    dashboardController.getDealerListByName();
                    print('You just selected ${dashboardController.dealersName.value}');
                  },
                ),
              ),*/
                  TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
                        hintText: 'Search by name',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search)
                    ),
                    onChanged: (value) => dashboardController.runFilter(value),
                  ),
                  Obx((){
                    return Expanded(
                      child: dashboardController.isLoading5.value
                        ? Center(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(
                                  color: AppColor.appBarColor,
                                ),
                              ),
                              Text('Loading...')
                            ],
                          ),
                        )
                        : ListView.builder(
                        itemCount: dashboardController.foundDealerList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: SizedBox(
                              height: Dimensions.height50 + Dimensions.height20,
                              child: ListTile(
                                onTap: () {
                                  Get.to(() => ProductsScreen(
                                    xcus: dashboardController.foundDealerList[index]['xcus'].toString(),
                                    xOrg: dashboardController.foundDealerList[index]['xorg'].toString(),
                                    xterritory: dashboardController.foundDealerList[index]['xterritory'].toString(),
                                    xareaop: dashboardController.foundDealerList[index]['xareaop'].toString(),
                                    xdivisionop: dashboardController.foundDealerList[index]['xdivisionop'].toString(),
                                    xsubcat: dashboardController.foundDealerList[index]['xsubcat'].toString(),
                                    xgcus: dashboardController.foundDealerList[index]['xgcus'].toString(),
                                  ));
                                },
                                tileColor: AppColor.appBarColor,
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BigText(
                                      text: dashboardController.foundDealerList[index]['xorg'].toString(),
                                      size: 14,
                                      color: AppColor.defWhite,
                                    )
                                  ],
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SmallText(
                                              text: dashboardController.foundDealerList[index]['xcus'],
                                              size: 12,
                                            ),
                                            Container(
                                              height: 50,
                                              width: Dimensions.height150,
                                              child:  SmallText(
                                                text: dashboardController.foundDealerList[index]['xphone'],
                                                size: 10,
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 50,
                                          width: Dimensions.height150,
                                          child: SmallText(
                                            text: dashboardController.foundDealerList[index]['xmadd'],
                                            size: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                })
              ],
            ),
          );
        }),
      ),
    );
  }
}

/*
ListView.builder(
itemCount: dashboardController.list.length,
itemBuilder: (context, index) {
return Padding(
padding: const EdgeInsets.only(top: 5, bottom: 5),
child: SizedBox(
height: Dimensions.height50 + Dimensions.height20,
child: ListTile(
onTap: (){
Get.to(() => ProductsScreen(
xcus: dashboardController.list[index]['xcus'].toString(),
xOrg: dashboardController.list[index]['xorg'].toString(),
xterritory: dashboardController.list[index]['xterritory'].toString(),
xareaop: dashboardController.list[index]['xareaop'].toString(),
xdivisionop: dashboardController.list[index]['xdivisionop'].toString(),
xsubcat: dashboardController.list[index]['xsubcat'].toString(),
));
},
tileColor: AppColor.appBarColor,
title: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
BigText(text: dashboardController.list[index]['xorg'].toString(), size: 16, color: AppColor.defWhite,)
],),
subtitle: Column(
children: [
Row (
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
SmallText(text: dashboardController.list[index]['xcus'], size: 14,),
SmallText(text: dashboardController.list[index]['xterritory'], size: 14,),
],
),
],
),
),
),
);
})*/



///main
/*Obx((){
return dashboardController.enableDealerList.value == false
? Expanded(
child: dashboardController.isLoading1.value
? Center(
child: Column(
children: [
Container(
margin: EdgeInsets.all(10.0),
child: CircularProgressIndicator(),
),
Text('Loading...')
],
),
)
    : ListView.builder(
itemCount: dashboardController.list.length,
itemBuilder: (context, index) {
return Padding(
padding: const EdgeInsets.only(top: 5, bottom: 5),
child: SizedBox(
height: Dimensions.height50 + Dimensions.height20,
child: ListTile(
onTap: () {
Get.to(() => ProductsScreen(
xcus: dashboardController.list[index]['xcus'].toString(),
xOrg: dashboardController.list[index]['xorg'].toString(),
xterritory: dashboardController.list[index]['xterritory'].toString(),
xareaop: dashboardController.list[index]['xareaop'].toString(),
xdivisionop: dashboardController.list[index]['xdivisionop'].toString(),
xsubcat: dashboardController.list[index]['xsubcat'].toString(),
));
},
tileColor: AppColor.appBarColor,
title: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
BigText(
text: dashboardController.list[index]['xorg'].toString(),
size: 16,
color: AppColor.defWhite,
)
],
),
subtitle: Column(
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
SmallText(
text: dashboardController.list[index]['xcus'],
size: 14,
),
SmallText(
text: dashboardController.list[index]['xphone'],
size: 14,
),
],
),
Container(
height: 50,
width: Dimensions.height150,
child: SmallText(
text: dashboardController.list[index]['xmadd'],
size: 14,
),
)
],
),
],
),
),
),
);
}),
)
    : Expanded(
child: dashboardController.isLoading5.value
? Center(
child: Column(
children: [
Container(
margin: EdgeInsets.all(10.0),
child: CircularProgressIndicator(),
),
Text('Loading...')
],
),
)
    : ListView.builder(
itemCount: dashboardController.dealerListByName.length,
itemBuilder: (context, index) {
return Padding(
padding: const EdgeInsets.only(top: 5, bottom: 5),
child: SizedBox(
height: Dimensions.height50 + Dimensions.height20,
child: ListTile(
onTap: () {
dashboardController.enableDealerList(false);
Get.to(() => ProductsScreen(
xcus: dashboardController.dealerListByName[index]['xcus'].toString(),
xOrg: dashboardController.dealerListByName[index]['xorg'].toString(),
xterritory: dashboardController.dealerListByName[index]['xterritory'].toString(),
xareaop: dashboardController.dealerListByName[index]['xareaop'].toString(),
xdivisionop: dashboardController.dealerListByName[index]['xdivisionop'].toString(),
xsubcat: dashboardController.dealerListByName[index]['xsubcat'].toString(),
));
},
tileColor: AppColor.appBarColor,
title: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
BigText(
text: dashboardController.dealerListByName[index]['xorg'].toString(),
size: 16,
color: AppColor.defWhite,
)
],
),
subtitle: Column(
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
SmallText(
text: dashboardController.dealerListByName[index]['xcus'],
size: 14,
),
SmallText(
text: dashboardController.dealerListByName[index]['xterritory'],
size: 14,
),
],
),
],
),
),
),
);
}),
) ;
})*/
