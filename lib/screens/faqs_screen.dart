import 'package:flutter/material.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FAQ {
  String question;
  String answer;
  String category;

  _FAQ({required this.question, required this.answer, required this.category});
}

class _FaqsScreenState extends State<FaqsScreen> {
  String _selectedCategory = '';
  String _searchQuery = '';
  List<_FAQ> faqs = [
    _FAQ(
      question: "What is Tugende App?",
      answer:
          "TugendeApp is a community-driven ride-sharing platform designed to help daily commuters and students find safe, affordable, and reliable rides by connecting with nearby drivers or fellow riders.",
      category: "Information",
    ),
    _FAQ(
      question: "Is TugendeApp safe?",
      answer: "Tugende is safe and will always be a safe way to share rides.",
      category: "Information",
    ),
    _FAQ(
      question: "How do I book a ride?",
      answer:
          "To book a ride, simply open the app, enter your destination, and select a nearby driver or rider to share the journey with.",
      category: "Booking",
    ),
    _FAQ(
      question: "Can I become a driver?",
      answer:
          "Yes, you can become a driver by signing up through the app and completing the necessary verification process. Ensure you meet the requirements and have a valid driver's license.",
      category: "Drivers",
    ),
    _FAQ(
      question: "What are the payment options?",
      answer:
          "TugendeApp supports various payment options, including cash, mobile money, and in-app payments. You can choose your preferred method during the booking process.",
      category: "Payments",
    ),
    _FAQ(
      question: "How do I report an issue?",
      answer:
          "If you encounter any issues, you can report them through the app's support feature or contact our customer service team via email or phone.",
      category: "Support",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = '';
                          });
                        },
                        child: Chip(
                          label: const Text('All'),
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          backgroundColor:
                              _selectedCategory == ''
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[100],
                          labelStyle:
                              _selectedCategory == ''
                                  ? TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )
                                  : TextStyle(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          side: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                    ),
                    ...faqs
                        .map((f) => f.category)
                        .toSet()
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              child: Chip(
                                label: Text(category),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 10.0,
                                ),
                                backgroundColor:
                                    _selectedCategory == category
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[100],
                                labelStyle:
                                    _selectedCategory == category
                                        ? TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                        )
                                        : TextStyle(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                side: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      faqs
                          .where(
                            (faq) =>
                                (_selectedCategory == '' ||
                                    faq.category == _selectedCategory) &&
                                (faq.question.toLowerCase().contains(
                                      _searchQuery,
                                    ) ||
                                    faq.answer.toLowerCase().contains(
                                      _searchQuery,
                                    )),
                          )
                          .length,
                  itemBuilder: (context, index) {
                    final faq =
                        faqs
                            .where(
                              (faq) =>
                                  (_selectedCategory == '' ||
                                      faq.category == _selectedCategory) &&
                                  (faq.question.toLowerCase().contains(
                                        _searchQuery,
                                      ) ||
                                      faq.answer.toLowerCase().contains(
                                        _searchQuery,
                                      )),
                            )
                            .toList()[index];
                    return ExpansionTile(
                      title: Text(faq.question),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      initiallyExpanded:
                          faq ==
                          faqs
                              .where(
                                (faq) =>
                                    (_selectedCategory == '' ||
                                        faq.category == _selectedCategory) &&
                                    (faq.question.toLowerCase().contains(
                                          _searchQuery,
                                        ) ||
                                        faq.answer.toLowerCase().contains(
                                          _searchQuery,
                                        )),
                              )
                              .first,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(faq.answer),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
