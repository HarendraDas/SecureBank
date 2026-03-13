package Entity;

public class Loan {
    private int    loanId;
    private int    customerId;
    private String loanType;
    private double amount;
    private int    duration;
    private String status;
    private String applyDate;

    // ===== Getters & Setters =====

    public int getLoanId() { return loanId; }
    public void setLoanId(int loanId) { this.loanId = loanId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getLoanType() { return loanType; }
    public void setLoanType(String loanType) { this.loanType = loanType; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getApplyDate() { return applyDate; }
    public void setApplyDate(String applyDate) { this.applyDate = applyDate; }

    @Override
    public String toString() {
        return "Loan [loanId=" + loanId
                + ", customerId=" + customerId
                + ", loanType=" + loanType
                + ", amount=" + amount
                + ", duration=" + duration
                + ", status=" + status
                + ", applyDate=" + applyDate + "]";
    }
}
