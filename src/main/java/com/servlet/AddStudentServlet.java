package com.servlet;

import com.dao.HostelDAO;
import com.model.Student;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

public class AddStudentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HostelDAO dao = new HostelDAO();
        req.setAttribute("nextID", dao.getNextAutoIncrementID());
        req.getRequestDispatcher("/studentadd.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name       = req.getParameter("studentName").trim();
        String room       = req.getParameter("roomNumber").trim().toUpperCase();
        String dateStr    = req.getParameter("admissionDate").trim();
        String paidStr    = req.getParameter("feesPaid").trim();
        String pendingStr = req.getParameter("pendingFees").trim();

        StringBuilder error = new StringBuilder();
        HostelDAO dao = new HostelDAO();

        // ── Basic empty check ──
        if (name.isEmpty() || room.isEmpty() || dateStr.isEmpty()
                || paidStr.isEmpty() || pendingStr.isEmpty()) {
            error.append("All fields are required. ");
        }

        // ── Name validation ──
        if (!name.isEmpty() && !name.matches("[a-zA-Z ]+"))
            error.append("Name must contain only letters and spaces. ");

        // ── Room format validation ──
        if (!room.isEmpty() && !room.matches("[A-Za-z0-9]+"))
            error.append("Room number must be alphanumeric (e.g. A101). ");

        // ── Fee validations ──
        double paid = 0, pending = 0;
        try {
            paid = Double.parseDouble(paidStr);
            if (paid < 0) error.append("Fees Paid cannot be negative. ");
        } catch (NumberFormatException e) {
            error.append("Fees Paid must be a valid number. ");
        }
        try {
            pending = Double.parseDouble(pendingStr);
            if (pending < 0) error.append("Pending Fees cannot be negative. ");
        } catch (NumberFormatException e) {
            error.append("Pending Fees must be a valid number. ");
        }

        // ── Room uniqueness check (SERVER-SIDE — authoritative) ──
        if (error.length() == 0 && dao.isRoomAllocated(room, -1)) {
            error.append("Room '" + room +
                "' is already allocated to another student. " +
                "Each room can have only ONE student.");
        }

        // ── If any error, go back ──
        if (error.length() > 0) {
            req.setAttribute("error", error.toString());
            req.setAttribute("nextID", dao.getNextAutoIncrementID());
            req.setAttribute("formName", name);
            req.setAttribute("formRoom", room);
            req.setAttribute("formDate", dateStr);
            req.setAttribute("formPaid", paidStr);
            req.setAttribute("formPending", pendingStr);
            req.getRequestDispatcher("/studentadd.jsp").forward(req, res);
            return;
        }

        Student s = new Student(0, name, room, Date.valueOf(dateStr), paid, pending);
        boolean success = dao.addStudent(s);

        if (success) {
            req.setAttribute("success",
                "Student registered successfully! Room " + room + " allocated.");
        } else {
            req.setAttribute("error", "Database error. Please try again.");
        }
        req.setAttribute("nextID", dao.getNextAutoIncrementID());
        req.getRequestDispatcher("/studentadd.jsp").forward(req, res);
    }
}