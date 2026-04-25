<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.model.Student" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Delete Student – HMS</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<header class="navbar">
  <a href="<%= request.getContextPath() %>/index.jsp" class="brand">
    <span class="icon">🏨</span> Hostel Management System
  </a>
  <nav>
    <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
    <a href="<%= request.getContextPath() %>/displayStudents">Students</a>
    <a href="<%= request.getContextPath() %>/reports.jsp">Reports</a>
  </nav>
</header>

<div class="page-wrapper">

  <div class="page-header">
    <div class="breadcrumb">
      <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &rsaquo;
      <a href="<%= request.getContextPath() %>/displayStudents">Students</a> &rsaquo;
      Delete Student
    </div>
    <h1>🗑️ Delete Student</h1>
    <p>Search for a student by ID and confirm deletion.</p>
  </div>

  <%-- Messages --%>
  <% String err = (String) request.getAttribute("errorMessage");
     if (err != null && !err.isEmpty()) { %>
  <div class="alert alert-error">⚠️ <%= err %></div>
  <% } %>

  <!-- Search -->
  <div class="card">
    <div class="card-title">🔍 Find Student to Delete</div>
    <form action="<%= request.getContextPath() %>/deleteStudent" method="get"
          style="display:flex; gap:10px; flex-wrap:wrap;">
      <input type="number" name="studentId" class="form-control" style="max-width:260px;"
             placeholder="Enter Student ID" min="1" required>
      <button type="submit" class="btn btn-primary">🔍 Search</button>
      <a href="<%= request.getContextPath() %>/displayStudents" class="btn btn-secondary">View All</a>
    </form>
  </div>

  <%-- Confirmation section --%>
  <%
    Student s = (Student) request.getAttribute("student");
    if (s != null) {
  %>
  <div class="confirm-box">
    <h3>⚠️ Confirm Deletion</h3>
    <p>You are about to permanently delete the following student record. This action cannot be undone.</p>
  </div>

  <div class="card">
    <div class="card-title" style="color:#c62828;">🗑️ Student to be Deleted</div>

    <table style="margin-bottom:24px;">
      <thead>
        <tr>
          <th>Student ID</th><th>Name</th><th>Room</th>
          <th>Admission Date</th><th>Fees Paid</th><th>Pending Fees</th>
        </tr>
      </thead>
      <tbody>
        <tr style="background:#fff8f8;">
          <td><strong><%= s.getStudentId() %></strong></td>
          <td><%= s.getStudentName() %></td>
          <td><span class="badge badge-warning"><%= s.getRoomNumber() %></span></td>
          <td><%= s.getAdmissionDate() %></td>
          <td>₹<%= s.getFeesPaid() %></td>
          <td>
            <% if (s.getPendingFees().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
              <span class="badge badge-danger">₹<%= s.getPendingFees() %></span>
            <% } else { %>
              <span class="badge badge-success">₹0.00</span>
            <% } %>
          </td>
        </tr>
      </tbody>
    </table>

    <form action="<%= request.getContextPath() %>/deleteStudent" method="post"
          onsubmit="return confirm('Are you absolutely sure you want to delete student <%= s.getStudentId() %>?');">
      <input type="hidden" name="studentId" value="<%= s.getStudentId() %>">
      <div class="form-actions">
        <button type="submit" class="btn btn-danger">🗑️ Yes, Delete Permanently</button>
        <a href="<%= request.getContextPath() %>/displayStudents" class="btn btn-secondary">Cancel</a>
      </div>
    </form>
  </div>
  <% } %>

</div>

<footer class="footer">&copy; 2026 Hostel Management System</footer>
</body>
</html>
