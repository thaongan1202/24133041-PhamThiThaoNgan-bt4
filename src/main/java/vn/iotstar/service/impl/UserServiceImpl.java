package vn.iotstar.service.impl;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.LocalDateTime;

import org.mindrot.jbcrypt.BCrypt;

import vn.iotstar.dao.IUserDao;
import vn.iotstar.dao.UserDao;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.util.MailUtil;

public class UserServiceImpl implements IUserService {
    private IUserDao userDao = new UserDao();

    @Override
    public User login(String username, String password) {
        User user = findByUsername(username);
        if (user == null) {
            return null;
        }

        String stored = user.getPassword();
        if (stored.startsWith("$2")) {
            return BCrypt.checkpw(password, stored) ? user : null;
        }

        if (stored.equals(password)) {
            user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            userDao.update(user);
            return user;
        }
        return null;
    }

    @Override
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public boolean register(String username, String password, String email, String fullname, String phone) {
        if (userDao.checkExistUsername(username)) {
            return false;
        }
        User user = new User();
        user.setUsername(username);
        user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
        user.setEmail(email);
        user.setFullname(fullname);
        user.setPhone(phone);
        user.setRoleid(5);
        user.setActive(false);
        user.setCreateddate(LocalDate.now());
        userDao.insert(user);
        return true;
    }
    
    @Override
    public User findById(int id) { return userDao.findById(id); }

    @Override
    public User findByEmail(String email) { return userDao.findByEmail(email); }

    @Override
    public User findByPhone(String phone) { return userDao.findByPhone(phone); }

    @Override
    public User updateProfile(int userId, String fullname, String phone, String avatarUrl) {
        User user = userDao.findById(userId);
        if (user == null) {
            return null;
        }
        user.setFullname(fullname);
        user.setPhone(phone);
        if (avatarUrl != null) {
            user.setAvatar(avatarUrl);
        }
        userDao.update(user);
        return user;
    }

    @Override
    public boolean requestEmailChange(int userId, String newEmail) {
        User user = userDao.findById(userId);
        if (user == null) {
            return false;
        }
        String otp = String.format("%06d", new SecureRandom().nextInt(1_000_000));
        user.setPendingEmail(newEmail);
        user.setOtp(otp);
        user.setOtpExpiry(LocalDateTime.now().plusMinutes(5));
        userDao.update(user);

        System.out.println("OTP đổi email của " + newEmail + ": " + otp);
        try {
            MailUtil.send(newEmail, "Xác nhận email mới ShoppingJPA",
                    "Mã OTP của bạn là: " + otp + "\nMã có hiệu lực trong 5 phút.");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean confirmEmailChange(int userId, String otp) {
        User user = userDao.findById(userId);
        if (user == null || user.getPendingEmail() == null || !otpValid(user, otp)) {
            return false;
        }
        if (userDao.checkExistEmail(user.getPendingEmail())) {
            return false;
        }
        user.setEmail(user.getPendingEmail());
        user.setPendingEmail(null);
        user.setOtp(null);
        user.setOtpExpiry(null);
        userDao.update(user);
        return true;
    }

    @Override
    public boolean sendOtp(String email, String subject) {
        User user = userDao.findByEmail(email);
        if (user == null) {
            return false;
        }

        String otp = String.format("%06d", new SecureRandom().nextInt(1_000_000));
        user.setOtp(otp);
        user.setOtpExpiry(LocalDateTime.now().plusMinutes(5));
        userDao.update(user);

        System.out.println("OTP của " + email + ": " + otp);
        try {
            MailUtil.send(email, subject, "Mã OTP của bạn là: " + otp + "\nMã có hiệu lực trong 5 phút.");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean activate(String email, String otp) {
        User user = userDao.findByEmail(email);
        if (!otpValid(user, otp)) {
            return false;
        }
        user.setActive(true);
        user.setOtp(null);
        user.setOtpExpiry(null);
        userDao.update(user);
        return true;
    }

    @Override
    public boolean resetPassword(String email, String otp, String newPassword) {
        User user = userDao.findByEmail(email);
        if (!otpValid(user, otp)) {
            return false;
        }
        user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        user.setOtp(null);
        user.setOtpExpiry(null);
        userDao.update(user);
        return true;
    }

    private boolean otpValid(User user, String otp) {
        return user != null && otp != null && otp.equals(user.getOtp())
                && user.getOtpExpiry() != null && LocalDateTime.now().isBefore(user.getOtpExpiry());
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistPhone(String phone) {
        return userDao.checkExistPhone(phone);
    }
}