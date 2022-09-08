library cnic_scanner;

import 'dart:developer';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'model/card_model.dart';

class CardScanner {
  /// it will pick your image either form Gallery or from Camera
  final ImagePicker _picker = ImagePicker();

  /// it will check the image source
  late ImageSource source;

  /// a model class to store card data
  CardModel cardDetails = CardModel();

  /// this var track record which side has been scanned
  /// and which needed to be scanned and prompt user accordingly
  bool isFrontScan = false;

  /// this method will be called when user uses this package
  Future<CardModel> scanImage({required ImageSource imageSource}) async {
    source = imageSource;
    XFile? image = await _picker.pickImage(source: imageSource);
    if (image == null) {
      return Future.value(cardDetails);
    } else {
      return await scanCnic(
          imageToScan: InputImage.fromFilePath(image.path), image: image);
    }
  }

  /// this method will process the images and extract information from the card
  Future<CardModel> scanCnic(
      {required InputImage imageToScan, required XFile image}) async {
    List<String> cardDates = [];
    final textRecognizer = TextRecognizer();
    final RecognizedText recognisedText =
        await textRecognizer.processImage(imageToScan);
    // TextDetector textDetector = GoogleMlKit.vision.textDetector();
    // final RecognisedText recognisedText =
    //     await textDetector.processImage(imageToScan);
    String name = "";
    String sex = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        String selectedText = line.text;
        print("line -> ${selectedText}");
        if (selectedText.contains("Name")) {
          for (final i in line.elements) {
            if (i.text.toLowerCase() != "name") {
              name = name + i.text + " ";
            }
          }
          log("your name is:" + name);
          cardDetails.cardHolderName = name.substring(0, name.length - 1);
        }
        if (selectedText.length == 1 &&
            (selectedText == 'M' || selectedText == 'F')) {
          if (selectedText.contains("M")) {
            cardDetails.cardHolderGender = "Male";
          } else {
            cardDetails.cardHolderGender = "Female";
          }
          log(cardDetails.cardHolderGender);
        }
        if (line.text.length == 12 && isNumeric(line.text)) {
          log("civi ${line.text}");
          cardDetails.cardNumber = line.text;
        }
        log(selectedText);
        if (selectedText.toLowerCase().contains("nationality")) {
          String nation = "";
          log("nation ${line.text}");
          for (final i in line.elements) {
            log("su" + i.text);
            if (i.text.toLowerCase() != "nationality") {
              nation = i.text.substring(0);
            }
          }
          cardDetails.cardHolderNationality = nation;
        }
        for (TextElement element in line.elements) {
          String selectedText = element.text;
          if (selectedText != null &&
              selectedText.length == 15 &&
              selectedText.contains("-", 5) &&
              selectedText.contains("-", 13)) {
            cardDetails.cardNumber = selectedText;
          } else if (selectedText != null &&
              selectedText.length == 10 &&
              ((selectedText.contains("/", 2) &&
                      selectedText.contains("/", 5)) ||
                  (selectedText.contains(".", 2) &&
                      selectedText.contains(".", 5)))) {
            cardDates.add(selectedText.replaceAll(".", "/"));
          }
        }
      }
    }
    if (cardDates.length > 1) {
      cardDetails.cardExpiry = cardDates[1];
    }
    if (cardDates.length > 0) {
      cardDetails.cardHolderDateOfBirth = cardDates[0];
    }
    cardDetails.cardFile = image;
    return Future.value(cardDetails);
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
