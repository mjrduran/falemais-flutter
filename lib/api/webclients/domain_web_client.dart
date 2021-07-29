import 'dart:convert';

import 'package:falemais/models/area_code.dart';
import 'package:falemais/models/plan.dart';
import 'package:falemais/models/price.dart';
import 'package:http/http.dart';

class DomainWebClient {
  final Client client;
  final String baseAuthority;

  const DomainWebClient(this.client,
      {this.baseAuthority: 'your_url_goes_here'});

  static const areCodePath = 'area-codes';
  static const plansPath = 'plans';
  static const pricesPath = 'prices';

  static const defaultErrorMessage =
      'Ocorreu um erro inesperado. Tente novamente mais tarde';

  Future<List<AreaCode>> getAreaCodes() async {
    try {
      Response response =
          await client.get(Uri.https(baseAuthority, areCodePath));

      if (response.statusCode == 200) {
        List<dynamic> areaCodeList = jsonDecode(response.body);
        return areaCodeList
            .map((dynamic json) => AreaCode.fromJson(json))
            .toList();
      }

      throw _getException(response.statusCode);
    } catch (error) {
      throw HttpException(defaultErrorMessage);
    }
  }

  Future<List<Plan>> getPlans() async {
    try {
      Response response = await client.get(Uri.https(baseAuthority, plansPath));

      if (response.statusCode == 200) {
        List<dynamic> planList = jsonDecode(response.body);
        return planList.map((dynamic json) => Plan.fromJson(json)).toList();
      }

      throw _getException(response.statusCode);
    } catch (error) {
      throw HttpException(defaultErrorMessage);
    }
  }

  Future<List<Price>> getPrices() async {
    try {
      Response response =
          await client.get(Uri.https(baseAuthority, pricesPath));

      if (response.statusCode == 200) {
        List<dynamic> planList = jsonDecode(response.body);
        return planList.map((dynamic json) => Price.fromJson(json)).toList();
      }

      throw _getException(response.statusCode);
    } catch (error) {
      throw HttpException(defaultErrorMessage);
    }
  }

  Exception _getException(statusCode) {
    return HttpException(getMessage(statusCode));
  }

  String getMessage(statusCode) {
    return httpErrors[statusCode] ?? defaultErrorMessage;
  }

  static Map<int, String> httpErrors = {
    404: 'Serviço não encontrado. Tente novamente mais tarde',
    500: defaultErrorMessage,
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
