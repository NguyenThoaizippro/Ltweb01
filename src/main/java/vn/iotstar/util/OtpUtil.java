package vn.iotstar.util;

import java.security.SecureRandom;
import java.time.Instant;
import java.util.Date;

public class OtpUtil {
    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Generate a random 6-digit OTP string.
     */
    public static String generate() {
        return String.format("%06d", RANDOM.nextInt(1_000_000));
    }

    /**
     * Check if the token has expired based on expiresAt Date.
     */
    public static boolean isExpired(Date expiresAt) {
        if (expiresAt == null) return true;
        return new Date().after(expiresAt);
    }

    /**
     * Check if the token has expired based on expiresAt Instant.
     */
    public static boolean isExpired(Instant expiresAt, long ttlSec) {
        if (expiresAt == null) return true;
        return Instant.now().isAfter(expiresAt);
    }

    /**
     * Check if a new OTP can be resent based on createdAt and cooldown seconds (e.g. 60s).
     */
    public static boolean canResend(Date createdAt, long cooldownSec) {
        if (createdAt == null) return true;
        return (System.currentTimeMillis() - createdAt.getTime()) >= (cooldownSec * 1000);
    }

    /**
     * Check if a new OTP can be resent based on createdAt Instant.
     */
    public static boolean canResend(Instant createdAt, long cooldownSec) {
        if (createdAt == null) return true;
        return Instant.now().isAfter(createdAt.plusSeconds(cooldownSec));
    }
}
