class Validations {

  static String? validateEmail(String? value) {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value?.isEmpty==true){
      return 'Email is required';
    }
    else if (value?.isNotEmpty == true && !regex.hasMatch(value!)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return "Password must contain at least one uppercase letter";
    // }
    // if (!value.contains(RegExp(r'[a-z]'))) {
    //   return "Password must contain at least one lowercase letter";
    // }
    // if (!value.contains(RegExp(r'[0-9]'))) {
    //   return "Password must contain at least one numeric character";
    // }
    // if (!value.contains(RegExp(r'[!@#$%^&*()<>?/|}{~:]'))) {
    //   return "Password must contain at least one special character";
    // }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    // Check if the phone number is not of length 10 or 11
    if (value.length < 10 || value.length > 11) {
      return "Phone number must be 10 or 11 characters long";
    }
    // Check if the phone number contains any character that is not a digit
    if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
      return "Phone number must only contain digits";
    }
    return null;

  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters long";
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Date is required";
    }
    return null;
  }

  static String? validateReferralCode(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 6) {
      return "Referral code must be at least 6 characters long";
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value!.isEmpty) {
      return "OTP is required";
    }
    return null;
  }
}