import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// map one by one with the General Exception
class CacheFailure extends Failure {}

class ServerFailure extends Failure {}
