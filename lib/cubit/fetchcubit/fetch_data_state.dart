part of 'fetch_data_cubit.dart';

@immutable
sealed class FetchDataState {}

final class FetchDataInitial extends FetchDataState {}

final class FetchDataLoading extends FetchDataState {}

final class FetchDataSuccess extends FetchDataState {}

final class FetchDataFailure extends FetchDataState {
  String error;
  FetchDataFailure(this.error);
}
