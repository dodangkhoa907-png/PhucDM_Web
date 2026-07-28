package com.eighttea.util;

import com.eighttea.config.Database;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * Thin wrapper — delegates to {@link Database#getConnection()} (HikariCP pool).
 * Kept for binary compatibility; no static initializer, no separate db.properties load.
 */
public final class DBContext {

    private DBContext() { }

    public static Connection getConnection() throws SQLException {
        return Database.getConnection();
    }
}
