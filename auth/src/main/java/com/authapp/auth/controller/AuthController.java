package com.authapp.auth.controller;

import org.springframework.web.bind.annotation.*;

import com.authapp.auth.annotation.Authenticated;
import com.authapp.auth.dto.LoginDTO;
import com.authapp.auth.dto.LoginResponseDTO;
import com.authapp.auth.dto.UserDTO;
import com.authapp.auth.service.AuthService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;



@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public String register(HttpServletRequest request) {
		UserDTO user = new UserDTO();
		user.setFullName(request.getParameter("fullName"));
		user.setEmail(request.getParameter("email"));
		user.setPhoneNumber(request.getParameter("phoneNumber"));
		user.setUsername(request.getParameter("username"));
		user.setPassword(request.getParameter("password"));
		boolean created = authService.createUser(user);
		return created ? "User created successfully!" : "Failed to create user.";
    }
    
//    @PostMapping("/register")
//    public String register(@RequestBody UserDTO user) {
//        boolean created = authService.createUser(user);
//        return created ? "User created successfully!" : "Failed to create user.";
//    }
    
    @PostMapping("/login")
    public LoginResponseDTO login(HttpServletRequest request, HttpServletResponse response) {
        // Extract client IP
        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null || ipAddress.isEmpty()) {
            ipAddress = request.getRemoteAddr();
        }

        LoginDTO login = new LoginDTO();
        login.setUsername(request.getParameter("username"));
        login.setPassword(request.getParameter("password"));

        LoginResponseDTO loginResponse = authService.validateLogin(login, ipAddress);

        // Set token in response header if login successful
        if (loginResponse != null && "Success".equals(loginResponse.getStatus())) {
            response.setHeader("Authorization", loginResponse.getToken());
            response.setStatus(HttpServletResponse.SC_OK); // 200
            return loginResponse;
        } else {
            // Invalid user → return 401 Unauthorized
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            return null;
        }

    }
    
    
    @GetMapping("/getUserByToken")
    public UserDTO getUserByToken(HttpServletRequest request, HttpServletResponse response) {
        // Extract token from Authorization header (optional Bearer prefix)
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7); // remove "Bearer " prefix
        }

        // Extract client IP
        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null || ipAddress.isEmpty()) {
            ipAddress = request.getRemoteAddr();
        }

        // Fetch user using service
        UserDTO user = authService.getUserByToken(token, ipAddress);

        // If user exists, set token in response header
        if (user != null) {
            // Valid user → set token in response header
            response.setHeader("Authorization", token);
            response.setStatus(HttpServletResponse.SC_OK); // 200
            return user;
        } else {
            // Invalid user → return 401 Unauthorized
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            return null;
        }

    }
    
    @PostMapping("/logout")
    @Authenticated //user defined attribute to check if request is raised by login user or someone else
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7); // remove "Bearer " prefix
        }

        // Extract client IP
        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null || ipAddress.isEmpty()) {
            ipAddress = request.getRemoteAddr();
        }

        boolean success = authService.logout(token, ipAddress);

        // Clear token from response header
        response.setHeader("Authorization", "");

        if (success) {
            response.setStatus(HttpServletResponse.SC_OK);
            return "Logout successful";
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return "Logout failed";
        }
    }

}
