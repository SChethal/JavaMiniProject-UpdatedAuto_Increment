<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Student, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Report Results | HostelMS</title>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: linear-gradient(135deg, #1a1a2e, #0f3460);
    min-height: 100vh; font-family: 'Segoe UI', sans-serif; }

  nav { background: rgba(255,255,255,0.05); backdrop-filter: blur(10px);
    border-bottom: 1px solid rgba(255,255,255,0.1); padding: 15px 40px;
    display: flex; justify-content: space-between; align-items: center; }
  .brand { font-size: 1.4rem; font-weight: 700; color: #e94560; text-decoration: none; }
  .nav-links { display: flex; gap: 10px; }
  .nav-links a { color: rgba(255,255,255,0.7); text-decoration: none; padding: 6px 14px;
    border: 1px solid rgba(255,255,255,0.2); border-radius: 20px; font-size: 0.88rem; transition: all 0.3s; }
  .nav-links a:hover { color: white; border-color: #e94560; background: rgba(233,69,96,0.15); }

  .page-title { text-align: center; padding: 40px 20px 20px; color: white; }
  .page-title h1 { font-size: 2.2rem; font-weight: 800; }
  .page-title h1 span { color: #a29bfe; }

  .container { max-width: 1100px; margin: 0 auto; padding: 0 20px 60px; }

  .alert-error { background: rgba(231,76,60,0.2); border: 1px solid #e74c3c; color: #ff6b6b;
    border-radius: 12px; padding: 14px 18px; margin-bottom: 18px; }

  .report-banner { background: rgba(162,155,254,0.15); border: 1px solid rgba(162,155,254,0.35);
    border-radius: 14px; padding: 16px 22px; margin-bottom: 24px; }
  .report-banner h4 { color: #a29bfe; font-weight: 700; font-size: 1.1rem; }

  /* Summary boxes */
  .summary-row { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-bottom: 24px; }
  @media(max-width:550px) { .summary-row { grid-template-columns: 1fr; } }
  .summary-box { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12);
    border-radius: 14px; padding: 20px; text-align: center; }
  .summary-box h3 { font-size: 1.8rem; font-weight: 800; }
  .summary-box p { color: rgba(255,255,255,0.55); font-size: 0.85rem; margin-top: 6px; }
  .clr-purple { color: #a29bfe; }
  .clr-green  { color: #2ecc71; }
  .clr-red    { color: #ff6b6b; }

  /* Table */
  .table-card { background: rgba(255,255,255,0.08); backdrop-filter: blur(15px);
    border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; padding: 30px; }
  .table-wrap { overflow-x: auto; }
  table.data-table { width: 100%; border-collapse: collapse; }
  table.data-table thead tr { background: rgba(162,155,254,0.25); }
  table.data-table th { padding: 13px 14px; text-align: left; color: white; font-weight: 600; font-size: 0.9rem; }
  table.data-table tbody tr { border-bottom: 1px solid rgba(255,255,255,0.07); transition: background 0.2s; }
  table.data-table tbody tr:hover { background: rgba(255,255,255,0.05); }
  table.data-table td { padding: 12px 14px; color: rgba(255,255,255,0.85); font-size: 0.9rem; vertical-align: middle; }
  .room-tag { background: rgba(116,185,255,0.2); color: #74b9ff; padding: 3px 10px; border-radius: 10px; font-size: 0.85rem; }
  .badge { display: inline-block; padding: 3px 12px; border-radius: 20px; font-size: 0.82rem; }
  .badge-green { background: rgba(39,174,96,0.25); color: #2ecc71; border: 1px solid #27ae60; }
  .badge-red   { background: rgba(231,76,60,0.25);  color: #ff6b6b; border: 1px solid #e74c3c; }

  .empty-msg { text-align: center; padding: 50px 20px; color: rgba(255,255,255,0.4); }
  .empty-msg span { font-size: 3rem; display: block; margin-bottom: 12px; }

  .back-links { text-align: center; margin-top: 24px; display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
  .back-links a { color: rgba(255,255,255,0.7); text-decoration: none; padding: 9px 22px;
    border: 1px solid rgba(255,255,255,0.25); border-radius: 20px; font-size: 0.88rem; transition: all 0.3s; }
  .back-links a:hover { color: white; background: rgba(255,255,255,0.1); }
</style>
</head>
<body>

<nav>
  <a class="brand" href="index.jsp">🏨 HostelMS</a>
  <div class="nav-links">
    <a href="index.jsp">🏠 Home</a>
    <a href="DisplayStudents">👥 Students</a>
    <a href="Report">📊 Reports</a>
  </div>
</nav>

<div class="page-title">
  <h1>📄 Report <span>Results</span></h1>
</div>

<div class="container">

  <% String error = (String)request.getAttribute("error");
     if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>

  <% String title  = (String)request.getAttribute("reportTitle");
     List<Student> result = (List<Student>)request.getAttribute("reportResult");
     if (title != null && result != null) { %>

  <div class="report-banner"><h4>📋 <%= title %></h4></div>

  <% if (result.isEmpty()) { %>
    <div class="table-card">
      <div class="empty-msg"><span>📭</span>No records found for this criteria.</div>
    </div>
  <% } else {
       double totalPaid = 0, totalPending = 0;
       for (Student s : result) { totalPaid += s.getFeesPaid(); totalPending += s.getPendingFees(); }
  %>

  <div class="summary-row">
    <div class="summary-box"><h3 class="clr-purple"><%= result.size() %></h3><p>Total Students</p></div>
    <div class="summary-box"><h3 class="clr-green">₹<%= totalPaid %></h3><p>Total Paid</p></div>
    <div class="summary-box"><h3 class="clr-red">₹<%= totalPending %></h3><p>Total Pending</p></div>
  </div>

  <div class="table-card">
    <div class="table-wrap">
      <table class="data-table">
        <thead>
          <tr><th>ID</th><th>Name</th><th>Room</th><th>Admission Date</th><th>Fees Paid (₹)</th><th>Pending (₹)</th></tr>
        </thead>
        <tbody>
          <% for (Student s : result) { %>
          <tr>
            <td><strong><%= s.getStudentID() %></strong></td>
            <td><%= s.getStudentName() %></td>
            <td><span class="room-tag"><%= s.getRoomNumber() %></span></td>
            <td><%= s.getAdmissionDate() %></td>
            <td><span class="badge badge-green">₹<%= s.getFeesPaid() %></span></td>
            <td><span class="badge <%= s.getPendingFees() > 0 ? "badge-red" : "badge-green" %>">₹<%= s.getPendingFees() %></span></td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
  <% } %>
  <% } %>

  <div class="back-links">
    <a href="Report">← New Report</a>
    <a href="DisplayStudents">👥 All Students</a>
    <a href="index.jsp">🏠 Home</a>
  </div>
</div>
</body>
</html>