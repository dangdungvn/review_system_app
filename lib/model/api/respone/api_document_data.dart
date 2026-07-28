import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_document_data.freezed.dart';
part 'api_document_data.g.dart';

@freezed
sealed class ApiDocumentData with _$ApiDocumentData {
  const ApiDocumentData._();

  const factory ApiDocumentData({
    @Default(0) int id,
    @Default('') String title,
    String? description,
    @Default('') String originalFileName,
    @Default('') String filePath,
    @Default(0) int fileSize,
    @Default('') String status,
  }) = _ApiDocumentData;

  factory ApiDocumentData.fromJson(Map<String, dynamic> json) =>
      _$ApiDocumentDataFromJson(json);
}
