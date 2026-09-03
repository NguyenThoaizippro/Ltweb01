package vn.iotstar.dao;

import vn.iotstar.model.User;

public interface UserDao {

	User get(String username);
	User getByEmail(String email);
	void insert(User user);
	void updateActiveByEmail(String email, int isActive);
	void updatePassword(User user);
}
