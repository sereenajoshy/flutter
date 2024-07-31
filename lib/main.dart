import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.white,
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> circleTexts = [
    "Day 1: \n Oatmeal, Berries, Nuts \n Chicken, Salad, Butter \n Spinach, Whole Grain Bread ",
    "Day 2: \n Smoothie, Banana, Chia Seeds \n Quinoa, Black Beans \n Yogurt, HoneySalmon \n Vegetables ",
    "Day 3: \n Avocado, Toast, Egg \n Turkey, Avocado, Wrap \n Dark Chocolate, Almonds \n Tofu, Broccoli, Brown Rice",
    "Day 4: \n Chia Seeds, Mango \n Chicken, Vegetables \n Carrots, Hummus \n Spaghetti, Tomato, Basil",
    "Day 5: \n Eggs, Spinach, Tomatoes \n FetaRice Cakes, Peanut Butter \n Shrimp, Tacos",
    "Day 6: \n Berries, Almond Milk, Flax Seeds \n Couscous, Vegetables \n Fruit Salad \nChicken Curry, Brown Rice",
    "Day 7: \n Pancakes, Fruit \n Caprese Salad, Whole Grain Bread \n Trail Mix, Nuts, Dried Fruits \n Chicken, Greens \n  Sweet Potatoes"
  ];

  final ScrollController _scrollController = ScrollController();

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  // Generate the list of dates for the app bar
  List<DateTime> dateList = List.generate(
    31,
    (index) => DateTime.now().subtract(Duration(days: index)),
  ).reversed.toList(); // Show recent dates first

  @override
  void initState() {
    super.initState();
    // Set the initial scroll position to center the first card
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const double itemWidth = 300; // Adjust based on card width and padding
      final double containerWidth = MediaQuery.of(context).size.width;
      final double initialScrollPosition =
          (containerWidth / 2) - (itemWidth / 2);
      _scrollController.jumpTo(initialScrollPosition);
    });
  }

  // Function to show the date picker for selecting period start and end dates
  Future<void> _selectPeriodDates(BuildContext context) async {
    DateTime initialStartDate = selectedStartDate ?? DateTime.now();
    DateTime initialEndDate =
        selectedEndDate ?? initialStartDate.add(Duration(days: 1));

    // Select start date
    DateTime? startPicked = await showDatePicker(
      context: context,
      initialDate: initialStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Start Date', // Heading for start date selection
    );

    if (startPicked != null) {
      setState(() {
        selectedStartDate = startPicked;
      });

      // Select end date
      DateTime? endPicked = await showDatePicker(
        context: context,
        initialDate: initialEndDate,
        firstDate: startPicked,
        lastDate: DateTime(2100),
        helpText: 'Select End Date', // Heading for end date selection
      );

      if (endPicked != null) {
        setState(() {
          selectedEndDate = endPicked;
        });
      } else {
        // Reset start date if end date is not selected
        setState(() {
          selectedStartDate = null;
        });
      }
    }
  }

  // Function to format date
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    // Calculate cycle duration
    int cycleDuration = selectedEndDate != null && selectedStartDate != null
        ? selectedEndDate!.difference(selectedStartDate!).inDays + 1
        : 0;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 160, 218),
      appBar: AppBar(
        toolbarHeight: 70, // Increase height to fit dates
        backgroundColor: Color.fromARGB(255, 209, 208, 208),
        iconTheme: const IconThemeData(color: Colors.black), // Change icon color
        title: const Text(
          "\n\nSelect date:",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        flexibleSpace: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dateList.length,
            itemBuilder: (context, index) {
              DateTime date = dateList[index];
              bool isSelected = selectedStartDate != null &&
                  selectedEndDate != null &&
                  date.isAfter(
                      selectedStartDate!.subtract(Duration(days: 1))) &&
                  date.isBefore(selectedEndDate!.add(Duration(days: 1)));

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Date selected: ${_formatDate(date)}"),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        isSelected ? Colors.green : Colors.pinkAccent,
                    child: Text(
                      "${date.day}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Text(
                " PERIOD\nTRACKER",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 350, // Diameter of the circle
                height: 350, // Diameter of the circle
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 225, 135, 165),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedStartDate != null && selectedEndDate != null
                          ? "Day ${selectedEndDate!.difference(selectedStartDate!).inDays + 1}"
                          : "Select\nperiod dates",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      selectedStartDate != null && selectedEndDate != null
                          ? "Cycle lasted ${selectedEndDate!.difference(selectedStartDate!).inDays + 1} days"
                          : "No cycle selected",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _selectPeriodDates(context);
                      },
                      child: Text("Edit period dates"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: Container(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemCount: circleTexts.length,
                      itemBuilder: (context, index) {
                        // Determine if the index is within the cycle duration
                        bool isVisible = index < cycleDuration;
                        return Visibility(
                          visible: isVisible,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              width: 300, // Adjust width of the card
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 225, 135, 165),
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: for rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset:
                                        Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  circleTexts[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
