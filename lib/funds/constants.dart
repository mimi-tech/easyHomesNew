class Deposit{
  static int? amount;
  static String? otpText;
  static String  resolveAccount = 'https://api.flutterwave.com/v3/accounts/resolve';
  static String  initiatePayment = 'https://api.flutterwave.com/v3/charges?type=debit_ng_account';
  static String  checkOtp = 'https://api.flutterwave.com/v3/validate-charge';
  static String  checkTransfer = 'https://api.flutterwave.com/v3/charges?type=bank_transfer';
  static String  checkUSSD = 'https://api.flutterwave.com/v3/charges?type=ussd';
}