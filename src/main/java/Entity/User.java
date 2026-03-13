package Entity;

public class User {
    private int    userId;
    private String fullName;
    private String email;
    private String username;
    private String password;
    private String accountNumber;
    private String phoneNo;
    private double balance;

    // ===== Getters & Setters =====

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public String getPhoneNo() { return phoneNo; }
    public void setPhoneNo(String phoneNo) { this.phoneNo = phoneNo; }

    public double getBalance() { return balance; }
    public void setBalance(double balance) { this.balance = balance; }

    @Override
    public String toString() {
        return "User [userId=" + userId
                + ", fullName=" + fullName
                + ", email=" + email
                + ", username=" + username
                + ", accountNumber=" + accountNumber
                + ", balance=" + balance
                + ", phoneNo=" + phoneNo + "]";
    }
}
