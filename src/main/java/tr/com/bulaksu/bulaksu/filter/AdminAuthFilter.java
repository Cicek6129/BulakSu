package tr.com.bulaksu.bulaksu.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin", "/admin/*"})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        if (requestURI.equals(contextPath + "/giris") ||
            requestURI.equals(contextPath + "/admin/giris") ||
            requestURI.equals(contextPath + "/admin/cikis") ||
            requestURI.startsWith(contextPath + "/css/") ||
            requestURI.startsWith(contextPath + "/images/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // CSS ve statik dosyaları da filtre dışı bırak
        if (requestURI.endsWith(".css") || requestURI.endsWith(".js") || 
            requestURI.endsWith(".png") || requestURI.endsWith(".jpg") ||
            requestURI.endsWith(".ico")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Session kontrolü
        HttpSession session = httpRequest.getSession(false);
        
        if (session != null && session.getAttribute("kullanici") != null) {
            tr.com.bulaksu.bulaksu.entity.Kullanici k = (tr.com.bulaksu.bulaksu.entity.Kullanici) session.getAttribute("kullanici");
            if ("ADMIN".equals(k.getRol())) {
                // Giriş yapmış ve Admin - devam et
                chain.doFilter(request, response);
                return;
            }
        }
        
        // Giriş yapmamış veya Admin değil - login sayfasına yönlendir
        httpResponse.sendRedirect(contextPath + "/giris");
    }

    @Override
    public void destroy() {
        // Cleanup
    }
}
