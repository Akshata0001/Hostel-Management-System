package com.servlet;

import com.dao.hostelDAO;
import com.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * GET /displayStudents             → show all students
 * GET /displayStudents?studentId=X → search single student
 */
@WebServlet("/displayStudents")
public class DisplayStudentServlet extends HttpServlet {

    private final hostelDAO dao = new hostelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr    = req.getParameter("studentId");
        String message  = req.getParameter("message");
        String msgType  = req.getParameter("type");     // success | error

        if (message != null && !message.isEmpty()) {
            req.setAttribute("flashMessage", message);
            req.setAttribute("flashType",    msgType != null ? msgType : "success");
        }

        try {
            if (idStr != null && !idStr.trim().isEmpty()) {
                // Search mode
                int id = Integer.parseInt(idStr.trim());
                Student s = dao.getStudentById(id);
                if (s == null) {
                    req.setAttribute("errorMessage", "No student found with ID: " + id);
                    List<Student> all = dao.getAllStudents();
                    req.setAttribute("students", all);
                    attachSummary(req, all);
                } else {
                    req.setAttribute("students", List.of(s));
                    req.setAttribute("searchMode", true);
                }
            } else {
                // Show all
                List<Student> all = dao.getAllStudents();
                req.setAttribute("students", all);
                attachSummary(req, all);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid Student ID.");
            loadAll(req);
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
            req.setAttribute("students", List.of());
        }

        req.getRequestDispatcher("/studentdisplay.jsp").forward(req, resp);
    }

    private void loadAll(HttpServletRequest req) {
        try {
            List<Student> all = dao.getAllStudents();
            req.setAttribute("students", all);
            attachSummary(req, all);
        } catch (SQLException ignore) {
            req.setAttribute("students", List.of());
        }
    }

    private void attachSummary(HttpServletRequest req, List<Student> list) throws SQLException {
        BigDecimal[] summary = dao.getFeeSummary();
        req.setAttribute("summaryTotal",     summary[0]);
        req.setAttribute("summaryPaid",      summary[1]);
        req.setAttribute("summaryPending",   summary[2]);
    }
}
