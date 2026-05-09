package com.servlet;

import com.dao.HostelDAO;
import com.model.Student;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class DeleteStudentServlet extends HttpServlet {

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
        req.getRequestDispatcher("/studentdelete.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String idStr = req.getParameter("studentID");
        StringBuilder error = new StringBuilder();

        if (idStr == null || idStr.trim().isEmpty()) {
            error.append("Student ID is required.");
        }

        int id = 0;
        try { id = Integer.parseInt(idStr.trim()); if (id <= 0) error.append("ID must be positive."); }
        catch (NumberFormatException e) { error.append("Invalid Student ID."); }

        if (error.length() > 0) {
            req.setAttribute("error", error.toString());
            req.getRequestDispatcher("/studentdelete.jsp").forward(req, res);
            return;
        }

        HostelDAO dao = new HostelDAO();
        boolean success = dao.deleteStudent(id);

        if (success) {
            req.setAttribute("success", "Student with ID " + id + " deleted successfully!");
        } else {
            req.setAttribute("error", "Delete failed. Student ID " + id + " not found.");
        }
        req.getRequestDispatcher("/studentdelete.jsp").forward(req, res);
    }
}