package Entity;

import java.util.Date;

public class Transaction {
    private int    txnId;
    private String senderAccount;
    private String receiverAccount;
    private double amount;
    private String txnType;       // "Credit" or "Debit" or "TRANSFER"
    private String description;
    private String status;        // "SUCCESS", "FAILED", "PENDING"
    private Date   txnDate;

    // ===== Constructors =====

    public Transaction() {}

    public Transaction(int txnId, String senderAccount, String receiverAccount,
                       double amount, String txnType, String description,
                       String status, Date txnDate) {
        this.txnId           = txnId;
        this.senderAccount   = senderAccount;
        this.receiverAccount = receiverAccount;
        this.amount          = amount;
        this.txnType         = txnType;
        this.description     = description;
        this.status          = status;
        this.txnDate         = txnDate;
    }

    // ===== Getters & Setters =====

    public int getTxnId() { return txnId; }
    public void setTxnId(int txnId) { this.txnId = txnId; }

    public String getSenderAccount() { return senderAccount; }
    public void setSenderAccount(String senderAccount) { this.senderAccount = senderAccount; }

    public String getReceiverAccount() { return receiverAccount; }
    public void setReceiverAccount(String receiverAccount) { this.receiverAccount = receiverAccount; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getTxnType() { return txnType; }
    public void setTxnType(String txnType) { this.txnType = txnType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getTxnDate() { return txnDate; }
    public void setTxnDate(Date txnDate) { this.txnDate = txnDate; }

    @Override
    public String toString() {
        return "Transaction [txnId=" + txnId
                + ", senderAccount=" + senderAccount
                + ", receiverAccount=" + receiverAccount
                + ", amount=" + amount
                + ", txnType=" + txnType
                + ", description=" + description
                + ", status=" + status
                + ", txnDate=" + txnDate + "]";
    }
}
