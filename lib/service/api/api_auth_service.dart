import 'package:yazar/service/base/auth_service.dart';

class ApiAuthService implements AuthService{
  @override
  Future<String> signInWithEmailPassword(String email, String password) async{
    return "";

  }

  @override
  Future<String> signInWithGoogle() async{
    return "";

  }

  @override
  Future<String> signInWithApple() async{
    return "";
  }

}