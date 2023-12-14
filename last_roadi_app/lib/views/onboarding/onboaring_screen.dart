
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:last_roadi_app/utiles/app_constants.dart';
import 'package:last_roadi_app/utiles/preference.dart';
import 'package:last_roadi_app/utiles/route_helper.dart';
import 'package:last_roadi_app/widgets/myimage.dart';
import 'package:last_roadi_app/widgets/mytext.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  Preference sharePref = Preference.shared;

  List<String> introBigtext = <String>[
    "Welcome to Roadi!",
    "Stay Connected with Your Group!",
    "Stay Connected, Stay Informed!",
  ];

  List<String> introSmalltext = <String>[
    "Get ready for a seamless onboarding experience with Roadi, your go-to app for group transitions in Saudi Arabia.",
    "Roadi keeps your group connected, ensuring everyone is on the same page. Plan, coordinate, and make the most of your journey in Saudi Arabia together.",
    "Roadi keeps your group connected and well-informed, ensuring your journey in Saudi Arabia is smooth and enjoyable.",
  ];

  List<String> icons = <String>[
    "assets/image/logo.png",
    "assets/image/intro2.png",
    "assets/image/intro3.png",
  ];

  PageController pageController = PageController();
  final currentPageNotifier = ValueNotifier<int>(0);
  int pos = 0;

  _storeOnboardInfo() async {
    sharePref.setString(AppConstants.SEEN, "1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/image/bg.webp'), fit: BoxFit.fill)),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    child: PageView.builder(
                      itemCount: introBigtext.length,
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.all(50),
                            child: MyImage(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                imagePath: icons[index]),
                          ),
                        );
                      },
                      onPageChanged: (index) {
                        pos = index;
                        currentPageNotifier.value = index;
                        debugPrint("pos:$pos");
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DotsIndicator(
                            dotsCount: introBigtext.length,
                            position: pos.toDouble(),
                            decorator: DotsDecorator(
                              activeColor: HexColor("#0056C7"),
                              color: Colors.white,
                              size: const Size.square(7.0),
                              activeSize: const Size(18.0, 6.0),
                              activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyText(
                                colors: Color.fromARGB(255, 6, 135, 240),
                                maxline: 2,
                                title: introBigtext[pos],
                                textalign: TextAlign.center,
                                size: 20,
                                fontWeight: FontWeight.w600,
                                fontstyle: FontStyle.normal),
                          ),
                          // const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyText(
                                colors: Color.fromARGB(255, 205, 203, 203),
                                maxline: 5,
                                title: introSmalltext[pos],
                                textalign: TextAlign.center,
                                size: 14,
                                fontWeight: FontWeight.w600,
                                fontstyle: FontStyle.normal),
                          ),
                          const Spacer(),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 100,
                            child: TextButton(
                                child: MyText(
                                  title: pos == introBigtext.length - 1
                                      ? "FINISH"
                                      : "Next",
                                  colors: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(5)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor),
                                    shape:
                                        MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                side: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor)))),
                                onPressed: () => {
                                      if (pos == introBigtext.length - 1)
                                        {
                                          _storeOnboardInfo(),
                                          Get.offAndToNamed(
                                              RouteHelper.getLoginRoute())
                                        }
                                      else
                                        {
                                          pageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.ease)
                                        }
                                    }),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              _storeOnboardInfo();
                              Get.offAndToNamed(RouteHelper.getLoginRoute());
                            },
                            child: MyText(
                                colors: Color.fromARGB(255, 226, 225, 225),
                                maxline: 1,
                                title: 'Skip',
                                textalign: TextAlign.center,
                                size: 14,
                                fontWeight: FontWeight.w600,
                                fontstyle: FontStyle.normal),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
