import '../../common_import.dart';
import 'package:flutter_login/flutter_login.dart';

import 'home_screen.dart';

const users = const {
  '1@1.com': '123456',
};

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: 100);

  Future<String?> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      // if (!users.containsKey(data.name)) {
      //   return '이메일을 확인해주세요.';
      // }
      // if (users[data.name] != data.password) {
      //   return '비밀번호를 확인해주세요.';
      // }
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return '이메일 주소를 확인해주세요.';
      }
      return null;
    });
  }

  AppData appData = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (AppData appData) => Loading(
        child: Scaffold(
          body: FlutterLogin(
            // logo: 'assets/logo.png',
            // showDebugButtons: true,
            // title: '타임코코',
            // theme: ,
            messages: LoginMessages(
                recoverPasswordSuccess: '이메일이 전송되었습니다.',
                flushbarTitleSuccess: '성공',
                flushbarTitleError: '오류',
                confirmPasswordError: '비밀번호를 다시 확인해주세요.',
                userHint: '이메일을 적어주세요.',
                passwordHint: '비밀번호',
                loginButton: '로그인',
                forgotPasswordButton: '비밀번호 찾기',
                signupButton: '회원가입',
                recoverPasswordButton: '재설정 링크 전송',
                recoverPasswordIntro: '비밀번호를 재설정합니다.',
                recoverPasswordDescription:
                    '가입시 사용했던 이메일 주소를 입력해주시면 비밀번호 재설정 링크를 보내드립니다.',
                goBackButton: '뒤로가기',
                confirmPasswordHint: '비밀번호 확인'),
            userValidator: (val) {
              // if (val == null ? false : val.isEmpty) {
              //   return '이메일을 확인해주세요.';
              // }
            },
            passwordValidator: (val) {
              // if (val == null ? false : val.length < 6) {
              //   return '비밀번호가 너무 짧습니다.';
              // }
            },
            onLogin: _authUser,
            onSignup: _authUser,
            onSubmitAnimationCompleted: () {
              Get.off(() => HomeScreen());
            },
            onRecoverPassword: _recoverPassword,
          ),
        ),
      ),
    );
  }
}
