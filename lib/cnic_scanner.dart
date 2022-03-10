library cnic_scanner;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'model/cnic_model.dart';

class CnicScanner {
  /// it will pick your image either form Gallery or from Camera
  final ImagePicker _picker = ImagePicker();

  /// it will check the image source
  late ImageSource source;

  /// a model class to store cnic data
  CnicModel _cnicDetails = CnicModel();

  /// this var track record which side has been scanned
  /// and which needed to be scanned and prompt user accordingly
  bool isFrontScan = false;

  /// this method will be called when user uses this package
  Future<CnicModel> scanImage({required ImageSource imageSource}) async {
    source = imageSource;
    XFile? image = await _picker.pickImage(source: imageSource);
    if (image == null) {
      return Future.value(_cnicDetails);
    } else {
      return await scanCnic(imageToScan: InputImage.fromFilePath(image.path));
    }
  }

  /// this method will process the images and extract information from the card
  Future<CnicModel> scanCnic({required InputImage imageToScan}) async {
    List<String> cnicDates = [];
    GoogleMlKit.vision.languageModelManager();
    TextDetector textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(imageToScan);
    bool isNameNext = false;
    String name = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        String selectedText = line.text;
        if (selectedText.contains("Name:")) {
          for (final i in line.elements) {
            if (i.text.toLowerCase() != "name:") {
              name = name + i.text + " ";
            }
          }
          log("your name is:" + name);
          _cnicDetails.cnicHolderName = name.substring(0, name.length - 1);
          isNameNext = true;
        }
        if (selectedText.length == 18 &&
            isNumeric(selectedText.substring(0, 1)) &&
            selectedText.contains("-", 3) &&
            selectedText.contains("-", 8) &&
            selectedText.contains("-", 16)) {
          _cnicDetails.cnicNumber = line.text;
          log("your id number is:" + line.text);
        }
        if (selectedText.toLowerCase().contains("nationality")) {
          String nation = "";
          for (final i in line.elements) {
            log("su" + i.text);
            if (i.text != "Nationality:") {
              nation += i.text;
            }
          }
          _cnicDetails.nationality = nation;
        }
        log(line.text);
        if (_cnicDetails.nationality != "" &&
            _cnicDetails.cnicHolderName != "" &&
            _cnicDetails.cnicNumber != "") {
          isFrontScan = true;
          Fluttertoast.showToast(
              msg: "Scan Back Side Now",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        // if (isNameNext) {
        //   _cnicDetails.cnicHolderName = line.text;
        //   isNameNext = false;
        // }
        // if (line.text.toLowerCase() == "Name" ||
        //     line.text.toLowerCase() == "nane" ||
        //     line.text.toLowerCase() == "nam" ||
        //     line.text.toLowerCase() == "ame") {
        //   isNameNext = true;
        // }
        // for (TextElement element in line.elements) {
        //   String selectedText = element.text;
        //   if (selectedText.length == 15 &&
        //       selectedText.contains("-", 5) &&
        //       selectedText.contains("-", 13)) {
        //     _cnicDetails.cnicNumber = selectedText;
        //   } else if (selectedText.length == 10 &&
        //       ((selectedText.contains("/", 2) &&
        //               selectedText.contains("/", 5)) ||
        //           (selectedText.contains(".", 2) &&
        //               selectedText.contains(".", 5)))) {
        //     cnicDates.add(selectedText.replaceAll(".", "/"));
        //   }
        // }
      }
    }
    if (cnicDates.length > 0 &&
        _cnicDetails.cnicExpiryDate.length == 10 &&
        !cnicDates.contains(_cnicDetails.cnicExpiryDate)) {
      cnicDates.add(_cnicDetails.cnicExpiryDate);
    }
    if (cnicDates.length > 0 &&
        _cnicDetails.cnicIssueDate.length == 10 &&
        !cnicDates.contains(_cnicDetails.cnicIssueDate)) {
      cnicDates.add(_cnicDetails.cnicIssueDate);
    }
    if (cnicDates.length > 0 &&
        _cnicDetails.cnicExpiryDate.length == 10 &&
        !cnicDates.contains(_cnicDetails.cnicExpiryDate)) {
      cnicDates.add(_cnicDetails.cnicExpiryDate);
    }
    if (cnicDates.length > 1) {
      cnicDates = sortDateList(dates: cnicDates);
    }
    if (cnicDates.length == 1 &&
        _cnicDetails.cnicHolderDateOfBirth.length != 10) {
      _cnicDetails.cnicHolderDateOfBirth = cnicDates[0];
      isFrontScan = true;
      Fluttertoast.showToast(
          msg: "Scan Back Side Now",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (cnicDates.length == 2) {
      _cnicDetails.cnicIssueDate = cnicDates[0];
      _cnicDetails.cnicExpiryDate = cnicDates[1];
      if (!isFrontScan)
        Fluttertoast.showToast(
            msg: "Scan Front Side Now",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
    } else if (cnicDates.length == 3) {
      _cnicDetails.cnicHolderDateOfBirth = cnicDates[0].replaceAll(".", "/");
      _cnicDetails.cnicIssueDate = cnicDates[1].replaceAll(".", "/");
      _cnicDetails.cnicExpiryDate = cnicDates[2].replaceAll(".", "/");
    }
    textDetector.close();
    if (_cnicDetails.cnicNumber.length > 0 &&
        _cnicDetails.cnicHolderDateOfBirth.length > 0 &&
        _cnicDetails.cnicIssueDate.length > 0 &&
        _cnicDetails.cnicExpiryDate.length > 0) {
      print('==================== SMART CARD DETAILS $_cnicDetails');
      return Future.value(_cnicDetails);
    } else {
      print('==================== OLD CARD DETAILS $_cnicDetails');
      return await scanImage(imageSource: source);
    }
  }

  /// it will sort the dates
  static List<String> sortDateList({required List<String> dates}) {
    List<DateTime> tempList = [];
    DateFormat format = DateFormat("dd/MM/yyyy");
    for (int i = 0; i < dates.length; i++) {
      tempList.add(format.parse(dates[i]));
    }
    tempList.sort((a, b) => a.compareTo(b));
    dates.clear();
    for (int i = 0; i < tempList.length; i++) {
      dates.add(format.format(tempList[i]));
    }
    return dates;
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
