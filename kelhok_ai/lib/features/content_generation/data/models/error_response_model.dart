import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_response_model.g.dart';

/// Data model for error response from the API
@JsonSerializable()
class ErrorResponseModel extends Equatable {
  @JsonKey(name: 'detail')
  final String detail;

  const ErrorResponseModel({
    required this.detail,
  });

  /// Creates an ErrorResponseModel from JSON
  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseModelFromJson(json);

  /// Converts the ErrorResponseModel to JSON
  Map<String, dynamic> toJson() => _$ErrorResponseModelToJson(this);

  @override
  List<Object?> get props => [detail];
} 