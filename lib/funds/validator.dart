class Validator{
  static String? validateAMount(String? value) {
    if(value!.isEmpty) {
      return "Amount can't be empty";
    }

    if(int.parse(value) < 1000) {
      return "Amount can't be below 1000.00";
    }

    return null;
  }


  static String? validateWalletAMount(String? value) {
    if(value!.isEmpty) {
      return "Amount can't be empty";
    }

    if(int.parse(value) < 0) {
      return "Amount can't be below 0.00";
    }

    return null;
  }

  static String? validateCard(String? value) {
    if(value!.isEmpty) {
      return "Please enter card number";
    }


    return null;
  }

  static String? validateCardName(String? value) {
    if(value!.isEmpty) {
      return "Please enter name in the card";
    }


    return null;
  }

  static String? validateBankAccount(String? value) {
    if(value!.isEmpty) {
      return "Please choose your bank";
    }


    return null;
  }

  static String? validateBankAccountNumber(String? value) {
    if(value!.isEmpty) {
      return "Please enter your account number";
    }
    if(int.parse(value) > 10) {
      return "Account number should not be more than 10 digits";
    }

    return null;
  }

  static String? validateExp(String? value) {
    if(value!.isEmpty) {
      return "Expiring date";
    }


    return null;
  }

  static String? validateCvv(String? value) {
    if(value!.isEmpty) {
      return "Card cvv";
    }


    return null;
  }



  static String? validateDate(String? value) {
    if (value!.isEmpty) {
      //return Strings.fieldReq;
    }

    int year;
    int month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(new RegExp(r'(\/)'))) {
      var split = value.split(new RegExp(r'(\/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      month = int.parse(split[0]);
      year = int.parse(split[1]);

    } else { // Only the month was entered
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }

    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Expiry month is invalid';
    }

    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid year should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Expiry year is invalid';
    }

    if (!hasDateExpired(month, year)) {
      return "Card has expired";
    }
    return null;
  }


  /// Convert the two-digit year to four-digit year if necessary
  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }


  static bool hasDateExpired(int month, int year) {
    return !(month == null || year == null) && isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is less than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently, is greater than card's
    // year
    return fourDigitsYear < now.year;
  }
}