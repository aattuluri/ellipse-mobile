import 'package:flutter/material.dart';
import '../components/colors.dart';

class AppStyles {
  // Text style for paragraph text.
  static TextStyle textStyleParagraph(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.medium,
        fontWeight: FontWeight.w200,
        color: CustomColors.primaryTextColor);
  }

  // Text style for paragraph text with primary color.
  static TextStyle textStyleParagraphPrimary(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.medium,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  // Text style for thin paragraph text with primary color.
  static TextStyle textStyleParagraphThinPrimary(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w600,
        color: CustomColors.primaryTextColor);
  }

  // Text style for paragraph text with primary color.
  static TextStyle textStyleParagraphSuccess(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  // For snackbar/Toast text
  static TextStyle textStyleSnackbar(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  // Text style for primary button
  static TextStyle textStyleButtonPrimary(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes._large,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  // Green primary button
  static TextStyle textStyleButtonPrimaryGreen(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes._large,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  // Text style for outline button
  static TextStyle textStyleButtonPrimaryOutline(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes._large,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  // Text style for small outline button
  static TextStyle textStyleButtonPrimarySmallOutline(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  // Text style for small success outline button
  static TextStyle textStyleButtonSuccessSmallOutline(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  static TextStyle textStyleButtonPrimaryOutlineDisabled(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes._large,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  // Text style for success outline button
  static TextStyle textStyleButtonSuccessOutline(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes._large,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  // Text style for text outline button
  static TextStyle textStyleButtonTextOutline(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes._large,
        fontWeight: FontWeight.w700,
        color: CustomColors.primaryTextColor);
  }

  // General address/seed styles
  static TextStyle textStyleAddressPrimary60(BuildContext context) {
    return TextStyle(
      color: CustomColors.primaryTextColor,
      fontSize: AppFontSizes.small,
      height: 1.5,
      fontWeight: FontWeight.w100,
      fontFamily: 'OverpassMono',
    );
  }

  static TextStyle textStyleAddressPrimary(BuildContext context) {
    return TextStyle(
      color: CustomColors.primaryTextColor,
      fontSize: AppFontSizes.small,
      height: 1.5,
      fontWeight: FontWeight.w100,
      fontFamily: 'OverpassMono',
    );
  }

  static TextStyle textStyleAddressSuccess(BuildContext context) {
    return TextStyle(
      color: CustomColors.primaryTextColor,
      fontSize: AppFontSizes.small,
      height: 1.5,
      fontWeight: FontWeight.w100,
      fontFamily: 'OverpassMono',
    );
  }

  static TextStyle textStyleAddressText60(BuildContext context) {
    return TextStyle(
      color: CustomColors.primaryTextColor,
      fontSize: AppFontSizes.small,
      height: 1.5,
      fontWeight: FontWeight.w100,
      fontFamily: 'OverpassMono',
    );
  }

  static TextStyle textStyleAddressText90(BuildContext context) {
    return TextStyle(
      color: CustomColors.primaryTextColor,
      fontSize: AppFontSizes.small,
      height: 1.5,
      fontWeight: FontWeight.w100,
      fontFamily: 'OverpassMono',
    );
  }

  // Text style for alternate currencies on home page
  static TextStyle textStyleCurrencyAlt(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w600,
        color: CustomColors.primaryTextColor);
  }

  static TextStyle textStyleCurrencyAltHidden(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w600,
        color: Colors.transparent);
  }

  // Text style for primary currency on home page
  static TextStyle textStyleCurrency(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes._largest,
        fontWeight: FontWeight.w900,
        color: CustomColors.primaryTextColor);
  }

  // Text style for primary currency on home page
  static TextStyle textStyleCurrencySmaller(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: CustomColors.primaryTextColor);
  }

  /* Transaction cards */
  // Text style for transaction card "Received"/"Sent" text
  static TextStyle textStyleTransactionType(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w600,
        color: CustomColors.primaryTextColor);
  }

  // Amount
  static TextStyle textStyleTransactionAmount(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        color: CustomColors.primaryTextColor,
        fontSize: AppFontSizes.smallest,
        fontWeight: FontWeight.w600);
  }

  // Unit (e.g. BAN)
  static TextStyle textStyleTransactionUnit(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      color: CustomColors.primaryTextColor,
      fontSize: AppFontSizes.smallest,
      fontWeight: FontWeight.w100,
    );
  }

  // Address
  static TextStyle textStyleTransactionAddress(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.smallest,
      fontFamily: 'OverpassMono',
      fontWeight: FontWeight.w100,
      color: CustomColors.primaryTextColor,
    );
  }

  // Transaction Welcome
  static TextStyle textStyleTransactionWelcome(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.small,
      fontWeight: FontWeight.w200,
      color: CustomColors.primaryTextColor,
      fontFamily: 'NunitoSans',
    );
  }

  // Transaction Welcome Text
  static TextStyle textStyleTransactionWelcomePrimary(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.small,
      fontWeight: FontWeight.w200,
      color: CustomColors.primaryTextColor,
      fontFamily: 'NunitoSans',
    );
  }

  // Version info in settings
  static TextStyle textStyleVersion(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w100,
        color: CustomColors.primaryTextColor);
  }

  static TextStyle textStyleVersionUnderline(BuildContext context) {
    return TextStyle(
        fontFamily: "NunitoSans",
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w100,
        color: CustomColors.primaryTextColor,
        decoration: TextDecoration.underline);
  }

  // Text style for alert dialog header
  static TextStyle textStyleDialogHeader(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes._large,
      fontWeight: FontWeight.w700,
      color: CustomColors.primaryTextColor,
    );
  }

  // Text style for dialog options
  static TextStyle textStyleDialogOptions(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes.medium,
      fontWeight: FontWeight.w600,
      color: CustomColors.primaryTextColor,
    );
  }

  // Text style for dialog button text
  static TextStyle textStyleDialogButtonText(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes.smallest,
      fontWeight: FontWeight.w600,
      color: CustomColors.primaryTextColor,
    );
  }

  // Text style for seed text
  static TextStyle textStyleSeed(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.small,
      fontWeight: FontWeight.w100,
      fontFamily: 'OverpassMono',
      color: CustomColors.primaryTextColor,
      height: 1.5,
      letterSpacing: 1,
    );
  }

  static TextStyle textStyleSeedGray(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.small,
      fontWeight: FontWeight.w100,
      fontFamily: 'OverpassMono',
      color: CustomColors.primaryTextColor,
      height: 1.5,
      letterSpacing: 1,
    );
  }

  // Text style for mnemonic text
  static TextStyle textStyleMnemonicText(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.smallText(context),
      fontWeight: FontWeight.w100,
      fontFamily: 'OverpassMono',
      color: CustomColors.primaryTextColor,
      height: 1,
      letterSpacing: 1,
    );
  }

  static TextStyle textStyleMnemonicTextGray(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.smallText(context),
      fontWeight: FontWeight.w100,
      fontFamily: 'OverpassMono',
      color: CustomColors.primaryTextColor,
      height: 1,
      letterSpacing: 1,
    );
  }

  static TextStyle textStyleSeedGreen(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.small,
      fontWeight: FontWeight.w100,
      fontFamily: 'OverpassMono',
      color: CustomColors.primaryTextColor,
      height: 1.5,
      letterSpacing: 1,
    );
  }

  // Text style for general headers like sheet headers
  static TextStyle textStyleHeader(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes.largest(context),
      fontWeight: FontWeight.w700,
      color: CustomColors.primaryTextColor,
    );
  }

  // Text style for settings headers
  static TextStyle textStyleSettingsHeader(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes._largest,
      fontWeight: FontWeight.w700,
      color: CustomColors.primaryTextColor,
    );
  }

  // Text style for primary color header
  static TextStyle textStyleHeaderColored(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes._largest,
      fontWeight: FontWeight.w700,
      color: CustomColors.primaryTextColor,
    );
  }

  // Text style for primary color header
  static TextStyle textStyleHeader2Colored(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes.larger,
      fontWeight: FontWeight.w700,
      color: CustomColors.primaryTextColor,
    );
  }

  static TextStyle textStylePinScreenHeaderColored(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes._large,
      fontWeight: FontWeight.w700,
      color: CustomColors.primaryTextColor,
    );
  }

  static TextStyle textStyleLogoutButton(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes.small,
      fontWeight: FontWeight.w600,
      color: CustomColors.primaryTextColor,
    );
  }

  // Text style for setting item header
  static TextStyle textStyleSettingItemHeader(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes.medium,
      fontWeight: FontWeight.w600,
      color: CustomColors.primaryTextColor,
    );
  }

  static TextStyle textStyleSettingItemHeader60(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes.medium,
      fontWeight: FontWeight.w600,
      color: CustomColors.primaryTextColor,
    );
  }

  static TextStyle textStyleSettingItemHeader45(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes.medium,
      fontWeight: FontWeight.w600,
      color: CustomColors.primaryTextColor,
    );
  }

  // Text style for setting item subheader
  static TextStyle textStyleSettingItemSubheader(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes.smallest,
      fontWeight: FontWeight.w100,
      color: CustomColors.primaryTextColor,
    );
  }

  static TextStyle textStyleSettingItemSubheader30(BuildContext context) {
    return TextStyle(
      fontFamily: "NunitoSans",
      fontSize: AppFontSizes.smallest,
      fontWeight: FontWeight.w100,
      color: CustomColors.primaryTextColor,
    );
  }

  // Text style for lock screen error
  static TextStyle textStyleErrorMedium(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.small,
      color: CustomColors.primaryTextColor,
      fontFamily: 'NunitoSans',
      fontWeight: FontWeight.w600,
    );
  }

  // Text style for mnemonic
  static TextStyle textStyleMnemonic(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.smallText(context),
      color: CustomColors.primaryTextColor,
      fontFamily: 'OverpassMono',
      fontWeight: FontWeight.w100,
    );
  }

  // Text style for mnemonic success
  static TextStyle textStyleMnemonicSuccess(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.smallText(context),
      color: CustomColors.primaryTextColor,
      fontFamily: 'OverpassMono',
      fontWeight: FontWeight.w100,
    );
  }

  // Text style for numbers of mnemonic
  static TextStyle textStyleNumbersOfMnemonic(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.smallText(context),
      color: CustomColors.primaryTextColor,
      fontFamily: 'OverpassMono',
      fontWeight: FontWeight.w100,
    );
  }

  // Text style for numbers of mnemonic
  static TextStyle headerPrimary(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: CustomColors.primaryTextColor,
      fontFamily: 'NunitoSans',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle headerSuccess(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: CustomColors.primaryTextColor,
      fontFamily: 'NunitoSans',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle addressText(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      color: CustomColors.primaryTextColor,
      fontFamily: 'NunitoSans',
      fontWeight: FontWeight.w400,
    );
  }
}

class AppFontSizes {
  static const smallest = 12.0;
  static const small = 14.0;
  static const medium = 16.0;
  static const _large = 20.0;
  static const larger = 24.0;
  static const _largest = 28.0;
  static const largestc = 28.0;
  static const _sslarge = 18.0;
  static const _sslargest = 22.0;
  static double largest(context) {
    if (smallScreen(context)) {
      return _sslargest;
    }
    return _largest;
  }

  static double large(context) {
    if (smallScreen(context)) {
      return _sslarge;
    }
    return _large;
  }

  static double smallText(context) {
    if (smallScreen(context)) {
      return smallest;
    }
    return small;
  }
}

bool smallScreen(BuildContext context) {
  if (MediaQuery.of(context).size.height < 667)
    return true;
  else
    return false;
}
