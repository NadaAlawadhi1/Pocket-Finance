import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_app/colors/colors.dart';
import 'package:test_app/cubit/fetchcubit/fetch_data_cubit.dart';
import 'package:test_app/models/finance_model.dart';
import 'package:test_app/pages/add.dart';

class SeeAllPage extends StatefulWidget {
  const SeeAllPage({super.key});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FetchDataCubit>(context).fetchData(datetime: _selectedDay);
    BlocProvider.of<FetchDataCubit>(
      context,
    ).fetchData(filterForSeeAll: true, datetime: _selectedDay);
  }

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final headerTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: kPrimaryBlue,
    );
    final formatButtonTextStyle = TextStyle(
      color: kPrimaryBlue,
      fontWeight: FontWeight.w600,
    );

    return ValueListenableBuilder(
      valueListenable: Hive.box("darkModeBox").listenable(),
      builder: (context, box, child) {
        var darkMode = box.get('darkMode', defaultValue: false);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: darkMode ? kSecondaryGreen : kBlackColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),

            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,                      color: darkMode ? kPrimaryDarkGreen : kSecondaryGreen,
),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "All Activities",
              style: TextStyle(
                      color: darkMode ? kPrimaryDarkGreen : kSecondaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: BlocBuilder<FetchDataCubit, FetchDataState>(
            builder: (context, state) {
              final cubit = BlocProvider.of<FetchDataCubit>(context);
              final filteredList = cubit.filteredFinanceList.reversed.toList();
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime(2025),
                      lastDay: DateTime.now(),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      onFormatChanged:
                          (format) => setState(() => _calendarFormat = format),
                      selectedDayPredicate: (day) {
                        if (_selectedDay == null) return false;
                        return isSameDay(day, _selectedDay);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          if (_selectedDay != null &&
                              isSameDay(selectedDay, _selectedDay)) {
                            // If tapping the selected day again, clear filter (show all)
                            _selectedDay = null;
                            cubit.fetchData(filterForSeeAll: true);
                            // fetch all entries
                          } else {
                            _selectedDay = selectedDay;
                            cubit.fetchData(
                              filterForSeeAll: true,
                              datetime: selectedDay,
                            );
                          }
                          _focusedDay = focusedDay;
                        });
                      },
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        titleTextStyle: headerTextStyle,
                        formatButtonVisible: true,
                        formatButtonDecoration: BoxDecoration(
                          color: kSecondaryBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        formatButtonTextStyle: formatButtonTextStyle,
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: kPrimaryBlue,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: kPrimaryBlue,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: kSecondaryGreen,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(
                          color: kPrimaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: kPrimaryGreen,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(
                          color: kWhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _selectedDay == null
                              ? 'All Activities'
                              : 'Activities on ${DateFormat('d/M/yy').format(_selectedDay!)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    filteredList.isEmpty
                        ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 70),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: darkMode ? kSecondaryBlue : kBlackColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "No Activity",
                                style: TextStyle(
                                  color: kPrimaryBlue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        )
                        : Expanded(
                          child: ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];

                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Dismissible(
                                  background: Container(
                                    padding: EdgeInsets.all(8),

                                    color: kPrimaryGreen,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        Icons.edit,
                                        color: kWhiteColor,
                                      ),
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    padding: EdgeInsets.all(8),
                                    color: kPrimaryRed,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.delete,
                                        color: kWhiteColor,
                                      ),
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => AddPage(
                                                isPlus:
                                                    item.financeValue >= 0
                                                        ? true
                                                        : false,
                                                financeModel: item,
                                              ),
                                        ),
                                      );
                                      cubit.fetchData();
                                    } else if (direction ==
                                        DismissDirection.endToStart) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: kWhiteColor,
                                            title: Text(
                                              'Confirm Deletion',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete this item?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  cubit.fetchData();
                                                  Navigator.of(
                                                    context,
                                                  ).pop(); 
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: kPrimaryBlue,
                                                  ), 
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  item.delete();
                                                  cubit.fetchData();
                                                  Navigator.of(
                                                    context,
                                                  ).pop(); 
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: kPrimaryRed,
                                                  ), 
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  key: UniqueKey(),
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                item.financeValue > 0
                                                    ? kSecondaryGreen
                                                    : kSecondaryRed,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.details),
                                            Opacity(
                                              opacity: 0.5,
                                              child: Text(
                                                DateFormat(
                                                  'dd/MM/yyyy',
                                                ).format(item.date),
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),

                                        Text(
                                          item.financeValue == 0
                                              ? "0"
                                              : "${item.financeValue}",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
