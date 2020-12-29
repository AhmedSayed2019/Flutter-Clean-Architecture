import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mycleanarchitecture/core/network/network_info.dart';
import 'package:mycleanarchitecture/core/util/input_converter.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/repositories/NumberTriviaRepositoryImp.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:mycleanarchitecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/domain/repository/number_trivia_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features

  // bloc
  sl.registerFactory(() =>
      NumberTriviaBloc(inputConverter: sl(), random: sl(), concrete: sl()));

  //use-case
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImp(
          localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));

  // data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImp(client: sl()));

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImp(sharedPreferences: sl()));

  // Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Externals

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
