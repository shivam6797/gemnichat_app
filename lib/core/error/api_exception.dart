class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;

  // 💡 From status code (e.g., for Gemini API)
  static AppException fromStatusCode(int code) {
    switch (code) {
      case 400:
        return AppException("Bad Request — Please try again.");
      case 401:
        return AppException("Unauthorized — Please login again.");
      case 403:
        return AppException("Forbidden — Access denied.");
      case 404:
        return AppException("Resource not found.");
      case 500:
        return AppException("Server error — Try again later.");
      default:
        return AppException("Something went wrong — [$code]");
    }
  }

  // 💡 From Firebase Auth
  static AppException fromFirebaseAuth(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return AppException("Invalid email address.");
      case 'user-not-found':
        return AppException("User not found.");
      case 'wrong-password':
        return AppException("Incorrect password.");
      case 'email-already-in-use':
        return AppException("Email already in use.");
      case 'network-request-failed':
        return AppException("No internet connection.");
      default:
        return AppException("Authentication failed. [$errorCode]");
    }
  }
}
