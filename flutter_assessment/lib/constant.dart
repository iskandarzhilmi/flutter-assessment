import 'package:flutter_assessment/helpers/api_helper.dart';

ApiHelperInterface apiHelperInterface = ApiHelperInterface(
  isStaging: true,
  // change isStaging = false to make it production env
);

const String kReqresBaseUrl = 'https://reqres.in';
const String kReqresApiVersion = '/api';
