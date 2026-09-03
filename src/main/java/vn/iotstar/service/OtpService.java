package vn.iotstar.service;

import vn.iotstar.entity.OtpToken;

public interface OtpService {
    void createAndSend(String email, String purpose) throws Exception;
    boolean verify(String email, String otp, String purpose);
    OtpToken findLatest(String email, String purpose);
}
