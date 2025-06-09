import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:test_app/colors/colors.dart';
import 'package:test_app/cubit/fetchcubit/fetch_data_cubit.dart';
import 'package:test_app/pages/add.dart';
import 'package:test_app/pages/see_all.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FetchDataCubit>(context).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("darkModeBox").listenable(),
      builder: (context, box, child) {
        var darkMode = box.get('darkMode', defaultValue: false);

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 30,
              ), 
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ), 
                child: AppBar(
                  backgroundColor:
                      darkMode
                          ? kSecondaryGreen
                          : kBlackColor, 
                  elevation: 4, 
                  automaticallyImplyLeading: false, 
                  title: Text(
                    "Welcome",
                    style: TextStyle(
                      color: darkMode ? kPrimaryDarkGreen : kSecondaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: IconButton(
                        icon: Icon(
                          darkMode ? Icons.dark_mode : Icons.light_mode,
                          color: darkMode ? kPrimaryDarkGreen : kSecondaryGreen,
                        ),
                        onPressed: () {
                          setState(() {
                            darkMode = !darkMode;
                            box.put('darkMode', darkMode);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          body: BlocBuilder<FetchDataCubit, FetchDataState>(
            builder: (context, state) {
              final cubit = BlocProvider.of<FetchDataCubit>(context);
              final todayList = cubit.todayFinanceList.reversed.toList();
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child:
                    state is FetchDataLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryDarkGreen,
                          ),
                        )
                        : Column(
                          children: [
                            SizedBox(
                              height: 100,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: kBlackColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "My Balance",
                                            style: TextStyle(
                                              color: kWhiteColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            NumberFormat.compactCurrency(
                                                  decimalDigits: 2,
                                                  symbol: "",
                                                )
                                                .format(cubit.valuesSum)
                                                .toString(),
                                            style: TextStyle(
                                              color: kWhiteColor,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryBlue,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: kBlackColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Today's Balance",
                                          style: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          NumberFormat.compactCurrency(
                                                decimalDigits: 2,
                                                symbol: "",
                                              )
                                              .format(cubit.todayValuesSum)
                                              .toString(),
                                          style: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: kSecondaryRed,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 16,
                                      ),
                                      backgroundColor: kSecondaryGreen,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  AddPage(isPlus: true),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.add, color: kPrimaryGreen),
                                        SizedBox(width: 8),
                                        Text(
                                          "Plus",
                                          style: TextStyle(
                                            color: kBlackColor.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation:
                                          0, 

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 16,
                                      ),
                                      backgroundColor: kSecondaryRed,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  AddPage(isPlus: false),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.remove, color: kPrimaryRed),
                                        SizedBox(width: 8),
                                        Text(
                                          "Minus",
                                          style: TextStyle(
                                            color: kBlackColor.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Today's Activity",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SeeAllPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "See All",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kPrimaryBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            todayList.isEmpty
                                ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30,
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color:
                                            darkMode
                                                ? kSecondaryBlue
                                                : kBlackColor,
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
                                    itemCount: todayList.length,
                                    itemBuilder: (context, index) {
                                      final item = todayList[index];

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
                                                            item.financeValue >=
                                                                    0
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
                                                builder: (
                                                  BuildContext context,
                                                ) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        kWhiteColor,
                                                    title: Text(
                                                      'Confirm Deletion',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                          ).pop(); // Close the dialog
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            color: kPrimaryBlue,
                                                          ), // Button text color
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
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),

                                                Text(
                                                  item.financeValue == 0
                                                      ? "0"
                                                      : "${item.financeValue}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
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
