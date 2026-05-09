<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Student, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>View Students | HostelMS</title>
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
  .page-title h1 span { color: #00cec9; }
  .page-title p { color: rgba(255,255,255,0.6); margin-top: 8px; }

  .container { max-width: 1100px; margin: 0 auto; padding: 0 20px 60px; }

  .alert-error { background: rgba(231,76,60,0.2); border: 1px solid #e74c3c; color: #ff6b6b;
    border-radius: 12px; padding: 14px 18px; margin-bottom: 18px; }

  /* Search bar */
  .search-card { background: rgba(255,255,255,0.08); backdrop-filter: blur(15px);
    border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; padding: 24px; margin-bottom: 24px; }
  .search-row { display: flex; gap: 12px; align-items: flex-end; }
  .search-row .field { flex: 1; }
  .search-row label { display: block; color: rgba(255,255,255,0.8); font-size: 0.88rem;
    font-weight: 500; margin-bottom: 7px; }
  .search-row input { width: 100%; padding: 11px 15px; background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.25); border-radius: 10px; color: white; font-size: 0.95rem; outline: none; }
  .search-row input::placeholder { color: rgba(255,255,255,0.4); }
  .search-row input:focus { border-color: #00cec9; background: rgba(255,255,255,0.15); }
  .btn-search { padding: 11px 24px; background: linear-gradient(45deg,#00cec9,#0984e3);
    border: none; border-radius: 10px; color: white; font-weight: 600; cursor: pointer; white-space: nowrap; }
  .btn-all { padding: 11px 20px; background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.25);
    border-radius: 10px; color: white; text-decoration: none; font-size: 0.9rem; white-space: nowrap; }
  .btn-all:hover { background: rgba(255,255,255,0.18); }

  /* Single student profile */
  .profile-card { background: rgba(255,255,255,0.08); backdrop-filter: blur(15px);
    border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; padding: 30px; margin-bottom: 24px; }
  .profile-card h3 { color: #00cec9; font-weight: 700; margin-bottom: 20px; }
  .info-table { width: 100%; border-collapse: collapse; }
  .info-table tr { border-bottom: 1px solid rgba(255,255,255,0.08); }
  .info-table tr:last-child { border-bottom: none; }
  .info-table td { padding: 11px 8px; color: rgba(255,255,255,0.85); font-size: 0.95rem; }
  .info-table td:first-child { font-weight: 600; color: white; width: 35%; }
  .profile-actions { display: flex; gap: 10px; margin-top: 20px; }
  .btn-edit   { padding: 8px 20px; background: linear-gradient(45deg,#f39c12,#e67e22); border: none;
    border-radius: 8px; color: white; font-weight: 600; cursor: pointer; text-decoration: none; font-size: 0.88rem; }
  .btn-del    { padding: 8px 20px; background: linear-gradient(45deg,#e74c3c,#c0392b); border: none;
    border-radius: 8px; color: white; font-weight: 600; cursor: pointer; text-decoration: none; font-size: 0.88rem; }

  /* Table */
  .table-card { background: rgba(255,255,255,0.08); backdrop-filter: blur(15px);
    border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; padding: 30px; }
  .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
  .table-header h3 { color: #00cec9; font-weight: 700; }
  .count-badge { background: rgba(233,69,96,0.25); color: #e94560; border: 1px solid rgba(233,69,96,0.4);
    padding: 6px 16px; border-radius: 20px; font-size: 0.88rem; font-weight: 600; }
  .table-wrap { overflow-x: auto; }
  table.data-table { width: 100%; border-collapse: collapse; }
  table.data-table thead tr { background: rgba(233,69,96,0.25); }
  table.data-table th { padding: 13px 14px; text-align: left; color: white; font-weight: 600; font-size: 0.9rem; }
  table.data-table tbody tr { border-bottom: 1px solid rgba(255,255,255,0.07); transition: background 0.2s; }
  table.data-table tbody tr:hover { background: rgba(255,255,255,0.05); }
  table.data-table td { padding: 12px 14px; color: rgba(255,255,255,0.85); font-size: 0.9rem; vertical-align: middle; }
  .room-tag { background: rgba(116,185,255,0.2); color: #74b9ff; padding: 3px 10px; border-radius: 10px; font-size: 0.85rem; }
  .badge { display: inline-block; padding: 3px 12px; border-radius: 20px; font-size: 0.82rem; }
  .badge-green { background: rgba(39,174,96,0.25); color: #2ecc71; border: 1px solid #27ae60; }
  .badge-red   { background: rgba(231,76,60,0.25);  color: #ff6b6b; border: 1px solid #e74c3c; }
  .total-row td { background: rgba(233,69,96,0.12); font-weight: 700; color: white; }
  .action-btn { padding: 5px 12px; border: none; border-radius: 7px; cursor: pointer;
    font-size: 0.82rem; font-weight: 600; text-decoration: none; display: inline-block; }
  .action-edit { background: rgba(243,156,18,0.3); color: #f39c12; border: 1px solid rgba(243,156,18,0.4); }
  .action-del  { background: rgba(231,76,60,0.3);  color: #ff6b6b; border: 1px solid rgba(231,76,60,0.4); margin-left: 5px; }
  .action-edit:hover { background: rgba(243,156,18,0.5); }
  .action-del:hover  { background: rgba(231,76,60,0.5); }
  .empty-msg { text-align: center; padding: 50px 20px; color: rgba(255,255,255,0.4); }
  .empty-msg span { font-size: 3rem; display: block; margin-bottom: 12px; }

  .back-links { text-align: center; margin-top: 20px; display: flex; gap: 12px; justify-content: center; }
  .back-links a { color: rgba(255,255,255,0.7); text-decoration: none; padding: 8px 20px;
    border: 1px solid rgba(255,255,255,0.25); border-radius: 20px; font-size: 0.88rem; transition: all 0.3s; }
  .back-links a:hover { color: white; background: rgba(255,255,255,0.1); }
</style>
</head>
<body>

<nav>
  <a class="brand" href="index.jsp">🏨 HostelMS</a>
  <div class="nav-links">
    <a href="index.jsp">🏠 Home</a>
    <a href="AddStudent">➕ Add</a>
    <a href="Report">📊 Reports</a>
  </div>
</nav>

<div class="page-title">
  <h1>👥 Student <span>Records</span></h1>
  <p>View all or search individual student details</p>
</div>

<div class="container">

  <!-- Search Bar -->
  <div class="search-card">
    <form action="DisplayStudents" method="get">
      <div class="search-row">
        <div class="field">
          <label>Search by Student ID (leave blank to show all)</label>
          <input type="number" name="studentID" placeholder="Enter Student ID...">
        </div>
        <button type="submit" class="btn-search">🔍 Search</button>
        <a href="DisplayStudents" class="btn-all">Show All</a>
      </div>
    </form>
  </div>

  <% String error = (String)request.getAttribute("error");
     if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>

  <!-- Single Student Profile -->
  <% Student single = (Student)request.getAttribute("singleStudent");
     if (single != null) { %>
  <div class="profile-card">
    <h3>🪪 Student Profile</h3>
    <table class="info-table">
      <tr><td>🔢 Student ID</td><td><strong><%= single.getStudentID() %></strong></td></tr>
      <tr><td>👤 Name</td><td><%= single.getStudentName() %></td></tr>
      <tr><td>🚪 Room</td><td><%= single.getRoomNumber() %></td></tr>
      <tr><td>📅 Admission Date</td><td><%= single.getAdmissionDate() %></td></tr>
      <tr><td>💰 Fees Paid</td><td><span class="badge badge-green">₹<%= single.getFeesPaid() %></span></td></tr>
      <tr><td>⏳ Pending Fees</td>
        <td><span class="badge <%= single.getPendingFees() > 0 ? "badge-red" : "badge-green" %>">₹<%= single.getPendingFees() %></span></td>
      </tr>
    </table>
    <div class="profile-actions">
      <a href="UpdateStudent?studentID=<%= single.getStudentID() %>" class="btn-edit">✏️ Edit</a>
      <a href="DeleteStudent?studentID=<%= single.getStudentID() %>" class="btn-del">🗑️ Delete</a>
    </div>
  </div>
  <% } %>

  <!-- All Students Table -->
  <% List<Student> list = (List<Student>)request.getAttribute("studentList");
     if (list != null) {
       double totalPaid = 0, totalPending = 0;
       for (Student st : list) { totalPaid += st.getFeesPaid(); totalPending += st.getPendingFees(); }
  %>
  <div class="table-card">
    <div class="table-header">
      <h3>📋 All Students</h3>
      <span class="count-badge">Total: <%= list.size() %> students</span>
    </div>
    <% if (list.isEmpty()) { %>
      <div class="empty-msg"><span>📭</span>No students found.</div>
    <% } else { %>
    <div class="table-wrap">
      <table class="data-table">
        <thead>
          <tr>
            <th>ID</th><th>Name</th><th>Room</th><th>Admission Date</th>
            <th>Fees Paid (₹)</th><th>Pending (₹)</th><th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% for (Student st : list) { %>
          <tr>
            <td><strong><%= st.getStudentID() %></strong></td>
            <td><%= st.getStudentName() %></td>
            <td><span class="room-tag"><%= st.getRoomNumber() %></span></td>
            <td><%= st.getAdmissionDate() %></td>
            <td><span class="badge badge-green">₹<%= st.getFeesPaid() %></span></td>
            <td><span class="badge <%= st.getPendingFees() > 0 ? "badge-red" : "badge-green" %>">₹<%= st.getPendingFees() %></span></td>
            <td>
              <a href="UpdateStudent?studentID=<%= st.getStudentID() %>" class="action-btn action-edit">✏️ Edit</a>
              <a href="DeleteStudent?studentID=<%= st.getStudentID() %>" class="action-btn action-del">🗑️ Del</a>
            </td>
          </tr>
          <% } %>
          <tr class="total-row">
            <td colspan="4" style="text-align:right; color:#e94560; padding-right:16px;">TOTALS</td>
            <td><span class="badge badge-green"><strong>₹<%= totalPaid %></strong></span></td>
            <td><span class="badge badge-red"><strong>₹<%= totalPending %></strong></span></td>
            <td></td>
          </tr>
        </tbody>
      </table>
    </div>
    <% } %>
  </div>
  <% } %>

  <div class="back-links">
    <a href="index.jsp">← Home</a>
    <a href="AddStudent">➕ Add Student</a>
  </div>
</div>
</body>
</html>