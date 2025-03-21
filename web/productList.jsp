<%@ page import="model.Products" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    // Lấy số sản phẩm mỗi trang
    int pageSize = 8;
    // Lấy trang hiện tại từ request (nếu không có thì mặc định là trang 1)
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;

    // Lấy danh sách sản phẩm từ request
    List<Products> products = (List<Products>) request.getAttribute("products");

    // Kiểm tra nếu products là null, gán thành danh sách rỗng
    if (products == null) {
        products = new java.util.ArrayList<Products>();
    }

    // Tổng số sản phẩm
    int totalProducts = products.size();
    // Tính tổng số trang
    int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

    // Tính toán chỉ số bắt đầu và kết thúc
    int start = (currentPage - 1) * pageSize;
    int end = Math.min(start + pageSize, totalProducts);  // Không vượt quá tổng số sản phẩm

    // Lấy danh sách sản phẩm cho trang hiện tại
    List<Products> paginatedProducts = products.subList(start, end);
    request.setAttribute("products", paginatedProducts); // Cập nhật danh sách sản phẩm cho trang hiện tại
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("currentPage", currentPage);
%>


<link rel="stylesheet" href="css/index.css"/>

<div class="container mt-4">
    <div class="row">
        <div class="col-12">
            <c:if test="${not empty categoryTitle}">
                <h2 class="category-title">${categoryTitle}</h2>
            </c:if>

            <c:if test="${empty categoryTitle}">
                <h2 class="category-title">Sản phẩm nổi bật</h2>
            </c:if>

            <!-- Hiển thị tất cả sản phẩm -->
            <div class="row">
                <c:forEach var="product" items="${products}">
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-4">

                        <a href="<%= request.getContextPath()%>/productDetail?id=${product.productId}" class="pl">
                            <div class="card shadow-sm product-card">
                                <img class="card-img-top" src="${product.imageUrl}" alt="${product.nameProduct}">
                                <div class="card-body">
                                    <h5 class="card-title">${product.nameProduct}</h5>
                                    <div class="price">
                                        <fmt:formatNumber value="${product.price}" pattern="#,### VND" />
                                    </div>

                                    <div class="row"> 
                                        <div class="col">
                                            <!-- Form Thêm vào Giỏ -->
                                            <form action="carts" method="POST" class="add-to-cart">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="productId" value="${product.productId}">
                                                <input type="hidden" name="quantity" value="1" min="1" style="width: 50px; text-align: center;">
                                                <button type="submit" class="btn btn-success btn-block">Thêm vào Giỏ</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty products}">
                <div class="col-12">
                    <div class="alert alert-info">Không tìm thấy sản phẩm nào.</div>
                </div>
            </c:if>

            <!-- Kiểm tra nếu là trang danh mục -->
            <c:if test="${ isHomePage}">
                <!-- Hiển thị phân trang cho trang chủ -->
                <div class="pagination-container text-center mt-4">
                    <c:if test="${currentPage > 1}">
                        <!-- Liên kết phân trang Previous cho trang chủ -->
                        <a href="?page=${currentPage - 1}" class="pagination-link">Previous</a>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <!-- Liên kết phân trang cho trang chủ -->
                        <a href="?page=${i}" class="pagination-link ${i == currentPage ? 'active' : ''}">${i}</a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <!-- Liên kết phân trang Next cho trang chủ -->
                        <a href="?page=${currentPage + 1}" class="pagination-link">Next</a>
                    </c:if>
                </div>
            </c:if>

            <!-- Kiểm tra nếu là trang danh mục -->
            <c:if test="${not isHomePage}">
                <!-- Hiển thị phân trang cho trang danh mục -->
                <div class="pagination-container text-center mt-4">
                    <c:if test="${currentPage > 1}">
                        <!-- Liên kết phân trang Previous với categoryId -->
                        <a href="?id=${category.categoryId}&page=${currentPage - 1}" class="pagination-link">Previous</a>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <!-- Liên kết phân trang với categoryId -->
                        <a href="?id=${category.categoryId}&page=${i}" class="pagination-link ${i == currentPage ? 'active' : ''}">${i}</a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <!-- Liên kết phân trang Next với categoryId -->
                        <a href="?id=${category.categoryId}&page=${currentPage + 1}" class="pagination-link">Next</a>
                    </c:if>
                </div>
            </c:if>



        </div>
    </div>
</div>
