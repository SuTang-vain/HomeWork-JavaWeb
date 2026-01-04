package com.example;
import java.util.List;

public interface IBookDAO {
    boolean addStudent(Students student);
    Students queryStudentById(int id);
    List<Students> queryAllStudents();
    List<Students> queryStudentsByName(String name);
    boolean updateStudent(Students student);
    boolean deleteStudentById(int id);
    boolean deleteStudentByName(String name);
}
