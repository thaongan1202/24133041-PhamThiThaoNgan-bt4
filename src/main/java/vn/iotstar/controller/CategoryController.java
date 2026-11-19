package vn.iotstar.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.util.Constant;

@MultipartConfig
@WebServlet(urlPatterns = { "/admin/categories", "/admin/category/add", "/admin/category/insert",
        "/admin/category/edit", "/admin/category/update", "/admin/category/delete" })
public class CategoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ICategoryService cateService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String url = req.getRequestURI();

        if (url.contains("/admin/categories")) {
            List<Category> list = cateService.findAll();
            req.setAttribute("listcate", list);
            req.getRequestDispatcher("/views/admin/category-list.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/add")) {
            req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/edit")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Category category = cateService.findById(id);
            req.setAttribute("cate", category);
            req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/delete")) {
            int id = Integer.parseInt(req.getParameter("id"));
            try {
                Category category = cateService.findById(id);
                cateService.delete(id);
                if (category != null) {
                    deleteOldFile(category.getImages());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/admin/category/insert")) {
            String categoryname = req.getParameter("categoryname");
            int status = Integer.parseInt(req.getParameter("status"));
            String link = req.getParameter("images");

            Category category = new Category();
            category.setCategoryname(categoryname);
            category.setStatus(status);

            String uploaded = saveUpload(req);
            if (uploaded != null) {
                category.setImages(uploaded);
            } else if (link != null && !link.isBlank()) {
                category.setImages(link.trim());
            } else {
                category.setImages("avatar.png");
            }

            cateService.insert(category);
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        } else if (url.contains("/admin/category/update")) {
            int categoryid = Integer.parseInt(req.getParameter("categoryid"));
            String categoryname = req.getParameter("categoryname");
            String error = validateCategory(categoryname, req.getParameter("status"));
            if (error != null) {
                req.setAttribute("cate", cateService.findById(categoryid));
                req.setAttribute("error", error);
                req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
                return;
            }
            int status = Integer.parseInt(req.getParameter("status"));
            String link = req.getParameter("images");

            Category category = cateService.findById(categoryid);
            String fileOld = category.getImages();
            category.setCategoryname(categoryname);
            category.setStatus(status);

            String uploaded = saveUpload(req);
            if (uploaded != null) {
                deleteOldFile(fileOld);
                category.setImages(uploaded);
            } else if (link != null && !link.isBlank()) {
                category.setImages(link.trim());
            }

            cateService.update(category);
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    private String saveUpload(HttpServletRequest req) throws IOException, ServletException {
        Part part = req.getPart("images1");
        if (part == null || part.getSize() == 0) {
            return null;
        }
        File uploadDir = new File(Constant.DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String ext = filename.substring(filename.lastIndexOf('.') + 1);
        String fname = System.currentTimeMillis() + "." + ext;
        part.write(Constant.DIR + File.separator + fname);
        return fname;
    }

    private void deleteOldFile(String fileName) throws IOException {
        if (fileName != null && !fileName.startsWith("https")) {
            Files.deleteIfExists(Paths.get(Constant.DIR, fileName));
        }
    }
    
    private String validateCategory(String name, String status) {
        if (name == null || name.trim().isEmpty()) return "Tên danh mục không được để trống";
        if (name.trim().length() > 255) return "Tên danh mục tối đa 255 ký tự";
        if (!"0".equals(status) && !"1".equals(status)) return "Trạng thái không hợp lệ";
        return null;
    }
}