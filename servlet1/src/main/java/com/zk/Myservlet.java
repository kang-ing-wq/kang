package com.zk;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
@WebServlet("/myServlet")
//@WebServlet(urlPatterns = {"/myServlet1", "/myServlet2"})
public class Myservlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
//        System.out.println("name:偷吃了pantao"+name);
        response.getWriter().write("hello 我被访问了"+name);

        request.getRequestDispatcher("majiaqi.jsp?name="+name).forward(request,response);
    }
    public void init() throws ServletException {
        System.out.println("*****************init");
    }
}
