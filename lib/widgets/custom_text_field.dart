import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputField extends StatefulWidget {
  InputField(
      {Key? key,
      required this.label,
      required this.prefixIcon,
      this.suffixIcon,
      this.ontapfunction,
      this.textController,
      this.validatorFunction,
      this.keyboardType,
      this.suffix = false})
      : super(key: key);

  final String label;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final Future<void>? ontapfunction;
  final bool suffix;
  TextInputType? keyboardType;
  final String? Function(String?)? validatorFunction;

  TextEditingController? textController;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  RxBool passwordVisible = false.obs;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920), // Choose an appropriate starting year
      lastDate: DateTime.now(), // Disable current and future dates

    );
    if (picked != null && picked != DateTime.now()) {
      // Update the text field with the selected date
      setState(() {
        widget.textController!.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Align(
          alignment: Alignment.center,
          child: SizedBox(
            child: Obx(
              () => TextFormField(
                readOnly: widget.label.contains("Date de Naissance")?true:false,
                onTap: () async {
                  if(widget.label.contains("Date de Naissance")){
                    _selectDate(context);
                  }
                },
                scrollPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).viewInsets.bottom),
                cursorColor: Color(0xff273085),
                controller: widget.textController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: widget.suffix ? !passwordVisible.value : false.obs.value,
                keyboardType: widget.keyboardType,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  hintText: widget.label.contains("Password")
                      ? "********"
                      : widget.label.contains("Email")
                          ? "jane@drinkhint.com	"
                          : '${widget.label}',
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w400),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xff273085),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xff273085),
                    ),
                  ),
                  prefixIcon: Icon(
                    widget.prefixIcon,
                    color: Color(0xff273085),
                    size: 20,
                  ),
                  suffixIcon: widget.suffix
                      ? GestureDetector(
                          onTap: widget.suffix == false
                              ? null
                              : () {
                                  passwordVisible.value =
                                      !passwordVisible.value;
                                },
                          child: Obx(
                            () => Icon(
                              !passwordVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.black.withOpacity(0.5),
                              size: 20,
                            ),
                          ))
                      : null,
                ),
                validator: widget.validatorFunction,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
