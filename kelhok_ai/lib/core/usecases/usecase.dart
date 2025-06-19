import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base use case interface
/// [Type] is the return type
/// [Params] is the parameter type that the use case expects
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case class for when no parameters are needed
class NoParams {} 