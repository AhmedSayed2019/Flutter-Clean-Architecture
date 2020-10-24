import 'package:mycleanarchitecture/features/number_trivia/domain/entity/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {

  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<void> cacheNumberTrivia(int number);

  Future<NumberTrivia> getNumberTrivia();

}
