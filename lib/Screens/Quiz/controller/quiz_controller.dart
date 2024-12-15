import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysaiph/Screens/Quiz/model/question_model.dart';
import 'package:mysaiph/Screens/Quiz/screens/result_screen/result_screen.dart';
import 'package:mysaiph/Screens/Quiz/screens/welcome_screen.dart';

class QuizController extends GetxController {
  String name = '';
  BuildContext? context = null;

  //question variables
  int get countOfQuestion => _questionsList.length;
  List<QuestionModel> _questionsList = [
    QuestionModel(
      id: 1,
      question: "La dose journalière maximale de ADOL est de:",
      answer: 2,
      options: [' 3G', ' 4G', ' 5G'],
    ),
    QuestionModel(
      id: 2,
      question: "L’intervalle à respecter entre les prises d’ADOL1000 est de :",
      answer: 2,
      options: [' 2h minimum', ' 4h minimum', ' 6h minimum'],
    ),
    QuestionModel(
      id: 3,
      question: "ADOL EXTRA:",
      answer: 3,
      options: [
        ' Contient du Paracétamol + Tramadol',
        ' La boite est de couleur Jaune',
        ' Le seul Paracétamol Caféiné en Tunisie qui contient 20 Comprimés pour une meilleure observance'
      ],
    ),
    QuestionModel(
      id: 4,
      question:
      "DYSFEN® la Flurbiprofène de SAIPH est considéré comme le meilleur traitement efficace contre les règles douloureuses Versus tous les AINS:",
      answer: 1,
      options: [' OUI', ' NON'],
    ),
    QuestionModel(
      id: 5,
      question:
      "DYSFEN® la Flurbiprofène de SAIPH est un Anti-inflammatoire non stéroïdien (AINS) avec une activité:",
      answer: 3,
      options: [
        ' Antalgique',
        'Anti-inflammatoire',
        'Antalgique, Anti-inflammatoire & Antipyrétique'
      ],
    ),
    QuestionModel(
      id: 6,
      question: "DYSFEN® la Flurbiprofène de SAIPH est indiqué dans:",
      answer: 2,
      options: [
        ' Les Dysménorrhées (Les règles douloureuses)',
        ' Les Dysménorrhées, l’angine et les infections Rhumatismales'
      ],
    ),
    QuestionModel(
      id: 7,
      question:
      "Dans votre pratique quotidienne, L’avantage d’utilisation de « Vita D3 ®» de SAIPH par rapport à son concurrent direct Vitamine D3 B.O.N ® d’Opalia :",
      answer: 1,
      options: [
        ' Présence du Code-barres & d’une vignette',
        ' Présence d’une vignette'
      ],
    ),
    QuestionModel(
      id: 8,
      question:
      "La Vita B12® de SAIPH est la seule vitamine B12 disponible sur le marché tunisien :",
      answer: 1,
      options: [' VRAI', ' FAUX'],
    ),
    QuestionModel(
      id: 9,
      question: "CYSTODOSE® est la seule fosfomycine made in Tunisia :",
      answer: 1,
      options: [' VRAI', ' FAUX'],
    ),
    QuestionModel(
      id: 10,
      question: "CIPRO Saiph®   est de la famille des Fluoroquinolones :",
      answer: 1,
      options: [' VRAI', ' FAUX'],
    ),
    QuestionModel(
      id: 11,
      question: "Quels sont les composants de D-mannosa ?",
      answer: 3,
      options: [
        ' Canneberge',
        ' D-mannose',
        ' Association de Canneberge et de D-mannose'
      ],
    ),
    QuestionModel(
      id: 12,
      question: "Quel est le nombre de sachets dans la boite de D-mannosa ?",
      answer: 1,
      options: [' 14', ' 20', ' 10'],
    ),
    QuestionModel(
      id: 13,
      question: "Quel est le goût Faloxim PPS ?",
      answer: 3,
      options: [' Orange', ' Pêche', ' Fraise'],
    ),
    QuestionModel(
      id: 14,
      question: "Est-ce que Flutica est base de remboursement CNAM ?",
      answer: 1,
      options: [' OUI', ' NON'],
    ),
    QuestionModel(
      id: 15,
      question:
      "SAIFOXYL 1g BTE 24 est l’unique boite d’Amoxicilline avec 24 comprimés ?",
      answer: 1,
      options: [' OUI', ' NON'],
    ),
    QuestionModel(
      id: 16,
      question: "SAIFOXYL PPS est délicieux grâce à son goût",
      answer: 1,
      options: [
        ' Cocktail pêche+ abricot+ orange',
        ' Fraise',
        ' Orange',
      ],
    ),
    QuestionModel(
      id: 17,
      question: "AIRGIX est disponible en combien de présentations ?",
      answer: 1,
      options: [
        ' 3: BTE 10, BTE 20, BTE 30',
        ' 2: BTE 10 et BTE 20',
        ' 1 seule BTE 10',
      ],
    ),
    QuestionModel(
      id: 18,
      question:
      "OROKEN est le seul céfixime qui dispose de la boite de 8 comprimés ?",
      answer: 1,
      options: [' Oui', ' Non'],
    ),
    QuestionModel(
      id: 19,
      question: "Quelle est la DCI de CIPROSAIPH ?",
      answer: 1,
      options: [' Ciprofloxacine', ' Levofloxacine', ' Amoxicilline '],
    ),
    QuestionModel(
      id: 20,
      question: "Quelles sont les présentations de BIOGYL ?",
      answer: 1,
      options: [' Bte 10 ET BTE 20', ' BTE 10'],
    ),
  ];
  List<QuestionModel> get questionsList => [... _questionsList];

  bool _isPressed = false;
  bool get isPressed => _isPressed;

  double _numberOfQuestion = 1;
  double get numberOfQuestion => _numberOfQuestion;

  int? _selectAnswer;
  int? get selectAnswer => _selectAnswer;

  int? _correctAnswer;
  int _countOfCorrectAnswers = 0;
  int get countOfCorrectAnswers => _countOfCorrectAnswers;

  final Map<int, bool> _questionIsAnswered = {};

  late PageController pageController;

  Timer? _timer;
  final maxSec = 15;
  final RxInt _sec = 15.obs;
  RxInt get sec => _sec;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    resetAnswer();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  int get scoreResult {
    return _countOfCorrectAnswers;
  }

  void checkAnswer(QuestionModel questionModel, int selectAnswer) {
    _isPressed = true;

    _selectAnswer = selectAnswer;
    _correctAnswer = questionModel.answer;

    if (_correctAnswer == _selectAnswer) {
      _countOfCorrectAnswers++;
    }
    stopTimer();
    _questionIsAnswered.update(questionModel.id, (value) => true);
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => nextQuestion());
    update();
  }

  bool checkIsQuestionAnswered(int quesId) {
    return _questionIsAnswered.entries
        .firstWhere((element) => element.key == quesId)
        .value;
  }

  void nextQuestion() {
    if (_timer != null && _timer!.isActive) {
      stopTimer();
    }

    if (pageController.page == _questionsList.length - 1) {
      Navigator.pushReplacement(
        context!,
        MaterialPageRoute(
          builder: (context) => ResultScreen(),
        ),
      );
    } else {
      _isPressed = false;
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );

      startTimer();
    }
    _numberOfQuestion = pageController.page! + 2;
    update();
  }

  void resetAnswer() {
    _questionIsAnswered.clear();
    for (var element in _questionsList) {
      _questionIsAnswered[element.id] = false;
    }
    _countOfCorrectAnswers = 0;
    _selectAnswer = null;
    _correctAnswer = null;
    _sec.value = maxSec;
    _numberOfQuestion = 1;
    _isPressed = false;
    _questionsList.shuffle(Random());
    _questionsList = _questionsList.sublist(0, 10);
    update();
  }

  Color getColor(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Colors.green.shade700;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Colors.red.shade700;
      }
    }
    return Color(0xFF273085);
  }

  IconData getIcon(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Icons.done;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Icons.close;
      }
    }
    return Icons.close;
  }

  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sec.value > 0) {
        _sec.value--;
      } else {
        stopTimer();
        nextQuestion();
      }
    });
  }

  void resetTimer() => _sec.value = maxSec;

  void stopTimer() => _timer?.cancel();
  void startAgain() {
    _correctAnswer = null;
    _countOfCorrectAnswers = 0;
    resetAnswer();
    _selectAnswer = null;
    _questionsList.shuffle(Random());
    _questionsList = _questionsList.sublist(0, 10);
    update();
  }
}