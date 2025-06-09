import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:test_app/colors/colors.dart';
import 'package:test_app/cubit/addcubit/add_data_cubit.dart';
import 'package:test_app/cubit/fetchcubit/fetch_data_cubit.dart';
import 'package:test_app/models/finance_model.dart';

class AddPage extends StatefulWidget {
  FinanceModel? financeModel;
  final bool isPlus;
  AddPage({super.key, required this.isPlus, this.financeModel});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController detailsController = TextEditingController();
  String num = "";

  @override
  void initState() {
    super.initState();
    if (widget.financeModel != null) {
      detailsController.text = widget.financeModel!.details;
      num = financeValueToInputString(widget.financeModel!.financeValue);
    }
  }

  final borderRadius = BorderRadius.all(Radius.circular(12));
  final buttonPadding = EdgeInsets.symmetric(vertical: 14, horizontal: 16);

  ButtonStyle elevatedButtonStyle(Color backgroundColor) =>
      ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        padding: buttonPadding,
        backgroundColor: backgroundColor,
      );

  Widget buildKeyPadButton(String text) {
    return KeyPadItem(
      numText: text,
      onTab: () {
        setState(() {
          if (text == '.') {
            if (!num.contains('.')) {
              if (num.isEmpty) {
                num = "0.";
              } else {
                num += text;
              }
            }
          } else {
            if (num == "0" || num == "0.0") {
              num = text;
            } else {
              num += text;
            }
          }
        });
      },
    );
  }

  String financeValueToInputString(double value) {
    return value < 0 ? (-value).toString() : value.toString();
  }

  double inputStringToFinanceValue(String input, bool isPlus) {
    double val = double.tryParse(input) ?? 0;
    return isPlus ? val : -val;
  }

  bool get isZeroOrEmpty => num.isEmpty || double.tryParse(num) == 0;

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      hintText: 'Details Here...',
      hintStyle: TextStyle(fontSize: 14, color: kBlackColor),
      filled: true,
      fillColor: kSecondaryBlue,
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.transparent),
      ),
    );

    return ValueListenableBuilder(
      valueListenable: Hive.box("darkModeBox").listenable(),
      builder: (context, box, child) {
        var darkMode = box.get('darkMode', defaultValue: false);

        return Scaffold(
          resizeToAvoidBottomInset: false,
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
                  Radius.circular(14),
                ), 
                child: AppBar(
                  backgroundColor:
                      darkMode
                          ? kSecondaryGreen
                          : kBlackColor, 
                  elevation: 4,
                  automaticallyImplyLeading: false, 
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: darkMode ? kPrimaryDarkGreen : kSecondaryGreen,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    widget.isPlus ? "Plus" : "Minus",
                    style: TextStyle(
                      color: darkMode ? kPrimaryDarkGreen : kSecondaryGreen,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
            ),
          ),
          body: BlocProvider(
            create: (context) => AddDataCubit(),
            child: BlocBuilder<AddDataCubit, AddDataState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      TextField(
                        style: TextStyle(
                          color:
                              kBlackColor, 
                        ),
                        controller: detailsController,
                        cursorColor: kPrimaryBlue,
                        decoration: inputDecoration,
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 25.0,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              widget.isPlus ? kSecondaryGreen : kSecondaryRed,
                          borderRadius: borderRadius,
                        ),
                        child: Center(
                          child: Text(
                            isZeroOrEmpty
                                ? "0.0"
                                : (widget.isPlus ? "+ " : "- ") + num,
                            style: TextStyle(
                              color:
                                  widget.isPlus ? kPrimaryGreen : kPrimaryRed,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        flex: 9,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  buildKeyPadButton("7"),
                                  buildKeyPadButton("8"),
                                  buildKeyPadButton("9"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  buildKeyPadButton("4"),
                                  buildKeyPadButton("5"),
                                  buildKeyPadButton("6"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  buildKeyPadButton("1"),
                                  buildKeyPadButton("2"),
                                  buildKeyPadButton("3"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  buildKeyPadButton("."),
                                  buildKeyPadButton("0"),
                                  KeyPadItem(
                                    onTab: () {
                                      setState(() {
                                        if (num.isNotEmpty) {
                                          num = num.substring(
                                            0,
                                            num.length - 1,
                                          );
                                          if (num.isEmpty) num = "";
                                        }
                                      });
                                    },
                                    child: Icon(
                                      Icons.backspace_outlined,
                                      color: kWhiteColor,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: elevatedButtonStyle(kSecondaryBlue),
                              onPressed:
                                  isZeroOrEmpty
                                      ? null 
                                      : () {
                                        try {
                                          double enteredValue =
                                              inputStringToFinanceValue(
                                                num,
                                                widget.isPlus,
                                              );
                                          if (widget.financeModel != null) {
                                            widget.financeModel!.details =
                                                detailsController.text;
                                            widget.financeModel!.financeValue =
                                                enteredValue;
                                            widget.financeModel!.save();
                                          } else {
                                            BlocProvider.of<AddDataCubit>(
                                              context,
                                            ).addData(
                                              FinanceModel(
                                                details: detailsController.text,
                                                financeValue: enteredValue,
                                                date: DateTime.now(),
                                              ),
                                            );
                                          }
                                          BlocProvider.of<FetchDataCubit>(
                                            context,
                                          ).fetchData();
                                          Navigator.pop(context);
                                        } catch (e) {
                                          // error 
                                        }
                                      },
                              child: Text(
                                widget.financeModel != null ? "SAVE" : "ADD",
                                style: TextStyle(
                                  color: kBlackColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              style: elevatedButtonStyle(kSecondaryRed),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "CANCEL",
                                style: TextStyle(
                                  color: kBlackColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class KeyPadItem extends StatelessWidget {
  final String? numText;
  final Widget? child;
  final VoidCallback onTab;

  const KeyPadItem({super.key, this.numText, this.child, required this.onTab})
    : assert(
        numText != null || child != null,
        'Either numText or child must be provided',
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: GestureDetector(
          onTap: onTab,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kBlackColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child:
                  child ?? Text(numText!, style: TextStyle(color: kWhiteColor)),
            ),
          ),
        ),
      ),
    );
  }
}
