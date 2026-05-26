package com.ebookBuy.sevlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * 通用文件上传Servlet（最终修复版）
 * 适配你的images目录 + 文件名不超过数据库100字符限制
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB 内存阈值
        maxFileSize = 1024 * 1024 * 10,   // 单个文件最大10MB
        maxRequestSize = 1024 * 1024 * 50 // 单次请求总大小最大50MB
)
@WebServlet("/fileUpload")
public class FileUploadServlet extends HttpServlet {

    // 允许上传的文件类型白名单
    private static final Map<String, List<String>> ALLOWED_TYPES = new HashMap<>();
    static {
        ALLOWED_TYPES.put("image", Arrays.asList(
                "image/jpeg", "image/png", "image/gif", "image/webp",
                ".jpg", ".jpeg", ".png", ".gif", ".webp"
        ));
        ALLOWED_TYPES.put("document", Arrays.asList(
                "application/pdf", "application/epub+zip", "text/plain",
                ".pdf", ".epub", ".txt"
        ));
    }

    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;
    private static final int MAX_FILE_COUNT = 5;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String uploadType = request.getParameter("type") == null ? "image" : request.getParameter("type");
        List<String> allowedList = ALLOWED_TYPES.get(uploadType);
        if (allowedList == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"不支持的上传类型\"}");
            return;
        }

        Collection<Part> parts = request.getParts();
        List<String> successPaths = new ArrayList<>();
        List<String> errorMessages = new ArrayList<>();
        int fileCount = 0;

        String saveRootPath = getServletContext().getRealPath("/");

        for (Part part : parts) {
            if (part.getSize() == 0 || part.getSubmittedFileName() == null) {
                continue;
            }

            fileCount++;
            if (fileCount > MAX_FILE_COUNT) {
                errorMessages.add("最多只能上传" + MAX_FILE_COUNT + "个文件");
                break;
            }

            if (part.getSize() > MAX_FILE_SIZE) {
                errorMessages.add("文件「" + part.getSubmittedFileName() + "」超过最大限制10MB");
                continue;
            }

            String fileName = part.getSubmittedFileName();
            String fileExt = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            String contentType = part.getContentType();

            if (!allowedList.contains(contentType) || !allowedList.contains(fileExt)) {
                errorMessages.add("文件「" + fileName + "」类型不允许");
                continue;
            }

            // ✅ 修复1：极简唯一文件名（总长度<30，绝对不会被数据库截断）
            String uniqueFileName = System.currentTimeMillis() + "_"
                    + String.format("%06d", new Random().nextInt(999999))
                    + fileExt;

            // ✅ 修复2：适配你的现有目录，图片存images，文件存files
            String saveDir = uploadType.equals("image") ? "images/" : "files/";
            String fullSavePath = saveRootPath + saveDir;
            File saveDirFile = new File(fullSavePath);
            if (!saveDirFile.exists()) {
                saveDirFile.mkdirs(); // 自动创建缺失目录
            }

            try {
                part.write(fullSavePath + uniqueFileName);
                successPaths.add("/" + saveDir + uniqueFileName);
            } catch (Exception e) {
                errorMessages.add("文件「" + fileName + "」上传失败：" + e.getMessage());
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", errorMessages.isEmpty());
        result.put("paths", successPaths);
        result.put("message", errorMessages.isEmpty() ? "上传成功" : String.join("；", errorMessages));

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":").append(result.get("success")).append(",");
        json.append("\"paths\":").append(listToJsonArray(successPaths)).append(",");
        json.append("\"message\":\"").append(result.get("message").toString().replace("\"", "\\\"")).append("\"");
        json.append("}");

        response.getWriter().write(json.toString());
    }

    private String listToJsonArray(List<String> list) {
        if (list.isEmpty()) return "[]";
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(list.get(i).replace("\"", "\\\"")).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }
}