import 'package:falemais/api/webclient.dart';
import 'package:falemais/api/webclients/domain_web_client.dart';
import 'package:falemais/components/bloc_container.dart';
import 'package:falemais/components/progress.dart';
import 'package:falemais/components/response_dialog.dart';
import 'package:falemais/models/area_code.dart';
import 'package:falemais/models/plan.dart';
import 'package:falemais/models/price.dart';
import 'package:falemais/screens/input_form_states.dart';
import 'package:falemais/services/call_price_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputFormCubit extends Cubit<InputFormState> {
  InputFormCubit() : super(InitInputFormState());

  void load(DomainWebClient client) async {
    try {
      emit(LoadingInputFormState());
      List<AreaCode> areaCodes = await client.getAreaCodes();
      List<Plan> plans = await client.getPlans();
      List<Price> prices = await client.getPrices();
      emit(LoadedInputFormState(areaCodes, plans, prices));
    } on HttpException catch (e) {
      emit(ErrorInputFormState(e.message));
    }
  }

  void calculatePrice(AreaCode originCode, AreaCode targetCode, Plan plan,
      int callDurationInMinutes, List<Price> prices) async {
    CallPriceService callPriceService = CallPriceService(prices);

    try {
      emit(LoadingInputFormState());
      await Future.delayed(Duration(seconds: 2));
      double result = callPriceService.calculateCallPrice(
        originCode.code,
        targetCode.code,
        plan,
        callDurationInMinutes,
      );
      emit(CalculatedCallPriceState(result));
    } on UnsupportedOriginOrTargetException catch (e) {
      emit(ErrorInputFormState(e.message));
    }
  }
}

class InputFormContainer extends BlocContainer {
  final DomainWebClient _client = DomainWebClient(defaultHttpClient);

  @override
  Widget build(BuildContext blocContext) {
    return BlocProvider<InputFormCubit>(
      create: (BuildContext context) {
        final InputFormCubit cubit = InputFormCubit();
        return cubit;
      },
      child: InputFormView(_client),
    );
  }
}

class InputFormView extends StatelessWidget {
  final DomainWebClient _client;

  InputFormView(this._client);

  @override
  Widget build(BuildContext blocContext) {
    return Scaffold(
      appBar: AppBar(title: Text('Calcular ligação')),
      body: BlocBuilder<InputFormCubit, InputFormState>(
        builder: (context, state) {
          if (state is InitInputFormState) {
            blocContext.read<InputFormCubit>().load(_client);
            return Progress(text: 'Carregando...');
          }

          if (state is LoadingInputFormState) {
            return Progress(text: 'Carregando...');
          }

          if (state is LoadedInputFormState) {
            return BasicFormView(state.areaCodes, state.plans, state.prices);
          }

          if (state is CalculatedCallPriceState) {
            return BasicResultView(state.resultedPrice, _client);
          }

          if (state is ErrorInputFormState) {
            return ErrorView(state.message, _client);
          }
          return ErrorView('Erro desconhecido', _client);
        },
      ),
    );
  }
}

class BasicFormView extends StatefulWidget {
  final List<AreaCode> _areaCodes;
  final List<Plan> _plans;
  final List<Price> _prices;

  BasicFormView(this._areaCodes, this._plans, this._prices);

  @override
  _BasicFormViewState createState() =>
      _BasicFormViewState(_areaCodes, _plans, this._prices);
}

class _BasicFormViewState extends State<BasicFormView> {
  AreaCode selectedOriginAreaCode;
  AreaCode selectedTargetAreaCode;
  Plan selectedPlan;
  final List<AreaCode> _areaCodes;
  final List<Plan> _plans;
  final List<Price> _prices;
  final TextEditingController _minutesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _BasicFormViewState(this._areaCodes, this._plans, this._prices)
      : selectedOriginAreaCode = _areaCodes[0],
        selectedTargetAreaCode = _areaCodes[0],
        selectedPlan = _plans[0];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            DropdownButtonFormField<AreaCode>(
              decoration: InputDecoration(labelText: 'DDD de origem'),
              value: selectedOriginAreaCode,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.purple[400], fontSize: 16),
              onChanged: (AreaCode? newValue) {
                setState(() {
                  selectedOriginAreaCode = newValue!;
                });
              },
              items:
                  _areaCodes.map<DropdownMenuItem<AreaCode>>((AreaCode value) {
                return DropdownMenuItem<AreaCode>(
                  value: value,
                  child: Text(value.code.toString()),
                );
              }).toList(),
            ),
            DropdownButtonFormField<AreaCode>(
              decoration: InputDecoration(labelText: 'DDD de destino'),
              value: selectedTargetAreaCode,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.purple[400], fontSize: 16),
              onChanged: (AreaCode? newValue) {
                setState(() {
                  selectedTargetAreaCode = newValue!;
                });
              },
              items:
                  _areaCodes.map<DropdownMenuItem<AreaCode>>((AreaCode value) {
                return DropdownMenuItem<AreaCode>(
                  value: value,
                  child: Text(value.code.toString()),
                );
              }).toList(),
            ),
            DropdownButtonFormField<Plan>(
              decoration: InputDecoration(labelText: 'Plano'),
              value: selectedPlan,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.purple[400], fontSize: 16),
              onChanged: (Plan? newValue) {
                setState(() {
                  selectedPlan = newValue!;
                });
              },
              items: _plans.map<DropdownMenuItem<Plan>>((Plan value) {
                return DropdownMenuItem<Plan>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
            TextFormField(
              controller: _minutesController,
              decoration: InputDecoration(
                labelText: "Duração (em minutos)",
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.purple[400], fontSize: 16),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a duração';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<InputFormCubit>(context).calculatePrice(
                          selectedOriginAreaCode,
                          selectedTargetAreaCode,
                          selectedPlan,
                          int.tryParse(_minutesController.text) ?? 0,
                          _prices);
                    }
                  },
                  child: Text("Calcular"),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class BasicResultView extends BlocContainer {
  final double callPrice;
  final DomainWebClient _client;

  BasicResultView(this.callPrice, this._client);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'O custo da ligação será de:',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${getResult(callPrice)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<InputFormCubit>(context).load(_client);
                },
                child: Text("Voltar"),
              ),
            ),
          )
        ],
      )),
    );
  }

  String getResult(double price) {
    if (price == 0.0) {
      return 'Grátis';
    }
    return 'R\$ ${format(price)}';
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }
}

class ErrorView extends BlocContainer {
  final String message;
  final DomainWebClient _client;

  ErrorView(this.message, this._client);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '$message',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<InputFormCubit>(context).load(_client);
                },
                child: Text("Voltar"),
              ),
            ),
          )
        ],
      )),
    );
  }
}
