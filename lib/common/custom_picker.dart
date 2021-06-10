import 'package:flutter/material.dart';
import 'package:flutter_template_app/common/custom_text_field.dart';

/// [CustomPicker] looks like [CustomTextField], but using as a button.
class CustomPicker<T> extends StatelessWidget {
  final String? textHint;
  final Function()? changeCallback;
  final bool? autoValidate;
  final IconData? icon;
  final T? currentValue;
  final String? displayedValue;
  final String errorMessage;

  const CustomPicker(
      {Key? key,
      this.textHint,
      this.changeCallback,
      this.autoValidate,
      this.icon,
      this.currentValue,
      this.displayedValue,
      required this.errorMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                onTap: changeCallback,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: autoValidate! && currentValue == null
                          ? Theme.of(context).errorColor
                          : Colors.black,
                      width: autoValidate! && currentValue == null ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(22, 18, 12, 20),
                        child: currentValue == null
                            ? Text(
                                textHint!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Theme.of(context).hintColor),
                              )
                            : Text(
                                displayedValue!,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(
                        icon,
                        size: 22,
                        color: autoValidate! && currentValue == null
                            ? Theme.of(context).errorColor
                            : Colors.black,
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ],
        ),
        autoValidate! && currentValue == null
            ? Padding(
                padding: EdgeInsets.only(left: 22, top: 6),
                child: Text(errorMessage,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).errorColor,
                        fontWeight: FontWeight.w400)),
              )
            : SizedBox()
      ],
    );
  }
}
