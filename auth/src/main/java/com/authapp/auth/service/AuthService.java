package com.authapp.auth.service;

import org.springframework.stereotype.Service;

import com.authapp.auth.dto.LoginDTO;
import com.authapp.auth.dto.LoginResponseDTO;
import com.authapp.auth.dto.UserDTO;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.sql.DataSource;
import java.sql.*;
import java.security.MessageDigest;

import org.springframework.beans.factory.annotation.Autowired;


@Service
public class AuthService {

    @Autowired
    private DataSource dataSource;
    private static final String SECRET_KEY = "MySuperSecretKey123"; // 🔑 choose a strong key

	 // Hash password using HMAC-SHA256
	 private String hash_HMAC_SHA_256_WithKey(String password) {
	     try {
	         SecretKeySpec secretKey = new SecretKeySpec(SECRET_KEY.getBytes("UTF-8"), "HmacSHA256");
	         Mac mac = Mac.getInstance("HmacSHA256");
	         mac.init(secretKey);
	
	         byte[] hash = mac.doFinal(password.getBytes("UTF-8"));
	
	         StringBuilder hex = new StringBuilder();
	         for (byte b : hash) {
	             String h = Integer.toHexString(0xff & b);
	             if (h.length() == 1) hex.append('0');
	             hex.append(h);
	         }
	         return hex.toString();
	     } catch (Exception e) {
	         throw new RuntimeException(e);
	     }
	 }
    // Hash password using SHA-256
    private String hash_SHA_256(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes("UTF-8"));
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) {
                String h = Integer.toHexString(0xff & b);
                if (h.length() == 1) hex.append('0');
                hex.append(h);
            }
            return hex.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // Create user
    public boolean createUser(UserDTO user) {
        String sql = "{call sp_CreateUser_Alt(?,?,?,?,?)}";
        try (Connection conn = dataSource.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhoneNumber());
            stmt.setString(4, user.getUsername());
            stmt.setString(5, hash_HMAC_SHA_256_WithKey(user.getPassword()));

            stmt.execute();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public LoginResponseDTO validateLogin(LoginDTO login, String ipAddress) {
        String sql = "{call sp_ValidateLogin_Secure(?,?,?,?)}";

        try (Connection conn = dataSource.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setString(1, login.getUsername());
            stmt.setString(2, hash_HMAC_SHA_256_WithKey(login.getPassword())); // hash before sending
            stmt.setString(3, ipAddress);
            stmt.registerOutParameter(4, Types.VARCHAR);

            boolean hasResult = stmt.execute();

            if (hasResult) {
                try (ResultSet rs = stmt.getResultSet()) {
                    if (rs.next()) {
                        LoginResponseDTO response = new LoginResponseDTO();
                        int status = rs.getInt("Status");
                        response.setStatus(status == 1 ? "Success" : "Failed");

                        if (status == 1) {
                            response.setToken(rs.getString("SessionToken"));
                            response.setUserId(rs.getInt("UserId"));
                        }

                        return response;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        LoginResponseDTO failed = new LoginResponseDTO();
        failed.setStatus("Failed");
        return failed;
    }




 // inside AuthService.java
    public UserDTO getUserByToken(String token, String requestIp) {
        String sql = "{call sp_GetUserByToken(?,?)}";
        try (Connection conn = dataSource.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setString(1, token);
            stmt.setString(2, requestIp);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                UserDTO user = new UserDTO();
                user.setUserId(rs.getInt("UserId"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setPhoneNumber(rs.getString("PhoneNumber"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean logout(String token, String ipAddress) {
        String sql = "{call sp_DeleteSession(?, ?)}";

        try (Connection conn = dataSource.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setString(1, token);
            stmt.setString(2, ipAddress); // can be null
            stmt.execute();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}

