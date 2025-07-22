import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _TextItem {
  final String title;
  final String description;
  final String skipText;
  final String nextText;
  final void Function() onSkip;
  final void Function() onNext;

  _TextItem({
    required this.title,
    required this.description,
    required this.skipText,
    required this.nextText,
    required this.onSkip,
    required this.onNext,
  });
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  int _current = 0;
  int _currentText = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  void _navigateToNext() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('TODO: Navigate to login screen or to home if logged in')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgUrls = [
      'assets/images/taxi_1.png',
      'assets/images/taxi_2.png',
      'assets/images/taxi_3.png',
    ];

    final List<_TextItem> textItems = [
      _TextItem(
        skipText: 'Skip',
        nextText: 'Continue',
        onSkip: _navigateToNext,
        onNext: () {
          setState(() {
            _currentText = _currentText + 1;
          });
        },
        title: 'TugendeApp - Hassle-Free ride-sharing solution!',
        description: 'Turning everyday commuting a breeze. No long lines, no surge prices, no confusion. Just reliable, shared rides — so you can reclaim your time and enjoy the journey.',
      ),
      _TextItem(
        skipText: 'Go back',
        nextText: 'Continue',
        onSkip: () {
          setState(() {
            _currentText = _currentText > 0 ? _currentText - 1 : 0;
          });
        },
        onNext: () {
          setState(() {
            _currentText = _currentText + 1;
          });
        },
        title: 'Discover available rides tailored to your needs.',
        description: 'We are making it easy to find rides that match your daily route. View nearby drivers or co-riders in real time, pick what fits, and submit your request.',
      ),
      _TextItem(
        skipText: 'Go back',
        nextText: 'Let\'s Get Started',
        onSkip: () {
          setState(() {
            _currentText = _currentText > 0 ? _currentText - 1 : 0;
          });
        },
        onNext: _navigateToNext,
        title: 'Enjoy a seamless ride-sharing experience!',
        description: 'Communicate with your driver, apply promos, and choose your preferred payment method. Your comfort and convenience are our priority!',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    child: CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: 300,
                        autoPlay: true,
                        viewportFraction: 1.0,
                        autoPlayInterval: Duration(seconds: 10),
                        autoPlayAnimationDuration: Duration(seconds: 1),
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                      items:
                          imgUrls.map((imgUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      imgUrl,
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  imgUrls.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withAlpha(_current == entry.key ? 153 : 77),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 15, left: 18, right: 18, bottom: 20),
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textItems[_currentText].title,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          textItems[_currentText].description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 20,
                      children: [
                        TextButton(
                          onPressed: textItems[_currentText].onSkip,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          child: Text(textItems[_currentText].skipText),
                        ),
                        ElevatedButton(
                          onPressed: textItems[_currentText].onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(textItems[_currentText].nextText),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
