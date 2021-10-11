import 'dart:async';
import 'package:arc_flutter1/core/error/failures.dart';
import 'package:arc_flutter1/core/usecases/usecases.dart';
import 'package:arc_flutter1/core/util/input_converter.dart';
import 'package:arc_flutter1/features/number_trivia/domain/entints/number_trivia.dart';
import 'package:arc_flutter1/features/number_trivia/domain/usecases/get_concerate_number.dart';
import 'package:arc_flutter1/features/number_trivia/domain/usecases/get_random_number.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';
class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState>
{
  static const INVALID_INPUT_FAILURE_MESSAGE = 'invalid input';
  static const CACHE_FAILURE_MESSAGE = 'invalid server cashe';
  final GetConcreateNumberTrivia getConcreateNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc(
      {required this.getConcreateNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter}):super(NumberTriviaInitial());
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcerateNumber) {
      final  inputEither =  inputConverter.stringToUnsaignedInteger(event.numberString);
      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      }
      ,(integer) async* {
        final failureOrTrivia =
            await getConcreateNumberTrivia(Params(number: integer));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    }
    else if(event is GetTriviaForRandomNumber){
      yield loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParms());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }
  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> either,
      ) async* {
    yield either.fold(
          (failure) => Error(message: mapFailureToMessage(failure)),
          (trivia) => Loaded(trivia: trivia),
    );
  }
  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return INVALID_INPUT_FAILURE_MESSAGE;
      case CasheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }


}
