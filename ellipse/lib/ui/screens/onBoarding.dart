import 'package:flutter/material.dart';

import '../../util/index.dart';

Color kPrimaryColor = Color(0xFF111F5C);
Color kSecondaryColor = Color(0xFF139AD6);
Color kGreyColor = Color(0xFF888888);
List<OnBoardingPage> getOnBoardingPages() {
  return <OnBoardingPage>[
    OnBoardingPage("assets/images/onboarding_1.png", "Quick and easy.",
        "Millions of customers around the world use us for one simple reason: it's simple. Just an email address and password will get you through to check out before you can reach for your wallet."),
    OnBoardingPage("assets/images/onboarding_2.png", "We've got you covered.",
        "Shop with peace of mind, knowing we protect your elegible purchases. If an eligible item doesn't show up, or turns out to be different than described, we'll help sort things out with the seller."),
    OnBoardingPage("assets/images/onboarding_3.png", "Shop around the world.",
        "No need to book a flight ticket to shop worldwide. With a PayPal account you can shop at thousands of stores around the world in just a fwe clicks, knowing your card details are never shared with the seller."),
  ];
}

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController(initialPage: 0);
  final int _totalPages = 3;
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (var i = 0; i < _totalPages; i++) {
      list.add(_indicator(i == _currentPage));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
          color: isActive ? kSecondaryColor : Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(5))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView(
              physics: BouncingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: getOnBoardingPages()
                  .map((item) => renderPageItem(item))
                  .toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(48),
            child: Container(
                height: 48,
                child: _currentPage != _totalPages - 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.signin);
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                //color: kPrimaryColor,
                              ),
                            ),
                          ),
                          Row(
                            children: _buildPageIndicator(),
                          ),
                          InkWell(
                            onTap: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                //color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    : RoundedButton(
                        text: "Let's start",
                        onPress: () {
                          Navigator.pushNamed(context, Routes.signin);
                        })),
          ),
        ],
      ),
    );
  }

  Widget renderPageItem(OnBoardingPage page) {
    return Padding(
      padding: EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              page.imageUrl,
              height: 250,
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(
            height: 64,
          ),
          Center(
            child: Text(
              page.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                //color: kPrimaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Center(
            child: Container(
              height: 1,
              width: 100,
              //color: Colors.grey[300],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Center(
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                // color: kGreyColor,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onPress;

  RoundedButton({@required this.text, this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              // color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class OnBoardingPage {
  String imageUrl;
  String title;
  String description;

  OnBoardingPage(this.imageUrl, this.title, this.description);
}
