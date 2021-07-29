

import 'package:bloc_test/bloc_test.dart';
import 'package:falemais/api/webclient.dart';
import 'package:falemais/api/webclients/domain_web_client.dart';
import 'package:falemais/models/area_code.dart';
import 'package:falemais/models/plan.dart';
import 'package:falemais/models/price.dart';
import 'package:falemais/screens/input_form.dart';
import 'package:falemais/screens/input_form_states.dart';
import 'package:test/test.dart';


void main(){
    group('InputFormCubit', () {
    late InputFormCubit cubit;
    DomainWebClient client = DomainWebClient(defaultHttpClient);
    DomainWebClient invalidClient = DomainWebClient(defaultHttpClient, baseAuthority: 'invalid');
    List<Price> fullPriceListTest = [
      Price(11, 16, 1.9),
      Price(16, 11,  2.9),
      Price(11, 17, 1.7),
      Price(17, 11, 2.7),
      Price(11, 18, 0.9),
      Price(18, 11, 1.9)
    ];
    Plan tarifaFixa = Plan('tarifa-fixa','Tarifa Fixa', 0, 0);

    setUp(() {
      cubit = InputFormCubit();
    });

    test('Should be InitInputFormState when created', () {
        expect(cubit.state,  TypeMatcher<InitInputFormState>());
    });

    blocTest(
      'Should emit LoadingInputFormState and LoadedInputFormState when load is called',
      build: () => cubit,
      act: (bloc) => cubit.load(client),
      expect: () => [TypeMatcher<LoadingInputFormState>(), TypeMatcher<LoadedInputFormState>()],
    );

    blocTest(
      'Should emit CalculatedCallPriceState when calculatePrice is called',
      build: () => cubit,
      act: (bloc) => cubit.calculatePrice(AreaCode(11, ""), AreaCode(16, ""), tarifaFixa, 10, fullPriceListTest),
      expect: () => [TypeMatcher<LoadingInputFormState>(), TypeMatcher<CalculatedCallPriceState>()],
    );

    blocTest(
      'Should emit LoadingInputFormState and ErrorInputFormState when invalid client url is called',
      build: () => cubit,
      act: (bloc) => cubit.load(invalidClient),
      expect: () => [TypeMatcher<LoadingInputFormState>(), TypeMatcher<ErrorInputFormState>()],
    );
  });
}