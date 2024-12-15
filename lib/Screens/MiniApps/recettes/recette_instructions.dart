import 'package:flutter/material.dart';
import '../recettes/models/recette.dart';

class RecetteInstructions extends StatefulWidget {
  final Recette recette;

  const RecetteInstructions({Key? key, required this.recette}) : super(key: key);

  @override
  State<RecetteInstructions> createState() => _RecetteInstructionsState();
}

class _RecetteInstructionsState extends State<RecetteInstructions>  with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeRatio = screenHeight * 0.00125;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: Color(0xFF273085),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        elevation: 0,
        title: Text(
          widget.recette.title,
          style: const TextStyle(color: Color(0xFF273085)),
        ),
        backgroundColor: const Color(0xFFFCFCFC),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomContainer(fontSizeRatio, Icons.groups_rounded, widget.recette.persons.toString()),
              CustomContainer(fontSizeRatio, Icons.timer_rounded, "${widget.recette.prep_time+widget.recette.prep_time} min"),
            ],
          ),
          const SizedBox(height: 30,),
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF273085),
            labelColor: const Color(0xFF273085),
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Ingrédients'),
              Tab(text: 'Étapes'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                  child: ListView.builder(
                    itemCount: widget.recette.ingredients.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child:Text(
                          "• ${widget.recette.ingredients[index]}",
                          style: TextStyle(
                            color: const Color(0xFF273085),
                            fontSize: 14*fontSizeRatio,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Content for the 'Étapes' tab
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                  child: ListView.builder(
                    itemCount: widget.recette.steps.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "• ${widget.recette.steps[index]}",
                          style: TextStyle(
                            color: const Color(0xFF273085),
                            fontSize: 14*fontSizeRatio,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget CustomContainer(double fontSizeRatio, IconData icon, String text){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius:  BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(icon,color: const Color(0xFF273085),size: 25,),
          const SizedBox(width: 10,),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF273085),
              fontSize: 16*fontSizeRatio,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
