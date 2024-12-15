import 'package:get/get.dart';
import 'package:mysaiph/Screens/Quiz/controller/quiz_controller.dart';

class BilndingsApp implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuizController());
  }
}
