import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/usecase/get_concrete_number_trivia.dart';
import '../../domain/usecase/get_random_number_trivia.dart';
import 'number_trivia_event.dart';
import 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  // this bloc will receive events
  // with string number
  // convert it into int to check if valid

  // valid=> continue to call the usecase
  // invalid => show Error message

  // required instances for this bloc are:
  // 1. instance of Concrete use-case
  // 2. instance of Random use-case
  // 3. instance of input converter

  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(random != null),
        assert(concrete != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        yield Empty();
      }, (integer) async* {


        final failureOrTrivia =
        await getConcreteNumberTrivia(Params(number: 1));


      });
    }
  }
}
