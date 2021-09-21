class Validation {
  var emailpattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  namevalidation(String val){
    if (val.trim().isEmpty) {
      return "This Filed Cannot be empty";
    }
    if (val.trim().length < 4) {
      return "name is too short ";
    }
  }
emailvalidation(String val){
  if (!RegExp(emailpattern).hasMatch(val)) {
    return "This email isn't correct";
  }
  if (val.isEmpty) {
    return "This Filed Cannot be empty";
  }
  if (val.length < 4) {
    return "name is too short ";
  }
}
phonevalidation(String val){
  if (val.trim().isEmpty) {
    return "phone number cannot be empty";
  }
  if (val.length < 11) {
    return "phone number cannot be less than 11 characters";
  }
  if (val.length > 11) {
    return "phone number cannot be more than 11 characters";
  }
  if (!val.startsWith('01')) {
    return "This phone is incorrect";
  }
}
passwordvalidation(String val){
  if (val.toString().isEmpty) {
    return "This Filed Cannot be empty";
  }
  if (val.toString().length < 4) {
    return "name is too short ";
  }
}
}