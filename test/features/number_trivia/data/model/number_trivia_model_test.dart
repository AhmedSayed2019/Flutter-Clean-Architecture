import 'package:flutter_test/flutter_test.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/entity/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  // model for test

  final NumberTriviaModel tModel =
      NumberTriviaModel(text: "test text", number: 5);

  test('NumberTriviaModel shoud be an instance of its entitiy (NumberTrivia)',
      () {
    // arrange => not needed
    // act => not needed
    // assert
    expect(tModel, isA<NumberTrivia>());
  });

  // test that event json response with integer will return model in integer or double also return model with integer
  group('fromJson', () {
    test('should return valid model when json number is an integer', () {
      // arrange
      String json = fixture("trivia.json");
      // act
      NumberTriviaModel numberTriviaModel = NumberTriviaModel.fromJson(json);
      // assert
      expect(numberTriviaModel, equals(tModel));
    });

    test('should return valid model when json number is a double', () {
      // arrange
      String json = fixture("trivia_double.json");
      // act
      NumberTriviaModel numberTriviaModel = NumberTriviaModel.fromJson(json);
      // assert
      expect(numberTriviaModel, equals(tModel));
    });
  });

  // test toMap method
  group('toMap', () {
    test('should return Map containing the proper date', () {
      // arrange=> not needed
      // act
      final Map<String, dynamic> result = tModel.toMap();

      // assert
      final Map<String, dynamic> expectedMap = {
        "text": "test text",
        "number": 5
      };

      expect(result, equals(expectedMap));
    });
  });

}
