<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Hostel Management System</title>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
    min-height: 100vh; font-family: 'Segoe UI', sans-serif; }

  /* NAVBAR */
  nav { background: rgba(255,255,255,0.05); backdrop-filter: blur(10px);
    border-bottom: 1px solid rgba(255,255,255,0.1); padding: 15px 40px;
    display: flex; justify-content: space-between; align-items: center; }
  .brand { font-size: 1.5rem; font-weight: 700; color: #e94560; text-decoration: none; }
  .nav-links { display: flex; gap: 12px; }
  .nav-links a { color: rgba(255,255,255,0.7); text-decoration: none; padding: 7px 16px;
    border: 1px solid rgba(255,255,255,0.2); border-radius: 20px; font-size: 0.9rem;
    transition: all 0.3s; }
  .nav-links a:hover { color: white; border-color: #e94560; background: rgba(233,69,96,0.15); }

  /* HERO */
  .hero { text-align: center; padding: 80px 20px 50px; color: white; }
  .hero h1 { font-size: 3rem; font-weight: 800; margin-bottom: 15px; }
  .hero h1 span { color: #e94560; }
  .hero p { font-size: 1.2rem; color: rgba(255,255,255,0.7); margin-bottom: 30px; }
  .btn-glow { background: linear-gradient(45deg, #e94560, #c0392b); border: none;
    color: white; border-radius: 50px; padding: 12px 35px; font-weight: 600;
    font-size: 1rem; cursor: pointer; text-decoration: none; display: inline-block;
    transition: all 0.3s; }
  .btn-glow:hover { box-shadow: 0 0 25px rgba(233,69,96,0.6); transform: scale(1.05); }

  /* CARDS GRID */
  .cards-section { max-width: 1000px; margin: 0 auto; padding: 0 20px 60px; }
  .cards-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
  @media(max-width:768px) { .cards-grid { grid-template-columns: repeat(2,1fr); } .hero h1 { font-size:2rem; } }
  @media(max-width:480px) { .cards-grid { grid-template-columns: 1fr; } }

  .module-card { background: rgba(255,255,255,0.07); backdrop-filter: blur(10px);
    border: 1px solid rgba(255,255,255,0.1); border-radius: 20px; padding: 30px 20px;
    text-align: center; text-decoration: none; color: white;
    transition: all 0.3s; display: block; }
  .module-card:hover { transform: translateY(-10px); border-color: #e94560;
    background: rgba(233,69,96,0.2); box-shadow: 0 20px 40px rgba(233,69,96,0.3); }
  .module-card .icon { font-size: 3rem; margin-bottom: 15px; display: block; }
  .module-card h4 { font-size: 1.1rem; font-weight: 700; margin-bottom: 10px; }
  .module-card p { color: rgba(255,255,255,0.6); font-size: 0.88rem; line-height: 1.5; }

  /* STATS BAR */
  .stats-bar { background: rgba(255,255,255,0.05);
    border-top: 1px solid rgba(255,255,255,0.1); padding: 25px 20px; }
  .stats-inner { display: flex; justify-content: center; gap: 80px; max-width: 600px; margin: 0 auto; }
  .stat-item { text-align: center; color: white; }
  .stat-item h3 { color: #e94560; font-size: 2rem; font-weight: 800; }
  .stat-item p { color: rgba(255,255,255,0.6); font-size: 0.85rem; margin-top: 5px; }

  footer { color: rgba(255,255,255,0.4); text-align: center; padding: 20px;
    font-size: 0.85rem; }
</style>
</head>
<body>

<nav>
  <a class="brand" href="index.jsp">🏨 Alva's Hostel</a>
  <div class="nav-links">
    <a href="DisplayStudents">All Students</a>
    <a href="Report">Reports</a>
  </div>
</nav>

<div class="hero">
  <h1>Hostel <span>Management</span> System</h1>
  <p>Efficiently manage student admissions, room allocations, and fee records</p>
  <a href="DisplayStudents" class="btn-glow">View All Students</a>
</div>

<div class="cards-section">
  <div class="cards-grid">
    <a href="AddStudent" class="module-card">
      <span class="icon">➕</span>
      <h4>Add Student</h4>
      <p>Register new hostel students with full details and room allocation</p>
    </a>
    <a href="UpdateStudent" class="module-card">
      <span class="icon">✏️</span>
      <h4>Update Student</h4>
      <p>Modify existing student details, room changes, and fee records</p>
    </a>
    <a href="DeleteStudent" class="module-card">
      <span class="icon">🗑️</span>
      <h4>Delete Student</h4>
      <p>Remove student records from the hostel management system</p>
    </a>
    <a href="DisplayStudents" class="module-card">
      <span class="icon">👥</span>
      <h4>View Students</h4>
      <p>Display all students or search by individual student ID</p>
    </a>
    <a href="Report" class="module-card">
      <span class="icon">📊</span>
      <h4>Reports</h4>
      <p>Generate pending fees, room-wise, and date-range admission reports</p>
    </a>
  </div>
</div>

<div class="stats-bar">
  <div class="stats-inner">
    <div class="stat-item"><h3>🔒</h3><p>Secure JDBC</p></div>
    <div class="stat-item"><h3>🧩</h3><p>MVC Pattern</p></div>
    <div class="stat-item"><h3>✅</h3><p>Full Validation</p></div>
  </div>
</div>

<footer>© 2025 Hostel Management System | AIET, Mijar | Dynamic Web Project</footer>
</body>
</html>