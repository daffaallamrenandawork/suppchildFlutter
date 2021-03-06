import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suppchild_ver_1/constant.dart';
import 'package:suppchild_ver_1/homePageDaerah/cabang_chart.dart';
import 'package:suppchild_ver_1/homePageDaerah/total_chart.dart';
import 'package:suppchild_ver_1/homePagePusat/fotoSlideShow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:suppchild_ver_1/pusat/sizeConfig.dart';
import 'package:http/http.dart' as http;
import 'package:suppchild_ver_1/main.dart';

Widget titleChart(title) {
  return Text(
    '$title',
    style: TextStyle(
      fontFamily: 'Rubik',
      fontSize: SizeConfig.safeBlockHorizontal * 6,
      fontWeight: FontWeight.w600,
      color: colorMainPurple,
    ),
  );
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List Foto
  int _currentIndex = 0;
  List cardList = [
    Item1(),
    Item2(),
    Item3(),
  ];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Widget slideShow() {
    return CarouselSlider(
      options: CarouselOptions(
        height: SizeConfig.safeBlockVertical * 30,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 12),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        aspectRatio: 2.0,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items: cardList.map((card) {
        return Builder(builder: (BuildContext context) {
          return Container(
            width: SizeConfig.safeBlockHorizontal * 80,
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.white,
              child: card,
            ),
          );
        });
      }).toList(),
    );
  }

  Map<String, dynamic> myMap;
//Mengambil data anak dari db
  void getDataTabel() async {
    final response =
        await http.get("http://suppchild.xyz/API/getTabelAnak.php");
    myMap = new Map<String, dynamic>.from(json.decode(response.body));
    setState(() {
      gresikL = myMap["GresikL"];
      gresikP = myMap["GresikP"];

      bangkalanL = myMap["BangkalanL"];
      bangkalanP = myMap["BangkalanP"];

      mojokertoL = myMap["MojokertoL"];
      mojokertoP = myMap["MojokertoP"];

      surabayaL = myMap["SurabayaL"];
      surabayaP = myMap["SurabayaP"];

      sidoarjoL = myMap["SidoarjoL"];
      sidoarjoP = myMap["SidoarjoP"];

      lamonganL = myMap["LamonganL"];
      lamonganP = myMap["LamonganP"];
    });
  }

  Map<String, dynamic> mapTotal;
//Mengambil data anak dari db
  void getTabelTotal() async {
    final response =
        await http.get("http://suppchild.xyz/API/getTabelTotal.php");
    mapTotal = new Map<String, dynamic>.from(json.decode(response.body));
    setState(() {
      count2018 = mapTotal["2018"];
      count2019 = mapTotal["2019"];
      count2020 = mapTotal["2020"];
      count2021 = mapTotal["2021"];
    });
  }

  @override
  void initState() {
    super.initState();
    // getTabelTotal();
    // getDataTabel();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: Column(
        children: <Widget>[
          spasiBaris(2.0),
          slideShow(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(cardList, (index, url) {
              return Container(
                height: SizeConfig.safeBlockVertical * 1.1,
                width: SizeConfig.safeBlockHorizontal * 3.25,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == index ? colorSecondPurple : Colors.grey,
                ),
              );
            }),
          ),
          spasiBaris(8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding :EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: titleChart('Total Anak Binaan')),
              spasiBaris(2.0),
              SafeArea(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: SizeConfig.safeBlockVertical * 65,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey[100],
                      elevation: 4.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: LineChartSample1(),
                    )),
              ),
            ],
          ),
          spasiBaris(10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleChart('Anak Binaan Cabang'),
              spasiBaris(2.0),
              Container(
                height: SizeConfig.safeBlockVertical * 35,
                width: SizeConfig.safeBlockHorizontal * 85,
                child: Card(
                    color: Colors.grey[100],
                    elevation: 4.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: PieChartSample2()),
              ),
            ],
          ),
          spasiBaris(6.0),
        ],
      ),
    );
  }
}
