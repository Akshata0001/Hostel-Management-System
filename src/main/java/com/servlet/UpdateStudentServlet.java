package com.servlet;

import com.dao.hostelDAO;
import com.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;

/**
 * GET  /updateStudent?studentId=XXX  → search form, or pre-populate edit form
 * POST /updateStudent                → commit update to DB
 */
@WebServlet("/updateStudent")
public class UpdateStudentServlet extends HttpServlet {

    private final hostelDAO dao = new hostelDAO();

    // ------------------------------------------------------------------
    //  GET
    // ------------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("studentId");

        if (idStr == null || idStr.trim().isEmpty()) {
            // Show blank search form
            req.getRequestDispatcher("/studentupdate.jsp").forward(req, resp);
            return;
        }

        // Load existing student data to pre-populate form
        try {
            int id = Integer.parseInt(idStr.trim());
            Student s = dao.getStudentById(id);
            if (s == null) {
                req.setAttribute("errorMessage", "No student found with ID: " + id);
            } else {
                req.setAttribute("student", s);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid Student ID.");
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }
        req.getRequestDispatcher("/studentupdate.jsp").forward(req, resp);
    }

    // ------------------------------------------------------------------
    //  POST  –  commit the update
    // ------------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String idStr      = req.getParameter("studentId")     != null ? req.getParameter("studentId").trim()     : "";
        String name       = req.getParameter("studentName")   != null ? req.getParameter("studentName").trim()   : "";
        String room       = req.getParameter("roomNumber")    != null ? req.getParameter("roomNumber").trim()    : "";
        String dateStr    = req.getParameter("admissionDate") != null ? req.getParameter("admissionDate").trim() : "";
        String paidStr    = req.getParameter("feesPaid")      != null ? req.getParameter("feesPaid").trim()      : "";
        String pendingStr = req.getParameter("pendingFees")   != null ? req.getParameter("pendingFees").trim()   : "";

        StringBuilder errors = new StringBuilder();

        int studentId = 0;
        try {
            studentId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            errors.append("Invalid Student ID. ");
        }

        if (name.isEmpty())    errors.append("Student name is required. ");
        if (room.isEmpty())    errors.append("Room number is required. ");

        Date admissionDate = null;
        try { admissionDate = Date.valueOf(dateStr); }
        catch (IllegalArgumentException e) { errors.append("Invalid date format. "); }

        BigDecimal feesPaid = BigDecimal.ZERO, pendingFees = BigDecimal.ZERO;
        try { feesPaid    = new BigDecimal(paidStr.isEmpty()    ? "0" : paidStr);    }
        catch (NumberFormatException e) { errors.append("Invalid Fees Paid amount. "); }
        try { pendingFees = new BigDecimal(pendingStr.isEmpty() ? "0" : pendingStr); }
        catch (NumberFormatException e) { errors.append("Invalid Pending Fees amount. "); }

        if (errors.length() > 0) {
            req.setAttribute("errorMessage", errors.toString());
            // Reconstruct a Student to repopulate the form
            Student tmp = new Student();
            tmp.setStudentId(studentId);
            tmp.setStudentName(name);
            tmp.setRoomNumber(room);
            tmp.setAdmissionDate(admissionDate);
            tmp.setFeesPaid(feesPaid);
            tmp.setPendingFees(pendingFees);
            req.setAttribute("student", tmp);
            req.getRequestDispatcher("/studentupdate.jsp").forward(req, resp);
            return;
        }

        Student s = new Student(studentId, name, room, admissionDate, feesPaid, pendingFees);
        try {
            boolean updated = dao.updateStudent(s);
            if (updated) {
                resp.sendRedirect(req.getContextPath()
                    + "/displayStudents?message=Student+updated+successfully&type=success");
            } else {
                req.setAttribute("errorMessage", "No student found with ID: " + studentId + ". Update failed.");
                req.setAttribute("student", s);
                req.getRequestDispatcher("/studentupdate.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            req.setAttribute("errorMessage", "Database error: " + ex.getMessage());
            req.setAttribute("student", s);
            req.getRequestDispatcher("/studentupdate.jsp").forward(req, resp);
        }
    }
}
