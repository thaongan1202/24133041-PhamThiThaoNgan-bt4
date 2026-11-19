package vn.iotstar.util;

import java.util.regex.Pattern;

public class ValidationUtil {
    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9_]{4,30}$");
    private static final Pattern EMAIL = Pattern.compile("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+$");
    private static final Pattern PHONE = Pattern.compile("^0\\d{9}$");
    private static final Pattern OTP = Pattern.compile("^\\d{6}$");

    public static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
    public static boolean isValidUsername(String s) {
        return s != null && USERNAME.matcher(s.trim()).matches();
    }
    public static boolean isValidEmail(String s) {
        return s != null && s.trim().length() <= 255 && EMAIL.matcher(s.trim()).matches();
    }
    public static boolean isValidPhone(String s) {
        return s != null && PHONE.matcher(s.trim()).matches();
    }
    public static boolean isValidPassword(String s) {
        return s != null && s.length() >= 6 && s.length() <= 50;
    }
    public static boolean isValidFullname(String s) {
        return s != null && s.trim().length() >= 2 && s.trim().length() <= 100;
    }
    public static boolean isValidOtp(String s) {
        return s != null && OTP.matcher(s.trim()).matches();
    }
}