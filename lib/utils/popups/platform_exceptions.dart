class TPlatformException implements Exception{

  final String code;

  TPlatformException(this.code);

  String get message {
    switch(code){
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Invalid login credentials';
      case 'too-many-requests':
        return 'Too many requests.';
      case 'invalid-argument':
        return 'Invalid argument provided to the authentication method.';
      case 'invalid-phone-number':
        return 'The provided phone number is invalid';
      case 'session-cookie-expired':
        return 'The Firebase session cookie has expired';
      case 'invalid-password':
        return 'Incorrect password';

      default:
        return 'An error occurred! Please login again.';
    }
  }
}