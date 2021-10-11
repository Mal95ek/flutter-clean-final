import 'package:arc_flutter1/features/number_trivia/presention/bloc/number_trivia_bloc.dart';
import 'package:arc_flutter1/features/number_trivia/presention/widget/loading_widget.dart';
import 'package:arc_flutter1/features/number_trivia/presention/widget/message_display.dart';
import 'package:arc_flutter1/features/number_trivia/presention/widget/trivia_controler.dart';
import 'package:arc_flutter1/features/number_trivia/presention/widget/trivia_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import 'package:flutter/widgets.dart';
class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }
  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
          child: Padding(
          padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(

            builder: (context, state) {
               if (state is NumberTriviaInitial) {
              return MessageDisplay(message: 'state search',) ;
              }
               if (state is loading) {
              return LoadingWidget();
              }


              else if (state is Loaded){
                return TriviaDisplay(
                  numberTrivia: state.trivia,
                );
              }
              else if (state is Error) {
                return MessageDisplay(
                  message: state.message,
                );
              }
          return Container();
            },
          ),
          SizedBox(height: 20),

          TriviaControls()
        ],
      ),
    ),
    );
  }
}
