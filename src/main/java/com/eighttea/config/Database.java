package com.eighttea.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Connection pool dùng chung toàn ứng dụng (HikariCP).
 *
 * Cấu hình ưu tiên biến môi trường (DB_URL, DB_USERNAME, DB_PASSWORD, DB_DRIVER — cùng
 * quy ước với {@link PayOSConfig}), fallback sang src/main/resources/db.properties (db.url,
 * db.username, db.password, db.driver) cho local dev. File db.properties bị .gitignore
 * chặn (chứa mật khẩu thật) nên KHÔNG có mặt khi build image Docker từ Git — nếu vẫn bắt
 * buộc phải có file này, container sẽ crash ngay lúc khởi động trên mọi nền tảng deploy
 * (Render, Railway...). Mọi DAO lấy Connection qua {@link #getConnection()}.
 */
public final class Database {

    private static volatile HikariDataSource dataSource;

    private Database() { }

    /** Khởi tạo pool 1 lần khi app start (gọi từ AppContextListener). */
    public static synchronized void init() {
        if (dataSource != null) return;

        Properties props = new Properties();
        try (InputStream in = Database.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) props.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("Lỗi đọc db.properties", e);
        }

        String jdbcUrl = resolve("DB_URL", props.getProperty("db.url"));
        String username = resolve("DB_USERNAME", props.getProperty("db.username"));
        String password = resolve("DB_PASSWORD", props.getProperty("db.password"));
        String driver = resolve("DB_DRIVER", props.getProperty("db.driver"));
        if (driver == null || driver.isBlank()) driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

        if (jdbcUrl == null || jdbcUrl.isBlank()) {
            throw new IllegalStateException(
                "Chưa cấu hình kết nối CSDL — đặt biến môi trường DB_URL (kèm DB_USERNAME, "
                + "DB_PASSWORD) hoặc tạo src/main/resources/db.properties cho local dev.");
        }

        if (!jdbcUrl.toLowerCase().contains("statementpoolingcachesize")) {
            jdbcUrl += (jdbcUrl.endsWith(";") ? "" : ";") + "statementPoolingCacheSize=512;disableStatementPooling=false";
        }

        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(jdbcUrl);
        cfg.setUsername(username);
        cfg.setPassword(password);
        cfg.setDriverClassName(driver);
        cfg.setPoolName("NhietDoiXanhPool");
        cfg.setMaximumPoolSize(8);
        cfg.setMinimumIdle(2);
        cfg.setConnectionTimeout(10_000);
        cfg.setIdleTimeout(300_000);
        cfg.setMaxLifetime(900_000);
        cfg.setKeepaliveTime(120_000);
        cfg.setValidationTimeout(3_000);
        cfg.setLeakDetectionThreshold(30_000);

        System.out.println("[DB] Creating HikariCP pool (MinIdle=2, MaxSize=8)...");
        dataSource = new HikariDataSource(cfg);
        System.out.println("[DB] HikariCP pool initialized");
    }

    public static DataSource getDataSource() {
        if (dataSource == null) init();
        return dataSource;
    }

    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }

    public static synchronized void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            dataSource = null;
        }
    }

    private static String resolve(String envKey, String fromProps) {
        String fromEnv = System.getenv(envKey);
        if (fromEnv != null && !fromEnv.isBlank()) return fromEnv.trim();
        return (fromProps == null || fromProps.isBlank()) ? null : fromProps.trim();
    }
}
