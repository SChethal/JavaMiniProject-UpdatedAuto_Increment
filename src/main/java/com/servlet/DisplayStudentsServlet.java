package com.servlet;

import com.dao.HostelDAO;
import com.model.Student;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class DisplayStudentsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String idStr = req.getParameter("studentID");
        HostelDAO dao = new HostelDAO();

        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                Student s = dao.getStudentByID(id);
                if (s != null) {
                    req.setAttribute("singleStudent", s);
                } else {
                    req.setAttribute("error", "No student found with ID: " + id);
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid ID format.");
            }
        } else {
            List<Student> list = dao.getAllStudents();
            req.setAttribute("studentList", list);
        }
        req.getRequestDispatcher("/studentdisplay.jsp").forward(req, res);
    }
}