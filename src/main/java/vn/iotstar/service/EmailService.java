package vn.iotstar.service;

public interface EmailService {
    void sendOtp(String toEmail, String otp, String purpose) throws Exception;
}
