import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mealtime/models/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mealtime/models/snackbar.dart';
import 'package:mealtime/views/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  List<dynamic> _recipes = [];
  List<String> ingredients = [];
  bool _loading = false;

  Future<List<dynamic>> _getRecipes() async {
    String baseUrl = 'https://api.spoonacular.com/recipes/findByIngredients';
    String apiKey = '92ed0aef4aeb42f1a609b9816696241e';

    String joinedIngredients = ingredients.join(',');
    String url =
        '$baseUrl?apiKey=$apiKey&ingredients=$joinedIngredients&number=100&ranking=1&ignorePantry=true&type=main%20course&includeNutrition=true';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      for (var recipe in data) {
        // Parse the recipe times from the response data
        int prepTime = recipe['preparationMinutes'];
        int cookTime = recipe['cookingMinutes'];
        int totalTime = recipe['readyInMinutes'];

        // Add the recipe times to the recipe object
        recipe['prepTime'] = prepTime;
        recipe['cookTime'] = cookTime;
        recipe['totalTime'] = totalTime;
      }
      return data;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  void _searchRecipes() {
    setState(() {
      _loading = true;
    });
    _getRecipes().then((data) {
      setState(() {
        _recipes = data;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'mealtime',
                              style: GoogleFonts.archivo(
                                  color: blackColor, fontSize: 40),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  FluentIcons.settings_16_regular,
                                  color: blackColor,
                                  size: 40,
                                ))
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Expanded(
                                flex: 4,
                                child: SearchBar(
                                    controller: _ingredientController)),
                            const Gap(10),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: greyColor),
                              child: Center(
                                child: IconButton(
                                  color: greyColor,
                                  onPressed: () {
                                    if (_ingredientController.text.isNotEmpty &&
                                        ingredients.length != 5) {
                                      setState(() {
                                        ingredients
                                            .add(_ingredientController.text);
                                      });
                                      _ingredientController.clear();
                                    } else {
                                      showSnackBar(context, 'max 5');
                                    }
                                  },
                                  icon: Icon(
                                    FluentIcons.add_12_regular,
                                    size: 35,
                                    color: fullGreyColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  ingredients.isNotEmpty
                      ? Expanded(
                          flex: 1,
                          child: Wrap(
                            spacing: 8.0, // set the spacing between the boxes
                            children: ingredients.map((value) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ingredients.remove(
                                        value); // remove the value from the list
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(value,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: blackColor)),
                                      const SizedBox(width: 4.0),
                                      Icon(
                                        Icons.close,
                                        size: 16.0,
                                        color: blackColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ))
                      : const SizedBox(),
                  ingredients.isNotEmpty
                      ? Expanded(
                          flex: 10,
                          child: _loading == false
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(14, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _recipes.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          leading: Image.network(
                                              _recipes[index]['image']),
                                          title: Text(
                                            _recipes[index]['title'],
                                            style: GoogleFonts.archivo(
                                                color: blackColor),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                      color: blackColor),
                                ),
                        )
                      : Expanded(
                          flex: 10,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Enter an ingredient to see recipes!",
                                style: GoogleFonts.archivo(
                                    color: blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: _searchRecipes,
              child: Container(
                margin: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width - 200,
                height: 60,
                decoration: BoxDecoration(
                    color: blackColor, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Show Recipes',
                      style: GoogleFonts.archivo(fontSize: 18),
                    ),
                    const Gap(10),
                    const Icon(
                      FluentIcons.arrow_right_12_regular,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
