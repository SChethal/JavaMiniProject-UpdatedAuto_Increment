package com.servlet;

import com.dao.HostelDAO;
import com.model.Student;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

public class UpdateStudentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String idStr = req.getParameter("studentID");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                HostelDAO dao = new HostelDAO();
                Student s = dao.getStudentByID(id);
                if (s != null) {
                    req.setAttribute("student", s);
                } else {
                    req.setAttribute("error", "No student found with ID: " + id);
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid ID format.");
            }
        }
        req.getRequestDispatcher("/studentupdate.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String idStr      = req.getParameter("studentID").trim();
        String name       = req.getParameter("studentName").trim();
        String room       = req.getParameter("roomNumber").trim();
        String dateStr    = req.getParameter("admissionDate").trim();
        String paidStr    = req.getParameter("feesPaid").trim();
        String pendingStr = req.getParameter("pendingFees").trim();

        StringBuilder error = new StringBuilder();

        if (idStr.isEmpty() || name.isEmpty() || room.isEmpty() ||
            dateStr.isEmpty() || paidStr.isEmpty() || pendingStr.isEmpty()) {
            error.append("All fields are required. ");
        }

        int id = 0;
        double paid = 0, pending = 0;

        try { id = Integer.parseInt(idStr); }
        catch (NumberFormatException e) { error.append("Invalid ID. "); }

        try { paid = Double.parseDouble(paidStr); if (paid < 0) error.append("Fees Paid cannot be negative. "); }
        catch (NumberFormatException e) { error.append("Invalid Fees Paid. "); }

        try { pending = Double.parseDouble(pendingStr); if (pending < 0) error.append("Pending Fees cannot be negative. "); }
        catch (NumberFormatException e) { error.append("Invalid Pending Fees. "); }

        if (!name.matches("[a-zA-Z ]+")) error.append("Name must contain only letters. ");

        if (error.length() > 0) {
            req.setAttribute("error", error.toString());
            req.getRequestDispatcher("/studentupdate.jsp").forward(req, res);
            return;
        }

        HostelDAO dao = new HostelDAO();
        Student s = new Student(id, name, room, Date.valueOf(dateStr), paid, pending);
        boolean success = dao.updateStudent(s);

        if (success) {
            req.setAttribute("success", "Student updated successfully!");
        } else {
            req.setAttribute("error", "Update failed. Student ID may not exist.");
        }
        req.setAttribute("student", s);
        req.getRequestDispatcher("/studentupdate.jsp").forward(req, res);
    }
}