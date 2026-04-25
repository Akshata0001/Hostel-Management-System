package com.servlet;

import com.dao.hostelDAO;
import com.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * GET  /deleteStudent               → show search/confirmation form
 * GET  /deleteStudent?studentId=XX  → load student details for confirmation
 * POST /deleteStudent               → perform delete
 */
@WebServlet("/deleteStudent")
public class DeleteStudentSevlet extends HttpServlet {

    private final hostelDAO dao = new hostelDAO();

    // ------------------------------------------------------------------
    //  GET
    // ------------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("studentId");

        if (idStr != null && !idStr.trim().isEmpty()) {
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
        }

        req.getRequestDispatcher("/studentdelete.jsp").forward(req, resp);
    }

    // ------------------------------------------------------------------
    //  POST  –  delete confirmed
    // ------------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("studentId");
        if (idStr == null || idStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Student ID is required.");
            req.getRequestDispatcher("/studentdelete.jsp").forward(req, resp);
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            boolean deleted = dao.deleteStudent(id);
            if (deleted) {
                resp.sendRedirect(req.getContextPath()
                    + "/displayStudents?message=Student+deleted+successfully&type=success");
            } else {
                req.setAttribute("errorMessage", "No student found with ID: " + id + ". Delete failed.");
                req.getRequestDispatcher("/studentdelete.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid Student ID.");
            req.getRequestDispatcher("/studentdelete.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/studentdelete.jsp").forward(req, resp);
        }
    }
}
