import 'package:yazar/base/auth_base.dart';
import 'package:yazar/service/api/api_auth_service.dart';
import 'package:yazar/service/base/auth_service.dart';
import 'package:yazar/tools/locator.dart';

class AuthRepository implements AuthBase{

  AuthService _authService = locator<ApiAuthService>();
  @override
  Future<String> signInWithEmailPassword(String email, String password) async{

    return _authService.signInWithEmailPassword(email, password);

  }

  @override
  Future<String> signInWithGoogle() async{

    return _authService.signInWithGoogle();

  }

  @override
  Future<String> signInWithApple() async{
   return _authService.signInWithApple();
  }
  
}