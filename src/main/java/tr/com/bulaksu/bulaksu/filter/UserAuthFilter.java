package tr.com.bulaksu.bulaksu.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Giriş yapmamış kullanıcıların anasayfa, ürünler, sepet ve sipariş
 * sayfalarına erişimini engeller. Giriş sayfasına yönlendirir.
 */
@WebFilter(urlPatterns = {"/anasayfa", "/urunler", "/sepet", "/siparis"})
public class UserAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Session kontrolü — giriş yapmış mı?
        HttpSession session = httpRequest.getSession(false);

        if (session != null && session.getAttribute("kullanici") != null) {
            // Giriş yapmış — devam et
            chain.doFilter(request, response);
        } else {
            // Giriş yapmamış — login sayfasına yönlendir
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/giris");
        }
    }

    @Override
    public void destroy() {
        // Cleanup
    }
}
