import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suppchild_ver_1/constant.dart';
import 'package:suppchild_ver_1/daerah/rootDaerah.dart';
import 'package:suppchild_ver_1/pusat/sizeConfig.dart';
import 'package:intl/intl.dart';

class BuatKegiatan extends StatefulWidget {
  @override
  _BuatKegiatanState createState() => _BuatKegiatanState();
}

class _BuatKegiatanState extends State<BuatKegiatan> {
  File selectedFile;
  Response response;
  Dio dio = new Dio();
  String fileName;
  PlatformFile fileAkhirBanget;
  bool berhasil = true;
  String msg = '';
  int idDaerah;

  var _kategori = ['Umum', 'Internal'];
  var _currentKategoriSelected = 'Umum';

  // Controller
  TextEditingController controllerFile;
  TextEditingController controllerNama = new TextEditingController();
  TextEditingController controllerDeskripsi = new TextEditingController();
  TextEditingController controllerKategori = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _takePrefs();
  }

  _takePrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idDaerah = prefs.getInt('id_daerah');
    });
  }

  _checkForm() {
    if (controllerNama.text.isEmpty) {
      setState(() {
        msg = "Nama Kegiatan Kosong!";
        berhasil = false;
        print(msg);
      });
    } else if (fileName == null) {
      setState(() {
        msg = "File Terkait Masih Kosong!";
        berhasil = false;
        print(msg);
      });
    } else {
      msg = "";
      berhasil = true;
    }
  }

  Widget alertGagal() {
    return Center(
      child: Text(
        msg,
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  _openFileExplorer() async {
    FilePickerResult selectedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    PlatformFile fileAkhir = selectedFile.files.first;

    setState(() {
      fileAkhirBanget = fileAkhir;
      fileName = fileAkhir.name;
      controllerFile = new TextEditingController(text: fileName);
    });
  }

  _unggahFile() async {
    String uploadurl = "http://suppchild.xyz/API/daerah/buatKegiatan.php";
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String tglUpload = dateFormat.format(DateTime.now());

    FormData formdata = FormData.fromMap({
      "nama_kegiatan": controllerNama.text,
      "deskripsi": controllerDeskripsi.text,
      "id_kategori": _currentKategoriSelected == 'Umum' ? '1' : '2',
      "id_daerah": idDaerah.toString(),
      "file_ajuan": await MultipartFile.fromFile(fileAkhirBanget.path,
          filename: basename(fileAkhirBanget.name)
          //show only filename from path
          ),
      "tgl_upload": tglUpload,
    });
    print(formdata);

    response = await dio.post(uploadurl, data: formdata);

    if (response.statusCode == 200) {
      print('Berhasil Up!');
      //print response from server
    } else {
      print("Error during connection to server.");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Widget buttonAmbilFile() {
      return Center(
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 45,
          height: SizeConfig.safeBlockVertical * 6.5,
          child: RaisedButton(
            onPressed: () {
              _openFileExplorer();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: colorSecondPurple,
            child: Text(
              'Unggah File',
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.safeBlockHorizontal * 5.75,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      );
    }

    Widget buttonUnggah() {
      Widget buttonbatal() {
        return Center(
          child: Container(
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.red,
              child: Text(
                'Tidak',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        );
      }

      Widget buttonYakin() {
        return Center(
          child: Container(
            child: RaisedButton(
              onPressed: () {
                _checkForm();
                if (berhasil == true) {
                  _unggahFile();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RootDaerah(selectedScreen: 'kegiatan'),
                      ));
                } else {
                  Navigator.pop(context);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: colorMainPurple,
              child: Text(
                'Ya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        );
      }

      Widget contModal() {
        return AlertDialog(
          content: Container(
            height: SizeConfig.safeBlockHorizontal * 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                spasiBaris(1.0),
                Text(
                  'Apakah Anda Yakin?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                spasiBaris(2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    buttonYakin(),
                    buttonbatal(),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      return Center(
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 35,
          height: SizeConfig.safeBlockVertical * 6.5,
          child: RaisedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => contModal(),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: colorMainPurple,
            child: Text(
              'Ajukan',
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.safeBlockHorizontal * 5.75,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      );
    }

    Widget buttonBatal() {
      return Center(
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 35,
          height: SizeConfig.safeBlockVertical * 6.5,
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: Colors.redAccent,
            child: Text(
              'Batal',
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.safeBlockHorizontal * 5.75,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      );
    }

    Widget formNama() {
      return Container(
        width: SizeConfig.safeBlockHorizontal * 80,
        height: SizeConfig.safeBlockVertical * 8,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 2, color: colorMainPurple),
        ),
        child: TextField(
          controller: controllerNama,
          autofocus: false,
          cursorColor: colorMainPurple,
          style: TextStyle(
            color: colorSecondPurple,
            fontSize: SizeConfig.safeBlockHorizontal * 5,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(25, 0, 10, 0),
            border: InputBorder.none,
            hintText: 'Nama Kegiatan',
            hintStyle: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 5,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
              color: colorSecondPurple,
            ),
          ),
        ),
      );
    }

    Widget formDeskripsi() {
      return Container(
        width: SizeConfig.safeBlockHorizontal * 80,
        height: SizeConfig.safeBlockVertical * 20,
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2, color: colorMainPurple),
        ),
        child: TextField(
          maxLines: 5,
          controller: controllerDeskripsi,
          autofocus: false,
          cursorColor: colorMainPurple,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: colorSecondPurple,
            fontSize: SizeConfig.safeBlockHorizontal * 5,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(25, 15, 10, 15),
            border: InputBorder.none,
            hintText: 'Deskripsi Singkat',
            hintStyle: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 5,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
              color: colorSecondPurple,
            ),
          ),
        ),
      );
    }

    Widget formRead(hint) {
      return Container(
        height: SizeConfig.safeBlockVertical * 8,
        width: SizeConfig.safeBlockHorizontal * 37,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorSecondPurple,
          borderRadius: BorderRadius.circular(100),
        ),
        child: TextFormField(
          readOnly: true,
          autofocus: false,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.safeBlockHorizontal * 5,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(25, 0, 10, 0),
            border: InputBorder.none,
            hintText: '$hint',
            hintStyle: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 5,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    Widget dropDownKategori() {
      return Container(
        height: SizeConfig.safeBlockVertical * 8,
        width: SizeConfig.safeBlockHorizontal * 37,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 2, color: colorMainPurple),
        ),
        child: DropdownButton<String>(
          items: _kategori.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(
                dropDownStringItem,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w500,
                  color: colorSecondPurple,
                ),
              ),
            );
          }).toList(),
          onChanged: (String newValueSelected) {
            setState(() {
              this._currentKategoriSelected = newValueSelected;
              controllerKategori.text = newValueSelected;
            });
          },
          value: _currentKategoriSelected,
        ),
      );
    }

    Widget formFile() {
      return Container(
        width: SizeConfig.safeBlockHorizontal * 80,
        height: SizeConfig.safeBlockVertical * 8,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 2, color: colorMainPurple),
        ),
        child: TextField(
          controller: controllerFile,
          readOnly: true,
          autofocus: false,
          cursorColor: colorMainPurple,
          style: TextStyle(
            color: colorSecondPurple,
            fontSize: SizeConfig.safeBlockHorizontal * 5,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(25, 0, 10, 0),
            border: InputBorder.none,
            hintText: 'Nama File',
            hintStyle: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 5,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
              color: colorSecondPurple,
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarTitle('Buat Kegiatan'),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                spasiBaris(4.0),
                Text(
                  'Ajukan Kegiatan',
                  style: TextStyle(
                    color: colorMainPurple,
                    fontSize: SizeConfig.safeBlockHorizontal * 6.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                spasiBaris(4.0),
                formNama(),
                spasiBaris(2.0),
                Center(
                  child: Container(
                    width: SizeConfig.safeBlockHorizontal * 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        formRead("Kategori:"),
                        dropDownKategori(),
                      ],
                    ),
                  ),
                ),
                spasiBaris(2.0),
                formDeskripsi(),
                spasiBaris(2.0),
                Container(
                  width: SizeConfig.safeBlockHorizontal * 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      buttonAmbilFile(),
                      Container(
                        width: SizeConfig.safeBlockHorizontal * 30,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '*.doc / .pdf',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: SizeConfig.safeBlockHorizontal * 5.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                spasiBaris(2.0),
                formFile(),
                spasiBaris(2.0),
                alertGagal(),
                spasiBaris(6.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    buttonUnggah(),
                    buttonBatal(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
