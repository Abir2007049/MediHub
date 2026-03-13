import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihub/core/di/service_locator.dart';

BlocProvider<T> appBlocProvider<T extends StateStreamableSource<Object?>>() {
  return BlocProvider<T>(create: (_) => sl<T>());
}
