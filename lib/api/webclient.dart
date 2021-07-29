import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

Client defaultHttpClient = HttpClientWithInterceptor.build(
  interceptors: [
    LoggingInterceptor(),
  ],
  requestTimeout: Duration(seconds: 5),
);