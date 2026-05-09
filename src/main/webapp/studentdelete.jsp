<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Student" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Delete Student | HostelMS</title>
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
  .page-title h1 span { color: #e74c3c; }
  .page-title p { color: rgba(255,255,255,0.6); margin-top: 8px; }

  .container { max-width: 560px; margin: 0 auto; padding: 0 20px 60px; }

  .alert { border-radius: 12px; padding: 14px 18px; margin-bottom: 18px; font-size: 0.95rem; }
  .alert-success { background: rgba(39,174,96,0.2); border: 1px solid #27ae60; color: #2ecc71; }
  .alert-error   { background: rgba(231,76,60,0.2);  border: 1px solid #e74c3c; color: #ff6b6b; }

  .card { background: rgba(255,255,255,0.08); backdrop-filter: blur(15px);
    border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; padding: 30px; margin-bottom: 24px; }
  .card h3 { font-weight: 700; font-size: 1.3rem; margin-bottom: 20px; color: #3498db; }

  .search-row { display: flex; gap: 12px; }
  .search-row input { flex: 1; padding: 11px 15px; background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.25); border-radius: 10px; color: white; font-size: 0.95rem; outline: none; }
  .search-row input::placeholder { color: rgba(255,255,255,0.4); }
  .search-row input:focus { border-color: #3498db; background: rgba(255,255,255,0.15); }
  .btn-search { padding: 11px 24px; background: linear-gradient(45deg,#3498db,#2980b9);
    border: none; border-radius: 10px; color: white; font-weight: 600; cursor: pointer; }
  .btn-search:hover { box-shadow: 0 4px 15px rgba(52,152,219,0.4); }

  /* Warning box */
  .warning-box { background: rgba(231,76,60,0.15); border: 1px solid rgba(231,76,60,0.4);
    border-radius: 12px; padding: 14px; margin-bottom: 20px; color: #ff6b6b;
    text-align: center; font-size: 0.95rem; }

  /* Info rows */
  .info-table { width: 100%; border-collapse: collapse; margin-bottom: 24px; }
  .info-table tr { border-bottom: 1px solid rgba(255,255,255,0.08); }
  .info-table tr:last-child { border-bottom: none; }
  .info-table td { padding: 10px 6px; font-size: 0.95rem; color: rgba(255,255,255,0.85); }
  .info-table td:first-child { font-weight: 600; color: white; width: 45%; }
  .badge { display: inline-block; padding: 3px 12px; border-radius: 20px; font-size: 0.85rem; }
  .badge-green { background: rgba(39,174,96,0.25); color: #2ecc71; border: 1px solid #27ae60; }
  .badge-red   { background: rgba(231,76,60,0.25); color: #ff6b6b; border: 1px solid #e74c3c; }

  .btn-delete { width: 100%; padding: 13px;
    background: linear-gradient(45deg, #e74c3c, #c0392b);
    border: none; border-radius: 10px; color: white;
    font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.3s; }
  .btn-delete:hover { box-shadow: 0 5px 20px rgba(231,76,60,0.5); transform: translateY(-2px); }

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
    <a href="DisplayStudents">👥 Students</a>
    <a href="Report">📊 Reports</a>
  </div>
</nav>

<div class="page-title">
  <h1>🗑️ Delete <span>Student</span></h1>
  <p>Search and permanently remove student records</p>
</div>

<div class="container">

  <% String success = (String)request.getAttribute("success");
     String error   = (String)request.getAttribute("error");
     if (success != null) { %><div class="alert alert-success">✅ <%= success %></div><% }
     if (error   != null) { %><div class="alert alert-error">❌ <%= error %></div><% } %>

  <!-- Search -->
  <div class="card">
    <h3>🔍 Find Student</h3>
    <form action="DeleteStudent" method="get" id="searchForm">
      <div class="search-row">
        <input type="number" name="studentID" id="searchID" placeholder="Enter Student ID" min="1">
        <button type="submit" class="btn-search">Search</button>
      </div>
    </form>
  </div>

  <!-- Student Info + Confirm Delete -->
  <% Student s = (Student)request.getAttribute("student");
     if (s != null) { %>
  <div class="card">
    <div class="warning-box">⚠️ <strong>Warning!</strong> This action cannot be undone. Student will be permanently deleted.</div>
    <h3>👤 Student Details</h3>
    <table class="info-table">
      <tr><td>Student ID</td><td><%= s.getStudentID() %></td></tr>
      <tr><td>Name</td><td><%= s.getStudentName() %></td></tr>
      <tr><td>Room Number</td><td><%= s.getRoomNumber() %></td></tr>
      <tr><td>Admission Date</td><td><%= s.getAdmissionDate() %></td></tr>
      <tr><td>Fees Paid</td><td><span class="badge badge-green">₹<%= s.getFeesPaid() %></span></td></tr>
      <tr><td>Pending Fees</td>
        <td><span class="badge <%= s.getPendingFees() > 0 ? "badge-red" : "badge-green" %>">₹<%= s.getPendingFees() %></span></td>
      </tr>
    </table>
    <form action="DeleteStudent" method="post" onsubmit="return confirmDelete()">
      <input type="hidden" name="studentID" value="<%= s.getStudentID() %>">
      <button type="submit" class="btn-delete">🗑️ Confirm Delete</button>
    </form>
  </div>
  <% } %>

  <div class="back-links">
    <a href="index.jsp">← Home</a>
    <a href="DisplayStudents">👥 All Students</a>
  </div>
</div>

<script>
function confirmDelete() {
  return confirm('Are you sure you want to permanently delete this student?');
}
document.getElementById('searchForm').addEventListener('submit', function(e) {
  const id = document.getElementById('searchID').value;
  if (!id || parseInt(id) <= 0) { e.preventDefault(); alert('Please enter a valid Student ID.'); }
});
</script>
</body>
</html>