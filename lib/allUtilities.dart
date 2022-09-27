import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SecureStorageService{
  final FlutterSecureStorage storage;
  const SecureStorageService({required this.storage});

  Future<String?>? read ({AndroidOptions? aOptions, IOSOptions? iOptions, required String key, LinuxOptions? lOptions, MacOsOptions? mOptions, WindowsOptions? wOptions, WebOptions? webOptions}) async {
    return storage.read(key: key, aOptions: aOptions, iOptions: iOptions, lOptions: lOptions, mOptions: mOptions, webOptions: webOptions, wOptions: wOptions);
  }

  Future<void> write({AndroidOptions? aOptions, IOSOptions? iOptions, required String key, LinuxOptions? lOptions, MacOsOptions? mOptions, required String? value, WindowsOptions? wOptions, WebOptions? webOptions})async {
    storage.write(key: key, value: value, aOptions: aOptions, iOptions: iOptions, lOptions: lOptions, mOptions: mOptions, webOptions: webOptions, wOptions: wOptions);
  }
}

class MockSecureStorageService {

  final Map map = const {'login_urn':'asfsafs', "login_email":"mawaris99@gmail.com", "login_status":"false"};

  MockSecureStorageService() {print("In Mock");}

  Future<String?> read({String? key}){
    return Future.value(map[key]);
  }
  Future<void> write({String? key, String? value})async {
    Future.delayed(Duration(milliseconds: 50), () {
      map[key] = value;
    },);
  }
}

// const storage = SecureStorageService(storage: FlutterSecureStorage());
MockSecureStorageService storage = MockSecureStorageService();

Future<bool> SendEmail(senderEmail, senderLinkedInUrl, receiverEmail,receiverLinkedInurl) async{
  String username = 'saurabh9759mishra@gmail.com';
  String password = 'qrqbdrjmhnnonhul'; //Must use G_Oauth.
  final smtpServer = gmail(username,password);
  final receiversMessage = Message()
    ..from = Address(username,"Matrix App")
    ..recipients.add(receiverEmail)
    ..subject = 'Scanned Alert! ${DateTime.now()}'
    ..html = "<h1>Hello</h1>\n<p>Your LinkedIn profile has been visited by $senderLinkedInUrl through Matrix App</p>";

  final sendersMessage = Message()
    ..from = Address(username,"Matrix App")
    ..recipients.add(senderEmail)
    ..subject = 'Scanning Alert! at ${DateTime.now()}'
    ..html = "<h1>Hello</h1>\n<p>You have scanned Matrix QR and visted $receiverLinkedInurl</p>";

  try {
    var connection = PersistentConnection(smtpServer);

    await connection.send(receiversMessage);

    await connection.send(sendersMessage);

    await connection.close();

    return true;
  }
  on MailerException catch (e) {
    return false;
  }
}


