package vn.iotstar.dao;

import vn.iotstar.model.User;

public interface UserDao {

	User findById(int id);
	User get(String username);
	User getByEmail(String email);
	void insert(User user);
	void update(User user);
	void updateActiveByEmail(String email, int isActive);
	void updatePassword(User user);
}
