<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hostel Management System</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<!-- ===================== NAVBAR ===================== -->
<header class="navbar">
  <a href="<%= request.getContextPath() %>/index.jsp" class="brand">
    <span class="icon">🏨</span> Hostel Management System
  </a>
  <nav>
    <a href="<%= request.getContextPath() %>/index.jsp" class="active">Home</a>
    <a href="<%= request.getContextPath() %>/displayStudents">Students</a>
    <a href="<%= request.getContextPath() %>/reports.jsp">Reports</a>
  </nav>
</header>

<!-- ===================== CONTENT ===================== -->
<div class="page-wrapper">

  <!-- Hero / Welcome -->
  <div class="card" style="background: linear-gradient(135deg,#1a3a5c,#122840); color:#fff; margin-bottom:28px;">
    <div style="display:flex; align-items:center; gap:20px; flex-wrap:wrap;">
      <div style="font-size:4rem;">🏨</div>
      <div>
        <h1 style="font-size:1.8rem; margin-bottom:6px;">Welcome to Hostel Management System</h1>
        <p style="color:rgba(255,255,255,.75); font-size:1rem;">
          Manage student admissions, room allocations, fee tracking and generate comprehensive reports — all in one place.
        </p>
      </div>
    </div>
  </div>

  <!-- Quick Stats -->
  <div class="stat-grid">
    <div class="stat-card blue">
      <div class="stat-icon">👨‍🎓</div>
      <div class="stat-info">
        <div class="label">Total Students</div>
        <div class="value">—</div>
      </div>
    </div>
    <div class="stat-card green">
      <div class="stat-icon">✅</div>
      <div class="stat-info">
        <div class="label">Full Fee Paid</div>
        <div class="value">—</div>
      </div>
    </div>
    <div class="stat-card orange">
      <div class="stat-icon">⚠️</div>
      <div class="stat-info">
        <div class="label">Pending Fees</div>
        <div class="value">—</div>
      </div>
    </div>
    <div class="stat-card" style="border-color:#7b1fa2;">
      <div class="stat-icon">🚪</div>
      <div class="stat-info">
        <div class="label">Rooms Occupied</div>
        <div class="value">—</div>
      </div>
    </div>
  </div>
  <p class="text-muted mt-16" style="text-align:right; margin-bottom:16px;">
    * Live stats available on the <a href="<%= request.getContextPath() %>/displayStudents" style="color:#2196f3;">Students page</a>
  </p>

  <!-- ---- Student Management Section ---- -->
  <div class="page-header">
    <h1>📋 Student Management</h1>
    <p>Perform full CRUD operations on hostel student records.</p>
  </div>

  <div class="action-grid" style="margin-bottom:36px;">
    <a href="<%= request.getContextPath() %>/addStudent" class="action-card green">
      <span class="action-icon">➕</span>
      <span class="action-title">Add New Student</span>
      <span class="action-desc">Admit a new student and allocate a room with fee details.</span>
    </a>
    <a href="<%= request.getContextPath() %>/displayStudents" class="action-card">
      <span class="action-icon">📄</span>
      <span class="action-title">View All Students</span>
      <span class="action-desc">Browse and search all enrolled students with full details.</span>
    </a>
    <a href="<%= request.getContextPath() %>/updateStudent" class="action-card orange">
      <span class="action-icon">✏️</span>
      <span class="action-title">Update Student</span>
      <span class="action-desc">Modify room, fee, or personal information for any student.</span>
    </a>
    <a href="<%= request.getContextPath() %>/deleteStudent" class="action-card red">
      <span class="action-icon">🗑️</span>
      <span class="action-title">Delete Student</span>
      <span class="action-desc">Remove a student record with confirmation prompt.</span>
    </a>
  </div>

  <!-- ---- Reports Section ---- -->
  <div class="page-header">
    <h1>📊 Reports &amp; Analytics</h1>
    <p>Generate targeted reports for administrative decisions.</p>
  </div>

  <div class="action-grid">
    <a href="<%= request.getContextPath() %>/report?reportType=pending" class="action-card red">
      <span class="action-icon">💰</span>
      <span class="action-title">Pending Fees Report</span>
      <span class="action-desc">View all students who have outstanding fee balances.</span>
    </a>
    <a href="<%= request.getContextPath() %>/reportCriteria" class="action-card purple">
      <span class="action-icon">🔍</span>
      <span class="action-title">Custom Reports</span>
      <span class="action-desc">Filter students by room number or admission date range.</span>
    </a>
    <a href="<%= request.getContextPath() %>/reports.jsp" class="action-card green">
      <span class="action-icon">📈</span>
      <span class="action-title">All Reports</span>
      <span class="action-desc">Access the full reports dashboard with all available filters.</span>
    </a>
  </div>

</div>

<!-- ===================== FOOTER ===================== -->
<footer class="footer">
  &copy; 2026 Hostel Management System &mdash; Built with Java EE (JSP / Servlets / JDBC / MySQL)
</footer>

</body>
</html>
