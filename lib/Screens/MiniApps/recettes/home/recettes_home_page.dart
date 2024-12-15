import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/recette_fitness_item.dart';
import '../models/recette_type.dart';


class RecettesHomePage extends StatefulWidget {
  const RecettesHomePage({Key? key}) : super(key: key);

  @override
  State<RecettesHomePage> createState() => _RecettesHomePageState();
}

class _RecettesHomePageState extends State<RecettesHomePage> {
  final Map<RecetteType, String> recetteMap = {
    RecetteType.Pates: "Pâtes",
    RecetteType.Soupes: "Soupes",
    RecetteType.Ragouts: "Ragouts",
    RecetteType.Salades: "Salades",
    RecetteType.Desserts: "Desserts",
  };

  late List<RecetteType> filteredList;

  @override
  void initState() {
    super.initState();
    filteredList = RecetteType.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeRatio = screenHeight * 0.00125;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                "assets/images/close_icon.svg",
                width: 25,
              ),
            ),
          )
        ],
        elevation: 0,
        title: const Text(
          "MySaiph Recettes",
          style: TextStyle(color: Color(0xFF273085)),
        ),
        backgroundColor: const Color(0xFFFCFCFC),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              style: const TextStyle(color: Color(0xff273085)),
              cursorColor: const Color(0xff273085),
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: 'Recherche',
                prefixIcon: const Icon(
                  Icons.search,
                  color: const Color(0xff273085),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),*/
          const SizedBox(height: 35,),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Choisissez votre catégorie",
              style: TextStyle(
                  fontSize: 14 * fontSizeRatio,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff273085)),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: RecetteFitnessItem(
                    title: recetteMap[filteredList[index]]!,
                    image:
                    'assets/images/${recetteMap[filteredList[index]]!.toLowerCase().replaceAll(' ', '_')}.png',
                    isFitness: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filter(String searchText) {
    setState(() {
      filteredList = RecetteType.values.where((type) =>
          recetteMap[type]!
              .toLowerCase()
              .contains(searchText.toLowerCase())).toList();
    });
  }
}
