package com.ebookBuy.sevlet;

import com.ebookBuy.dao.BookManageDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;

/**
 * 典籍文件下载Servlet（最终修复版）
 * 强制下载不打开 + 自动统计下载次数 + 中文文件名支持
 */
@WebServlet("/fileDownload")
public class FileDownloadServlet extends HttpServlet {

    private final BookManageDao bookManageDao = new BookManageDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String bookIdStr = request.getParameter("bookId");
        String filePath = request.getParameter("filePath");

        // 参数校验
        if (bookIdStr == null || filePath == null || filePath.trim().isEmpty()) {
            returnError(response, "参数错误：缺少典籍ID或文件路径");
            return;
        }

        // 适配数据库bigint类型
        Long bookId;
        try {
            bookId = Long.parseLong(bookIdStr);
        } catch (NumberFormatException e) {
            returnError(response, "典籍ID无效");
            return;
        }

        filePath = filePath.trim();
        String relativePath = filePath.startsWith("/") ? filePath.substring(1) : filePath;
        String realRootPath = getServletContext().getRealPath("/");
        File file = new File(realRootPath, relativePath);

        // 文件存在校验
        if (!file.exists() || !file.isFile()) {
            returnError(response, "文件不存在：" + filePath);
            return;
        }

        // 处理中文文件名乱码
        String fileName = file.getName();
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");

        // 强制浏览器下载而不是打开
        response.reset();
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment;filename*=UTF-8''" + encodedFileName);
        response.setContentLength((int) file.length());
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        // 流式下载大文件不占内存
        try (InputStream in = new BufferedInputStream(new FileInputStream(file));
             OutputStream out = new BufferedOutputStream(response.getOutputStream())) {

            byte[] buffer = new byte[8192];
            int len;
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
            out.flush();

            // 只有完全下载成功才更新传阅次数
            bookManageDao.increaseDownloadTimes(Math.toIntExact(bookId));

        } catch (Exception e) {
            // 用户取消下载不更新次数
            e.printStackTrace();
        }
    }

    // 返回JSON错误信息
    private void returnError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String json = "{\"success\":false,\"message\":\"" + message.replace("\"", "\\\"") + "\"}";
        response.getWriter().write(json);
    }
}