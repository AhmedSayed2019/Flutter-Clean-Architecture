import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mycleanarchitecture/core/error/failures.dart';
import 'package:mycleanarchitecture/core/util/input_converter.dart';

main(){
  InputConverter inputConverter;

  setUp((){
    inputConverter = InputConverter();

  });
  group("stringToUnsignedInteger", (){
    
    test("should return integer when the string represent unsigned integer", (){

      // arrange
      final str= '123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(Right(123)));

    });

    test("should return a Failure when the string is not an  integer", (){

      // arrange
      final str= 'abc';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(Left(InvalidInputConverter())));

    });


    test("should return a Failure when the string is a negative integer", (){

      // arrange
      final str= '-1';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(Left(InvalidInputConverter())));

    });

    
  });
  
}