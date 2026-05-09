package com.servlet;

import com.dao.HostelDAO;
import com.model.Student;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

public class AddStudentServlet extends HttpServlet {

    // GET: load page and fetch next auto-increment ID to show in readonly field
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HostelDAO dao = new HostelDAO();
        int nextID = dao.getNextAutoIncrementID();
        req.setAttribute("nextID", nextID);
        req.getRequestDispatcher("/studentadd.jsp").forward(req, res);
    }

    // POST: save student (ID assigned by DB auto-increment)
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name       = req.getParameter("studentName").trim();
        String room       = req.getParameter("roomNumber").trim();
        String dateStr    = req.getParameter("admissionDate").trim();
        String paidStr    = req.getParameter("feesPaid").trim();
        String pendingStr = req.getParameter("pendingFees").trim();

        StringBuilder error = new StringBuilder();

        if (name.isEmpty() || room.isEmpty() || dateStr.isEmpty()
                || paidStr.isEmpty() || pendingStr.isEmpty()) {
            error.append("All fields are required. ");
        }

        double paid = 0, pending = 0;

        try {
            paid = Double.parseDouble(paidStr);
            if (paid < 0) error.append("Fees Paid cannot be negative. ");
        } catch (NumberFormatException e) { error.append("Fees Paid must be a number. "); }

        try {
            pending = Double.parseDouble(pendingStr);
            if (pending < 0) error.append("Pending Fees cannot be negative. ");
        } catch (NumberFormatException e) { error.append("Pending Fees must be a number. "); }

        if (!name.matches("[a-zA-Z ]+"))   error.append("Name must contain only letters. ");
        if (!room.matches("[A-Za-z0-9]+")) error.append("Room number is invalid. ");

        HostelDAO dao = new HostelDAO();

        if (error.length() > 0) {
            req.setAttribute("error", error.toString());
            req.setAttribute("nextID", dao.getNextAutoIncrementID());
            req.getRequestDispatcher("/studentadd.jsp").forward(req, res);
            return;
        }

        // StudentID = 0 because DB will auto-assign it
        Student s = new Student(0, name, room, Date.valueOf(dateStr), paid, pending);
        boolean success = dao.addStudent(s);

        if (success) {
            req.setAttribute("success", "Student registered successfully!");
        } else {
            req.setAttribute("error", "Failed to add student. Please try again.");
        }
        req.setAttribute("nextID", dao.getNextAutoIncrementID());
        req.getRequestDispatcher("/studentadd.jsp").forward(req, res);
    }
}