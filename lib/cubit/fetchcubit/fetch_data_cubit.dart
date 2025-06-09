import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:test_app/models/finance_model.dart';

part 'fetch_data_state.dart';
class FetchDataCubit extends Cubit<FetchDataState> {
  FetchDataCubit() : super(FetchDataInitial());

  List<FinanceModel> financeList = [];         // all entries
  List<FinanceModel> todayFinanceList = [];    // only today entries
  List<FinanceModel> filteredFinanceList = []; // filtered by date or all
  double valuesSum = 0.0;
  double todayValuesSum = 0.0;

  fetchData({DateTime? datetime, bool filterForSeeAll = false}) {
    emit(FetchDataLoading());
    try {
      final box = Hive.box<FinanceModel>("financeBox");
      financeList = box.values.toList();

      final now = DateTime.now();
      todayFinanceList = financeList.where((e) =>
          e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day).toList();

      if (filterForSeeAll) {
        if (datetime == null) {
          filteredFinanceList = financeList;
        } else {
          filteredFinanceList = financeList.where((e) =>
            e.date.year == datetime.year &&
            e.date.month == datetime.month &&
            e.date.day == datetime.day).toList();
        }
      }

      valuesSum = financeList.fold(0, (sum, e) => sum + e.financeValue);
      todayValuesSum = todayFinanceList.fold(0, (sum, e) => sum + e.financeValue);

      emit(FetchDataSuccess());
    } catch (e) {
      emit(FetchDataFailure(e.toString()));
    }
  }
}