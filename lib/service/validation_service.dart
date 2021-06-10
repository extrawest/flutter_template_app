/// [ValidationService] for validating text
/// Methods return null if data is valid.

class ValidationService {
  final String _emailFormatRegExr =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  String? validEmail(String email) {
    var exp = RegExp(_emailFormatRegExr);
    if (exp.hasMatch(email)) {
      return null;
    } else {
      return 'Please provide a valid email address';
    }
  }

  String? validPassword(String password) {
    if (password.length >= 6) {
      return null;
    } else {
      return 'Please provide a valid password';
    }
  }

  String? validConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please provide password again';
    } else if (password == confirmPassword) {
      return null;
    } else {
      return 'Password and Confirm Password do not match';
    }
  }

  String? validUsername(String username) {
    if (username.isNotEmpty) {
      return null;
    } else {
      return 'Please provide a valid username';
    }
  }

  String? validateMessage(String message) {
    if (message.trim().isEmpty) {
      return 'Please enter the message';
    } else {
      return null;
    }
  }

  String? validateSubject(String subject) {
    if (subject.isEmpty) {
      return 'Please enter the subject';
    } else {
      return null;
    }
  }

  String? validateFirstName(String firstName) {
    if (firstName.isNotEmpty) {
      return null;
    } else {
      return 'Please provide a valid First Name';
    }
  }

  String? validateLastName(String lastName) {
    if (lastName.isNotEmpty) {
      return null;
    } else {
      return 'Please provide a valid Last Name';
    }
  }

  String? validateDateOfBirth(DateTime? dateOfBirthday) {
    if (dateOfBirthday != null) {
      return null;
    } else {
      return 'Please provide a valid date of birth';
    }
  }
}
