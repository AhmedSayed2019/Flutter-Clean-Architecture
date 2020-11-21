import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:mycleanarchitecture/core/error/exceptions.dart';
import 'package:mycleanarchitecture/core/error/failures.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  /// Cashes the [NumberTriviaModel]
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);

  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();
}

const CACHED_NUMBER_TRIVIA_KEY = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImp implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImp({@required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) {
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA_KEY, numberTriviaModel.toJson());
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    //  shared preferences get data synchronously =
    //  but we predict that the method returns Future because in case we want use
    //  other package it probably works asynchronously so your function will work as well
    String jsonTrivia = sharedPreferences.getString(CACHED_NUMBER_TRIVIA_KEY);
    if (jsonTrivia != null) {
      return Future.value(NumberTriviaModel.fromJson(jsonTrivia));
    } else {
      throw CacheException();
    }
  }

}
