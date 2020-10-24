import 'dart:convert';

import 'package:mycleanarchitecture/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:meta/meta.dart';

// model class
class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({@required String text, @required int number})
      : super(text: text, number: number); // pass the data to parent

  factory NumberTriviaModel.fromJson(String str) =>
      NumberTriviaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NumberTriviaModel.fromMap(Map<String, dynamic> json) =>
      NumberTriviaModel(
        text: json["text"],
        number: (json["number"] as num).toInt(),
      );

  Map<String, dynamic> toMap() => {
        "text": text,
        "number": number,
      };
}
