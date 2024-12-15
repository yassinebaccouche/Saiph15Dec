
import 'package:mysaiph/Screens/MiniApps/recettes/models/recette_type.dart';

class Recette {
  String title;
  int prep_time;
  int cook_time;
  int persons;
  List<String> ingredients;
  List<String>  steps;
  RecetteType type;

  Recette({
    required this.title,
    required this.prep_time,
    required this.cook_time,
    required this.persons,
    required this.ingredients,
    required this.steps,
    required this.type,
  });
}

List<Recette> recettes = [
  Recette(
    title: "Couscous à l'agneau",
    prep_time: 15,
    cook_time: 70,
    persons: 3,
    ingredients: ["3 morceaux de viande", "2 pommes de terres", "2 carottes", "3 piments", "2 oignons", "Poignée de pois chiches", "0.5 cuillère a soupe de sel", "0.5 cuillère en bois de piment rouge", "2 cuillères a soupe de concentre de tomates", "Une pincée de ras el hanout", "Un fond d'huile d'olive", "De la semoule moyenne"],
    steps: [
      "Mettre le fond d'huile d'olive + un oignons coupes en dés, faites un peu revenir, rajouter par la suite l'agneau, le concentré de tomate.",
      "Rajouter de l'eau jusqu'à hauteur de la viande même un peu plus, rajouter dedans, le piment,le raz el hanout, le sel,les carottes couper et les pois chiches .recouvrir est laisser cuire 1 h 10 environ",
      "Préparer en attendant les pommes de terre coupées en 2, le piment, retire le bout qui dépasse.",
      "Préparer la semoule mettre dans un saladier le remplir d'eau puis renversé l'eau et réserve en couvrant d'un torchons.",
      "Donc des que l'heure est passée mettre la semoule sur le dessus du couscoussier et poivré un peu le dessus pour donner du gout.",
      "Mettre dans la sauce : les pommes de terre, les piments, l'oignon entier."
    ],
    type: RecetteType.Pates
  ),
  Recette(
    title: "Spaghettis bolognaise ",
    prep_time: 5,
    cook_time: 45,
    persons: 3,
    ingredients: ["300 gr Viande hachée", "4 feuilles de laurier", "Oignon émincé", "1 c. à soupe ail haché", "2 c. à soupe Tomates en conserve", "1/2 c. à soupe de harissa", "1/2 verre(s) d'huile d'olive", "2 c. à café Coriandre en poudre", "1 c. à café Piment rouge en poudre", "300 gr de spaghettis", "Sel et poivre"],
    steps: [
      "Faire revenir l'oignon haché et l'ail dans l'huile d'olive, ajouter la viande hachée. Laisser cuire à feu moyen en mélangeant régulièrement.",
      "Saler et poivrer.",
      "Ajouter ensuite le concentré de tomate, les feuilles de laurier, l'harissa, le piment rouge en poudre et la coriandre.",
      "Ajouter un verre d'eau et laisser mijoter pendant 30 minutes. La sauce doit être épaisse.",
      "Faire cuire les spaghettis dans une eau bouillante salée.",
      "Lorsque les spaghettis sont cuits, les faire revenir à la poêle avec la sauce.",
    ],
      type: RecetteType.Pates
  ),
  Recette(
      title: "Pâte sauce blanche au poulet",
      prep_time: 10,
      cook_time: 15,
      persons: 2,
      ingredients: ["2 steaks de dinde", "Fromage râpé", "De l'huile", "Crème liquide", "Tomates cerise", "Sel et poivre", "1/2 oignon haché", "Spaghettis"],
      steps: [
        "Cuire les pâtes dans l'eau bouillante salée.",
        "Entre temps, émincer les steaks de dinde et les faire sauter avec l'oignon haché dans l'huile jusqu'à avoir une belle couleur.",
        "Ajouter ensuite la crème liquide et le fromage râpé.",
        "Assaisonner de sel et poivre.",
        "Après cuisson des pâtes les mélanger avec la sauce.",
        "Dresser dans un plat, parsemer de fromage râpé et décorer de tomates cerise.",
      ],
      type: RecetteType.Pates
  ),

  Recette(
      title: "Soupe d'orge",
      prep_time: 15,
      cook_time: 30,
      persons: 4,
      ingredients: ["Viande de bœuf","Tomate concentrée","Chorba frik","Pois chiches déjà trempés","1 oignon haché","Ail haché","Céleri haché","Harissa arbi","1 c. à café de tabel","De l'huile","Sel et poivre"],
      steps: [
        "Dans un faitout, faire revenir l'oignon dans un filet d'huile.",
        "Ajouter les morceaux de viande et le céleri haché.",
        "Ajouter ensuite l'harissa arbi et la tomate concentrée.",
        "Couvrir d'eau puis mettre les pois chiches et assaisonner de sel, poivre, tabel et ail.",
        "Laisser cuire la viande.",
        "Ajouter la chorba frik et laisser cuire 10 minutes encore.",
      ],
      type: RecetteType.Soupes
  ),
  Recette(
      title: "Soupe langues d'oiseau",
      prep_time: 10,
      cook_time: 20,
      persons: 4,
      ingredients: ["4 morceaux de poulet", "1 c. à café de concentré de tomate", "Pâtes langue d'oiseau", "1 oignon haché", "Feuille(s) de céleri", "1 c. à café de curcuma", "Sel et poivre", "1/2 citron", "De  l'huile",],
      steps: [
        "Dans un faitout, faire l'huile.",
        "Ajouter les morceaux de poulet, l'oignon haché, les feuilles de céleri.",
        "Assaisonner de curcuma, sel et poivre. Couvrir d'eau et laisser cuire.",
        "Ajouter enfin les petites pâtes langue d'oiseau et laisser cuire 7 minutes. ",
      ],
      type: RecetteType.Soupes
  ),
  Recette(
      title: "Soupe de lentilles",
      prep_time: 30,
      cook_time: 20,
      persons: 4,
      ingredients: ["4 verres de lentilles corail", "2 tomates", "1 oignon", "Cumin en grains", "Sel et poivre", "Feuille(s) de persil"],
      steps: [
        "Faire revenir l'oignon émincé dans une casserole avec un peu d'huile d'olive. Couper les tomates en petits dés et les ajouter.",
        "Ajouter les lentilles, puis recouvrir presque immédiatement d'eau. La cuisson est très rapide.",
        "Saler. Poivrer. Moudre le cumin. Goûter et rectifier selon votre goût.",
        "Mixer: la soupe doit être crémeuse.",
        "Servir très chaud dans des petits bols, et décorer avec une feuille de persil plat (ou de coriandre). Ajouter éventuellement un filet d'huile d'olive.",
      ],
      type: RecetteType.Soupes
  ),

  Recette(
      title: "Kamounia",
      prep_time: 5,
      cook_time: 30,
      persons: 2,
      ingredients: ["Huile d'olive", "300 g de foie de mouton ou d'agneau ou d'abats", "1/2 oignon émincé", "1,5 c. à soupe de concentré de tomates", "2 c. à café de piment en poudre", "1 c. à café de tabel-karouia", "1,5 c. à café de cumin", "4 gousses d'ail", "1 c. à café de sel", "Persil", "1 pincée de poivre"],
      steps: [
        "Mettre dans un faitout un fond (un peu épais) d'huile d'olive, l'oignon émincé, le foie coupé en petits morceaux (environ 3-4 cm), les épices (SAUF LE CUMIN), le sel et le poivre. Ajouter par dessus la tomate concentrée.",
        "Mettre sur une flamme vive, et faire revenir SANS AJOUTER D'EAU pendant 5 bonnes minutes en remuant.",
        "Ajouter 1/2 l d'eau bien chaude, et laisser cuire à couvert pendant 20 minutes. Au bout de 10 minutes, mettre l'ail écrasé dans la sauce. Ajouter le cumin 5 minutes avant la fin.",
        "En fin de cuisson, la sauce doit être bien épaisse. Servir chaud décoré avec du persil et de l'oignon hahché, et un piment frit (facultatif).",
      ],
      type: RecetteType.Ragouts
  ),
  Recette(
      title: "Ojja",
      prep_time: 10,
      cook_time: 15,
      persons: 2,
      ingredients: ["2 Pommes de terre 2 gousses d'ail", "2 c. à café de tomate concentrée", "1 c. à café de harissa", "1 c. à café de carvi", "1 c. à café de coriandre", "Sel et poivre", "Persil haché", "Huile d'olive", "2 œufs"],
      steps: [
        "Épluchez les gousses d'ail, et écrasez-les avec le carvi et la coriandre.",
        "Épluchez les pommes de terre, coupez-les en dés et faites-les revenir dans l'huile d'olive pendant 2-3 minutes.",
        "Diluez la tomate concentrée et l'harissa dans 30 ml d'eau chaude, et versez le tout sur les pommes de terre.",
        "Salez et laissez cuire pendant 5 minutes, et une fois la sauce réduite, ajoutez le mélange ail, carvi et coriandre après 2 minutes, versez les œufs préalablement battus, et laissez-les mijoter 1 à 2 minutes sans remuez.",
        "Une fois cuite, parsemez de persil ciselé, et dégustez.",
      ],
      type: RecetteType.Ragouts
  ),
  Recette(
      title: "Ragoût aux pommes de terre",
      prep_time: 15,
      cook_time: 40,
      persons: 4,
      ingredients: ["Morceaux de viande de boeuf ", "Concentré de tomate", "Pommes de terre coupées en quartiers", "1 oignon haché", "2 poivrons verts", "Harissa arbi", "Paprika", "Persil ciselé", "1 c. à café de tabel", "1 c. à café de curcuma", "De l'huile", "Sel et poivre"],
      steps: [
        "Dans un faitout, faire chauffer l'huile et y faire revenir l'oignon et les morceaux de viande.",
        "Ajouter ensuite le concentré de tomate et l'harissa arbi.",
        "Ajouter avec un peu d'eau et assaisonner de sel, poivre, curcuma, tabel et paprika.",
        "Couvrir d'eau et laisser cuire la viande.",
        "Ajouter ensuite les quartiers de pommes de terre et les poivrons verts et laisser cuire.",
        "Dresser dans un plat et parsemer de persil ciselé et d'oignon haché.",
      ],
      type: RecetteType.Ragouts
  ),

  Recette(
      title: "Salade tunisienne",
      prep_time: 15,
      cook_time: 0,
      persons: 4,
      ingredients: ["2 tomates", "2 poivrons verts", "1 oignon de taille moyenne", "1 concombre", "Quelques feuilles de menthes séchées", "Sel et poivre", "3 c. à soupe d'huile d'olive", "2 c. à soupe de citron", "Des œufs durs", "Olives"],
      steps: [
        "Coupez le concombre, la tomate, le poivron, et l'oignon en petits cubes.",
        "Mettez le tout dans un saladier et mélangez.",
        "Dans un petit bol, mélangez à l'aide d'une fourchette le jus de citron, l'huile d'olive, sel et poivre.",
        "Incorporez cette préparation au mélange de légumes coupés et ajouter la menthe séchée.",
        "Versez dans un plat à servir, et décorez avec des oeufs durs et des olives."
      ],
      type: RecetteType.Salades
  ),
  Recette(
      title: "Salade méchwiya",
      prep_time: 15,
      cook_time: 15,
      persons: 4,
      ingredients: ["Poivrons", "1 aubergine", "Tomates", "2 gousses d'ail", "Thon", "1 œuf dur", "1 oignon", "1 c. à café de carvi", "Sel", "Huile d'olive"],
      steps: [
        "Mettre les poivrons, les tomates, les oignons, les aubergines et les gousses d'ail sur une plaque. Les faire griller.",
        "Une fois les légumes grillés de tous les côtés, Les mettre dans un sac plastique puis les éplucher et les écraser.",
        "Assaisonner avec du carvi moulu et sel. Ajouter l'huile d'olive.",
        "Dresser dans un plat de service et décorer de thon, d'olives et d'œuf dur."
      ],
      type: RecetteType.Salades
  ),

  Recette(
      title: "Mhalbia",
      prep_time: 10,
      cook_time: 20,
      persons: 4,
      ingredients: ["500 ml de lait", "150 gr de riz", "60 gr de sucre", "3 c. à soupe de lait concentré sucré", "Eau de rose"],
      steps: [
        "Mettre le riz et le lait dans une casserole.",
        "Ajouter le sucre et mélanger.",
        "Mettre sur le feu et remuer sans cesse jusqu'à ce que le riz au lait soit crémeux.",
        "Ajouter le lait concentré et l'eau de rose tout en remuant.",
        "Goûter pour vérifier que le riz est tendre et mettre hors du feu.",
      ],
      type: RecetteType.Desserts
  ),
  Recette(
      title: "Bouza",
      prep_time: 2,
      cook_time: 10,
      persons: 4,
      ingredients: ["1 sachet de prépration bouza", "500 ml de lait", "4 c. à soupe de sucre"],
      steps: [
        "Dans une casserole, mélanger le sachet de préparation bouza, le lait et le sucre.",
        "Mettre sur le feu en remuant sans arrêt à l'aide d'un fouet.",
        "Verser dans des verres."
      ],
      type: RecetteType.Desserts
  ),


];