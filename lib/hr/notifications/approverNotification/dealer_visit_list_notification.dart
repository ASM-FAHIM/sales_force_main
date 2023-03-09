import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:petronas_project/sales/constant/app_constants.dart';
import '../../../data_model/notification_model/admin_approver_model/dealer_visit_list_model.dart';

class DealerVisitList extends StatefulWidget {
  DealerVisitList(
      {required this.xposition,
        required this.xstaff,
        required this.zemail,
        required this.zid,
      });
  String xposition;
  String xstaff;
  String zemail;
  String zid;

  @override
  State<DealerVisitList> createState() => _DealerVisitListState();
}

class _DealerVisitListState extends State<DealerVisitList> {
  Future<List<DealerVisitListModel>>? futurePost;
  AppConstants appConstants = AppConstants();

  Future<List<DealerVisitListModel>> fetchPost() async {
    var response = await http.get(Uri.parse("http://${AppConstants.baseurl}/salesforce/TSO_Daily_Visit.php?id=${widget.xposition}"),);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed.map<DealerVisitListModel>((json) => DealerVisitListModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
    fetchPost().whenComplete(() => futurePost);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xff064A76),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            "Dealer Visit List",
            style: GoogleFonts.bakbakOne(
              fontSize: 20,
              color: Color(0xff074974),
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: 20,
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<DealerVisitListModel>>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 6.0),
                          child: ExpansionTile(
                            expandedCrossAxisAlignment:
                            CrossAxisAlignment.start,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${snapshot.data![index].tsoid}",
                                                style: GoogleFonts.bakbakOne(
                                                  fontSize: 18,
                                                  //color: Color(0xff074974),
                                                ),
                                              ),
                                              Text(
                                                "${snapshot.data![index].xdate}",
                                                style: GoogleFonts.bakbakOne(
                                                  fontSize: 18,
                                                  //color: Color(0xff074974),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${snapshot.data![index].dealer}",
                                            style: GoogleFonts.bakbakOne(
                                              fontSize: 18,
                                              //color: Color(0xff074974),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            children: <Widget>[
                              Text(
                                "Location: " + " ${snapshot.data![index].location}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.bakbakOne(
                                  fontSize: 18,
                                  //color: Color(0xff074974),
                                ),
                              ),
                              /*Text(
                                "Visit Date: " +
                                    " ${snapshot.data![index].xdate}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.bakbakOne(
                                  fontSize: 18,
                                  //color: Color(0xff074974),
                                ),
                              ),*/
                              SizedBox(height: 10,),
                              Container(
                                height: 300,
                                width: 400,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(20.0),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'http://${AppConstants.baseurl}/salesforce/images/${snapshot.data![index].image}'),
                                      fit: BoxFit.cover),
                                ),
                                // child: Image.network(
                                //   'http://${AppConstants.baseurl}/pick_kids/create_account/images/${authController.authPersonList![index].authImg}',
                                //   scale: 1,
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Image(image: AssetImage("assets/images/loading.gif")),
              );
            }
          },
        ),
      ),
    );
  }
}
