import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mycleanarchitecture/core/error/exceptions.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/model/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

// test the remote data source
// which depends on http.Client, so that we will create a mock for it
class MockHttpClient extends Mock implements http.Client {}

main() {
  MockHttpClient httpClient;
  NumberTriviaRemoteDataSourceImp remoteDataSourceImp;
  setUp(() {
    httpClient = MockHttpClient();
    remoteDataSourceImp = NumberTriviaRemoteDataSourceImp(client: httpClient);
  });

  void setupMockHttpClientFailure404() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong!', 404));
  }
  void setupMockHttpClientSuccess200() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  group('getConcreteNumberTrivia', () {
    int testNumber = 5;
    NumberTriviaModel testNumberTriviaModel =
        NumberTriviaModel.fromJson(fixture('trivia.json'));

    test(
        'should perform GET request on a URL with number '
        'as end-point and application/json header', () {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      remoteDataSourceImp.getConcreteNumberTrivia(testNumber);

      // assert
      verify(httpClient.get('http://numbersapi.com/$testNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTriviaModel when response code 200 (success)',
        () async {
      // arrange
          setupMockHttpClientSuccess200();
      // act
      final result =
          await remoteDataSourceImp.getConcreteNumberTrivia(testNumber);

      // assert
      expect(result, equals(testNumberTriviaModel));
    });
    test('should return ServerException when response code not 200 (failure)',
        () async {
      // arrange
          setupMockHttpClientFailure404();
      // act
      final call = remoteDataSourceImp.getConcreteNumberTrivia;

      // assert
      expect(
          () => call((testNumber)), throwsA(isInstanceOf<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    NumberTriviaModel testNumberTriviaModel =
        NumberTriviaModel.fromJson(fixture('trivia.json'));

    test(
        'should perform GET request on a URL with randome '
        'as end-point and application/json header', () {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      remoteDataSourceImp.getRandomNumberTrivia();

      // assert
      verify(httpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTriviaModel when response code 200 (success)',
        () async {
      // arrange
          setupMockHttpClientSuccess200();
      // act
      final result =
          await remoteDataSourceImp.getRandomNumberTrivia();

      // assert
      expect(result, equals(testNumberTriviaModel));
    });

    test('should return ServerException when response code  404 (failure)',
        () async {
      // arrange
          setupMockHttpClientFailure404();
      // act
      final call = remoteDataSourceImp.getRandomNumberTrivia;

      // assert
      expect(
          () => call(), throwsA(isInstanceOf<ServerException>()));
    });
  });
}


