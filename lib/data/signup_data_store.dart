class SignupDataStore {
  // Static map to store signup data
  static Map<String, dynamic> signupData = {};

  // Save user data
  static void save(Map<String, dynamic> data) {
    signupData = data;
  }

  // Clear user data (e.g., on logout)
  static void clear() {
    signupData = {};
  }

  // Check if a user is signed up/logged in
  static bool get isSignedUp => signupData.isNotEmpty;

  // Get a value safely
  static dynamic get(String key) {
    return signupData[key];
  }
}
