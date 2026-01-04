-- 创建学生信息表 (使用 user 数据库)
USE user;

-- 创建学生信息表
CREATE TABLE IF NOT EXISTS students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    height DOUBLE NOT NULL,
    weight DOUBLE NOT NULL,
    bmi DOUBLE,
    health_status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入测试数据
INSERT INTO students (name, age, gender, height, weight, bmi, health_status) VALUES
    ('张三', 20, '男', 175.0, 70.0, 22.86, '正常'),
    ('李四', 21, '女', 162.0, 55.0, 20.96, '正常'),
    ('王五', 19, '男', 180.0, 75.0, 23.15, '正常'),
    ('赵六', 22, '女', 158.0, 50.0, 20.03, '偏瘦'),
    ('钱七', 20, '男', 170.0, 85.0, 29.41, '超重');
