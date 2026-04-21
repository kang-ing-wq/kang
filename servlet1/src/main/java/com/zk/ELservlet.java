package com.zk;

import com.pojo.Person;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintStream;

@WebServlet("/elservlet")
public class ELservlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        System.setOut(new PrintStream(System.out, true, "UTF-8"));
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");


        String sz = req.getParameter("name");
//        req.setAttribute("name",sz);
        req.getSession().setAttribute("name", sz);


        Person p = new  Person();
        p.setName("杨幂");
        p.setAge(18);
        req.setAttribute("p",p);

        System.out.println("----"+sz);
        req.getRequestDispatcher("sz.jsp").forward(req,resp);

    }
}
