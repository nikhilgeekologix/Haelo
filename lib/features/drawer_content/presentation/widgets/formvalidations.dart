import 'package:flutter/material.dart';

class FormValidation {
  String validateFirmId(value) {
    if (value.isEmpty) {
      return 'Please Enter Your Firm Id';
    } else if (value.length != 10) {
      return 'Firm Id is not valid';
    } else {
      return "";
    }
  }

  String validatephonenumber(value) {
    if (value.isEmpty) {
      return 'Please Enter Your Mobile Number';
    } else if (value.length != 10) {
      return 'Phone Number is not valid';
    } else {
      return "";
    }
  }

  String validateitmo(value) {
    if (value.isEmpty) {
      return 'Please Enter ITMO';
    } else {
      return "";
    }
  }

  String? validatename(value) {
    if (value.isEmpty) {
      return 'Please Enter Your Name';
    } else {
      return null;
    }
  }

  String? validateFirmname(value) {
    if (value.isEmpty) {
      return 'Please Enter Your Firm Name';
    } else {
      return null;
    }
  }

  String? validateTitlename(value) {
    if (value.isEmpty) {
      return 'Please Enter Your Title';
    } else {
      return null;
    }
  }

  String? validateTeamMember(value) {
    if (value.isEmpty) {
      return 'Please select team member';
    } else {
      return null;
    }
  }

  String validateCaseNo(value) {
    if (value.isEmpty) {
      return 'Please Enter Your Case No';
    } else {
      return "";
    }
  }

  String? validateDesciptionname(value) {
    if (value.isEmpty) {
      return 'Please Enter Description';
    } else {
      return null;
    }
  }

  String validateCaseNumber(value) {
    if (value.isEmpty) {
      return 'Please Enter Case Number';
    } else {
      return "";
    }
  }

  String validateFillingNum(value) {
    if (value.isEmpty) {
      return 'Please Enter Description';
    } else {
      return "";
    }
  }

  String validateAmount(value) {
    if (value.isEmpty) {
      return 'Please Enter Amount';
    } else {
      return "";
    }
  }

  String validateEmail(value) {
    Pattern pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern.toString());
    if (value.isEmpty) {
      return 'Please Enter Your Email';
    } else if (!regex.hasMatch(value) || value == null)
      return 'Please Enter a Valid Email address ';
    else
      return "";
  }

  String validatepassword(value) {
    if (value.isEmpty) {
      return 'Please Enter Password';
    } else if (value.length < 8) {
      return 'Password Length Must Be Greater Than Equals to 8 Digit';
    } else {
      return "";
    }
  }

  String validatenewpassword(value) {
    if (value.isEmpty) {
      return 'Please Enter New Password';
    } else if (value.length < 8) {
      return 'Password Length Must Be Greater Than Equals to 8 Digit';
    } else {
      return "";
    }
  }

  String validateoldpassword(value) {
    if (value.isEmpty) {
      return 'Please Enter Old Password';
    } else if (value.length < 8) {
      return 'Password Length Must Be Greater Than Equals to 8 Digit';
    } else {
      return "";
    }
  }

  String validatecpassword(value) {
    if (value.isEmpty) {
      return 'Please Enter Confirm Password';
    } else if (validatecpassword == validatepassword) {
      return 'Confirm Password Must be Same As Password';
    } else {
      return "";
    }
  }

  String validatefirstname(value) {
    if (value.isEmpty) {
      return 'Please Enter a Valid Name';
    } else {
      return "";
    }
  }

  String validatelastname(value) {
    if (value.isEmpty) {
      return 'Please Enter a Valid Name';
    } else {
      return "";
    }
  }

  String validatemiddlename(value) {
    if (value.isEmpty) {
      return 'Please Enter a Valid Name';
    } else {
      return "";
    }
  }

  String validateaddress(value) {
    if (value.isEmpty) {
      return 'Please Enter a Valid Name';
    } else {
      return "";
    }
  }

  String validatecountry(value) {
    if (value.isEmpty) {
      return 'Please Enter a Valid Name';
    } else {
      return "";
    }
  }

  String validatestate(value) {
    if (value.isEmpty) {
      return 'Please Enter a Valid Name';
    } else {
      return "";
    }
  }

  String validatecity(value) {
    if (value.isEmpty) {
      return 'Please Enter a Valid Name';
    } else {
      return "";
    }
  }

  String validatepincode(value) {
    if (value.isEmpty) {
      return 'Please Enter a Valid Name';
    } else {
      return "";
    }
  }
}
