import 'package:mycleanarchitecture/features/number_trivia/domain/entity/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {

  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  Future<NumberTrivia> getRandomNumberTrivia();

}
