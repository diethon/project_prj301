/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Users;
import java.sql.*;

/**
 *
 * @author anhqu
 */
public class UsersDAO extends GenericDAO<Users> {

    public UsersDAO() {
        super(Users.class);
    }

    public Users checkLogin(String email, String password) {
        String sql = "SELECT * FROM users WHERE mail = ? AND hashed_password = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("mail"),
                        rs.getString("username"),
                        rs.getString("hashed_password"),
                        rs.getString("role"),
                        rs.getBoolean("verified")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE mail = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insert(Users user) {
        if (emailExists(user.getMail())) {
            return false;
        }
        String sql = "INSERT INTO users (mail, username, hashed_password, role, verification_token, verified) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getMail());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getHashedPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getVerification_token());
            ps.setBoolean(6, user.isVerified());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Users findByToken(String token) {
        String sql = "SELECT * FROM users WHERE verification_token = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("mail"),
                        rs.getString("username"),
                        rs.getString("hashed_password"),
                        rs.getString("role"),
                        rs.getBoolean("verified")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void verifyUser(int userId) {
        String sql = "UPDATE users SET verified = 1 WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean resetPassword(String email, String newPassword) {
        String sql = "UPDATE users SET hashed_password = ? WHERE mail = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
