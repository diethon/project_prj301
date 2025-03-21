    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><c:if test="${product != null}">Chỉnh sửa sản phẩm</c:if><c:if test="${product == null}">Thêm sản phẩm</c:if></title>
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        </head>
        <body>
            <div class="container mt-4">
                <h2 class="text-center">
                <c:if test="${product != null}">Chỉnh sửa sản phẩm</c:if>
                <c:if test="${product == null}">Thêm sản phẩm</c:if>
                </h2>

            <c:if test="${errorMessage != null}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <form action="products" method="post">
                <input type="hidden" name="action" value="${product != null ? 'update' : 'insert'}">
                <c:if test="${product != null}">
                    <input type="hidden" name="id" value="${product.productId}">
                </c:if>

                <!-- Tên sản phẩm -->
                <div class="form-group">
                    <label>Tên sản phẩm</label>
                    <input type="text" name="nameProduct" class="form-control" value="${product.nameProduct}" required>
                </div>

                <!-- Mô tả sản phẩm -->
                <div class="form-group">
                    <label>Mô tả</label>
                    <textarea name="description" class="form-control">${product.description}</textarea>
                </div>

                <!-- SKU -->
                <div class="form-group">
                    <label>SKU</label>
                    <input type="text" name="sku" class="form-control" value="${product.sku}" required>
                </div>

                <!-- Giá -->
                <div class="form-group">
                    <label>Giá</label>
                    <input type="number" step="0.01" name="price" class="form-control" value="${product.price}" required>
                </div>

                <!-- Thành phần -->
                <div class="form-group">
                    <label>Thành phần</label>
                    <input type="text" name="ingredient" class="form-control" value="${product.ingredient}">
                </div>

                <!-- Trạng thái -->
                <div class="form-group">
                    <label>Trạng thái</label>
                    <input type="checkbox" name="state" ${product.state ? 'checked' : ''}>
                    Còn hàng
                </div>

                <!-- Danh mục sản phẩm -->
                <div class="form-group">
                    <label>Danh mục</label>
                    <select name="categoryId" class="form-control">
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryId}" ${category.categoryId == product.categoryId.categoryId ? 'selected' : ''}>
                                ${category.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Giảm giá -->
                <div class="form-group">
                    <label>Giảm giá</label>
                    <select name="discountId" class="form-control">
                        <!-- Thêm tùy chọn từ 0% - 100% với khoảng cách 10% -->
                        <c:forEach var="i" begin="0" end="100" step="10">
                            <option value="${i}" ${i == product.discountId.discountPercent ? 'selected' : ''}>
                                ${i}%
                            </option>
                        </c:forEach>

                        <!-- Danh sách giảm giá từ database -->
                        <c:forEach var="discount" items="${discounts}">
                            <option value="${discount.discountId}" ${discount.discountId == product.discountId.discountId ? 'selected' : ''}>
                                ${discount.discountPercent}%
                            </option>
                        </c:forEach>
                    </select>
                </div>





                <!-- Kho hàng -->
                <option value="${inventory.inventoryId}" ${inventory.inventoryId == product.productInventory.inventoryId ? 'selected' : ''}>
                    ${inventory.inventoryName}
                </option>


                <!-- Xuất xứ -->
                <div class="form-group">
                    <label>Xuất xứ</label>
                    <select name="originId" class="form-control">
                        <c:forEach var="origin" items="${origins}">
                            <option value="${origin.originId}" ${origin.originId == product.originId.originId ? 'selected' : ''}>
                                ${origin.nameCountry}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Nút Submit -->
                <button type="submit" class="btn btn-success">
                    <c:if test="${product != null}">Cập nhật</c:if>
                    <c:if test="${product == null}">Thêm</c:if>
                </button>

                <a href="products?action=list" class="btn btn-secondary">Hủy</a>
            </form>
        </div>
    </body>
</html>
