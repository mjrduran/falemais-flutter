import 'package:falemais/models/plan.dart';
import 'package:falemais/models/price.dart';

class CallPriceService {
  final List<Price> _prices;

  CallPriceService(this._prices): assert(_prices.length > 0);

  double calculateCallPrice(
    int originCode,
    int targetCode,
    Plan plan,
    int callDurationInMinutes,
  ) {
    try {
      Price price = _prices.firstWhere((element) {
        return element.fromCode == originCode &&
            element.toCode == targetCode;
      });

      if (callDurationInMinutes <= plan.freeTimeInMinutes){
        return 0;
      }
      int extraMinutes = callDurationInMinutes - plan.freeTimeInMinutes;

      double partialResult = price.price * extraMinutes;
      double finalResult = partialResult + (partialResult * plan.additionalMinuteRate);
      return finalResult;
    } on StateError {
      throw UnsupportedOriginOrTargetException('Origem ou destino não é suportado');
    }
  }
}

class UnsupportedOriginOrTargetException implements Exception {
  final String message;

  UnsupportedOriginOrTargetException(this.message);
}