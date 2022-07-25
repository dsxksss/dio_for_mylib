import 'package:test_server/http_lib.dart';

void main(List<String> arguments) {
  Future a() async {
    UserHttpLib signin = UserHttpLib();
    var obj = await signin.signIn(data: {
      "account": "3066556430@qq.com",
      "password": "123456789",
    });
    print(obj["headers"]["x-auth-token"]![0]);
    // _loginIn(_re.headers["x-auth-token"]![0]);
  }

  a();
  // Future.delayed(Duration(seconds: 2), () async {
  //   await signin.signUp({
  //     "name": "test2",
  //     "email": "3066556430@qq.com",
  //     "password": "123456789",
  //   });
  // });
}
