import 'package:equatable/equatable.dart';

/// Abstract failure class that all concrete failures should extend
abstract class Failure extends Equatable {
  final String message;
  
  const Failure({required this.message});
  
  @override
  List<Object?> get props => [message];
}

/// Server failure - when API returns an error response
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Network failure - when there's no internet connection or network issues
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Parsing failure - when JSON parsing fails
class ParsingFailure extends Failure {
  const ParsingFailure({required super.message});
}

/// General failure - for unexpected errors
class GeneralFailure extends Failure {
  const GeneralFailure({required super.message});
} 