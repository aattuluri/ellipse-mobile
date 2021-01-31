import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../util/index.dart';

class Acceptance extends StatelessWidget {
  final String text;
  final bool pp;
  const Acceptance(this.text, this.pp);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: text,
            children: [
              if (pp) ...[
                TextSpan(
                  text: 'PRIVACY POLICY',
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, Routes.pdfView, arguments: {
                        'title': 'Privacy Policy',
                        'link': "https://ellipseapp.com/Privacy_Policy.pdf"
                      });
                    },
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                TextSpan(
                  text: ' & ',
                ),
              ],
              TextSpan(
                text: 'TERMS AND CONDITIONS',
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, Routes.mdDecode, arguments: {
                      'title': 'Terms and Conditions',
                      'url':
                          'https://gunasekhar0027.github.io/ellipsedata/terms_and_conditions.md'
                    });
                  },
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
