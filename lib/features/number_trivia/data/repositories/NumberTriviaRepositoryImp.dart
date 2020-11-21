import 'package:dartz/dartz.dart';
import 'package:mycleanarchitecture/core/error/exceptions.dart';
import 'package:mycleanarchitecture/core/error/failures.dart';
import 'package:mycleanarchitecture/core/network/network_info.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:mycleanarchitecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:mycleanarchitecture/features/number_trivia/domain/repository/number_trivia_repository.dart';

typedef Future<NumberTrivia> Function() _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImp implements NumberTriviaRepository {
  // data sources needed

  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImp(
      {this.remoteDataSource, this.localDataSource, this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(concreteOrRandomTrivia) async {
    if (await networkInfo.isConnected) {
      try {
        NumberTrivia numberTrivia = await concreteOrRandomTrivia();
        localDataSource.cacheNumberTrivia(numberTrivia);
        return Right(numberTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        NumberTrivia numberTrivia = await localDataSource.getLastNumberTrivia();
        return Right(numberTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
