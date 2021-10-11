import 'package:arc_flutter1/features/number_trivia/data/repositories/NumberTriviaRepositoriesImp.dart';
import 'package:arc_flutter1/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:arc_flutter1/features/number_trivia/domain/usecases/get_concerate_number.dart';
import 'package:arc_flutter1/features/number_trivia/domain/usecases/get_random_number.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivie_local__data.dart';
import 'features/number_trivia/presention/bloc/number_trivia_bloc.dart';
final sl = GetIt.instance;
Future<void> init() async {
  sl.registerFactory(() => NumberTriviaBloc(getConcreateNumberTrivia: sl(), getRandomNumberTrivia: sl(), inputConverter: sl(),
  ));
  sl.registerLazySingleton(() => GetConcreateNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  sl.registerLazySingleton<NumberTriviaRepositories>(() => NumberTriviaRepositoriesIml
    (remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
        () => NumberTriviaRemoteDataSourceIml(client: sl()),);
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
        () => NumberTriviaLocalDataSourceIml(sharedPreferences: sl()),
  );
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}


