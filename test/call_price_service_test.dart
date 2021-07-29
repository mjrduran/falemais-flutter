
import 'package:falemais/models/plan.dart';
import 'package:falemais/models/price.dart';
import 'package:falemais/services/call_price_service.dart';
import 'package:flutter_test/flutter_test.dart';

List<Price> emptyPricesTest = [];

List<Price> fullPriceListTest = [
  Price(11, 16, 1.9),
  Price(16, 11,  2.9),
  Price(11, 17, 1.7),
  Price(17, 11, 2.7),
  Price(11, 18, 0.9),
  Price(18, 11, 1.9)
];

Plan tarifaFixa = Plan('tarifa-fixa','Tarifa Fixa', 0, 0);
Plan faleMais30 = Plan('falemais-30','FaleMais 30', 30, 0.1);
Plan faleMais60 = Plan('falemais-60','FaleMais 60', 60, 0.1);
Plan faleMais120 = Plan('falemais-120','FaleMais 120', 120, 0.1);

void main() {
  CallPriceService callPriceService = CallPriceService(fullPriceListTest);

  test('Should throw error when price list is empty', () {
    expect(() => CallPriceService(emptyPricesTest), throwsAssertionError);
  });

  test('Should throw exception when calculate with invalid origin or target codes', () {
    expect(() => callPriceService.calculateCallPrice(11, 11, tarifaFixa, 10), throwsException);
  });

  test('Should be free when call duration is shorter than freeTimeInMinutes', () {
    double price = callPriceService.calculateCallPrice(11, 16, faleMais30, 29);
    expect(price, 0.0);
  });

  test('Should be free when call duration is shorter than freeTimeInMinutes', () {
    double price = callPriceService.calculateCallPrice(11, 16, faleMais60, 59);
    expect(price, 0.0);
  });

  test('Should be free when call duration is shorter than freeTimeInMinutes', () {
    double price = callPriceService.calculateCallPrice(11, 16, faleMais120, 119);
    expect(price, 0.0);
  });

  test('Should pay for extra minutes when call duration is larger than freeTimeInMinutes', () {
    double price = callPriceService.calculateCallPrice(11, 16, faleMais30, 31);
    expect(price, 2.09);
  });

  test('Should pay for extra minutes when call duration is larger than freeTimeInMinutes', () {
    double price = callPriceService.calculateCallPrice(11, 16, faleMais60, 61);
    expect(price, 2.09);
  });

  test('Should pay for extra minutes when call duration is larger than freeTimeInMinutes', () {
    double price = callPriceService.calculateCallPrice(11, 16, faleMais120, 121);
    expect(price, 2.09);
  });

  test('When calling with Tarifa fixa plan no free minutes are discounted', (){
      double price = callPriceService.calculateCallPrice(11, 16, tarifaFixa, 20);
      expect(price, 38.0);
  });
}