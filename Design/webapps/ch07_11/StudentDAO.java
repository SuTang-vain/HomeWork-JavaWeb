package com.example;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO implements IBookDAO {

    public boolean addStudent(Students student) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            double bmi = student.calculateBMI();
            String healthStatus = student.getHealthStatus();
            String sql = "INSERT INTO students (name, age, gender, height, weight, bmi, health_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, student.getName());
            pstmt.setInt(2, student.getAge());
            pstmt.setString(3, student.getGender());
            pstmt.setDouble(4, student.getHeight());
            pstmt.setDouble(5, student.getWeight());
            pstmt.setDouble(6, bmi);
            pstmt.setString(7, healthStatus);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    public Students queryStudentById(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Students student = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM students WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                student = new Students();
                student.setId(rs.getInt("id"));
                student.setName(rs.getString("name"));
                student.setAge(rs.getInt("age"));
                student.setGender(rs.getString("gender"));
                student.setHeight(rs.getDouble("height"));
                student.setWeight(rs.getDouble("weight"));
                student.setBmi(rs.getDouble("bmi"));
                student.setHealth_status(rs.getString("health_status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return student;
    }

    public List<Students> queryAllStudents() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Students> studentsList = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM students ORDER BY id";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Students student = new Students();
                student.setId(rs.getInt("id"));
                student.setName(rs.getString("name"));
                student.setAge(rs.getInt("age"));
                student.setGender(rs.getString("gender"));
                student.setHeight(rs.getDouble("height"));
                student.setWeight(rs.getDouble("weight"));
                student.setBmi(rs.getDouble("bmi"));
                student.setHealth_status(rs.getString("health_status"));
                studentsList.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return studentsList;
    }

    public List<Students> queryStudentsByName(String name) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Students> studentsList = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM students WHERE name LIKE ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + name + "%");
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Students student = new Students();
                student.setId(rs.getInt("id"));
                student.setName(rs.getString("name"));
                student.setAge(rs.getInt("age"));
                student.setGender(rs.getString("gender"));
                student.setHeight(rs.getDouble("height"));
                student.setWeight(rs.getDouble("weight"));
                student.setBmi(rs.getDouble("bmi"));
                student.setHealth_status(rs.getString("health_status"));
                studentsList.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return studentsList;
    }

    public boolean updateStudent(Students student) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            double bmi = student.calculateBMI();
            String healthStatus = student.getHealthStatus();
            String sql = "UPDATE students SET name = ?, age = ?, gender = ?, height = ?, weight = ?, bmi = ?, health_status = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, student.getName());
            pstmt.setInt(2, student.getAge());
            pstmt.setString(3, student.getGender());
            pstmt.setDouble(4, student.getHeight());
            pstmt.setDouble(5, student.getWeight());
            pstmt.setDouble(6, bmi);
            pstmt.setString(7, healthStatus);
            pstmt.setInt(8, student.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    public boolean deleteStudentById(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM students WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    public boolean deleteStudentByName(String name) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM students WHERE name = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }
}
