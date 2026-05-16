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
                if (s != null) req.setAttribute("student", s);
                else           req.setAttribute("error", "No student found with ID: " + id);
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
        String room       = req.getParameter("roomNumber").trim().toUpperCase();
        String dateStr    = req.getParameter("admissionDate").trim();
        String paidStr    = req.getParameter("feesPaid").trim();
        String pendingStr = req.getParameter("pendingFees").trim();

        StringBuilder error = new StringBuilder();
        HostelDAO dao = new HostelDAO();
        int id = 0;

        try { id = Integer.parseInt(idStr); }
        catch (NumberFormatException e) { error.append("Invalid Student ID. "); }

        if (name.isEmpty() || room.isEmpty() || dateStr.isEmpty()
                || paidStr.isEmpty() || pendingStr.isEmpty()) {
            error.append("All fields are required. ");
        }

        if (!name.isEmpty() && !name.matches("[a-zA-Z ]+"))
            error.append("Name must contain only letters. ");

        if (!room.isEmpty() && !room.matches("[A-Za-z0-9]+"))
            error.append("Room number must be alphanumeric. ");

        double paid = 0, pending = 0;
        try {
            paid = Double.parseDouble(paidStr);
            if (paid < 0) error.append("Fees Paid cannot be negative. ");
        } catch (NumberFormatException e) { error.append("Invalid Fees Paid. "); }

        try {
            pending = Double.parseDouble(pendingStr);
            if (pending < 0) error.append("Pending Fees cannot be negative. ");
        } catch (NumberFormatException e) { error.append("Invalid Pending Fees. "); }

        // ── Room uniqueness: exclude THIS student's own ID ──
        // So a student can keep their existing room without error
        if (error.length() == 0 && dao.isRoomAllocated(room, id)) {
            error.append("Room '" + room +
                "' is already allocated to another student. " +
                "Each room can have only ONE student.");
        }

        if (error.length() > 0) {
            Student existing = dao.getStudentByID(id);
            if (existing != null) req.setAttribute("student", existing);
            req.setAttribute("error", error.toString());
            req.getRequestDispatcher("/studentupdate.jsp").forward(req, res);
            return;
        }

        Student s = new Student(id, name, room, Date.valueOf(dateStr), paid, pending);
        boolean success = dao.updateStudent(s);

        if (success) {
            req.setAttribute("success",
                "Student updated successfully! Room " + room + " allocated.");
            req.setAttribute("student", dao.getStudentByID(id));
        } else {
            req.setAttribute("error", "Update failed. Please try again.");
            req.setAttribute("student", dao.getStudentByID(id));
        }
        req.getRequestDispatcher("/studentupdate.jsp").forward(req, res);
    }
}