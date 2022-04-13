import 'package:flutter/material.dart';

import 'package:flutter_assessment/helpers/api_helper.dart';

ApiHelperInterface apiHelperInterface = ApiHelperInterface(
  isStaging: true,
  // change isStaging = false to make it production env
);

const String kReqresBaseUrl = 'https://reqres.in';
const String kReqresApiVersion = '/api';
const Color kPrimaryColor = Color(0xff32baa5);
const Color kTextColor = Colors.white;
const favouriteStarColor = Color(0xffF2C94C);
