package com.model;

import java.math.BigDecimal;
import java.sql.Date;

/**
 * Model class representing a student in the hostel.
 * Maps 1-to-1 with the HostelStudents database table.
 */
public class Student {

    private int        studentId;
    private String     studentName;
    private String     roomNumber;
    private Date       admissionDate;
    private BigDecimal feesPaid;
    private BigDecimal pendingFees;

    // -------------------------------------------------------
    //  Constructors
    // -------------------------------------------------------

    public Student() {}

    public Student(int studentId, String studentName, String roomNumber,
                   Date admissionDate, BigDecimal feesPaid, BigDecimal pendingFees) {
        this.studentId     = studentId;
        this.studentName   = studentName;
        this.roomNumber    = roomNumber;
        this.admissionDate = admissionDate;
        this.feesPaid      = feesPaid;
        this.pendingFees   = pendingFees;
    }

    // -------------------------------------------------------
    //  Getters & Setters
    // -------------------------------------------------------

    public int getStudentId() {
        return studentId;
    }
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getRoomNumber() {
        return roomNumber;
    }
    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public Date getAdmissionDate() {
        return admissionDate;
    }
    public void setAdmissionDate(Date admissionDate) {
        this.admissionDate = admissionDate;
    }

    public BigDecimal getFeesPaid() {
        return feesPaid;
    }
    public void setFeesPaid(BigDecimal feesPaid) {
        this.feesPaid = feesPaid;
    }

    public BigDecimal getPendingFees() {
        return pendingFees;
    }
    public void setPendingFees(BigDecimal pendingFees) {
        this.pendingFees = pendingFees;
    }

    // -------------------------------------------------------
    //  Helper
    // -------------------------------------------------------

    @Override
    public String toString() {
        return "Student{id=" + studentId
             + ", name='" + studentName + '\''
             + ", room='" + roomNumber + '\''
             + ", admitted=" + admissionDate
             + ", paid=" + feesPaid
             + ", pending=" + pendingFees + '}';
    }
}
