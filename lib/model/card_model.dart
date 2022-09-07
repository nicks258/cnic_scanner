import 'package:image_picker/image_picker.dart';

/// this class is used to store data from package and display data on user screen

class CardModel {
  String _cardNumber = "";
  String _cardHolderName = "";
  String _cardExpiry = "";
  String _cardHolderNationality = "";
  String _cardHolderGender = "";
  String _cardHolderDateOfBirth = "";
  XFile? _cardFile;
  //
  // @override
  // String toString() {
  //   var string = '';
  //   string += _cardNumber.isEmpty ? "" : 'Cnic Number = $cardNumber\n';
  //   string +=
  //       _cardExpiry.isEmpty ? "" : 'Cnic Expiry Date = $cardExpiry\n';
  //   string += _cardHolderNationality.isEmpty ? "" : 'Nationality = $_cardHolderNationality\n';
  //   string +=
  //       _cardHolderName.isEmpty ? "" : 'Cnic Holder Name = $cardHolderName\n';
  //   string += _cardHolderDateOfBirth.isEmpty
  //       ? ""
  //       : 'Cnic Holder DoB = $cardHolderDateOfBirth\n';
  //   return string;
  // }

  String get cardNumber => _cardNumber;
  String get cardHolderName => _cardHolderName;

  String get cardExpiry => _cardExpiry;

  String get cardHolderDateOfBirth => _cardHolderDateOfBirth;
  String get cardHolderGender => _cardHolderGender;
  String get cardHolderNationality => _cardHolderNationality;
  XFile? get cardFile => _cardFile;
  set cardHolderDateOfBirth(String value) {
    _cardHolderDateOfBirth = value;
  }

  set cardHolderNationality(String value) {
    _cardHolderNationality = value;
  }

  set cardHolderGender(String value) {
    _cardHolderGender = value;
  }

  set cardExpiry(String value) {
    _cardExpiry = value;
  }

  set cardHolderName(String value) {
    _cardHolderName = value;
  }

  set cardFile(XFile? value) {
    _cardFile = value;
  }

  set cardNumber(String value) {
    _cardNumber = value;
  }
}
