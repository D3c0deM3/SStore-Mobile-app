import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({Key? key}) : super(key: key);

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  final PageController _controller = PageController(viewportFraction: 0.75);
  int _currentPage = 0;

  final List<Map<String, dynamic>> plans = [
    {
      'title': 'BASIC Plan',
      'price': '\$10/month',
      'features': [
        '5 Market Reports / month',
        'Basic Data Visualization',
        'Export in PDF only',
        'Email Support',
      ],
    },
    {
      'title': 'PRO Plan',
      'price': '\$50/month',
      'features': [
        '25 Market Reports / month',
        'Advanced Data Visualization',
        'Export in PDF, Excel & PPT',
        'Industry Trends & Forecasts',
        'Priority Email Support',
      ],
    },
    {
      'title': 'ENTERPRISE Plan',
      'price': '\$100/month',
      'features': [
        'Unlimited Reports',
        'Custom Visualizations',
        'Full Export Options',
        'Dedicated Account Manager',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF042631),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Choose Plan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: plans.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final isFocused = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                      horizontal: isFocused ? 8 : 16,
                      vertical: isFocused ? 20 : 40,
                    ),
                    decoration: BoxDecoration(
                      color: isFocused ? const Color(0xFF083C4E) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            plans[index]['title'],
                            style: TextStyle(
                              color: isFocused ? Colors.white : Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            plans[index]['price'],
                            style: TextStyle(
                              color: isFocused ? Colors.white : Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(plans[index]['features'].length, (
                            i,
                          ) {
                            return Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color:
                                      isFocused ? Colors.white : Colors.black54,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    plans[index]['features'][i],
                                    style: TextStyle(
                                      color:
                                          isFocused
                                              ? Colors.white
                                              : Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isFocused
                                      ? const Color(0xFF4C7273)
                                      : Colors.grey[300],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'BUY NOW',
                              style: TextStyle(
                                color:
                                    isFocused ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SmoothPageIndicator(
              controller: _controller,
              count: plans.length,
              effect: const WormEffect(
                activeDotColor: Colors.white,
                dotColor: Colors.white38,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
