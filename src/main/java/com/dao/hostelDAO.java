package com.dao;

import com.model.Student;
import com.dao.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for HostelStudents table.
 * All DB interactions go through this class (PreparedStatements used
 * everywhere to prevent SQL injection).
 */
public class hostelDAO {

    // -------------------------------------------------------
    //  SQL constants
    // -------------------------------------------------------
    private static final String SQL_INSERT =
        "INSERT INTO HostelStudents (StudentID, StudentName, RoomNumber, " +
        "AdmissionDate, FeesPaid, PendingFees) VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SQL_UPDATE =
        "UPDATE HostelStudents SET StudentName=?, RoomNumber=?, " +
        "AdmissionDate=?, FeesPaid=?, PendingFees=? WHERE StudentID=?";

    private static final String SQL_DELETE =
        "DELETE FROM HostelStudents WHERE StudentID=?";

    private static final String SQL_SELECT_ALL =
        "SELECT * FROM HostelStudents ORDER BY StudentID";

    private static final String SQL_SELECT_BY_ID =
        "SELECT * FROM HostelStudents WHERE StudentID=?";

    private static final String SQL_PENDING_FEES =
        "SELECT * FROM HostelStudents WHERE PendingFees > 0 ORDER BY PendingFees DESC";

    private static final String SQL_BY_ROOM =
        "SELECT * FROM HostelStudents WHERE RoomNumber=? ORDER BY StudentID";

    private static final String SQL_BY_DATE_RANGE =
        "SELECT * FROM HostelStudents WHERE AdmissionDate BETWEEN ? AND ? " +
        "ORDER BY AdmissionDate";

    // -------------------------------------------------------
    //  Helper – map a ResultSet row to a Student object
    // -------------------------------------------------------
    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("StudentID"));
        s.setStudentName(rs.getString("StudentName"));
        s.setRoomNumber(rs.getString("RoomNumber"));
        s.setAdmissionDate(rs.getDate("AdmissionDate"));
        s.setFeesPaid(rs.getBigDecimal("FeesPaid"));
        s.setPendingFees(rs.getBigDecimal("PendingFees"));
        return s;
    }

    // -------------------------------------------------------
    //  CRUD operations
    // -------------------------------------------------------

    /**
     * Inserts a new student record.
     * @return true if insert succeeded
     */
    public boolean addStudent(Student s) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {

            ps.setInt(1, s.getStudentId());
            ps.setString(2, s.getStudentName());
            ps.setString(3, s.getRoomNumber());
            ps.setDate(4, s.getAdmissionDate());
            ps.setBigDecimal(5, s.getFeesPaid());
            ps.setBigDecimal(6, s.getPendingFees());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Updates an existing student by StudentID.
     * @return true if at least one row was updated
     */
    public boolean updateStudent(Student s) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_UPDATE)) {

            ps.setString(1, s.getStudentName());
            ps.setString(2, s.getRoomNumber());
            ps.setDate(3, s.getAdmissionDate());
            ps.setBigDecimal(4, s.getFeesPaid());
            ps.setBigDecimal(5, s.getPendingFees());
            ps.setInt(6, s.getStudentId());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Deletes a student by StudentID.
     * @return true if a row was deleted
     */
    public boolean deleteStudent(int studentId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_DELETE)) {

            ps.setInt(1, studentId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Returns all students ordered by StudentID.
     */
    public List<Student> getAllStudents() throws SQLException {
        List<Student> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    /**
     * Returns a single student by ID, or null if not found.
     */
    public Student getStudentById(int studentId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_SELECT_BY_ID)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    // -------------------------------------------------------
    //  Report queries
    // -------------------------------------------------------

    /**
     * Returns students with pending fees > 0, sorted by pending amount descending.
     */
    public List<Student> getStudentsWithPendingFees() throws SQLException {
        List<Student> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_PENDING_FEES);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    /**
     * Returns all students assigned to a given room.
     */
    public List<Student> getStudentsByRoom(String roomNo) throws SQLException {
        List<Student> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_BY_ROOM)) {

            ps.setString(1, roomNo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    /**
     * Returns students admitted between start and end dates (inclusive).
     */
    public List<Student> getStudentsByDateRange(Date start, Date end) throws SQLException {
        List<Student> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_BY_DATE_RANGE)) {

            ps.setDate(1, start);
            ps.setDate(2, end);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    /**
     * Convenience: returns a distinct list of all room numbers in the DB.
     * Used to populate the room-filter dropdown on the Reports page.
     */
    public List<String> getAllRoomNumbers() throws SQLException {
        List<String> rooms = new ArrayList<>();
        String sql = "SELECT DISTINCT RoomNumber FROM HostelStudents ORDER BY RoomNumber";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                rooms.add(rs.getString("RoomNumber"));
            }
        }
        return rooms;
    }

    /**
     * Returns summary totals: [totalStudents, totalFeesPaid, totalPendingFees]
     */
    public BigDecimal[] getFeeSummary() throws SQLException {
        String sql = "SELECT COUNT(*) AS cnt, COALESCE(SUM(FeesPaid),0) AS paid, " +
                     "COALESCE(SUM(PendingFees),0) AS pending FROM HostelStudents";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return new BigDecimal[]{
                    BigDecimal.valueOf(rs.getInt("cnt")),
                    rs.getBigDecimal("paid"),
                    rs.getBigDecimal("pending")
                };
            }
        }
        return new BigDecimal[]{ BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO };
    }
}
