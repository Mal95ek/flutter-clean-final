part of 'number_trivia_bloc.dart';
abstract class NumberTriviaState extends Equatable {
  List<Object> get props => [];
}
class NumberTriviaInitial extends NumberTriviaState {

}
class loading extends NumberTriviaState {

}
class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({required this.trivia});
  List<Object> get props => [trivia];
}
class Error extends NumberTriviaState {
  final String message;
  Error({required this.message});
  List<Object> get props => [message];
}


