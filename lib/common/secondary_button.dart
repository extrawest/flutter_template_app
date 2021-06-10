import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Function? callback;
  final String? buttonText;

  const SecondaryButton({Key? key, this.callback, this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).accentColor, width: 1),
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: callback as void Function()?,
      color: Theme.of(context).primaryColor,
      disabledColor: Theme.of(context).hintColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(buttonText!,
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Theme.of(context).accentColor)),
          ),
        ],
      ),
    );
  }
}
