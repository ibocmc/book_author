abstract class AuthBase{

  Future<String> signInWithEmailPassword(String email,String password);
  Future<String> signInWithGoogle();
  Future<String> signInWithApple();

}