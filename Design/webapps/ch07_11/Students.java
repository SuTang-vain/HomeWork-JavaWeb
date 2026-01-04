package com.example;

public class Students {
    private int id;
    private String name;
    private int age;
    private String gender;
    private double height;
    private double weight;
    private double bmi;
    private String health_status;

    public Students() {}

    public Students(int id, String name, int age, String gender, double height, double weight, double bmi, String health_status) {
        this.id = id;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.height = height;
        this.weight = weight;
        this.bmi = bmi;
        this.health_status = health_status;
    }

    public double calculateBMI() {
        double heightInMeters = height / 100.0;
        return weight / (heightInMeters * heightInMeters);
    }

    public String getHealthStatus() {
        double bmiValue = calculateBMI();
        if (bmiValue < 18.5) return "偏瘦";
        else if (bmiValue < 24) return "正常";
        else if (bmiValue < 28) return "超重";
        else return "肥胖";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public double getHeight() { return height; }
    public void setHeight(double height) { this.height = height; }
    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }
    public double getBmi() { return bmi; }
    public void setBmi(double bmi) { this.bmi = bmi; }
    public String getHealth_status() { return health_status; }
    public void setHealth_status(String health_status) { this.health_status = health_status; }
}
