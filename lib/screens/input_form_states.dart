import 'package:falemais/models/area_code.dart';
import 'package:falemais/models/plan.dart';
import 'package:falemais/models/price.dart';
import 'package:flutter/material.dart';

@immutable
abstract class InputFormState {
  const InputFormState();
}

@immutable
class InitInputFormState extends InputFormState {
  const InitInputFormState();
}

@immutable
class LoadingInputFormState extends InputFormState {
  const LoadingInputFormState();
}

@immutable
class LoadedInputFormState extends InputFormState {
  final List<AreaCode> areaCodes;
  final List<Plan> plans;
  final List<Price> prices;

  const LoadedInputFormState(this.areaCodes, this.plans, this.prices);
}

@immutable
class ErrorInputFormState extends InputFormState {
  final String message;

  ErrorInputFormState(this.message);
}

@immutable
class CalculatingCallPriceState extends InputFormState {
  const CalculatingCallPriceState();
}

@immutable
class CalculatedCallPriceState extends InputFormState {
  final double resultedPrice;

  CalculatedCallPriceState(this.resultedPrice);
}