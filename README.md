# AuthSystem-SpringBoot

## Description
Secure authentication system using Spring Boot and SQL Server. Features:
- Token-based login with HMAC-SHA256 password hashing
- IP-bound session management
- Login/logout REST APIs
- Interceptor-based route protection
- Audit logging of login attempts
- Stored procedures for database operations

## Tech Stack
- Java, Spring Boot
- SQL Server
- JDBC, CallableStatement
- HTTP/REST APIs

## How to Run
1. Configure `application.properties` with your DB credentials
2. Import the SQL scripts from `db/` folder
3. Run `mvn spring-boot:run` or run from your IDE
