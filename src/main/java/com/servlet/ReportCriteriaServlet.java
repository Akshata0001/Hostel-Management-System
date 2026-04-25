package com.servlet;

import com.dao.hostelDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * GET /reportCriteria → render report_form.jsp with filter options
 * (Populates room-number dropdown dynamically from DB)
 */
@WebServlet("/reportCriteria")
public class ReportCriteriaServlet extends HttpServlet {

    private final hostelDAO dao = new hostelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<String> rooms = dao.getAllRoomNumbers();
            req.setAttribute("roomNumbers", rooms);
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Could not load room list: " + e.getMessage());
        }
        req.getRequestDispatcher("/report_form.jsp").forward(req, resp);
    }
}
