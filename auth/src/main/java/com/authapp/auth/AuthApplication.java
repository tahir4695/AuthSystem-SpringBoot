package com.authapp.auth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

//When you use @SpringBootApplication, Spring Boot automatically scans that package and its subpackages for @RestController, @Service, etc.
//@SpringBootApplication(scanBasePackages = {"com.authapp.auth", "controller"})
@SpringBootApplication
public class AuthApplication {

	public static void main(String[] args) {
		SpringApplication.run(AuthApplication.class, args);
	}

}
