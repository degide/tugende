import 'package:flutter/material.dart';
import 'package:tugende/config/routes_config.dart';

class PromosTab extends StatefulWidget {
  const PromosTab({super.key});

  @override
  State<PromosTab> createState() => _PromosTabState();
}

class _Promo {
  String title;
  String description;
  String image;
  String category;

  _Promo({
    required this.title,
    required this.description,
    required this.image,
    required this.category,
  });
}

class _PromosTabState extends State<PromosTab> {
  String _selectedCategory = '';
  final List<_Promo> promos = [
    _Promo(
      title: "Best deal: 20% OFF",
      description: "Black Friday sale. 20% discount on all services",
      image: "assets/images/taxi_1.png",
      category: "Offers",
    ),
    _Promo(
      title: "Best deal: 15% OFF",
      description: "Black Friday sale. 15% discount on all services",
      image: "assets/images/taxi_3.png",
      category: "Referral",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promos'),
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
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.redeemPromoScreen,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                  ),
                  child: Row(
                    spacing: 5,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Icon(Icons.money, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Have a promo code?',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            Text(
                              'Enter your promo code here',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.chevron_right_outlined,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
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
                    ...promos
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
                child: ListView.separated(
                  itemCount:
                      promos
                          .where(
                            (promo) =>
                                (_selectedCategory == '' ||
                                    promo.category == _selectedCategory),
                          )
                          .length,
                  itemBuilder: (context, index) {
                    final promo =
                        promos
                            .where(
                              (promo) =>
                                  (_selectedCategory == '' ||
                                      promo.category == _selectedCategory),
                            )
                            .toList()[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            promo.image,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          promo.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          promo.description,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                        ),
                      ],
                    );
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
