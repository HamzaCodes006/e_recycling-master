import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class PaymentRepository {
  // Merchant account information
  final String _ppMerchantID = "MC32238";
  final String _ppPassword = "duy9wub134";
  final String _integeritySalt = "z2v85y84ww";
  final String _ppLanguage = "EN";

  final String _ppVer = "2.0";
  final String _ppTxnCurrency = "PKR";
  late Digest sha256Result;
  String responseCode="";

  // ignore: missing_return
  Future<String> makeTransactionThroughMWallet(
      { required String ppAmount,
         required String ppDescription,
         required String cnic,
         required String mobileNumber}

         ) async {
    final String _postURL =
        'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/2.0/Purchase/DoMWalletTransaction';
    try {
      String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
      String dexpiredate = DateFormat("yyyyMMddHHmmss")
          .format(DateTime.now().add(Duration(minutes: 5)));
      String ppTxnDateTime = dateandtime.toString();
      String ppTxnExpiryDateTime = dexpiredate.toString();
      String ppBillReference = 'billRef';
      String tre = "T" + dateandtime;
      String and = '&';
      String ppTxnType = 'MWALLET';
      String ppDescription = 'Description';
      String ppTxnRefNo = tre.toString();
      String superdata;

      try {
        superdata = _integeritySalt +
            and +
            _ppLanguage +
            and +
            _ppMerchantID +
            and +
            _ppPassword +
            and +
            _ppTxnCurrency +
            and +
            ppAmount +
            and +
            ppBillReference +
            and +
            ppDescription +
            and +
            ppTxnDateTime +
            and +
            ppTxnExpiryDateTime +
            and +
            ppTxnRefNo +
            and +
            ppTxnType +
            and +
            _ppVer;
        var key = utf8.encode(_integeritySalt);
        var bytes = utf8.encode(superdata);
        var hmacSha256 = new Hmac(sha256, key);
        sha256Result = hmacSha256.convert(bytes);

      } catch (e) {
        print(e);
      }
      var url=Uri.parse(_postURL);

      var response = await http.post(url, body: {
        "pp_Version": _ppVer,
        "pp_TxnType": ppTxnType,
        "pp_Language": _ppLanguage,
        "pp_MerchantID": _ppMerchantID,
        "pp_SubMerchantID": "",
        "pp_Password": _ppPassword,
        "pp_TxnRefNo": tre,
        "pp_Amount": ppAmount,
        "pp_TxnCurrency": _ppTxnCurrency,
        "pp_TxnDateTime": dateandtime,
        "pp_BillReference": ppBillReference,
        "pp_DiscountedAmount": "",
        "pp_Description": ppDescription,
        "pp_TxnExpiryDateTime": dexpiredate,
        "pp_ReturnURL": _postURL,
        "pp_SecureHash": sha256Result.toString(),
        "pp_MobileNumber": mobileNumber,
        "pp_CNIC": cnic,
        "ppmpf_1": "",
        "ppmpf_2": "",
        "ppmpf_3": "",
        "ppmpf_4": "",
        "ppmpf_5": "",
      });
      responseCode=response.statusCode.toString();
      print(response.body);
      return json.decode(response.body);
    } catch (e) {
      print("Expection: $e");
    }
return responseCode;


  }
}