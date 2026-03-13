package Utils;

public class AccountNumberGenerator {

    public static synchronized String generateAccountNo() {
        long timestamp = System.currentTimeMillis();
        int  random    = (int)(Math.random() * 900) + 100;
        return timestamp + "" + random + "SBI";
    }
}