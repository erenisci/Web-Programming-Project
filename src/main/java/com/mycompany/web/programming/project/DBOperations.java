/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.mycompany.web.programming.project;

import com.mycompany.web.programming.project.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author iscie
 */

public class DBOperations {
    public static ResultSet executeQuery(String sql) {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        try {
            connection = DBConnection.getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            return resultSet;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } 
    }
    
    public static int getAllProduct(String sql) throws SQLException {
        int totalProduct = 0;

        try (ResultSet resultSet = executeQuery(sql)) {
            if (resultSet.next()) {
                totalProduct = resultSet.getInt("total");
            }
        }
        
        return totalProduct;
    }
    
    public static int getTotalProduct() throws SQLException {
        int totalProduct = 0;
        String sql = "SELECT COUNT(*) as total FROM urunler";

        try (ResultSet resultSet = executeQuery(sql)) {
            if (resultSet.next()) {
                totalProduct = resultSet.getInt("total");
            }
        }
        
        return totalProduct;
    }
    
    public static int getTotalQueryProduct(String query) throws SQLException {
        int totalProduct = 0;
        String sql = query.replace("*", "COUNT(*)");
        sql = sql.substring(0, sql.length() - 10);
        

        try (ResultSet resultSet = executeQuery(sql)) {
            if (resultSet.next()) {
                totalProduct = resultSet.getInt(1);
            }
        }

        return totalProduct;
    }
    
    public static int getTotalCategoryProduct(String query) throws SQLException {
        int totalProduct = 0;
        String sql = query.replace("u.*", "COUNT(*)");
        sql = sql.substring(0, sql.length() - 10);
        

        try (ResultSet resultSet = executeQuery(sql)) {
            if (resultSet.next()) {
                totalProduct = resultSet.getInt(1);
            }
        }

        return totalProduct;
    }
}
