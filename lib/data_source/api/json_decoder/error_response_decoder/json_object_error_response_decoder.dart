import 'package:injectable/injectable.dart';

import '../../../../index.dart';

@Injectable()
class JsonObjectErrorResponseDecoder extends BaseErrorResponseDecoder<Map<String, dynamic>> {
  @override
  ServerError mapToServerError(Map<String, dynamic>? data) {
    final errorData = data?['error'];
    final errorMap = errorData is Map ? errorData : null;

    final statusCode = errorMap?['status_code'] as int? ?? data?['statusCode'] as int?;
    final generalMessage = errorMap?['message'] as String? ?? data?['message'] as String?;
    final errorCode =
        errorMap?['error_code'] as String? ?? (errorData is String ? errorData : null);

    return ServerError(
      generalServerStatusCode: statusCode,
      generalServerErrorId: errorCode,
      generalMessage: generalMessage,
    );
  }
}
