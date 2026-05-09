package com.servlet;

import com.dao.HostelDAO;
import com.model.Student;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

public class ReportServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String reportType = req.getParameter("reportType");
        HostelDAO dao = new HostelDAO();
        List<Student> result = null;
        String reportTitle = "";
        String error = null;

        try {
            if ("pending".equals(reportType)) {
                result = dao.getStudentsWithPendingFees();
                reportTitle = "Students with Pending Fees";

            } else if ("room".equals(reportType)) {
                String room = req.getParameter("roomNumber");
                if (room == null || room.trim().isEmpty()) {
                    error = "Please enter a room number.";
                } else {
                    result = dao.getStudentsByRoom(room.trim().toUpperCase());
                    reportTitle = "Students in Room: " + room.trim().toUpperCase();
                }

            } else if ("date".equals(reportType)) {
                String fromStr = req.getParameter("fromDate");
                String toStr   = req.getParameter("toDate");
                if (fromStr == null || fromStr.isEmpty() || toStr == null || toStr.isEmpty()) {
                    error = "Please provide both From and To dates.";
                } else {
                    Date from = Date.valueOf(fromStr);
                    Date to   = Date.valueOf(toStr);
                    if (from.after(to)) {
                        error = "From date cannot be after To date.";
                    } else {
                        result = dao.getStudentsByDateRange(from, to);
                        reportTitle = "Students Admitted from " + fromStr + " to " + toStr;
                    }
                }
            }
        } catch (Exception e) {
            error = "Error generating report: " + e.getMessage();
        }

        req.setAttribute("reportTitle", reportTitle);
        req.setAttribute("reportResult", result);
        req.setAttribute("error", error);
        req.getRequestDispatcher("/report_result.jsp").forward(req, res);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/report_form.jsp").forward(req, res);
    }
}