// base class for all use cases
// Type=> return type,
import 'package:dartz/dartz.dart';
import 'package:mycleanarchitecture/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
