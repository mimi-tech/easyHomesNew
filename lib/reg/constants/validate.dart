class Validators{
  static String? validateAddress(String? value) {
    if(value!.isEmpty) {
      return "Sorry your address is not found";
    }

    return null;
  }



  static String? validateMobile(String value) {
    if(value.isEmpty) {
      return "Sorry your mobile number is not found";
    }

    return null;
  }
}