package vn.iotstar.service.impl;

import vn.iotstar.dao.OtpTokenDao;
import vn.iotstar.dao.impl.OtpTokenDaoImpl;
import vn.iotstar.entity.OtpToken;
import vn.iotstar.service.EmailService;
import vn.iotstar.service.OtpService;
import vn.iotstar.util.OtpUtil;

import java.util.Date;

public class OtpServiceImpl implements OtpService {
    private final OtpTokenDao otpTokenDao;
    private final EmailService emailService;

    public OtpServiceImpl() {
        this.otpTokenDao = new OtpTokenDaoImpl();
        this.emailService = new EmailServiceImpl();
    }

    public OtpServiceImpl(EmailService emailService) {
        this.otpTokenDao = new OtpTokenDaoImpl();
        this.emailService = emailService;
    }

    public OtpServiceImpl(OtpTokenDao otpTokenDao, EmailService emailService) {
        this.otpTokenDao = otpTokenDao;
        this.emailService = emailService;
    }

    @Override
    public void createAndSend(String email, String purpose) throws Exception {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email không được để trống");
        }

        OtpToken latest = otpTokenDao.findLatest(email, purpose);
        if (latest != null && !OtpUtil.canResend(latest.getCreatedAt(), 60)) {
            long waitSec = 60 - ((System.currentTimeMillis() - latest.getCreatedAt().getTime()) / 1000);
            throw new Exception("Vui lòng đợi " + Math.max(waitSec, 1) + " giây trước khi gửi lại OTP");
        }

        String otp = OtpUtil.generate();
        Date expiresAt = new Date(System.currentTimeMillis() + 120_000); // 120s TTL
        OtpToken token = new OtpToken(email, otp, purpose, expiresAt);

        otpTokenDao.save(token);
        emailService.sendOtp(email, otp, purpose);
    }

    @Override
    public boolean verify(String email, String otp, String purpose) {
        if (email == null || otp == null || purpose == null) return false;

        OtpToken latest = otpTokenDao.findLatest(email, purpose);
        if (latest == null) return false;

        // Check attempts limit (max 5)
        if (latest.getAttempts() >= 5) {
            return false;
        }

        // Check expiration (120s)
        if (OtpUtil.isExpired(latest.getExpiresAt())) {
            return false;
        }

        // Verify OTP code
        if (!latest.getOtp().equals(otp.trim())) {
            otpTokenDao.incrementAttempts(latest.getId());
            return false;
        }

        // Success - clean up token so it cannot be reused
        otpTokenDao.delete(latest.getId());
        return true;
    }

    @Override
    public OtpToken findLatest(String email, String purpose) {
        return otpTokenDao.findLatest(email, purpose);
    }
}
