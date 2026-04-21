package com.zk;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintStream;

@WebServlet("*.do")
public class Xyj2Servlet  extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        System.setOut(new PrintStream(System.out, true, "UTF-8"));
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        System.out.println("脑袋有项圈的，都是唐僧的弟子");
    }
}
