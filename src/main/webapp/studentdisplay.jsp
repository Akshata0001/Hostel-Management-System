<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.model.Student, java.util.List, java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>All Students – HMS</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    .actions-col { white-space: nowrap; }
    .tbl-actions { display: flex; gap: 6px; }
  </style>
</head>
<body>

<header class="navbar">
  <a href="<%= request.getContextPath() %>/index.jsp" class="brand">
    <span class="icon">🏨</span> Hostel Management System
  </a>
  <nav>
    <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
    <a href="<%= request.getContextPath() %>/displayStudents" class="active">Students</a>
    <a href="<%= request.getContextPath() %>/reports.jsp">Reports</a>
  </nav>
</header>

<div class="page-wrapper">

  <div class="page-header">
    <div class="breadcrumb">
      <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &rsaquo; Students
    </div>
    <h1>📄 Student Records</h1>
    <p>View, search and manage all hostel student enrollments.</p>
  </div>

  <%-- Flash message --%>
  <% String flash = (String) request.getAttribute("flashMessage");
     String flashType = (String) request.getAttribute("flashType");
     if (flash != null && !flash.isEmpty()) { %>
  <div class="alert alert-<%= "error".equals(flashType) ? "error" : "success" %>">
    <%= "error".equals(flashType) ? "⚠️" : "✅" %> <%= flash %>
  </div>
  <% } %>

  <%-- Error --%>
  <% String err = (String) request.getAttribute("errorMessage");
     if (err != null && !err.isEmpty()) { %>
  <div class="alert alert-error">⚠️ <%= err %></div>
  <% } %>

  <%-- Summary stats (only on full list) --%>
  <%
    BigDecimal sumTotal   = (BigDecimal) request.getAttribute("summaryTotal");
    BigDecimal sumPaid    = (BigDecimal) request.getAttribute("summaryPaid");
    BigDecimal sumPending = (BigDecimal) request.getAttribute("summaryPending");
    Boolean searchMode    = (Boolean) request.getAttribute("searchMode");
    if (sumTotal != null) {
  %>
  <div class="stat-grid" style="margin-bottom:24px;">
    <div class="stat-card blue">
      <div class="stat-icon">👨‍🎓</div>
      <div class="stat-info">
        <div class="label">Total Students</div>
        <div class="value"><%= sumTotal.intValue() %></div>
      </div>
    </div>
    <div class="stat-card green">
      <div class="stat-icon">💵</div>
      <div class="stat-info">
        <div class="label">Total Fees Paid</div>
        <div class="value">₹<%= sumPaid %></div>
      </div>
    </div>
    <div class="stat-card orange">
      <div class="stat-icon">⏳</div>
      <div class="stat-info">
        <div class="label">Total Pending</div>
        <div class="value">₹<%= sumPending %></div>
      </div>
    </div>
  </div>
  <% } %>

  <!-- Action buttons + search bar -->
  <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:14px; margin-bottom:18px;">
    <div style="display:flex; gap:10px; flex-wrap:wrap;">
      <a href="<%= request.getContextPath() %>/addStudent" class="btn btn-success btn-sm">➕ Add Student</a>
      <% if (Boolean.TRUE.equals(searchMode)) { %>
      <a href="<%= request.getContextPath() %>/displayStudents" class="btn btn-outline btn-sm">📄 Show All</a>
      <% } %>
    </div>
    <!-- Search by ID -->
    <form action="<%= request.getContextPath() %>/displayStudents" method="get"
          style="display:flex; gap:8px;">
      <input type="number" name="studentId" class="form-control" style="width:180px;"
             placeholder="Search by ID" min="1">
      <button type="submit" class="btn btn-primary btn-sm">🔍 Search</button>
    </form>
  </div>

  <%-- Table --%>
  <%
    @SuppressWarnings("unchecked")
    List<Student> students = (List<Student>) request.getAttribute("students");
    if (students != null && !students.isEmpty()) {
  %>
  <div class="table-wrapper">
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Student ID</th>
          <th>Name</th>
          <th>Room</th>
          <th>Admission Date</th>
          <th>Fees Paid (₹)</th>
          <th>Pending Fees (₹)</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <%
          int row = 1;
          for (Student st : students) {
            boolean hasPending = st.getPendingFees().compareTo(BigDecimal.ZERO) > 0;
        %>
        <tr>
          <td class="text-muted"><%= row++ %></td>
          <td><strong><%= st.getStudentId() %></strong></td>
          <td><%= st.getStudentName() %></td>
          <td><span class="badge badge-warning"><%= st.getRoomNumber() %></span></td>
          <td><%= st.getAdmissionDate() %></td>
          <td>₹<%= st.getFeesPaid() %></td>
          <td>
            <% if (hasPending) { %>
              <span style="color:#c62828; font-weight:600;">₹<%= st.getPendingFees() %></span>
            <% } else { %>
              <span style="color:#2e7d32; font-weight:600;">₹0.00</span>
            <% } %>
          </td>
          <td>
            <% if (hasPending) { %>
              <span class="badge badge-danger">Pending</span>
            <% } else { %>
              <span class="badge badge-success">Cleared</span>
            <% } %>
          </td>
          <td class="actions-col">
            <div class="tbl-actions">
              <a href="<%= request.getContextPath() %>/updateStudent?studentId=<%= st.getStudentId() %>"
                 class="btn btn-warning btn-sm" title="Edit">✏️</a>
              <a href="<%= request.getContextPath() %>/deleteStudent?studentId=<%= st.getStudentId() %>"
                 class="btn btn-danger btn-sm" title="Delete">🗑️</a>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  <p class="text-muted mt-16" style="text-align:right;">
    Showing <%= students.size() %> record(s)
  </p>
  <% } else { %>
  <div class="card no-results">
    <div class="no-icon">🔍</div>
    <p>No student records found.</p>
    <a href="<%= request.getContextPath() %>/addStudent" class="btn btn-success mt-16">➕ Add First Student</a>
  </div>
  <% } %>

</div>

<footer class="footer">&copy; 2026 Hostel Management System</footer>
</body>
</html>
