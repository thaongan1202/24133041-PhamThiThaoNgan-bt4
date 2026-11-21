package vn.iotstar.service;

import vn.iotstar.entity.User;

public interface IUserService {
    User login(String username, String password);
    User findByUsername(String username);
    User findById(int id);
    User findByEmail(String email);
    User findByPhone(String phone);
    User updateProfile(int userId, String fullname, String phone, String avatarUrl);
    boolean requestEmailChange(int userId, String newEmail);
    boolean confirmEmailChange(int userId, String otp);
    boolean register(String username, String password, String email, String fullname, String phone);
    boolean sendOtp(String email, String subject);
    boolean activate(String email, String otp);
    boolean resetPassword(String email, String otp, String newPassword);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean checkExistPhone(String phone);
    
    
}