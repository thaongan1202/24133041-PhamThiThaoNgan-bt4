package vn.iotstar.dao;

import vn.iotstar.entity.User;

public interface IUserDao {
    User findByUsername(String username);
    
    User findById(int id);
    User findByPhone(String phone);
    
    void insert(User user);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean checkExistPhone(String phone);
    
    void update(User user);
    User findByEmail(String email);
}