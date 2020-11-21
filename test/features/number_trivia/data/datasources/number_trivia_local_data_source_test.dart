// test local data source

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mycleanarchitecture/core/error/exceptions.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  // our local data source will be the shared preferences
  // so we need to create a mock of SharedPreferences
}

main() {
  // we 'll test the local data source, so we should create an instance of
  // LocalDataSourceImp and pass the mocked preferences
  // to be able to test the implementation of each method
  // getLastNumberTrivia
  // cashNumberTrivia

  NumberTriviaLocalDataSourceImp localDataSourceImp;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSourceImp = NumberTriviaLocalDataSourceImp(
        sharedPreferences: mockSharedPreferences);
  });

  // now we are ready to write test for getting last cashed number trivia

  // => create a group for each case probabilities:
  // for example here, if there getCashedObject - may get or not get data
  // so this is a group of getting cached object
  // first test: if there is an object cached
  // second test: if there is no objects cached

  // so for testing local data source to get and cash data we should have two groups

  group("getLastNumberTrivia", () {
    test("should return NumberTriviaModel when there is one cached", () async {
      NumberTriviaModel testCashedObject =
      NumberTriviaModel.fromJson(fixture("cached_trivia.json"));
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture("cached_trivia.json"));
      // act
      final result = await localDataSourceImp.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA_KEY));

      expect(result, equals(testCashedObject));
    });

    test("should return CachException when there is no-cache", () async {
      NumberTriviaModel testCashedObject =
      NumberTriviaModel.fromJson(fixture("cached_trivia.json"));
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(null); // the value when shared preferences has no cache
      // act
      final call = localDataSourceImp.getLastNumberTrivia;
      // assert
      expect(
              () => call(),
          throwsA(isInstanceOf<
              CacheException>())); // isInstanceOf instead od deprecated TypeMatcher
    });
  });

  group("cacheNumberTrivia", () {
    test("should call SharedPerefrences to cache data", () async {
      NumberTriviaModel testCashedObject =
      NumberTriviaModel(number: 5, text: "test");
      // arrange
      // act
      await localDataSourceImp.cacheNumberTrivia(testCashedObject);
      // assert
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA_KEY, testCashedObject.toJson()));
    });
  });
}
