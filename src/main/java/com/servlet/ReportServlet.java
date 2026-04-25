package com.servlet;

import com.dao.hostelDAO;
import com.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * POST /report → run the chosen report and forward results to report_result.jsp
 *
 * reportType values:
 *   pending    – students with pending fees > 0
 *   room       – students in a specific room (param: roomNumber)
 *   dateRange  – students admitted between two dates (params: startDate, endDate)
 */
@WebServlet("/report")
public class ReportServlet extends HttpServlet {

    private final hostelDAO dao = new hostelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);   // allow bookmark-style GET links too
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String reportType = req.getParameter("reportType");
        List<Student> results = null;
        String reportTitle = "";
        String errorMessage = null;

        try {
            if ("pending".equals(reportType)) {
                results      = dao.getStudentsWithPendingFees();
                reportTitle  = "Students with Pending Fees";

            } else if ("room".equals(reportType)) {
                String room  = req.getParameter("roomNumber");
                if (room == null || room.trim().isEmpty()) {
                    errorMessage = "Please provide a room number.";
                } else {
                    results     = dao.getStudentsByRoom(room.trim());
                    reportTitle = "Students in Room: " + room.trim();
                    req.setAttribute("filterRoom", room.trim());
                }

            } else if ("dateRange".equals(reportType)) {
                String startStr = req.getParameter("startDate");
                String endStr   = req.getParameter("endDate");
                if (startStr == null || startStr.isEmpty() || endStr == null || endStr.isEmpty()) {
                    errorMessage = "Please provide both start and end dates.";
                } else {
                    Date start = Date.valueOf(startStr.trim());
                    Date end   = Date.valueOf(endStr.trim());
                    if (start.after(end)) {
                        errorMessage = "Start date must not be after end date.";
                    } else {
                        results     = dao.getStudentsByDateRange(start, end);
                        reportTitle = "Students Admitted: " + startStr + " to " + endStr;
                        req.setAttribute("filterStart", startStr);
                        req.setAttribute("filterEnd",   endStr);
                    }
                }

            } else {
                errorMessage = "Unknown report type selected.";
            }

        } catch (IllegalArgumentException e) {
            errorMessage = "Invalid date format. Please use YYYY-MM-DD.";
        } catch (SQLException e) {
            errorMessage = "Database error: " + e.getMessage();
        }

        req.setAttribute("results",      results);
        req.setAttribute("reportTitle",  reportTitle);
        req.setAttribute("reportType",   reportType);
        req.setAttribute("errorMessage", errorMessage);

        req.getRequestDispatcher("/report_result.jsp").forward(req, resp);
    }
}
