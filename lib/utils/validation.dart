class Validation {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }

    final int age = int.tryParse(value) ?? -1;
    if (age < 18 || age > 50) {
      return 'Invalid age. Age should be between 18 and 50';
    }

    return null;
  }

  static String? validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Write Something';
    }
    return null;
  }

  static String? validateCardNumber(String? value) {
    // Card number validation regex pattern
    const pattern = r'^[0-9]{16}$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Card number is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter a valid 16-digit card number';
    }

    return null;
  }

  static String? validateCVV(String? value) {
    // CVV validation regex pattern
    const pattern = r'^[0-9]{3}$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'CVV is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter a valid 3-digit CVV';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    // Email validation regex pattern
    const pattern =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    // Password validation criteria
    const minLength = 8; // Minimum password length
    // const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    // final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }
    // else if (value.length < minLength) {
    //   return 'Password must be at least $minLength characters long';
    // } else if (!regExp.hasMatch(value)) {
    //   return 'Password must contain at least one uppercase letter, one lowercase letter, and one digit';
    // }

    return null;
  }

  static String? validateMobileNumber(String? value) {
    // Mobile number validation regex pattern
    const pattern = r'^[0-9]{10}$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter a valid mobile number';
    }

    return null;
  }
}
