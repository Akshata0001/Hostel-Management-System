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
 * Handles GET  → show the Add-Student form (studentadd.jsp)
 *         POST → validate, insert into DB, redirect with result message
 */
@WebServlet("/addStudent")
public class AddStudentServlet extends HttpServlet {

    private final hostelDAO dao = new hostelDAO();

    // ------------------------------------------------------------------
    //  GET  –  just forward to the blank form
    // ------------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/studentadd.jsp").forward(req, resp);
    }

    // ------------------------------------------------------------------
    //  POST –  validate → insert → redirect
    // ------------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // ---------- read parameters ----------
        String idStr       = req.getParameter("studentId")     != null ? req.getParameter("studentId").trim()     : "";
        String name        = req.getParameter("studentName")   != null ? req.getParameter("studentName").trim()   : "";
        String room        = req.getParameter("roomNumber")    != null ? req.getParameter("roomNumber").trim()    : "";
        String dateStr     = req.getParameter("admissionDate") != null ? req.getParameter("admissionDate").trim() : "";
        String paidStr     = req.getParameter("feesPaid")      != null ? req.getParameter("feesPaid").trim()      : "";
        String pendingStr  = req.getParameter("pendingFees")   != null ? req.getParameter("pendingFees").trim()   : "";

        // ---------- server-side validation ----------
        StringBuilder errors = new StringBuilder();

        int studentId = 0;
        try {
            studentId = Integer.parseInt(idStr);
            if (studentId <= 0) errors.append("Student ID must be a positive integer. ");
        } catch (NumberFormatException e) {
            errors.append("Student ID must be a valid number. ");
        }

        if (name.isEmpty())   errors.append("Student name is required. ");
        if (room.isEmpty())   errors.append("Room number is required. ");
        if (dateStr.isEmpty()) errors.append("Admission date is required. ");

        Date admissionDate = null;
        try { admissionDate = Date.valueOf(dateStr); }
        catch (IllegalArgumentException e) { if (errors.length() == 0) errors.append("Invalid date format. "); }

        BigDecimal feesPaid = BigDecimal.ZERO, pendingFees = BigDecimal.ZERO;
        try { feesPaid = new BigDecimal(paidStr.isEmpty() ? "0" : paidStr); }
        catch (NumberFormatException e) { errors.append("Fees Paid must be a valid amount. "); }
        try { pendingFees = new BigDecimal(pendingStr.isEmpty() ? "0" : pendingStr); }
        catch (NumberFormatException e) { errors.append("Pending Fees must be a valid amount. "); }

        if (errors.length() > 0) {
            req.setAttribute("errorMessage", errors.toString());
            // re-populate form fields
            req.setAttribute("studentId",     idStr);
            req.setAttribute("studentName",   name);
            req.setAttribute("roomNumber",    room);
            req.setAttribute("admissionDate", dateStr);
            req.setAttribute("feesPaid",      paidStr);
            req.setAttribute("pendingFees",   pendingStr);
            req.getRequestDispatcher("/studentadd.jsp").forward(req, resp);
            return;
        }

        // ---------- build model & persist ----------
        Student s = new Student(studentId, name, room, admissionDate, feesPaid, pendingFees);
        try {
            boolean added = dao.addStudent(s);
            if (added) {
                resp.sendRedirect(req.getContextPath()
                    + "/displayStudents?message=Student+added+successfully&type=success");
            } else {
                req.setAttribute("errorMessage", "Could not add student. Please try again.");
                req.getRequestDispatcher("/studentadd.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            String msg = ex.getMessage();
            if (msg != null && msg.contains("Duplicate entry")) {
                req.setAttribute("errorMessage", "Student ID " + studentId + " already exists.");
            } else {
                req.setAttribute("errorMessage", "Database error: " + ex.getMessage());
            }
            req.setAttribute("studentId", idStr);
            req.setAttribute("studentName", name);
            req.setAttribute("roomNumber", room);
            req.setAttribute("admissionDate", dateStr);
            req.setAttribute("feesPaid", paidStr);
            req.setAttribute("pendingFees", pendingStr);
            req.getRequestDispatcher("/studentadd.jsp").forward(req, resp);
        }
    }
}
