import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

const storage = FlutterSecureStorage();

SendEmail(receiverEmail,receiverLinkedInurl) async{
  String username = 'saurabh9759mishra@gmail.com';
  String password = 'qrqbdrjmhnnonhul'; //Must use G_Oauth.

  String? senderLinkedInUrl = await storage.read(key: "login_urn");

  final smtpServer = gmail(username,password);
  final receiversMessage = Message()
    ..from = Address(username,"Matrix App")
    ..recipients.add(receiverEmail)
    ..subject = 'You Have A new Connection Request through Matrix App:: 😀 :: ${DateTime.now()}'
    ..html = "<h1>Hello</h1>\n<p>You have got a new connection request from $senderLinkedInUrl</p>";

  final sendersMessage = Message()
    ..from = Address(username,"Matrix App")
    ..recipients.add(await storage.read(key:"login_email"))
    ..subject = 'You Have Successfully Sent the request through Matrix App:: 😀 :: ${DateTime.now()}'
    ..html = "<h1>Hello</h1>\n<p>Hey! You have sent the connection request to $receiverLinkedInurl</p>";

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



