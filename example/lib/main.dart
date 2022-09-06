import 'package:cnic_scanner/cnic_scanner.dart';
import 'package:cnic_scanner/model/cnic_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'src/app_color.dart';
import 'src/custom_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameTEController = TextEditingController(),
      cnicTEController = TextEditingController(),
      dobTEController = TextEditingController(),
      doiTEController = TextEditingController(),
      doeTEController = TextEditingController(),
      nationTEController = TextEditingController();

  /// you're required to initialize this model class as method you used
  /// from this package will return a model of CnicModel type
  CnicModel _cnicModel = CnicModel();

  Future<void> scanCnic(ImageSource imageSource) async {
    /// you will need to pass one argument of "ImageSource" as shown here
    CnicModel cnicModel =
        await CnicScanner().scanImage(imageSource: imageSource);
    if (cnicModel == null) return;
    setState(() {
      _cnicModel = cnicModel;
      nameTEController.text = _cnicModel.cnicHolderName;
      cnicTEController.text = _cnicModel.cnicNumber;
      dobTEController.text = _cnicModel.cnicHolderDateOfBirth;
      doiTEController.text = _cnicModel.sex;
      doeTEController.text = _cnicModel.cnicExpiryDate;
      nationTEController.text = _cnicModel.nationality;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),
            const Text('Enter ID Card Details',
                style: TextStyle(
                    color: Color(kDarkGreyColor),
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 5,
            ),
            const Text(
                'To verify your Account, please enter your card details.',
                style: TextStyle(
                    color: Color(kLightGreyColor),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 35,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                children: [
                  _dataField(
                      text: 'Name', textEditingController: nameTEController),
                  _cnicField(textEditingController: cnicTEController),
                  _dataField(
                      text: 'Nationality',
                      textEditingController: nationTEController),
                  _dataField(
                      text: 'Date of Birth',
                      textEditingController: dobTEController),
                  _dataField(
                      text: 'Gender', textEditingController: doiTEController),
                  _dataField(
                      text: 'Date of Card Expire',
                      textEditingController: doeTEController),
                  const SizedBox(
                    height: 20,
                  ),
                  _getScanCNICBtn(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// these are my custom designs you can use according to your ease
  Widget _cnicField({required TextEditingController textEditingController}) {
    return Card(
      elevation: 7,
      margin: const EdgeInsets.only(top: 2.0, bottom: 5.0),
      child: Container(
        margin:
            const EdgeInsets.only(top: 2.0, bottom: 1.0, left: 0.0, right: 0.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 3,
                height: 45,
                margin: const EdgeInsets.only(left: 3.0, right: 7.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [
                        Color(kDeepDarkGreenColor),
                        Color(kDarkGreenColor),
                        Color(kGradientGreyColor),
                      ],
                      stops: [
                        0.0,
                        0.5,
                        1.0
                      ],
                      tileMode: TileMode.mirror,
                      end: Alignment.bottomCenter,
                      begin: Alignment.topRight),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ID Number',
                    style: TextStyle(
                        color: Color(kDarkGreenColor),
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Image.asset("assets/images/cnic.png",
                          width: 40, height: 30),
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            hintText: '41000-0000000-0',
                            hintStyle: TextStyle(color: Color(kLightGreyColor)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(left: 5.0),
                          ),
                          style: const TextStyle(
                              color: Color(kDarkGreyColor),
                              fontWeight: FontWeight.bold),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dataField(
      {required String text,
      required TextEditingController textEditingController}) {
    return Card(
        shadowColor: const Color(kShadowColor),
        elevation: 5,
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                (text == "Name") ? Icons.person : Icons.date_range,
                color: const Color(kDarkGreenColor),
                size: 17,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 5, bottom: 3),
                    child: Text(
                      text.toUpperCase(),
                      style: const TextStyle(
                          color: Color(kDarkGreenColor),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: text,
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: const TextStyle(
                            color: Color(kLightGreyColor),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      style: const TextStyle(
                          color: Color(kDarkGreyColor),
                          fontWeight: FontWeight.bold),
                      textInputAction: TextInputAction.done,
                      keyboardType: (text == "Name")
                          ? TextInputType.text
                          : TextInputType.number,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _getScanCNICBtn() {
    return ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(5),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)))),
      onPressed: () {
        /// this is the custom dialog that takes 2 arguments "Camera" and "Gallery"
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(onCameraBTNPressed: () {
                scanCnic(ImageSource.camera);
              }, onGalleryBTNPressed: () {
                scanCnic(ImageSource.gallery);
              });
            });
      },
      child: Container(
        alignment: Alignment.center,
        width: 500,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          gradient: LinearGradient(colors: <Color>[
            Color(kDeepDarkGreenColor),
            Color(kDarkGreenColor),
            Colors.green,
          ]),
        ),
        padding: const EdgeInsets.all(12.0),
        child: const Text('Scan Id', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
