import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/res/strings.dart';

const genderToStrMap = {
  UserGender.male: maleGender,
  UserGender.female: femaleGender,
};

const sexualOrientationToStrMap = {
  SexualOrientation.straight: straightSexualOrientationLbl,
  SexualOrientation.questioning: questioningSexualOrientationLbl,
  SexualOrientation.queer: queerSexualOrientationLbl,
  SexualOrientation.panSexual: panSexualSexualOrientationLbl,
  SexualOrientation.demiSexual: demiSexualSexualOrientationLbl,
  SexualOrientation.bisexual: biSexualSexualOrientationLbl,
  SexualOrientation.asexual: asexualSexualOrientationLbl,
  SexualOrientation.gay: gaySexualOrientationLbl,
};
