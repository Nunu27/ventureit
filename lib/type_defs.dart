import 'package:fpdart/fpdart.dart';
import 'package:ventureit/models/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
