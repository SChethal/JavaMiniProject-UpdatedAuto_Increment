package com.dao;

import com.model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HostelDAO {

    private static final String URL  = "jdbc:mysql://localhost:3306/HostelDB";
    private static final String USER = "root";
    private static final String PASS = "musab@123sql"; // ← your MySQL password

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // ── GET NEXT AUTO-INCREMENT ID ───────────────────────────────────
    public int getNextAutoIncrementID() {
        String sql = "SELECT AUTO_INCREMENT FROM information_schema.TABLES " +
                     "WHERE TABLE_SCHEMA = 'HostelDB' AND TABLE_NAME = 'HostelStudents'";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("AUTO_INCREMENT");
        } catch (Exception e) { e.printStackTrace(); }
        return 1;
    }

    // ── ROOM UNIQUENESS CHECK ────────────────────────────────────────
    // Pass excludeStudentID = -1 when ADDING (no student to exclude)
    // Pass excludeStudentID = actual ID when UPDATING (allow same room)
    public boolean isRoomAllocated(String roomNumber, int excludeStudentID) {
        String sql = "SELECT StudentID FROM HostelStudents " +
                     "WHERE UPPER(RoomNumber) = UPPER(?) AND StudentID != ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, roomNumber);
            ps.setInt(2, excludeStudentID);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // true = room is taken
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // ── ADD STUDENT ──────────────────────────────────────────────────
    public boolean addStudent(Student s) {
        String sql = "INSERT INTO HostelStudents " +
                     "(StudentName, RoomNumber, AdmissionDate, FeesPaid, PendingFees) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getStudentName());
            ps.setString(2, s.getRoomNumber());
            ps.setDate(3, s.getAdmissionDate());
            ps.setDouble(4, s.getFeesPaid());
            ps.setDouble(5, s.getPendingFees());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // ── UPDATE STUDENT ───────────────────────────────────────────────
    public boolean updateStudent(Student s) {
        String sql = "UPDATE HostelStudents SET StudentName=?, RoomNumber=?, " +
                     "AdmissionDate=?, FeesPaid=?, PendingFees=? WHERE StudentID=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getStudentName());
            ps.setString(2, s.getRoomNumber());
            ps.setDate(3, s.getAdmissionDate());
            ps.setDouble(4, s.getFeesPaid());
            ps.setDouble(5, s.getPendingFees());
            ps.setInt(6, s.getStudentID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // ── DELETE STUDENT ───────────────────────────────────────────────
    public boolean deleteStudent(int id) {
        String sql = "DELETE FROM HostelStudents WHERE StudentID=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // ── GET ALL STUDENTS ─────────────────────────────────────────────
    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM HostelStudents ORDER BY StudentID";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ── GET BY ID ────────────────────────────────────────────────────
    public Student getStudentByID(int id) {
        String sql = "SELECT * FROM HostelStudents WHERE StudentID=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // ── REPORT 1: Pending Fees ───────────────────────────────────────
    public List<Student> getStudentsWithPendingFees() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM HostelStudents WHERE PendingFees > 0 ORDER BY PendingFees DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ── REPORT 2: By Room ────────────────────────────────────────────
    public List<Student> getStudentsByRoom(String room) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM HostelStudents WHERE RoomNumber=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, room);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ── REPORT 3: By Date Range ──────────────────────────────────────
    public List<Student> getStudentsByDateRange(Date from, Date to) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM HostelStudents " +
                     "WHERE AdmissionDate BETWEEN ? AND ? ORDER BY AdmissionDate";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private Student mapRow(ResultSet rs) throws SQLException {
        return new Student(
            rs.getInt("StudentID"),
            rs.getString("StudentName"),
            rs.getString("RoomNumber"),
            rs.getDate("AdmissionDate"),
            rs.getDouble("FeesPaid"),
            rs.getDouble("PendingFees")
        );
    }
}