//package filter;
//
//import java.io.IOException;
//import jakarta.servlet.Filter;
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.FilterConfig;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.ServletRequest;
//import jakarta.servlet.ServletResponse;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//public class AuthorizationFilter implements Filter {
//
//     @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//        HttpSession session = req.getSession(false);
//
//        String role = (session != null) ? (String) session.getAttribute("role") : null;
//        String path = req.getRequestURI();
//        
//         if (role == null && !path.endsWith("home.jsp") && !path.endsWith("/home")) {
//            res.sendRedirect(req.getContextPath() + "/home.jsp");
//            return;
//        }
//
//        if ("user".equals(role) && path.contains("/users")) {
//            res.sendRedirect(req.getContextPath() + "/home.jsp");
//            return;
//        }
//
//        chain.doFilter(request, response); 
//    }
//
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {}
//
//    @Override
//    public void destroy() {}
//}
