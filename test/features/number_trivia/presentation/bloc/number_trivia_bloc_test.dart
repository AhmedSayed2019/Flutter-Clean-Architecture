// required instances
// 1. use-cases
// 2. input converter

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mycleanarchitecture/core/error/failures.dart';
import 'package:mycleanarchitecture/core/util/input_converter.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:mycleanarchitecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mycleanarchitecture/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:mycleanarchitecture/features/number_trivia/presentation/bloc/number_trivia_state.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;

  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState Should be Empty', () {
    // arrange => not needed
    // act => not needed
    // assert
    expect(bloc.state, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final String testNumberString = "1";
    final int testNumberParsed = 1;
    final NumberTrivia testNumberTrivia =
        NumberTrivia(number: 1, text: 'test text');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(testNumberParsed));

    // awl 7aga ht7sal lma el event da ybda2 eh ?
    test(
        'should call InputConverter to validate and convert input to unsigned integer',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(testNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(testNumberString));
      // it take some time for the bloc to execute the login inside mapEventToState()
      // so  we should wait to be executed => otherwise verify will be executed first
      await untilCalled(
          mockInputConverter.stringToUnsignedInteger(testNumberString));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
    });

    // like [Error()]
    test('should emits [Error] when input is invalid', () {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      // assert later
      final expected = [
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(
          bloc,
          emitsInOrder(
              expected)); // this expectLater will wait up to 30 seconds

      // act
      bloc.add(GetTriviaForConcreteNumber(
          testNumberString)); //to expect the state that should be emitted we should use expectLater that the states of bloc in precise order list
    });

    test('should call getConcreteNumberTrivia usecase', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(testNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(testNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: testNumberParsed)));
    });

    test('should emmit [Loading(), Loaded()] when data gotten successfully',
        () {
      //arrange
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(testNumberTrivia));

      //assert later
      final expects = [Loading(), Loaded(trivia: testNumberTrivia)];
      expectLater(bloc, emitsInOrder(expects));

      //act
      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));

      // assert later
      final expects = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expects));

      // act
      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });

    test(
        'should emit [Loading, Error] when getting data fails with proper message',
        () {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(CacheFailure()));

      // assert later
      final expects = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expects));

      // act
      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final NumberTrivia testNumberTrivia =
        NumberTrivia(number: 1, text: 'test text');

    test('should call getRandomNumberTrivia usecase', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(testNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emmit [Loading(), Loaded()] when data gotten successfully',
        () {
      //arrange

      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(testNumberTrivia));

      //assert later
      final expects = [Loading(), Loaded(trivia: testNumberTrivia)];
      expectLater(bloc, emitsInOrder(expects));

      //act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));

      // assert later
      final expects = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expects));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] when getting data fails with proper message',
        () {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(CacheFailure()));

      // assert later
      final expects = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expects));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
