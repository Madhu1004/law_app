class TFirebaseAuthException implements Exception {
  final String code;

  TFirebaseAuthException(this.code);

  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'The email address is already registered. please use a different email.';
      case 'invalid-email':
        return 'The email address is invalid';
      case 'weak-password':
        return 'The password is too weak';
      case 'user-disabled':
        return 'User disabled';
      case 'user-not-found':
        return 'Invalid username or email.';
      case 'wrong-password':
        return 'The password is incorrect.';
      case 'invalid-verification-code':
        return 'Invalid verification';
      case 'invalid-verification-id':
        return 'Invalid Verification id';
      case 'quota-exceeded':
        return 'Quota exceeded, please try again';

      case 'provider-already-linked:':
        return 'Quota exceeded, please try again';

      case 'operation-not-allowed':
        return 'Quota exceeded, please try again';

      case 'missing-verification-code':
        return 'Quota exceeded, please try again';

      case 'claims-too-large':
        return 'Quota exceeded, please try again';

      case 'email-already-exists':
        return 'The provided email is already in use by an existing user.';

      case 'id-token-expired':
        return 'The provided Firebase ID token is expired. ';

      case 'id-token-revoked':
        return 'The Firebase ID token has been revoked.';

      case 'insufficient-permission':
        return 'The credential used to initialize the Admin SDK has insufficient permission to access the requested Authentication resource.';

      case 'internal-error':
        return 'The Authentication server encountered an unexpected error while trying to process the request. ';
      case 'invalid-argument':
        return 'An invalid argument was provided to an Authentication method.';
      case 'invalid-claims':
        return 'The custom claim attributes provided to setCustomUserClaims() are invalid. ';
      case 'invalid-password':
        return 'The provided value for the password user property is invalid';
      case 'maximum-user-count-exceeded':
        return 'The maximum allowed number of users to import has been exceeded. ';

      default:
        return 'Something Went wrong!';
    }
  }
}
