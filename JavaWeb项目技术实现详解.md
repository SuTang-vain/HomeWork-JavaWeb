# JavaWeb项目技术实现详解

本文档详细解释`webapps`目录下5个项目的技术实现区别，从简单到复杂逐步演进。

---

## 目录

- [项目总体对比](#项目总体对比)
- [ch07_3 - JSP脚本模式](#ch07_3---jsp脚本模式)
- [ch07_5 - JavaBean模式](#ch07_5---javabean模式)
- [ch07_7 - Servlet模式](#ch07_7---servlet模式)
- [ch07_9 - 分层模式](#ch07_9---分层模式)
- [ch07_11 - MVC+DAO完整模式](#ch07_11---mvcdao完整模式)

---

## 项目总体对比

| 项目 | 架构模式 | 业务逻辑位置 | 数据访问层 | 页面导航方式 | 功能 |
|------|----------|--------------|------------|--------------|------|
| **ch07_3** | JSP脚本模式 | JSP内联Java代码 | JSP直接操作JDBC | `out.println()`直接输出 | 登录验证 |
| **ch07_5** | JavaBean模式 | UserBean类 | UserBean封装JDBC | `out.println()`输出 | 登录验证 |
| **ch07_7** | Servlet模式 | Servlet控制器 | Servlet操作JDBC | RequestDispatcher转发 | 登录验证 |
| **ch07_9** | 分层模式 | Servlet+ConnectDbase | 分离数据库操作层 | RequestDispatcher转发 | 登录验证 |
| **ch07_11** | MVC+DAO模式 | Servlet+JSP+DAO | DAO层+DBUtil工具类 | 完整CRUD流程 | 学生信息管理 |

### 架构演进图

```
ch07_3:  JSP内嵌Java代码
    ↓ 抽取业务逻辑
ch07_5:  JavaBean封装
    ↓ 引入Servlet控制器
ch07_7:  Servlet + JSP
    ↓ 分离数据访问层
ch07_9:  Servlet + Service + DAO
    ↓ 完整分层架构
ch07_11: MVC + DAO + 工具类
```

---

## ch07_3 - JSP脚本模式

### 项目文件

```
ch07_3/
├── ch07_3_tijiao.jsp    # 登录表单页面
└── ch07_3_yanzheng.jsp  # 处理逻辑页面
```

### 登录表单 (ch07_3_tijiao.jsp)

```jsp
<%@ page
    language="java"                           # 声明使用Java语言
    contentType="text/html; charset=UTF-8"    # 设置响应MIME类型和字符编码
    pageEncoding="UTF-8"%>                    # 设置JSP源文件编码
<form
    action="ch07_3_yanzheng.jsp"              # 表单提交目标地址（相对路径）
    method="post">                            # 提交方法：POST（不会在URL显示参数）
    用户名: <input type="text" name="username"><br>     # 文本输入框，name是参数名
    密码: <input type="password" name="userpassword"><br> # 密码输入框（显示为*号）
    <input type="submit" value="登录">        # 提交按钮
</form>
```

**表单元素说明：**

| 元素 | 属性 | 说明 |
|------|------|------|
| `<input type="text">` | name="username" | 单行文本输入，name值用于服务端获取参数 |
| `<input type="password">` | name="userpassword" | 密码输入，输入内容显示为掩码 |
| `<input type="submit">` | value="登录" | 提交按钮，点击后表单数据发送到action指定地址 |
| `<br>` | - | HTML换行标签 |

---

### 处理逻辑详解 (ch07_3_yanzheng.jsp)

```jsp
<%@ page
    language="java"                           # 指定JSP使用的脚本语言
    contentType="text/html; charset=UTF-8"    # 指定响应内容为HTML，字符编码UTF-8
    pageEncoding="UTF-8"%>                    # 指定JSP文件本身的字符编码

<%@ page import="java.sql.*" %>              # 导入java.sql包下的所有类
                                             # 包括：Connection、PreparedStatement、ResultSet等

<%-- JSP脚本片段：这里的代码会在服务端执行 --%>
<%
    // 设置请求对象的字符编码为UTF-8
    // 重要：必须在调用getParameter()之前设置，否则中文会乱码
    // request是JSP内置对象，代表HttpServletRequest
    request.setCharacterEncoding("UTF-8");

    // 从请求中获取表单提交的参数
    // getParameter(name) 返回String类型
    // 如果参数不存在，返回null
    String username = request.getParameter("username");
    String userpassword = request.getParameter("userpassword");

    // ==================== 数据库连接配置 ====================
    // JDBC驱动类名：MySQL 8.0+使用的驱动类
    // 旧版驱动是 com.mysql.jdbc.Driver
    String driver = "com.mysql.cj.jdbc.Driver";

    // 数据库连接URL：指定数据库位置和参数
    // 格式：jdbc:数据库类型://主机名:端口号/数据库名?参数1&参数2&...
    // mysql-db:3306 - Docker容器名作为主机名，3306是MySQL默认端口
    // user - 数据库名
    // useSSL=false - 禁用SSL连接（开发环境）
    // serverTimezone=UTC - 设置时区为UTC（MySQL 8.0+必需）
    // allowPublicKeyRetrieval=true - 允许公钥获取（解决连接问题）
    // useUnicode=true&characterEncoding=utf8 - 使用Unicode并指定编码
    String url = "jdbc:mysql://mysql-db:3306/user?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8";

    // 数据库用户名和密码
    // 注意：生产环境中不应硬编码密码，应使用配置文件或环境变量
    String dbUser = "root";
    String dbPassword = "root_password";

    // ==================== 声明JDBC对象 ====================
    // 声明在try块外部，以便在finally中关闭
    // 初始化为null，便于判断是否需要关闭

    // Connection：数据库连接对象，代表与数据库的一次会话
    // 通过DriverManager获取，用于执行SQL语句
    Connection conn = null;

    // PreparedStatement：预编译语句对象
    // 用于执行参数化SQL查询，比Statement更安全（防止SQL注入）
    PreparedStatement pstmt = null;

    // ResultSet：结果集对象
    // 封装查询返回的数据，类似数据库游标
    ResultSet rs = null;

    // ==================== 异常处理 ====================
    // try-catch-finally结构确保资源一定被释放
    try {
        // 加载JDBC驱动
        // Class.forName()会加载指定类并执行静态初始化块
        // 在JDBC 4.0+（Java 6+）之后，通常不需要显式调用
        // 但显式调用可确保驱动已加载
        Class.forName(driver);

        // 获取数据库连接
        // DriverManager.getConnection()根据URL、用户名、密码创建连接
        // 如果连接失败（如密码错误），会抛出SQLException
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        // 定义SQL语句
        // 使用参数化查询，?是占位符
        // SELECT * FROM user_b 表示查询user_b表的所有列
        // WHERE子句指定查询条件：用户名和密码都匹配
        String sql = "SELECT * FROM user_b WHERE username = ? AND userpassword = ?";

        // 创建预编译语句
        // conn.prepareStatement(sql)将SQL发送到数据库进行预编译
        // 数据库会解析SQL语法，优化执行计划
        // 返回PreparedStatement对象，后续可重复使用
        pstmt = conn.prepareStatement(sql);

        // 设置参数（参数索引从1开始）
        // setString(index, value)将?替换为指定字符串
        // JDBC会自动进行类型转换和转义，防止SQL注入攻击
        // 例如：如果username包含单引号，会自动转义
        pstmt.setString(1, username);      // 设置第1个?为username
        pstmt.setString(2, userpassword);  // 设置第2个?为userpassword

        // 执行查询
        // executeQuery()用于执行SELECT语句，返回ResultSet
        // 对于INSERT/UPDATE/DELETE，使用executeUpdate()
        rs = pstmt.executeQuery();

        // 处理结果集
        // rs.next()将游标移动到下一行
        // 初始位置在第一行之前，第一次调用移动到第一行
        // 如果有数据返回true，没有数据返回false
        if (rs.next()) {
            // 登录成功：找到匹配的用户
            // out是JSP内置对象，代表PrintWriter
            // 用于向响应输出内容
            out.println("登录成功");
        } else {
            // 登录失败：没有找到匹配的用户
            out.println("登录失败");
        }

    } catch (Exception e) {
        // 捕获所有异常（Exception是所有异常的父类）
        // 实际开发中应分别捕获不同类型的异常
        // e.printStackTrace()输出异常堆栈到服务器日志
        // 这里使用out.println()向页面输出错误信息
        out.println("错误: " + e.getMessage());  // e.getMessage()获取异常简要信息

    } finally {
        // finally块无论是否发生异常都会执行
        // 用于确保资源被正确释放
        try {
            // 关闭ResultSet
            // 如果rs为null（从未创建），调用close()不会报错
            if (rs != null) rs.close();

            // 关闭PreparedStatement
            // 释放数据库相关的语句资源
            if (pstmt != null) pstmt.close();

            // 关闭Connection
            // 最重要的一步：释放数据库连接
            // 如果不关闭，连接会一直占用，可能导致连接池耗尽
            if (conn != null) conn.close();

        } catch (SQLException e) {
            // 关闭资源时可能发生的异常
            // 这里选择静默处理，实际开发中应记录日志
        }
    }
%>
<br><a href="ch07_3_tijiao.jsp">返回</a>     # HTML链接，返回登录页面
```

---

### 代码逐段详细解析

#### 1. JSP指令元素详解

```jsp
<%@ page
    language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*"
%>
```

| 指令属性 | 说明 | 可选值 |
|----------|------|--------|
| `language` | 声明使用的脚本语言 | java（默认）、C#等 |
| `contentType` | 设置响应MIME类型和字符集 | text/html、text/xml等 |
| `pageEncoding` | JSP源文件保存时的字符编码 | UTF-8、GBK等 |
| `import` | 导入Java包或类，多个用逗号分隔 | java.sql.*、java.util.*等 |

**page指令的其他常用属性：**

| 属性 | 说明 |
|------|------|
| `session` | 是否创建session，默认true |
| `isErrorPage` | 是否是错误处理页面，默认false |
| `errorPage` | 指定错误处理页面的URL |
| `isELIgnored` | 是否忽略EL表达式，默认false |

---

#### 2. JSP内置对象说明

JSP在翻译为Servlet时，会自动声明并初始化以下9个内置对象：

| 对象名 | 类型 | 作用域 | 说明 |
|--------|------|--------|------|
| `request` | HttpServletRequest | request | 客户端请求信息 |
| `response` | HttpServletResponse | page | 响应信息 |
| `out` | JspWriter | page | 输出流 |
| `session` | HttpSession | session | 会话信息 |
| `application` | ServletContext | application | 应用上下文 |
| `config` | ServletConfig | page | Servlet配置 |
| `pageContext` | PageContext | page | 页面上下文 |
| `page` | Object | page | 当前Servlet实例 |
| `exception` | Throwable | page | 异常（仅errorPage） |

**request对象常用方法：**

```java
// 获取请求参数
String getParameter(String name)           // 获取单个参数
String[] getParameterValues(String name)   // 获取同名多个参数
Enumeration getParameterNames()            // 获取所有参数名

// 获取请求头
String getHeader(String name)              // 获取单个请求头
Enumeration getHeaders(String name)        // 获取同名多个请求头
String getContentType()                    // 获取Content-Type

// 获取请求方式、URL等
String getMethod()                         // GET、POST等
String getRequestURL()                     // 完整请求URL
String getContextPath()                    // 应用上下文路径

// 存储和获取属性（用于Servlet间传值）
void setAttribute(String key, Object value)
Object getAttribute(String key)
void removeAttribute(String key)
```

**out对象常用方法：**

```java
// 输出各种类型数据
void print(Object obj)     // 输出不换行
void println(Object obj)   // 输出后换行
void clear()               // 清空缓冲区
void flush()               // 刷新缓冲区
```

---

#### 3. JDBC核心API详解

**JDBC操作数据库的基本步骤：**

```
1. 加载驱动 → 2. 获取连接 → 3. 创建语句 → 4. 执行SQL → 5. 处理结果 → 6. 释放资源
```

**Connection接口常用方法：**

```java
// 创建语句对象
Statement createStatement()                           // 创建普通语句
PreparedStatement prepareStatement(String sql)        // 创建预编译语句
CallableStatement prepareCall(String sql)             // 创建存储过程调用

// 设置事务
void setAutoCommit(boolean autoCommit)                // 自动提交开关
void commit()                                         // 提交事务
void rollback()                                       // 回滚事务

// 关闭连接
void close()
```

**PreparedStatement接口常用方法：**

```java
// 设置参数（索引从1开始）
void setString(int index, String value)
void setInt(int index, int value)
void setDouble(int index, double value)
void setObject(int index, Object value)
void setNull(int index, int sqlType)                 // 设置NULL值

// 执行SQL
ResultSet executeQuery()      // 执行SELECT，返回ResultSet
int executeUpdate()           // 执行INSERT/UPDATE/DELETE，返回影响行数
boolean execute()             // 执行任意SQL，返回是否有结果集

// 批量操作
void addBatch()               // 将当前语句加入批处理
int[] executeBatch()          // 执行所有批处理语句
void clearBatch()             // 清空批处理
```

**ResultSet接口常用方法：**

```java
// 移动游标
boolean next()        // 移动到下一行，返回是否有数据
boolean previous()    // 移动到上一行
first()/last()        // 移动到第一行/最后一行

// 获取数据（列名或索引，索引从1开始）
String getString(String columnName)
int getInt(String columnName)
double getDouble(String columnName)
Object getObject(String columnName)

boolean wasNull()     // 判断最后一个读取的值是否为NULL
```

---

#### 4. SQL注入攻击与防御

**什么是SQL注入？**

攻击者通过构造特殊的输入参数，改变SQL语句的逻辑。

**示例（危险写法）：**

```java
// 拼接SQL字符串，危险！
String sql = "SELECT * FROM user WHERE username='" + username + "' AND password='" + password + "'";
// 如果username输入：' OR '1'='1
// 实际SQL：SELECT * FROM user WHERE username='' OR '1'='1' AND password='...'
// 条件永远为真！
```

**防御方法：使用参数化查询**

```java
// PreparedStatement自动转义，防止注入
String sql = "SELECT * FROM user WHERE username=? AND password=?";
pstmt = conn.prepareStatement(sql);
pstmt.setString(1, username);  // 特殊字符会被转义
pstmt.setString(2, password);
```

---

#### 5. 资源释放最佳实践

**为什么需要手动释放资源？**

1. 数据库连接是有限资源
2. 连接池耗尽会导致应用无法访问数据库
3. 文件句柄、内存等资源同理

**try-with-resources（Java 7+推荐写法）：**

```java
// 自动关闭实现AutoCloseable接口的资源
try (Connection conn = DriverManager.getConnection(url, user, pass);
     PreparedStatement pstmt = conn.prepareStatement(sql);
     ResultSet rs = pstmt.executeQuery()) {

    // 使用资源
    while (rs.next()) {
        // 处理结果
    }

} catch (SQLException e) {
    // 处理异常
} // 自动调用close()，无需finally块
```

**与旧写法对比：**

```java
// 传统try-catch-finally
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    // 使用资源
} catch (SQLException e) {
    // 处理异常
} finally {
    // 必须手动关闭，容易遗漏
    try { if (rs != null) rs.close(); } catch (SQLException e) {}
    try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
    try { if (conn != null) conn.close(); } catch (SQLException e) {}
}
```

---

### JSP脚本模式特点

| 优点 | 缺点 |
|------|------|
| 简单直接，适合小页面 | HTML与Java代码混杂 |
| 无需额外配置 | 代码复用性差 |
| 入门容易 | 维护成本高 |
| 适合快速原型 | 逻辑与表现未分离 |

---

## ch07_5 - JavaBean模式

### 项目文件

```
ch07_5/
├── ch07_5_tijiao.jsp    # 登录表单页面
├── ch07_5_yanzheng.jsp  # 处理页面
└── UserBean.java        # 业务逻辑封装
```

### 核心改进

将数据库操作逻辑从JSP抽取到JavaBean中，实现**表现层与业务逻辑层分离**。

---

### UserBean.java - 业务逻辑封装

```java
package com.example;  // 包声明：属于com.example包

// ==================== 导入语句 ====================
// java.sql包包含JDBC核心API
import java.sql.*;

// ==================== 类定义 ====================
// public：访问修饰符，表示该类对外可见
// class：声明这是一个类
// UserBean：类名（驼峰命名法，名词）
public class UserBean {

    // ==================== 成员变量（字段） ====================
    // private：私有访问修饰符，只能在类内部访问
    // 封装数据库连接配置，对外隐藏实现细节

    private String driver = "com.mysql.cj.jdbc.Driver";
    private String url = "jdbc:mysql://mysql-db:3306/user?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8";
    private String dbUser = "root";
    private String dbPassword = "root_password";

    // ==================== 公有方法 ====================

    /**
     * 验证用户名和密码是否匹配
     *
     * @param username 用户名
     * @param userpassword 密码
     * @return true-登录成功，false-登录失败
     */
    public boolean validateUser(String username, String userpassword) {
        // 声明JDBC对象
        // 注意：这些对象不能作为成员变量，否则多个请求会共享
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 1. 加载JDBC驱动
            // Driver类被加载时会注册到DriverManager
            Class.forName(driver);

            // 2. 获取数据库连接
            // DriverManager管理所有已注册的驱动
            // 它会尝试每个驱动直到成功连接
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // 3. 准备SQL语句
            // 查询user_b表中用户名和密码都匹配记录
            String sql = "SELECT * FROM user_b WHERE username = ? AND userpassword = ?";

            // 4. 创建预编译语句
            pstmt = conn.prepareStatement(sql);

            // 5. 设置参数
            // 索引1对应第一个?，索引2对应第二个?
            pstmt.setString(1, username);
            pstmt.setString(2, userpassword);

            // 6. 执行查询
            rs = pstmt.executeQuery();

            // 7. 判断结果
            // rs.next()移动到下一行，如果有数据返回true
            // 返回值直接作为方法的返回值
            return rs.next();

        } catch (Exception e) {
            // 捕获异常并打印堆栈
            // 实际项目中应该记录日志（如log4j）
            e.printStackTrace();

            // 发生异常时返回false
            // 调用方可以根据返回值判断操作失败
            return false;

        } finally {
            // 8. 释放资源
            // 使用try-catch确保即使关闭出错也能继续关闭其他资源
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                // 静默处理关闭异常
                // 实际项目中应记录日志
            }
        }
    }
}
```

---

### JavaBean规范

JavaBean是一种Java类的设计规范：

| 规范 | 说明 | 示例 |
|------|------|------|
| 无参构造器 | 必须有public的无参构造方法 | `public UserBean() {}` |
| 属性私有 | 所有字段使用private修饰 | `private String name;` |
| getter/setter | 提供公共的getter和setter方法 | `getName()` / `setName()` |
| 可序列化 | 实现Serializable接口（可选） | `implements Serializable` |

**字段命名与getter/setter的关系：**

| 字段名 | getter方法 | setter方法 |
|--------|------------|------------|
| `username` | `getUsername()` | `setUsername()` |
| `userpassword` | `getUserpassword()` | `setUserpassword()` |
| `isValid` | `isValid()` | `setValid()` |

---

### JSP调用JavaBean (ch07_5_yanzheng.jsp)

```jsp
<%@ page
    language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.example.UserBean" %>
    <%-- 导入UserBean类 --%>
    <%-- 注意：必须放在正确的包路径下，且编译后的class文件在classpath中 --%>

<%
    // 设置请求编码
    request.setCharacterEncoding("UTF-8");

    // 获取表单参数
    String username = request.getParameter("username");
    String userpassword = request.getParameter("userpassword");

    // 创建JavaBean实例
    // new操作符调用无参构造器创建对象
    UserBean userBean = new UserBean();

    // 调用业务方法
    // validateUser方法返回boolean值
    if (userBean.validateUser(username, userpassword)) {
        out.println("登录成功");
    } else {
        out.println("登录失败");
    }
%>
<br><a href="ch07_5_tijiao.jsp">返回</a>
```

---

### JavaBean模式特点

| 对比项 | ch07_3 (JSP脚本) | ch07_5 (JavaBean) |
|--------|------------------|-------------------|
| 业务逻辑位置 | JSP内嵌Java代码 | JavaBean类 |
| 代码复用 | 差（无法复用） | 好（可被多个JSP调用） |
| 可维护性 | 差 | 较好 |
| 关注点分离 | 未分离 | 初步分离 |

---

### JSP使用JavaBean的另一种方式

JSP还提供了专用的标签来使用JavaBean（实际项目中较少使用）：

```jsp
<%-- 创建JavaBean实例 --%>
<jsp:useBean id="userBean" class="com.example.UserBean" scope="request" />

<%-- 设置属性（调用setter） --%>
<jsp:setProperty name="userBean" property="username" value="<%= username %>" />

<%-- 获取属性（调用getter） --%>
<jsp:getProperty name="userBean" property="username" />
```

**scope属性（作用域）：**

| scope | 说明 |
|-------|------|
| page | 当前页面有效（默认） |
| request | 当前请求有效 |
| session | 当前会话有效 |
| application | 当前应用有效 |

---

## ch07_7 - Servlet模式

### 项目文件

```
ch07_7/
├── ch07_7_tijiao.jsp      # 登录表单页面
├── ch07_7_yanzheng.java   # Servlet控制器
├── ch07_7_yanzheng.class  # 编译后的Servlet
├── ch07_7_Success.jsp     # 成功页面
└── ch07_7_error.jsp       # 失败页面
```

### 核心改进

引入Servlet作为控制器，实现**请求与响应的分离**，使用**请求转发**进行页面跳转。

---

### Servlet控制器 (ch07_7_yanzheng.java)

```java
package com.example;  // 包声明，必须与web.xml或注解配置的包路径一致

// ==================== 导入语句 ====================
import java.io.IOException;           // IO异常
import java.sql.*;                    // JDBC相关类
import javax.servlet.ServletException; // Servlet异常
import javax.servlet.http.HttpServlet; // HTTP Servlet基类
import javax.servlet.http.HttpServletRequest;  // HTTP请求对象
import javax.servlet.http.HttpServletResponse; // HTTP响应对象

// ==================== 类定义 ====================
/**
 * 登录验证Servlet
 *
 * Servlet是运行在Web服务器上的Java程序
 * 继承HttpServlet可以方便地处理HTTP请求
 *
 * 访问路径配置（在web.xml或注解中）：
 * <url-pattern>/servlet/com.example.ch07_7_yanzheng</url-pattern>
 */
public class ch07_7_yanzheng extends HttpServlet {

    // ==================== 版本控制 ====================
    // serialVersionUID用于序列化版本控制
    // 当类结构改变时，版本号也应改变
    private static final long serialVersionUID = 1L;

    // ==================== 数据库配置（成员变量） ====================
    // 使用private final保证配置不可变且只在类加载时初始化一次
    private String driver = "com.mysql.cj.jdbc.Driver";
    private String url = "jdbc:mysql://mysql-db:3306/user?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8";
    private String dbUser = "root";
    private String dbPassword = "root_password";

    // ==================== HTTP GET请求处理 ====================
    /**
     * 处理HTTP GET请求
     *
     * 当浏览器直接访问Servlet URL或使用GET方式提交表单时调用
     * 本例中将GET请求委托给POST处理，保证逻辑统一
     *
     * @param request  HTTP请求对象，包含请求参数、头信息等
     * @param response HTTP响应对象，用于发送响应给客户端
     * @throws ServletException Servlet处理异常
     * @throws IOException      IO异常
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 将doGet的请求转发给doPost处理
        // 这样无论是GET还是POST请求，逻辑都一致
        doPost(request, response);
    }

    // ==================== HTTP POST请求处理 ====================
    /**
     * 处理HTTP POST请求
     *
     * 当表单使用method="post"提交时调用
     * POST请求适合提交敏感数据或大量数据
     *
     * @param request  HTTP请求对象
     * @param response HTTP响应对象
     * @throws ServletException Servlet处理异常
     * @throws IOException      IO异常
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 设置请求编码
        // 必须在获取任何参数之前设置，否则中文会乱码
        request.setCharacterEncoding("UTF-8");

        // 2. 设置响应内容类型和编码
        // 告诉浏览器响应内容是HTML，字符编码是UTF-8
        response.setContentType("text/html; charset=UTF-8");

        // 3. 获取请求参数
        String username = request.getParameter("username");
        String userpassword = request.getParameter("userpassword");

        // 4. 调用业务方法验证用户
        boolean loginSuccess = validateUser(username, userpassword);

        // 5. 将数据存储到request域
        // 这样数据可以在转发后的页面中获取
        request.setAttribute("username", username);

        // 6. 根据验证结果选择页面进行转发
        // 请求转发是服务器内部跳转，客户端不知道
        if (loginSuccess) {
            // 登录成功，转发到成功页面
            // getRequestDispatcher()参数是目标资源的路径
            // 斜杠开头表示从应用根目录开始
            request.getRequestDispatcher("/ch07_7/ch07_7_Success.jsp")
                    .forward(request, response);
        } else {
            // 登录失败，转发到错误页面
            request.getRequestDispatcher("/ch07_7/ch07_7_error.jsp")
                    .forward(request, response);
        }
    }

    // ==================== 私有业务方法 ====================
    /**
     * 验证用户名和密码是否正确
     *
     * @param username 用户名
     * @param userpassword 密码
     * @return true-验证通过，false-验证失败
     */
    private boolean validateUser(String username, String userpassword) {
        // 声明JDBC对象
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 加载驱动
            Class.forName(driver);

            // 获取连接
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // 预编译SQL
            String sql = "SELECT * FROM user_b WHERE username = ? AND userpassword = ?";
            pstmt = conn.prepareStatement(sql);

            // 设置参数
            pstmt.setString(1, username);
            pstmt.setString(2, userpassword);

            // 执行查询
            rs = pstmt.executeQuery();

            // 判断是否有匹配记录
            return rs.next();

        } catch (Exception e) {
            // 打印异常堆栈
            e.printStackTrace();
            return false;

        } finally {
            // 释放资源
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
    }
}
```

---

### Servlet核心概念详解

#### 1. Servlet生命周期

```
┌─────────────────────────────────────────────────────────────────┐
│                        Servlet生命周期                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. 加载与实例化                                                 │
│     ─────────────────→ Servlet构造器() ←────────────────         │
│                           (只执行一次)                           │
│                                                                 │
│  2. 初始化                                                       │
│     ─────────────────→ init() ←───────────────────────         │
│                           (只执行一次)                           │
│                           config参数可在web.xml配置              │
│                                                                 │
│  3. 请求处理（多次）                                             │
│     ┌──────────────┐                                            │
│     │ doGet/doPost │ ←──────────────── 每次请求都调用            │
│     └──────────────┘                                            │
│                                                                 │
│  4. 销毁（一次）                                                 │
│     ─────────────────→ destroy() ←─────────────────            │
│                           (服务器关闭或重新加载时调用)            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**生命周期方法说明：**

| 方法 | 调用时机 | 执行次数 | 作用 |
|------|----------|----------|------|
| `构造器` | 类加载时 | 1次 | 创建Servlet实例 |
| `init()` | 构造后 | 1次 | 初始化操作，如加载配置 |
| `doGet()` | GET请求时 | 多次 | 处理GET请求 |
| `doPost()` | POST请求时 | 多次 | 处理POST请求 |
| `destroy()` | 销毁前 | 1次 | 释放资源，如关闭连接池 |

---

#### 2. doGet与doPost方法

```java
// HttpServlet的默认实现
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    // 默认返回405 Method Not Allowed
    // 子类通常重写doGet或doPost，或两者都重写
}

protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    // 默认返回405 Method Not Allowed
}

// 常见的请求分发模式
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    doPost(request, response);  // GET请求也用POST逻辑处理
}
```

**为什么常用这种模式？**

1. 表单默认使用POST提交
2. 直接访问Servlet URL是GET请求
3. 将逻辑统一在doPost中，避免重复代码

---

#### 3. 请求转发（RequestDispatcher）

```java
// 获取RequestDispatcher
RequestDispatcher dispatcher = request.getRequestDispatcher("/path/to/page.jsp");

// 方式1：forward转发（服务器内部跳转）
dispatcher.forward(request, response);

// 方式2：include包含（将页面内容包含进来）
dispatcher.include(request, response);
```

**forward vs include：**

| 特性 | forward | include |
|------|---------|---------|
| 目标页面内容 | 完全替代当前页面 | 插入到当前页面中 |
| 执行顺序 | 只执行目标页面 | 先执行当前页面，再执行目标页面 |
| URL | 不变 | 不变 |
| response是否提交 | 不能提交（会抛异常） | 可以提交 |

---

#### 4. 请求转发 vs 重定向

```java
// 请求转发（Forward）
request.getRequestDispatcher("/target.jsp").forward(request, response);

// 重定向（Redirect）
response.sendRedirect("/contextPath/target.jsp");
```

**对比详解：**

```
┌─────────────────────────────────────────────────────────────────┐
│                      请求转发（Forward）                          │
│  ┌─────────┐     ┌─────────┐     ┌─────────┐                   │
│  │ 浏览器   │────▶│ Servlet │────▶│  JSP    │                   │
│  └─────────┘     └─────────┘     └─────────┘                   │
│       │                                 │                       │
│       │                                 │                       │
│       └─────────────────────────────────┘                       │
│              1次请求，URL不变                                    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      重定向（Redirect）                          │
│  ┌─────────┐     ┌─────────┐     ┌─────────┐                   │
│  │ 浏览器   │────▶│ Servlet │◀────│  JSP    │                   │
│  └─────────┘     └─────────┘     └─────────┘                   │
│       │               │                                         │
│       │               │ 302响应 + Location头                    │
│       └───────────────┘                                         │
│              2次请求，URL改变                                    │
└─────────────────────────────────────────────────────────────────┘
```

| 特性 | 请求转发 (forward) | 重定向 (redirect) |
|------|-------------------|-------------------|
| 请求次数 | 1次 | 2次 |
| URL变化 | 不变 | 改变 |
| 数据传递 | 共享request域 | 不共享（可用session） |
| 客户端感知 | 无感知 | 知道跳转 |
| 地址栏 | 显示原URL | 显示目标URL |
| 使用场景 | 登录验证成功后跳转 | 表单提交后跳转防止重复提交 |

---

#### 5. request域数据传递

```java
// 存储数据（任意Java对象）
request.setAttribute("key", object);

// 获取数据
Object obj = request.getAttribute("key");

// 获取所有属性名
Enumeration<String> names = request.getAttributeNames();

// 移除属性
request.removeAttribute("key");
```

**四大作用域：**

| 作用域 | 对象 | 范围 | 生命周期 |
|--------|------|------|----------|
| Page | pageContext | 当前页面 | 页面结束时销毁 |
| Request | request | 一次请求 | 请求结束后销毁 |
| Session | session | 一次会话 | 会话超时或失效时销毁 |
| Application | application | 整个应用 | 应用关闭时销毁 |

**数据传递方式对比：**

| 方式 | 作用域 | 适用场景 |
|------|--------|----------|
| request.setAttribute() | 一次请求 | 转发时传递数据 |
| session.setAttribute() | 会话 | 用户登录信息等 |
| application.setAttribute() | 应用 | 全局配置、缓存 |
| cookie | 客户端 | 跨会话保存数据 |

---

#### 6. Servlet配置方式

**方式1：web.xml配置（传统方式）**

```xml
<!-- 位于 WEB-INF/web.xml -->
<servlet>
    <servlet-name>LoginServlet</servlet-name>
    <servlet-class>com.example.ch07_7_yanzheng</servlet-class>
</servlet>

<servlet-mapping>
    <servlet-name>LoginServlet</servlet-name>
    <url-pattern>/servlet/com.example.ch07_7_yanzheng</url-pattern>
</servlet-mapping>
```

**方式2：注解配置（Servlet 3.0+推荐）**

```java
// 在Servlet类上添加注解
@WebServlet("/servlet/com.example.ch07_7_yanzheng")
public class ch07_7_yanzheng extends HttpServlet {
    // ...
}
```

**url-pattern规则：**

| 模式 | 含义 | 示例 |
|------|------|------|
| 精确匹配 | 精确匹配路径 | `/login` |
| 路径匹配 | 匹配路径前缀 | `/admin/*` |
| 扩展名匹配 | 匹配扩展名 | `*.do` |
| 默认匹配 | 匹配所有路径 | `/` |

---

### 登录表单 (ch07_7_tijiao.jsp)

```jsp
<%@ page
    language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%--
    表单提交到Servlet
    ../servlet/com.example.ch07_7_yanzheng 是相对于当前页面的路径
    ../ 表示上级目录
--%>
<form action="../servlet/com.example.ch07_7_yanzheng" method="post">
    用户名: <input type="text" name="username"><br>
    密码: <input type="password" name="userpassword"><br>
    <input type="submit" value="登录">
</form>
```

---

### 成功页面 (ch07_7_Success.jsp)

```jsp
<%@ page
    language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%--
    获取转发过来的数据
    request是内置对象，来自Servlet的setAttribute
--%>
登录成功，用户名: <%= request.getAttribute("username") %>
<br><a href="ch07_7_tijiao.jsp">返回</a>
```

**JSP表达式 `<%= %>`：**

```jsp
<%= expression %>    <%-- 计算表达式并输出结果 --%>

<%-- 等价于 --%>
<% out.println(expression); %>
```

---

### Servlet模式特点

| 优点 | 缺点 |
|------|------|
| 清晰的MVC雏形（V+C） | 业务逻辑仍在Servlet内 |
| 请求处理集中 | 数据库操作代码重复 |
| 支持多种请求方法 | 配置相对繁琐 |
| 可扩展性好 |  |

---

## ch07_9 - 分层模式

### 项目文件

```
ch07_9/
├── ch07_9_tijiao.jsp      # 登录表单页面
├── ch07_9_kongzhi.java    # Servlet控制器
├── ch07_9_Success.jsp     # 成功页面
├── ch07_9_error.jsp       # 失败页面
├── User.java              # 实体类
├── ConnectDbase.java      # 数据访问层
```

---

### 分层架构图

```
┌─────────────────────────────────────────────────────┐
│                    表现层 (View)                      │
│              JSP页面：ch07_9_tijiao.jsp               │
│              职责：用户界面展示                        │
└─────────────────────────────────────────────────────┘
                         ↓ HTTP请求
┌─────────────────────────────────────────────────────┐
│                  控制器层 (Controller)                │
│              Servlet：ch07_9_kongzhi.java             │
│              职责：接收请求、参数校验、调用业务层、页面跳转 │
└─────────────────────────────────────────────────────┘
                         ↓ 调用
┌─────────────────────────────────────────────────────┐
│                  数据访问层 (DAO)                     │
│           ConnectDbase.java（数据访问对象）           │
│              职责：封装所有数据库操作                   │
└─────────────────────────────────────────────────────┘
                         ↓ JDBC
┌─────────────────────────────────────────────────────┐
│                  实体类 (Model)                       │
│                    User.java                         │
│              职责：封装数据，getter/setter             │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│                  Database (数据库)                    │
│                    MySQL                             │
└─────────────────────────────────────────────────────┘
```

---

### User.java - 实体类详解

```java
package com.example;

/**
 * 用户实体类
 *
 * 实体类（Entity/Model）的职责：
 * 1. 封装数据（私有字段）
 * 2. 提供访问方法（getter/setter）
 * 3. 可选：包含业务逻辑
 *
 * 设计原则：
 * - 实现Serializable接口（可选，用于网络传输或序列化）
 * - 提供无参构造器
 * - 提供带参构造器（可选）
 * - 重写equals()和hashCode()（可选，用于集合操作）
 * - 重写toString()（可选，便于调试）
 */
public class User {

    // ==================== 私有字段（封装数据） ====================
    // private保证数据只能通过getter/setter访问
    // 实现信息隐藏，保证数据安全性

    private String username;      // 用户名
    private String userpassword;  // 密码

    // ==================== 构造方法 ====================

    /**
     * 无参构造器
     * JavaBean规范要求
     * 框架（如Spring）通常使用反射调用无参构造器创建对象
     */
    public User() {
        // 空实现，字段默认值为null
    }

    /**
     * 带参构造器
     * 方便创建对象时直接初始化字段
     * 注意：如果定义了带参构造器，不会自动生成无参构造器
     *       所以通常需要显式定义无参构造器
     */
    public User(String username, String userpassword) {
        // this关键字指向当前对象实例
        // 用于区分局部变量和成员变量
        this.username = username;
        this.userpassword = userpassword;
    }

    // ==================== Getter和Setter方法 ====================

    /**
     * 获取用户名
     * getter方法命名规范：get + 字段名首字母大写
     * boolean类型的getter可以用isXxx()命名
     */
    public String getUsername() {
        return username;  // 返回字段值
    }

    /**
     * 设置用户名
     * setter方法命名规范：set + 字段名首字母大写
     * 负责数据验证和类型转换
     */
    public void setUsername(String username) {
        this.username = username;  // this.成员变量 = 参数
    }

    public String getUserpassword() {
        return userpassword;
    }

    public void setUserpassword(String userpassword) {
        this.userpassword = userpassword;
    }

    // ==================== 可选方法 ====================

    /**
     * 重写toString()方法
     * 默认实现返回类名@哈希码，重写后便于调试和日志输出
     */
    @Override
    public String toString() {
        return "User{" +
                "username='" + username + '\'' +
                ", userpassword='" + userpassword + '\'' +
                '}';
    }

    /**
     * 重写equals()方法
     * 用于判断两个对象是否"相等"
     * 默认比较引用地址，重写后可以比较内容
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;  // 引用相同
        if (obj == null || getClass() != obj.getClass()) return false;
        User other = (User) obj;
        // 比较username和userpassword
        return username != null ? username.equals(other.username) : other.username == null
            && userpassword != null ? userpassword.equals(other.userpassword) : other.userpassword == null;
    }

    /**
     * 重写hashCode()方法
     * 与equals()配套使用，用于哈希表（如HashMap）
     */
    @Override
    public int hashCode() {
        int result = username != null ? username.hashCode() : 0;
        result = 31 * result + (userpassword != null ? userpassword.hashCode() : 0);
        return result;
    }
}
```

---

### ConnectDbase.java - 数据访问层详解

```java
package com.example;

import java.sql.*;

/**
 * 数据库连接与操作类
 *
 * DAO（Data Access Object）职责：
 * 1. 封装所有数据库操作
 * 2. 对外提供简洁的API
 * 3. 不包含业务逻辑，只负责数据存取
 *
 * 设计考虑：
 * - 方法参数使用实体类（User），而不是基本类型
 * - 返回值使用基本类型（boolean）表示操作结果
 * - 包含参数校验
 */
public class ConnectDbase {

    // ==================== 数据库配置（常量） ====================
    // 建议使用配置文件（如properties）管理，这里硬编码简化示例

    private String driver = "com.mysql.cj.jdbc.Driver";
    private String url = "jdbc:mysql://mysql-db:3306/user?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8";
    private String dbUser = "root";
    private String dbPassword = "root_password";

    // ==================== 业务方法 ====================

    /**
     * 验证用户登录
     *
     * @param user User对象，包含用户名和密码
     * @return true-验证通过，false-验证失败
     *
     * 为什么传入User对象而不是两个String参数？
     * 1. 可扩展性：以后需要验证更多字段时，只需添加User的字段
     * 2. 类型安全：避免参数顺序错误
     * 3. 语义清晰：表示验证的是整个用户对象
     */
    public boolean yanzheng_uesr(User user) {

        // 参数校验
        if (user == null) {
            // 防御性编程：防止空指针异常
            return false;
        }

        // 声明JDBC对象
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 加载驱动
            Class.forName(driver);

            // 获取连接
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // 准备SQL
            // 从user_b表中查询用户名和密码都匹配的记录
            String sql = "SELECT * FROM user_b WHERE username = ? AND userpassword = ?";

            // 创建预编译语句
            pstmt = conn.prepareStatement(sql);

            // 设置参数
            // 使用User对象的getter方法获取值
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getUserpassword());

            // 执行查询
            rs = pstmt.executeQuery();

            // 判断是否有匹配记录
            return rs.next();

        } catch (Exception e) {
            // 记录异常（实际项目应使用日志框架）
            e.printStackTrace();
            return false;

        } finally {
            // 释放资源
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
    }
}
```

---

### Servlet控制器 (ch07_9_kongzhi.java)

```java
package com.example;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 登录控制器（Servlet）
 *
 * 控制器（Controller）的职责：
 * 1. 接收用户请求
 * 2. 获取请求参数
 * 3. 调用业务层/数据访问层
 * 4. 存储数据到作用域
 * 5. 选择视图进行转发或重定向
 *
 * 注意：控制器应该"瘦"，业务逻辑应该放在Service层
 * 本例中DAO层承担了业务逻辑的职责
 */
public class ch07_9_kongzhi extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * 处理GET请求
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * 处理POST请求
     *
     * 处理流程：
     * 1. 设置请求/响应编码
     * 2. 获取请求参数
     * 3. 创建实体对象
     * 4. 调用DAO层
     * 5. 存储结果到request域
     * 6. 转发到对应页面
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // ==================== 2. 获取请求参数 ====================
        String username = request.getParameter("username");
        String userpassword = request.getParameter("userpassword");

        // ==================== 3. 创建实体对象 ====================
        // 封装请求参数为User对象
        User user = new User();
        user.setUsername(username);
        user.setUserpassword(userpassword);

        // ==================== 4. 调用数据访问层 ====================
        // 创建DAO实例
        ConnectDbase connectDbase = new ConnectDbase();
        // 调用验证方法，获取结果
        boolean loginSuccess = connectDbase.yanzheng_uesr(user);

        // ==================== 5. 存储数据到request域 ====================
        // 存储用户对象（登录成功时显示用户名）
        request.setAttribute("user", user);
        // 存储登录结果（供页面判断显示内容）
        request.setAttribute("loginSuccess", loginSuccess);

        // ==================== 6. 页面跳转 ====================
        if (loginSuccess) {
            // 登录成功，转发到成功页面
            request.getRequestDispatcher("/ch07_9/ch07_9_Success.jsp")
                    .forward(request, response);
        } else {
            // 登录失败，转发到错误页面
            request.getRequestDispatcher("/ch07_9/ch07_9_error.jsp")
                    .forward(request, response);
        }
    }
}
```

---

### 分层模式特点

| 优点 | 说明 |
|------|------|
| **职责分离** | 控制器、数据访问、实体各司其职 |
| **代码复用** | DAO可被多个控制器复用 |
| **可测试性** | DAO可单独测试（无需Servlet环境） |
| **易于维护** | 修改一处不影响其他层 |
| **团队协作** | 前后端可并行开发 |

---

## ch07_11 - MVC+DAO完整模式

### 项目文件

```
ch07_11/
├── add_student.jsp           # 添加学生页面
├── add_student_action.jsp    # 添加处理Action
├── edit_student.jsp          # 编辑学生页面
├── edit_student_action.jsp   # 编辑处理Action
├── delete_student.jsp        # 删除学生页面
├── delete_student_action.jsp # 删除处理Action
├── search_student.jsp        # 查询学生页面
├── index.jsp                 # 首页
├── Students.java             # 实体类（包含业务逻辑）
├── StudentDAO.java           # 数据访问对象（实现IBookDAO）
├── IBookDAO.java             # DAO接口
├── DBUtil.java               # 数据库工具类
└── init.sql                  # 数据库初始化脚本
```

---

### 完整MVC架构图

```
┌────────────────────────────────────────────────────────────────┐
│                         View (视图层)                            │
│   JSP页面: index.jsp, add_student.jsp, edit_student.jsp等       │
│   职责：用户界面展示，接收用户输入，展示处理结果                   │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│                      Controller (控制器层)                       │
│   JSP Action: add_student_action.jsp等                          │
│   职责：接收请求、调用Model层、转发页面                           │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│                       Model (模型层)                             │
│  ┌─────────────────┐  ┌────────────────┐  ┌────────────────┐   │
│  │     实体类       │  │     DAO层      │  │     工具类     │   │
│  │   Students      │  │  StudentDAO    │  │    DBUtil      │   │
│  │  封装数据+业务   │  │  实现IBookDAO  │  │  封装连接管理  │   │
│  └─────────────────┘  └────────────────┘  └────────────────┘   │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│                       Database (数据库)                          │
│                       MySQL / MariaDB                            │
│                       students表                                 │
└────────────────────────────────────────────────────────────────┘
```

---

### Students.java - 实体类（带业务逻辑）

```java
package com.example;

/**
 * 学生实体类
 *
 * 相比之前的User类，这个实体类包含业务逻辑方法：
 * - calculateBMI()：计算BMI值
 * - getHealthStatus()：根据BMI判断健康状况
 *
 * 这体现了"贫血模型"vs"充血模型"的讨论：
 * - 贫血模型：实体类只包含数据，业务逻辑在Service层
 * - 充血模型：实体类包含业务逻辑
 *
 * 本例采用混合方式：简单的业务逻辑放在实体类，复杂的放在Service层
 */
public class Students {

    // ==================== 私有字段 ====================
    private int id;              // 学号（主键）
    private String name;         // 姓名
    private int age;             // 年龄
    private String gender;       // 性别
    private double height;       // 身高（厘米）
    private double weight;       // 体重（公斤）
    private double bmi;          // BMI值（冗余字段，可根据身高体重计算）
    private String health_status; // 健康状况（偏瘦/正常/超重/肥胖）

    // ==================== 构造方法 ====================

    public Students() {
        // 无参构造器
    }

    /**
     * 全参构造器
     * 方便创建对象时初始化所有字段
     */
    public Students(int id, String name, int age, String gender,
                   double height, double weight, double bmi, String health_status) {
        this.id = id;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.height = height;
        this.weight = weight;
        this.bmi = bmi;
        this.health_status = health_status;
    }

    // ==================== 业务逻辑方法 ====================

    /**
     * 计算BMI值
     *
     * BMI公式：体重(kg) / 身高(m)²
     * 身高从厘米转换为米：height / 100
     *
     * @return BMI值（保留两位小数）
     */
    public double calculateBMI() {
        // 将身高从厘米转换为米
        double heightInMeters = height / 100.0;

        // 计算BMI
        // BMI = 体重 / (身高²)
        double bmiValue = weight / (heightInMeters * heightInMeters);

        // 返回结果（四舍五入到一位小数）
        return Math.round(bmiValue * 10) / 10.0;
    }

    /**
     * 根据BMI值判断健康状况
     *
     * BMI参考标准（中国）：
     * - < 18.5：偏瘦
     * - 18.5 ~ 23.9：正常
     * - 24 ~ 27.9：超重
     * - >= 28：肥胖
     *
     * @return 健康状况字符串
     */
    public String getHealthStatus() {
        // 先计算BMI
        double bmiValue = calculateBMI();

        // 多分支判断
        if (bmiValue < 18.5) {
            return "偏瘦";
        } else if (bmiValue < 24) {
            return "正常";
        } else if (bmiValue < 28) {
            return "超重";
        } else {
            return "肥胖";
        }
    }

    // ==================== Getter和Setter方法 ====================

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
```

---

### IBookDAO.java - DAO接口详解

```java
package com.example;

import java.sql.*;
import java.util.List;

/**
 * 学生数据访问接口
 *
 * 接口作用：
 * 1. 定义数据访问操作规范
 * 2. 实现类必须实现所有方法
 * 3. 便于替换实现方式（如从MySQL切换到Oracle）
 * 4. 支持多态调用
 *
 * 面向接口编程的好处：
 * - 降低耦合度
 * - 提高可测试性（可创建Mock实现）
 * - 便于团队协作（定义接口后，前后端可并行开发）
 */
public interface IBookDAO {

    // ==================== CRUD操作声明 ====================

    /**
     * 添加学生
     *
     * @param student 学生对象
     * @return true-添加成功，false-添加失败
     */
    boolean addStudent(Students student);

    /**
     * 根据ID查询学生
     *
     * @param id 学生ID
     * @return 学生对象，未找到返回null
     */
    Students queryStudentById(int id);

    /**
     * 查询所有学生
     *
     * @return 学生列表
     */
    List<Students> queryAllStudents();

    /**
     * 根据姓名模糊查询学生
     *
     * @param name 姓名（支持模糊匹配）
     * @return 匹配的学生列表
     */
    List<Students> queryStudentsByName(String name);

    /**
     * 更新学生信息
     *
     * @param student 学生对象（包含要更新的数据）
     * @return true-更新成功，false-更新失败
     */
    boolean updateStudent(Students student);

    /**
     * 根据ID删除学生
     *
     * @param id 学生ID
     * @return true-删除成功，false-删除失败
     */
    boolean deleteStudentById(int id);

    /**
     * 根据姓名删除学生
     *
     * @param name 学生姓名
     * @return true-删除成功，false-删除失败
     */
    boolean deleteStudentByName(String name);
}
```

---

### DBUtil.java - 数据库工具类详解

```java
package com.example;

import java.sql.*;

/**
 * 数据库工具类
 *
 * 工具类特点：
 * 1. 所有方法都是静态的（static），通过类名直接调用
 * 2. 私有构造方法（防止实例化）
 * 3. 封装重复代码，提高复用性
 *
 * 功能：
 * 1. 加载驱动（静态代码块）
 * 2. 获取连接
 * 3. 关闭资源（重载方法）
 */
public class DBUtil {

    // ==================== 数据库配置（静态常量） ====================
    // 使用static final声明常量
    // 常量名全大写，单词间用下划线分隔
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://mysql-db:3306/user?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root_password";

    // ==================== 静态代码块 ====================
    /**
     * 静态代码块
     *
     * 特点：
     * 1. 类加载时执行一次（早于构造方法）
     * 2. 只执行一次，无论创建多少实例
     * 3. 用于初始化静态资源
     *
     * 用途：
     * 1. 加载JDBC驱动
     * 2. 初始化连接池
     * 3. 加载配置文件
     */
    static {
        try {
            // 加载驱动
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            // 驱动类不存在（通常是jar包缺失）
            e.printStackTrace();
        }
    }

    // ==================== 私有构造方法 ====================
    /**
     * 私有构造方法
     *
     * 目的：防止外部通过new创建实例
     * 因为工具类的方法都是静态的，不需要实例
     */
    private DBUtil() {
        // 空实现
    }

    // ==================== 获取连接方法 ====================
    /**
     * 获取数据库连接
     *
     * @return Connection对象
     * @throws SQLException 获取连接失败的异常
     *
     * 注意：
     * - 调用方负责关闭连接
     * - 实际项目中通常使用连接池（如HikariCP、C3P0）
     * - 连接池可以复用连接，提高性能
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, DB_USER, DB_PASSWORD);
    }

    // ==================== 关闭资源方法 ====================
    /**
     * 关闭所有资源
     *
     * @param conn Connection对象
     * @param stmt Statement对象
     * @param rs   ResultSet对象
     *
     * 使用try-catch确保每个资源都能被关闭
     * 关闭顺序：ResultSet → Statement → Connection
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            // 关闭ResultSet
            if (rs != null && !rs.isClosed()) {
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            // 关闭Statement
            if (stmt != null && !stmt.isClosed()) {
                stmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            // 关闭Connection
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 关闭Connection和Statement（无ResultSet）
     */
    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }

    /**
     * 只关闭Connection
     */
    public static void close(Connection conn) {
        close(conn, null, null);
    }
}
```

---

### StudentDAO.java - 完整DAO实现详解

```java
package com.example;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 学生数据访问对象实现
 *
 * 实现IBookDAO接口，定义的所有方法都必须实现
 *
 * 设计考虑：
 * 1. 使用DBUtil工具类管理连接
 * 2. 每方法使用独立的连接（简单但有连接开销）
 * 3. 实际项目可使用连接池
 * 4. 自动计算BMI和健康状况
 */
public class StudentDAO implements IBookDAO {

    // ==================== 添加学生 ====================

    /**
     * 添加学生
     *
     * 实现步骤：
     * 1. 获取数据库连接
     * 2. 计算BMI和健康状况
     * 3. 预编译INSERT语句
     * 4. 设置参数
     * 5. 执行更新
     * 6. 释放资源
     *
     * @param student 学生对象
     * @return true-添加成功，false-添加失败
     */
    @Override
    public boolean addStudent(Students student) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 1. 获取连接
            conn = DBUtil.getConnection();

            // 2. 调用实体类的方法计算BMI和健康状况
            double bmi = student.calculateBMI();
            String healthStatus = student.getHealthStatus();

            // 3. 准备INSERT SQL语句
            // INSERT INTO 表名 (列1, 列2, ...) VALUES (值1, 值2, ...)
            String sql = "INSERT INTO students (name, age, gender, height, weight, bmi, health_status) VALUES (?, ?, ?, ?, ?, ?, ?)";

            // 4. 创建预编译语句
            pstmt = conn.prepareStatement(sql);

            // 5. 设置参数（索引从1开始）
            pstmt.setString(1, student.getName());
            pstmt.setInt(2, student.getAge());
            pstmt.setString(3, student.getGender());
            pstmt.setDouble(4, student.getHeight());
            pstmt.setDouble(5, student.getWeight());
            pstmt.setDouble(6, bmi);
            pstmt.setString(7, healthStatus);

            // 6. 执行更新
            // executeUpdate()返回受影响的行数
            // 大于0表示插入成功
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            // 打印异常堆栈
            e.printStackTrace();
            return false;

        } finally {
            // 7. 释放资源（只关闭conn和stmt）
            DBUtil.close(conn, pstmt);
        }
    }

    // ==================== 根据ID查询学生 ====================

    /**
     * 根据ID查询学生
     *
     * @param id 学生ID
     * @return 学生对象，未找到返回null
     */
    @Override
    public Students queryStudentById(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Students student = null;  // 初始化为null，未找到返回null

        try {
            // 获取连接
            conn = DBUtil.getConnection();

            // 准备SELECT SQL
            // SELECT * 表示查询所有列
            // WHERE id = ? 指定查询条件
            String sql = "SELECT * FROM students WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);  // 设置ID参数

            // 执行查询
            rs = pstmt.executeQuery();

            // 处理结果
            if (rs.next()) {  // 移动到第一行
                // 创建学生对象
                student = new Students();

                // 从ResultSet读取数据，设置到学生对象
                // 使用列名或列索引获取值
                student.setId(rs.getInt("id"));
                student.setName(rs.getString("name"));
                student.setAge(rs.getInt("age"));
                student.setGender(rs.getString("gender"));
                student.setHeight(rs.getDouble("height"));
                student.setWeight(rs.getDouble("weight"));
                student.setBmi(rs.getDouble("bmi"));
                student.setHealth_status(rs.getString("health_status"));
            }

        } catch (SQLException e) {
            e.printStackTrace();

        } finally {
            // 释放资源（包含rs）
            DBUtil.close(conn, pstmt, rs);
        }

        // 返回学生对象（可能为null）
        return student;
    }

    // ==================== 查询所有学生 ====================

    /**
     * 查询所有学生
     *
     * @return 按ID排序的学生列表
     */
    @Override
    public List<Students> queryAllStudents() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Students> studentsList = new ArrayList<>();  // 创建空列表

        try {
            conn = DBUtil.getConnection();

            // 查询所有，按ID排序
            String sql = "SELECT * FROM students ORDER BY id";
            pstmt = conn.prepareStatement(sql);

            rs = pstmt.executeQuery();

            // 循环读取所有行
            while (rs.next()) {
                // 每行创建一个学生对象
                Students student = new Students();
                student.setId(rs.getInt("id"));
                student.setName(rs.getString("name"));
                student.setAge(rs.getInt("age"));
                student.setGender(rs.getString("gender"));
                student.setHeight(rs.getDouble("height"));
                student.setWeight(rs.getDouble("weight"));
                student.setBmi(rs.getDouble("bmi"));
                student.setHealth_status(rs.getString("health_status"));

                // 添加到列表
                studentsList.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();

        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return studentsList;
    }

    // ==================== 根据姓名模糊查询 ====================

    /**
     * 根据姓名模糊查询学生
     *
     * 模糊查询使用LIKE关键字
     * % 表示任意字符序列
     * %keyword% 表示包含keyword
     * keyword% 表示以keyword开头
     *
     * @param name 姓名（支持模糊匹配）
     * @return 匹配的学生列表
     */
    @Override
    public List<Students> queryStudentsByName(String name) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Students> studentsList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();

            // LIKE模糊查询
            // WHERE name LIKE '%张%' 查找名字包含"张"的学生
            String sql = "SELECT * FROM students WHERE name LIKE ?";
            pstmt = conn.prepareStatement(sql);

            // 设置模糊查询参数
            // "%" + name + "%" 表示包含name的任意位置
            pstmt.setString(1, "%" + name + "%");

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Students student = new Students();
                student.setId(rs.getInt("id"));
                student.setName(rs.getString("name"));
                student.setAge(rs.getInt("age"));
                student.setGender(rs.getString("gender"));
                student.setHeight(rs.getDouble("height"));
                student.setWeight(rs.getDouble("weight"));
                student.setBmi(rs.getDouble("bmi"));
                student.setHealth_status(rs.getString("health_status"));
                studentsList.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();

        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return studentsList;
    }

    // ==================== 更新学生 ====================

    /**
     * 更新学生信息
     *
     * UPDATE语法：
     * UPDATE 表名 SET 列1=值1, 列2=值2, ... WHERE 条件
     * 如果省略WHERE，会更新所有行！
     *
     * @param student 学生对象（包含要更新的数据）
     * @return true-更新成功，false-更新失败
     */
    @Override
    public boolean updateStudent(Students student) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();

            // 重新计算BMI和健康状况
            double bmi = student.calculateBMI();
            String healthStatus = student.getHealthStatus();

            // UPDATE语句
            String sql = "UPDATE students SET name = ?, age = ?, gender = ?, height = ?, weight = ?, bmi = ?, health_status = ? WHERE id = ?";

            pstmt = conn.prepareStatement(sql);

            // 设置参数（前7个是SET子句的值，最后1个是WHERE条件）
            pstmt.setString(1, student.getName());
            pstmt.setInt(2, student.getAge());
            pstmt.setString(3, student.getGender());
            pstmt.setDouble(4, student.getHeight());
            pstmt.setDouble(5, student.getWeight());
            pstmt.setDouble(6, bmi);
            pstmt.setString(7, healthStatus);
            pstmt.setInt(8, student.getId());  // WHERE id = ?

            // 执行更新
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;

        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    // ==================== 根据ID删除学生 ====================

    /**
     * 根据ID删除学生
     *
     * DELETE语法：
     * DELETE FROM 表名 WHERE 条件
     * 如果省略WHERE，会删除所有行！
     *
     * @param id 学生ID
     * @return true-删除成功，false-删除失败
     */
    @Override
    public boolean deleteStudentById(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();

            // DELETE语句
            String sql = "DELETE FROM students WHERE id = ?";
            pstmt = conn.prepareStatement(sql);

            // 设置ID参数
            pstmt.setInt(1, id);

            // 执行删除
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;

        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    // ==================== 根据姓名删除学生 ====================

    /**
     * 根据姓名删除学生
     *
     * 注意：多个学生可能同名，都会删除
     *
     * @param name 学生姓名
     * @return true-删除成功，false-删除失败
     */
    @Override
    public boolean deleteStudentByName(String name) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();

            String sql = "DELETE FROM students WHERE name = ?";
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, name);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;

        } finally {
            DBUtil.close(conn, pstmt);
        }
    }
}
```

---

### 首页 (index.jsp)

```jsp
<%@ page
    language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.example.Students, com.example.StudentDAO, java.util.List" %>
    <%-- 导入必要的类 --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生管理系统</title>
</head>
<body>
    <%-- 页面标题 --%>
    <h1>学生管理系统</h1>

    <%-- 操作链接 --%>
    <ul>
        <li><a href="add_student.jsp">添加学生</a></li>
        <li><a href="search_student.jsp">查询学生</a></li>
    </ul>

    <%-- 创建DAO并查询所有学生 --%>
    <%
        // 实例化DAO
        StudentDAO studentDAO = new StudentDAO();
        // 调用查询方法，获取学生列表
        List<Students> students = studentDAO.queryAllStudents();
    %>

    <%-- 表格展示学生列表 --%>
    <h2>学生列表</h2>
    <table border="1">
        <tr>
            <th>ID</th>       <%-- 表头单元格 --%>
            <th>姓名</th>
            <th>年龄</th>
            <th>性别</th>
            <th>身高(cm)</th>
            <th>体重(kg)</th>
            <th>BMI</th>
            <th>健康状况</th>
            <th>操作</th>
        </tr>
        <%-- 遍历学生列表 --%>
        <% for (Students s : students) { %>
        <tr>
            <td><%= s.getId() %></td>
            <td><%= s.getName() %></td>
            <td><%= s.getAge() %></td>
            <td><%= s.getGender() %></td>
            <td><%= s.getHeight() %></td>
            <td><%= s.getWeight() %></td>
            <td><%= String.format("%.1f", s.getBmi()) %></td>
            <td><%= s.getHealth_status() %></td>
            <td>
                <%-- 编辑链接：传递学生ID --%>
                <a href="edit_student.jsp?id=<%= s.getId() %>">编辑</a>
                <%-- 删除链接：传递学生ID --%>
                <a href="delete_student.jsp?id=<%= s.getId() %>">删除</a>
            </td>
        </tr>
        <% } %>
    </table>
</body>
</html>
```

---

### 添加学生页面 (add_student.jsp)

```jsp
<%@ page
    language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加学生</title>
</head>
<body>
    <h1>添加学生</h1>
    <form action="add_student_action.jsp" method="post">
        <%-- required属性：HTML5客户端验证 --%>
        姓名: <input type="text" name="name" required><br>
        年龄: <input type="number" name="age" required><br>
        性别:
        <select name="gender">
            <option value="男">男</option>
            <option value="女">女</option>
        </select><br>
        身高(cm): <input type="number" name="height" step="0.1" required><br>
        体重(kg): <input type="number" name="weight" step="0.1" required><br>
        <input type="submit" value="添加">
    </form>
    <br><a href="index.jsp">返回首页</a>
</body>
</html>
```

---

### 添加处理Action (add_student_action.jsp)

```jsp
<%@ page
    language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.example.Students, com.example.StudentDAO" %>

<%
    // 1. 设置请求编码
    request.setCharacterEncoding("UTF-8");

    // 2. 获取表单参数
    // 注意：所有参数都是String类型，需要转换
    String name = request.getParameter("name");
    int age = Integer.parseInt(request.getParameter("age"));              // String → int
    String gender = request.getParameter("gender");
    double height = Double.parseDouble(request.getParameter("height"));    // String → double
    double weight = Double.parseDouble(request.getParameter("weight"));    // String → double

    // 3. 创建实体对象
    Students student = new Students();
    student.setName(name);
    student.setAge(age);
    student.setGender(gender);
    student.setHeight(height);
    student.setWeight(weight);

    // 4. 调用DAO添加学生
    StudentDAO studentDAO = new StudentDAO();
    boolean success = studentDAO.addStudent(student);

    // 5. 根据结果跳转
    if (success) {
        // 重定向到首页（避免表单重复提交）
        response.sendRedirect("index.jsp");
    } else {
        out.println("添加失败");
    }
%>
```

**表单重复提交问题：**

使用重定向而非转发，可以避免表单重复提交：

```
表单提交流程：
1. 用户提交表单到 add_student_action.jsp
2. 处理数据，执行重定向 response.sendRedirect("index.jsp")
3. 浏览器收到重定向响应，访问 index.jsp
4. 用户刷新 index.jsp 不会导致表单重复提交

错误方式（使用转发）：
1. 用户提交表单到 add_student_action.jsp
2. 处理数据，转发到 index.jsp
3. 用户刷新页面会重新提交表单！
```

---

### MVC+DAO模式特点

| 特点 | 说明 |
|------|------|
| **分层清晰** | View、Controller、Model三层分离 |
| **接口规范** | IBookDAO定义操作规范，便于扩展 |
| **工具封装** | DBUtil统一管理数据库连接 |
| **业务逻辑** | Students类包含BMI计算逻辑 |
| **完整CRUD** | 实现增删改查完整功能 |
| **易于扩展** | 新功能只需添加DAO方法 |

---

## 总结

### 技术演进历程

```
ch07_3 ──────────────────────> JSP脚本模式
    │                              │
    │ 抽取业务逻辑                  ↓
ch07_5 ──────────────────────> JavaBean模式
    │                              │
    │ 引入Servlet                  ↓
ch07_7 ──────────────────────> Servlet模式
    │                              │
    │ 分离数据访问层                ↓
ch07_9 ──────────────────────> 分层模式
    │                              │
    │ 完整MVC+DAO                  ↓
ch07_11 ─────────────────────> MVC+DAO完整模式
```

### 各层职责总结

| 层次 | 组件 | 职责 |
|------|------|------|
| **View** | JSP页面 | 用户界面展示 |
| **Controller** | Servlet/*_action.jsp | 请求处理、页面跳转 |
| **Model-实体类** | Students/User | 数据封装、业务逻辑 |
| **Model-DAO** | StudentDAO | 数据库操作 |
| **Model-工具类** | DBUtil | 公共功能封装 |

### 最佳实践建议

1. **保持单一职责**：每层只做自己的事情
2. **面向接口编程**：使用接口定义规范
3. **资源及时释放**：使用try-finally或try-with-resources
4. **异常处理**：分层处理，上层捕获下层异常
5. **代码复用**：抽取公共代码到工具类
6. **防御性编程**：对输入参数进行校验
7. **防止SQL注入**：始终使用参数化查询

---

### 常见问题与解决方案

#### 1. 中文乱码问题

```java
// 请求编码
request.setCharacterEncoding("UTF-8");

// 响应编码
response.setContentType("text/html; charset=UTF-8");

// 数据库连接URL
jdbc:mysql://host:3306/db?useUnicode=true&characterEncoding=utf8

// JSP页面编码
<%@ page pageEncoding="UTF-8" %>
<meta charset="UTF-8">
```

#### 2. 数据库连接泄漏

```java
// 正确：在finally中关闭
finally {
    DBUtil.close(conn, pstmt, rs);
}

// 推荐：使用连接池（如HikariCP）
```

#### 3. 表单重复提交

```java
// 使用重定向
response.sendRedirect("success.jsp");

// 或使用PRG模式（Post-Redirect-Get）
```

#### 4. SQL注入

```java
// 错误：字符串拼接
String sql = "SELECT * FROM users WHERE name='" + name + "'";

// 正确：参数化查询
String sql = "SELECT * FROM users WHERE name=?";
pstmt.setString(1, name);
```

---

*文档生成时间: 2026-01-05*
*最后更新时间: 2026-01-05*
