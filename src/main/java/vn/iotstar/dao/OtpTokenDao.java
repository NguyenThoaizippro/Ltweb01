package vn.iotstar.dao;

import vn.iotstar.entity.OtpToken;

public interface OtpTokenDao {
    void save(OtpToken token);
    OtpToken findLatest(String email, String purpose);
    void delete(int id);
    void incrementAttempts(int id);
}
