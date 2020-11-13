import 'package:dartz/dartz.dart';
import 'package:mycleanarchitecture/core/error/failures.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/entity/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {


  /// Cashes the [NumberTriviaModel]
  Future<void> cacheNumberTrivia(NumberTrivia numberTrivia);

  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTrivia> getLastNumberTrivia();

}
