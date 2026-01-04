import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class InsertRecord {
    public static void main(String[] args) {
        // 1. 数据库连接信息
        String url = "jdbc:mysql://localhost:3306/testdb?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
        String user = "root";
        String password = "123456";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // 2. 建立连接
            conn = DriverManager.getConnection(url, user, password);

            // 3. SQL 语句（带 ? 占位符）
            String sql = "INSERT INTO person (id, name, gender, age, weight, height) VALUES (?, ?, ?, ?, ?, ?)";

            // 4. 创建 PreparedStatement
            ps = conn.prepareStatement(sql);

            // 5. 设置参数
            ps.setInt(1, 16);
            ps.setString(2, "张三");
            ps.setString(3, "男");
            ps.setInt(4, 20);
            ps.setDouble(5, 70.0);
            ps.setInt(6, 175);

            // 6. 执行
            int result = ps.executeUpdate();

            // 7. 判断结果
            if (result > 0) {
                System.out.println("插入成功");
            } else {
                System.out.println("插入失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 8. 关闭资源（顺序：小的先关）
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
