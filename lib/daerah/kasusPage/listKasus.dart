import 'package:flutter/material.dart';
import 'package:suppchild_ver_1/constant.dart';
import 'package:suppchild_ver_1/homePage/cabang_chart.dart';
import 'package:suppchild_ver_1/homePage/total_chart.dart';
import 'package:bmnav/bmnav.dart' as bmnav;

class ListKasus extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Widget buttonTambah() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 22, 10, 22),
        child: Center(
          child: Container(
            width: 380,
            child: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/buatKegiatan');
              },
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: colorMainPurple,
              child: Text(
                'Tambah Laporan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      );
    }
    Widget listKasus(kasus) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colorMainPurple,
              width: 3,
            ),
            right: BorderSide(
              color: colorMainPurple,
              width: 3,
            ),
            bottom: BorderSide(
              color: colorMainPurple,
              width: 3,
            ),
          ),
        ),
        width: double.infinity,
        child: RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                '1. $kasus',
                style: TextStyle(

                  color: colorMainPurple,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: <Widget>[
        buttonTambah(),
        Container(
          width: 380,
          child: Wrap(
            children: <Widget>[
              Container(
                width: 380,
                child: Container(
                  color: colorMainPurple,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        'Surabaya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              listKasus('Pelecehan Seksual'),
              listKasus('Kekerasan Rumah Tangga'),
              listKasus('Drop Out Sekolah'),
            ],
          ),
        ),
      ],
    );
  }
}