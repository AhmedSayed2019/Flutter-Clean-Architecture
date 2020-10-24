import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {
// mock class of the repository which this usecase depends on
}

// TODO: we will test the usecase
void main() {
  // repository class
  MockNumberTriviaRepository mockNumberTriviaRepository;

  // usecase
  GetRandomNumberTrivia usecase;

  setUp(() {
    // this is  the setup method exits in any test class=> invoked before and test run

    // initialize the repository mock class
    mockNumberTriviaRepository = MockNumberTriviaRepository();

    //  initialize the use case
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final int testNumber = 1;
  final NumberTrivia testNumberTrivia =
      NumberTrivia(number: 1, text: "test random number text");
  test(
    "get random trivia from repository",
    () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((value) async => Right(testNumberTrivia));
      // act

      final result = await usecase(NoParams());

      // assert
      expect(result,
          Right(testNumberTrivia)); //  expecting the result should be = value

      verify(mockNumberTriviaRepository.getRandomNumberTrivia()); // verify that the result of the use case call the right method from repository

      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}

// this test really act like documentation for the functionality which we are about to implement
