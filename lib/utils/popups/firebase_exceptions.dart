class TFirebaseException implements Exception{

  final String code;

  TFirebaseException(this.code);

  String get message {
    switch(code){
      case 'unknown':
        return 'An unknown Firebase error occurred.';
        case 'invalid-custom-token':
        return 'The custom token format is incorrect';
        case 'custom-token-mismatch':
        return 'The custom token corresponds to a different audience';
        case 'user-disabled':
        return 'The user account has been disabled';
        case 'user-not-found':
        return 'No user found';

      default:
        return 'An Unexpected Firebase error occurred!';
    }
  }
}