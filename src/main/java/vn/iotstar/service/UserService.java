package vn.iotstar.service;

import vn.iotstar.entity.User;

public interface UserService {

	User login(String username, String password);

	User get(String username);

	User getByEmail(String email);

	void register(String username, String email, String password) throws Exception;

	void activate(String email);

	User findById(int id);

	void resetPassword(String email, String newPassword) throws Exception;

	User updateProfile(int id, String fullname, String phone, String avatar) throws Exception;

	void insert(User user) throws Exception;
}
