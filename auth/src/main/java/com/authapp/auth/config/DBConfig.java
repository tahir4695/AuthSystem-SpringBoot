package com.authapp.auth.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;
import com.microsoft.sqlserver.jdbc.SQLServerDataSource;

@Configuration
public class DBConfig {

	@Value("${spring.datasource.url}")
    private String url;
    @Bean
    public DataSource dataSource() {
    	//ds.setPortNumber(1433);          // fixed TCP port for SQLEXPRESS
    	SQLServerDataSource ds = new SQLServerDataSource();

    	ds.setURL("jdbc:sqlserver://localhost:1433;"
    	          + "databaseName=AuthDB;"
    	          + "encrypt=true;"
    	          + "trustServerCertificate=true");
    	ds.setUser("AuthUser");
    	ds.setPassword("Tahir@003");

        return ds;
    }
}
