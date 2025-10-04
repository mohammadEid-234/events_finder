import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CountryCode {
  final String name;
  final IsoCode iso2;
  final String dialCode;

  CountryCode({
    required this.name,
    required this.iso2,
    required this.dialCode,
  });


  /// Factory constructor to create from JSON
  factory CountryCode.fromJson(Map<String, dynamic> json) {


    return CountryCode(
      name: json['name'] as String,
      iso2: isoCodeConversionMap[json["iso2"]]??IsoCode.PS,
      dialCode: json['dial_code'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iso2': iso2,
      'dial_code': dialCode,
    };
  }

  @override
  String toString() => '$name ($iso2) $dialCode';
}
