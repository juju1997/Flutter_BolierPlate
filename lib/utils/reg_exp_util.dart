

class RegExpUtil {

  // 객체 생성 방지
  RegExpUtil._();

  static bool isEmail(String email){
      String emailRegExp = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
      return RegExp(emailRegExp).hasMatch(email);
  }

  static bool isNotEmail(String email){
    return !isEmail(email);
  }
}