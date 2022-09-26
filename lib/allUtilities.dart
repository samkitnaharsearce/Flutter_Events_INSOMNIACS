import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

const storage = FlutterSecureStorage();

SendEmail(receiverEmail) async{
  String username = 'saurabh9759mishra@gmail.com';
  String password = 'qrqbdrjmhnnonhul'; //Must use gOauth.


  final smtpServer = gmail(username,password);
  final receiversMessage = Message()
    ..from = Address(username,"Matrix App")
    ..recipients.add(receiverEmail)
    ..subject = 'You Have A new Connection Request through Matrix App:: 😀 :: ${DateTime.now()}'
    ..html = "<h1>Test</h1>\n<p>Hey! You have got a new connection request.</p>";

  final sendersMessage = Message()
    ..from = Address(username,"Matrix App")
    ..recipients.add(await storage.read(key:"login_email"))
    ..subject = 'You Have Successfully Sent the request through Matrix App:: 😀 :: ${DateTime.now()}'
    ..html = "<h1>Test</h1>\n<p>Hey! You have sent the connection request.</p>";

  try {


    var connection = PersistentConnection(smtpServer);

    await connection.send(receiversMessage);

    await connection.send(sendersMessage);

    await connection.close();

    return true;
  } on MailerException catch (e) {
    return false;
  }
}

ShareQR(){
  //Sharing Implementation of QR
}

SaveQR(imgData) async{
  await ImageGallerySaver.saveImage(
      Uint8List.fromList(imgData),
      quality: 100,
      name: "hello");
}



