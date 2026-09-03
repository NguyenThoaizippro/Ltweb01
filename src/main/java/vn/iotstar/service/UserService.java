package vn.iotstar.service;

import vn.iotstar.model.User;

public interface UserService {

	User login(String username, String password);

	User get(String username);

	User getByEmail(String email);

	void register(String username, String email, String password) throws Exception;

	void activate(String email);

	void resetPassword(String email, String newPassword) throws Exception;
}
