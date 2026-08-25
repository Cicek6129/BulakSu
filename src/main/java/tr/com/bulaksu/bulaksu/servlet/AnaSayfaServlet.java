package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.SubeDAO;

import java.io.IOException;

@WebServlet(urlPatterns = {"/anasayfa"})
public class AnaSayfaServlet extends HttpServlet {
    private final SubeDAO subeDAO = new SubeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("subeler", subeDAO.findAktifSubeler());
        request.getRequestDispatcher("/WEB-INF/jsp/index.jsp").forward(request, response);
    }
}
