package com.zk;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
@WebServlet("/helloServlet")
public class HolleServlet implements Servlet {
    @Override
    public void init(ServletConfig servletConfig) throws ServletException {
        //只调用一次
        System.out.println("***this is init ok????????***");
    }

    @Override
    public ServletConfig getServletConfig() {
        return null;
    }

    @Override
	public void service(ServletRequest req, ServletResponse res) throws ServletException, IOException {
        // 1. 先设置请求编码（处理 POST 乱码）
        req.setCharacterEncoding("UTF-8");
        // 2. 再设置响应编码（处理 浏览器/控制台 乱码）
        res.setContentType("text/html;charset=UTF-8");
        System.out.println("实现接口的方法jiekokoko---darenla,darenla");
    }

    @Override
    public String getServletInfo() {
        return "";
    }

    @Override
    public void destroy() {
        System.out.println("game over!!!");
    }

}
