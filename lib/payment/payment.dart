import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

// class using only one funct just me

class JazzCashPayment{

  final String _ppMerchantID = "MC12917";
  final String _ppPassword = "dt2atv2839";
  final String _integeritySalt = "98dw483ety";
  final String _ppLanguage = "EN";

  final String _ppVer = "2.0";
  final String _ppTxnCurrency = "PKR";
  final String ppAmount="1000";

  final String cnic="345678";
  final String mobileNumber="03123456780";
  final String _postURL =
      'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/2.0/Purchase/DoMWalletTransaction';

  var response;
  late Digest sha256Result;

  doPayment() async {

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

      response = await http.post(url, body: {
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
      print(response.body);
      return json.decode(response.body);
    } catch (e) {
      print("Expection: $e");
    }
    return response.body;

  }

}