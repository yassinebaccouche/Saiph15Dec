import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mysaiph/widgets/game_widgets/up_to_down.dart';

import '../../utils/custom_colors.dart';

Future<void> showCustomDialog(
  BuildContext context, {
  required String title,
  required Widget body,
  Widget? picture,
  required bool isNextLevelVisible,
  required bool isRestartVisible,
 required  bool isHomeVisible,
  required bool isOkVisible,
   VoidCallback? restarGameFunction,
   VoidCallback? nextLevelFunction,
}) {
  return showDialog(
    context: context,
    builder: (_) => CustomDialog(
      title: title,
      body: body,
      picture: picture,
      isNextLevelVisible: isNextLevelVisible,
      isRestartVisible: isRestartVisible,
      isHomeVisible: isHomeVisible,
      isOkVisible: isOkVisible,
      restarGameFunction: restarGameFunction,
      nextLevelFunction: nextLevelFunction,
    ),
  );
}

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? picture;
  final VoidCallback? restarGameFunction;
  final VoidCallback? nextLevelFunction;
  final   bool isNextLevelVisible;
  final    bool isRestartVisible;
  final bool isHomeVisible;
  final   bool isOkVisible;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.body,
    this.picture,
     this.nextLevelFunction,
     this.restarGameFunction,
    required this.isOkVisible,
    required this.isHomeVisible,
    required this.isRestartVisible,
    required this.isNextLevelVisible
    ,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: UpToDown(
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: CustomColors.lightBlue2,
            ),
            child: SizedBox(
              width: width / 1.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Column(
                      children: [
                        picture == null ? const SizedBox() : picture!,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: body,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(30),
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(visible: isOkVisible,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: SvgPicture.asset(
                                'assets/images/ok.svg',
                                width: MediaQuery.of(context).size.width / 9,
                              ),
                            ),
                          ),

                          Visibility(visible: isHomeVisible,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(onTap: (){
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                  child: SvgPicture.asset(
                                    'assets/images/home_icon.svg',
                                    width: MediaQuery.of(context).size.width / 9,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Visibility(visible: isRestartVisible,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(onTap: restarGameFunction,
                                  child: SvgPicture.asset(
                                    'assets/images/restart_icon.svg',
                                    width: MediaQuery.of(context).size.width / 9,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Visibility(visible: isNextLevelVisible,
                            child: Row(
                              children: [const SizedBox(
                                width: 15,
                              ),
                                GestureDetector(onTap: nextLevelFunction,
                                  child: SvgPicture.asset(
                                    'assets/images/next_icon.svg',
                                    width: MediaQuery.of(context).size.width / 9,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
