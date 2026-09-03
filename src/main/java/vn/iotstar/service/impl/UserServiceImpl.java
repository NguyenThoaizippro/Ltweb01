package vn.iotstar.service.impl;

import vn.iotstar.dao.UserDao;
import vn.iotstar.dao.impl.UserDaoImpl;
import vn.iotstar.model.User;
import vn.iotstar.service.OtpService;
import vn.iotstar.service.UserService;
import vn.iotstar.util.PasswordUtil;

public class UserServiceImpl implements UserService {

	private final UserDao userDao;
	private final OtpService otpService;

	public UserServiceImpl() {
		this.userDao = new UserDaoImpl();
		this.otpService = new OtpServiceImpl();
	}

	public UserServiceImpl(UserDao userDao, OtpService otpService) {
		this.userDao = userDao;
		this.otpService = otpService;
	}

	@Override
	public User login(String username, String password) {
		if (username == null || password == null) return null;

		User user = userDao.get(username);
		if (user == null) {
			user = userDao.getByEmail(username); // Allow login with email
		}

		if (user == null) {
			return null;
		}

		// Check inactive
		if (user.getIsActive() == 0) {
			return null;
		}

		// Check password (BCrypt with plain text fallback for legacy accounts)
		boolean passwordMatches = false;
		String hashed = user.getPassWord();
		if (hashed != null && hashed.startsWith("$2")) {
			passwordMatches = PasswordUtil.check(password, hashed);
		} else {
			passwordMatches = password.equals(hashed);
			// Auto upgrade legacy password to BCrypt hash
			if (passwordMatches) {
				user.setPassWord(PasswordUtil.hash(password));
				userDao.updatePassword(user);
			}
		}

		return passwordMatches ? user : null;
	}

	@Override
	public User get(String username) {
		return userDao.get(username);
	}

	@Override
	public User getByEmail(String email) {
		return userDao.getByEmail(email);
	}

	@Override
	public void register(String username, String email, String password) throws Exception {
		if (username == null || username.trim().isEmpty()) {
			throw new Exception("Tên đăng nhập không được để trống");
		}
		if (email == null || email.trim().isEmpty()) {
			throw new Exception("Email không được để trống");
		}
		if (password == null || password.trim().isEmpty()) {
			throw new Exception("Mật khẩu không được để trống");
		}

		if (userDao.get(username.trim()) != null) {
			throw new Exception("Username đã tồn tại");
		}
		if (userDao.getByEmail(email.trim()) != null) {
			throw new Exception("Email đã tồn tại");
		}

		User u = new User();
		u.setUserName(username.trim());
		u.setEmail(email.trim());
		u.setPassWord(PasswordUtil.hash(password));
		u.setIsActive(0); // 0 = inactive until verified with OTP
		u.setRoleid(3);   // standard user role
		u.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));

		userDao.insert(u);
		otpService.createAndSend(email.trim(), "REGISTER");
	}

	@Override
	public void activate(String email) {
		if (email != null) {
			userDao.updateActiveByEmail(email.trim(), 1);
		}
	}

	@Override
	public void resetPassword(String email, String newPassword) throws Exception {
		if (email == null || email.trim().isEmpty()) {
			throw new Exception("Email không được để trống");
		}
		if (newPassword == null || newPassword.trim().isEmpty()) {
			throw new Exception("Mật khẩu mới không được để trống");
		}

		User u = userDao.getByEmail(email.trim());
		if (u == null) {
			u = userDao.get(email.trim());
		}
		if (u == null) {
			throw new Exception("Không tìm thấy tài khoản với email này");
		}

		u.setPassWord(PasswordUtil.hash(newPassword));
		userDao.updatePassword(u);
	}

	@Override
	public User findById(int id) {
		return userDao.findById(id);
	}

	@Override
	public User updateProfile(int id, String fullname, String phone, String avatar) throws Exception {
		User u = userDao.findById(id);
		if (u == null) {
			throw new Exception("Không tìm thấy thông tin tài khoản!");
		}

		if (fullname != null && !fullname.trim().isEmpty()) {
			u.setFullName(fullname.trim());
		}
		if (phone != null) {
			u.setPhone(phone.trim());
		}
		if (avatar != null && !avatar.trim().isEmpty()) {
			u.setAvatar(avatar.trim());
		}

		userDao.update(u);
		return u;
	}
}
