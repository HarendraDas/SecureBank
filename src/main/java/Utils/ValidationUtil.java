package Utils;

public class ValidationUtil {

    // Check if a string is null or empty
    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    // Validate email format — must contain @ and .
    // Example: test@gmail.com = valid, testgmail.com = invalid
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) return false;
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    // Validate phone number — must be exactly 10 digits
    // Example: 9876543210 = valid, 98765 = invalid
    public static boolean isValidPhone(String phone) {
        if (isEmpty(phone)) return false;
        return phone.matches("^[0-9]{10}$");
    }

    // Validate password — minimum 6 characters
    public static boolean isValidPassword(String password) {
        if (isEmpty(password)) return false;
        return password.length() >= 6;
    }

    // Validate username — only letters and numbers, 4-20 chars
    public static boolean isValidUsername(String username) {
        if (isEmpty(username)) return false;
        return username.matches("^[a-zA-Z0-9]{4,20}$");
    }

    // Validate amount — must be positive number
    public static boolean isValidAmount(double amount) {
        return amount > 0;
    }
}
