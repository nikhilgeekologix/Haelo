import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';

class AddCaseField extends StatelessWidget {
  final addCaseController;
  final addCaseLabel;
  final bool isCaseNo;
  final bool isNumaric;
  const AddCaseField({
    Key? key,
    required this.addCaseController,
    required this.addCaseLabel,
    this.isCaseNo = false,
    this.isNumaric = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("isCaseNo $isCaseNo");
    return TextFormField(
      enabled: isCaseNo,
      maxLength: isNumaric ? 5 : null,
      controller: addCaseController,
      keyboardType: isNumaric ? TextInputType.number : TextInputType.text,
      inputFormatters: !isNumaric
          ? []
          : [
              LengthLimitingTextInputFormatter(isNumaric ? 20 : 200),
              FilteringTextInputFormatter.digitsOnly
            ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        labelText: addCaseLabel,
        labelStyle: const TextStyle(color: Colors.black45),
        suffixIcon: !isCaseNo
            ? const Icon(
                Icons.arrow_drop_down_sharp,
                color: Colors.black38,
              )
            : SizedBox(),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(width: 1, color: Colors.black38),
        ),
        errorBorder: errorboarder,
        focusedBorder: focusboarder,
        border: boarder,
      ),
      style: TextStyle(color: Colors.black),
      // validator: FormValidation().validatePriority,
    );
  }
}
