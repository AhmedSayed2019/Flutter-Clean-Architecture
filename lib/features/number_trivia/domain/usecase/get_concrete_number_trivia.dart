import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';
import 'package:mycleanarchitecture/core/error/failures.dart';
import 'package:mycleanarchitecture/core/usecase/usecase.dart';
import '../entity/number_trivia.dart';

import '../repository/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  // this is the usecase

  // this is the contract class which the usecase will communicate with to get data from third parties
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }

}

// create class to includes all this usecase parameters

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [num];
}
