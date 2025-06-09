import 'package:flutter/material.dart';
import 'package:test_app/colors/colors.dart';
import 'package:test_app/pages/home.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentIndex = 0;
  bool isLastPage = false;

  final PageController pageController = PageController();

  final List<PageItem> items = [
    PageItem(
      title: "Track Your Expenses",
      image: "assets/images/finance1.png",
      subTitle: "Easily monitor where your money goes every month.",
    ),
    PageItem(
      title: "Set Budget Goals",
      image: "assets/images/finance2.png",
      subTitle: "Create personalized budgets to save more effectively.",
    ),
    PageItem(
      title: "Plan for the Future",
      image: "assets/images/finance3.png",
      subTitle: "Get insights and tips to grow your wealth smartly.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            },
            child: Text(
              "Skip",
              style: TextStyle(
                color: kPrimaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: items.length,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                    isLastPage = (value + 1 == items.length);
                  });
                },
                itemBuilder: (context, index) => items[index],
              ),
            ),

            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    items.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      height: 10,
                      width: currentIndex == index ? 30 : 10,
                      decoration: BoxDecoration(
                        color:
                            currentIndex == index
                                ? kPrimaryGreen
                                : kPrimaryBlue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                // Text(
                //   "${currentIndex + 1} / ${items.length}",
                //   style: TextStyle(
                //     color: kPrimaryGreen,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //   ),
                // ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isLastPage ? kSecondaryGreen : kPrimaryGreen,
                    foregroundColor: isLastPage ? kPrimaryGreen : kWhiteColor,
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black45,
                  ),
                  onPressed: () {
                    if (isLastPage) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                      );
                    } else {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    isLastPage ? "Start" : "Next",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class PageItem extends StatelessWidget {
  final String title;
  final String image;
  final String subTitle;

  const PageItem({
    Key? key,
    required this.title,
    required this.image,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryGreen.withOpacity(0.2),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            clipBehavior:
                Clip.hardEdge, 
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kPrimaryGreen,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kBlackColor.withOpacity(0.5),
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
