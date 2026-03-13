package Utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {

    // Converts plain text password to MD5 hash
    // Example: "mypassword123" → "a1b2c3d4e5f6..."
    public static String hashPassword(String plainPassword) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hashedBytes = md.digest(plainPassword.getBytes());

            // Convert bytes to hex string
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    // Check if plain password matches stored hash
    // Use this during login to verify password
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        String hashedInput = hashPassword(plainPassword);
        return hashedInput != null && hashedInput.equals(hashedPassword);
    }
}
