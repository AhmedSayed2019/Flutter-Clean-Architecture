import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mycleanarchitecture/core/error/exceptions.dart';
import 'package:mycleanarchitecture/core/error/failures.dart';
import 'package:mycleanarchitecture/core/network/network_info.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/repositories/NumberTriviaRepositoryImp.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/entity/number_trivia.dart';

// create mocks for the abstarct classes of data sources which the repositoryImp will depend on

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImp repository;

  MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImp(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is connected to network', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
        body();
      });
    });
  }

  void runTestsOffline(Function body) {
    group('device is not connected to network', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
        body();
      });
    });
  }

  // group for test getConcreteNumberTrivia method with its probabilities
  group("getConcreteNumberTrivia", () {
    // constants for testing
    // test parameter
    int testNumber = 5;

    // check isNetwork called
    test('check that isConnected method called & device is Connected', () async {
      // arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      //act
      await repository.getConcreteNumberTrivia(testNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    // constant model result
    final NumberTriviaModel testNumberModel =
        NumberTriviaModel(number: testNumber, text: "test text");
    // constant entity result
    final NumberTrivia testEntity = testNumberModel;

    runTestsOnline(() {
      test('should return data when call to remote data success', () async {
        // arrange => ask your self what is the end of this flow and what it should return
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => testNumberModel);

        // act
        final result = await repository.getConcreteNumberTrivia(testNumber);

        // assert
        // end of flow is called with the same value of start the flow
        verify(mockNumberTriviaRemoteDataSource
            .getConcreteNumberTrivia(testNumber));

        expect(result, equals(Right(testEntity)));
      });

      test('should cach data when call to remote data success', () async {
        // arrange => ask your self what is the end of this flow and what it should return
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => testNumberModel);

        // act
        final result = await repository.getConcreteNumberTrivia(testNumber);

        // assert

        // remoteSource.getConcreteNumberTrivia() is called with the same value of start the flow
        verify(mockNumberTriviaRemoteDataSource
            .getConcreteNumberTrivia(testNumber));

        // localSource.cacheNumberTrivia() is called with the same success result
        verify(
            mockNumberTriviaLocalDataSource.cacheNumberTrivia(testNumberModel));
      });

      test('should return ServerFailure when call to remote data unsuccess', () async {
        // arrange => ask your self what is the end of this flow and what it should return
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        // act
        final result = await repository.getConcreteNumberTrivia(testNumber);

        // assert

        // remoteSource.getConcreteNumberTrivia() is called with the same value of start the flow
        verify(mockNumberTriviaRemoteDataSource
            .getConcreteNumberTrivia(testNumber));

        // localSource not being called
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);

        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline( () {
      test('should return data when cached data present', () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => testNumberModel);

        // act
        final result = await repository.getConcreteNumberTrivia(testNumber);

        // assert
        // localSource getLastNumberTrivia() is called
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());

        // remote source getConcreteNumberTrivia is not called
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);

        expect(result, equals(Right(testEntity)));
      });

      test('should return CachFailure when no cached data', () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await repository.getConcreteNumberTrivia(testNumber);

        // assert
        // localSource getLastNumberTrivia() is called
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());

        // remote source getConcreteNumberTrivia is not called
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);

        expect(result, equals(Left(CacheFailure())));
      });
    });

  });


  // group for test getRandomNumberTrivia method with its probabilities
  group("getRandomNumberTrivia", () {
    // constants for testing

    // check isNetwork called
    test('check that isConnected method called & device is Connected', () async {
      // arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      //act
      await repository.getRandomNumberTrivia();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    // constant model result
    final NumberTriviaModel testNumberModel =
        NumberTriviaModel(number: 123, text: "test text");
    // constant entity result
    final NumberTrivia testEntity = testNumberModel;

    runTestsOnline(() {
      test('should return data when call to remote data success', () async {
        // arrange => ask your self what is the end of this flow and what it should return
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => testNumberModel);

        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        // end of flow is called with the same value of start the flow
        verify(mockNumberTriviaRemoteDataSource
            .getRandomNumberTrivia());

        expect(result, equals(Right(testEntity)));
      });

      test('should cach data when call to remote data success', () async {
        // arrange => ask your self what is the end of this flow and what it should return
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => testNumberModel);

        // act
        final result = await repository.getRandomNumberTrivia();

        // assert

        // remoteSource.getConcreteNumberTrivia() is called with the same value of start the flow
        verify(mockNumberTriviaRemoteDataSource
            .getRandomNumberTrivia());

        // localSource.cacheNumberTrivia() is called with the same success result
          verify(
            mockNumberTriviaLocalDataSource.cacheNumberTrivia(testNumberModel));
      });

      test('should return ServerFailure when call to remote data unsuccess', () async {
        // arrange => ask your self what is the end of this flow and what it should return
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        // act
        final result = await repository.getRandomNumberTrivia();

        // assert

        // remoteSource.getConcreteNumberTrivia() is called with the same value of start the flow
        verify(mockNumberTriviaRemoteDataSource
            .getRandomNumberTrivia());

        // localSource not being called
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);

        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline( () {
      test('should return data when cached data present', () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => testNumberModel);

        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        // localSource getLastNumberTrivia() is called
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());

        // remote source getConcreteNumberTrivia is not called
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);

        expect(result, equals(Right(testEntity)));
      });
      test('should return CachFailure when no cached data', () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        // localSource getLastNumberTrivia() is called
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());

        // remote source getConcreteNumberTrivia is not called
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });


}
