<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SmartCare</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
        <link href="css/productDetail.css" rel="stylesheet">
        <link rel="Website Icon " type="png" href="img/logo.png">

        <script>
            let currentImageIndex = 0; // Lưu trữ chỉ số ảnh hiện tại
            let images = []; // Mảng chứa tất cả các URL ảnh

            // Hàm thay đổi ảnh lớn khi nhấn vào ảnh nhỏ
            function changeImage(thumbnail, imageUrl, index) {
                currentImageIndex = index; // Cập nhật chỉ số ảnh hiện tại
                var mainImage = document.getElementById("mainImage");
                mainImage.src = imageUrl; // Cập nhật ảnh lớn
                var thumbnails = document.querySelectorAll(".thumbnail");
                thumbnails.forEach(function (thumb) {
                    thumb.classList.remove("active"); // Xóa lớp "active" của tất cả ảnh nhỏ
                });
                thumbnail.classList.add("active"); // Thêm lớp "active" cho ảnh đã nhấn
            }

            // Hàm chuyển đến ảnh tiếp theo
            function nextImage() {
                currentImageIndex = (currentImageIndex + 1) % images.length; // Chuyển đến ảnh tiếp theo (quay lại từ đầu nếu đến cuối)
                changeImage(document.querySelectorAll(".thumbnail")[currentImageIndex], images[currentImageIndex], currentImageIndex);
            }

            // Hàm chuyển đến ảnh trước
            function prevImage() {
                currentImageIndex = (currentImageIndex - 1 + images.length) % images.length; // Chuyển đến ảnh trước (quay lại từ cuối nếu ở đầu)
                changeImage(document.querySelectorAll(".thumbnail")[currentImageIndex], images[currentImageIndex], currentImageIndex);
            }

            // Hàm khởi tạo mảng ảnh khi tải trang
            window.onload = function () {
                var thumbnailImages = document.querySelectorAll(".thumbnail img");
                thumbnailImages.forEach(function (img, index) {
                    images.push(img.src); // Lưu các URL ảnh vào mảng
                    if (index === 0) {
                        img.parentNode.classList.add("active"); // Thêm lớp active cho ảnh đầu tiên
                    }
                });
                changeImage(document.querySelector(".thumbnail.active"), images[0], 0); // Đặt ảnh đầu tiên làm ảnh lớn khi tải trang
            }
        </script>
    </head>
    <body>

        <jsp:include page="Header.jsp"></jsp:include>

            <div class="container mt-5 mb-5">
                <div class="row">
                    <div class="col-md-6">
                        <div class="product-gallery">
                            <div class="main-image">
                                <!-- Thêm nút Next và Previous trên ảnh lớn -->
                                <button class="prev-btn" onclick="prevImage()">
                                    <i class="fa fa-chevron-left"></i>
                                </button>
                                <img src="${product.imageUrl}" alt="${product.nameProduct}" id="mainImage">
                            <button class="next-btn" onclick="nextImage()">
                                <i class="fa fa-chevron-right"></i>
                            </button>
                        </div>
                        <div class="thumbnail-gallery">
                            <c:forEach var="image" items="${productImages}" varStatus="status">
                                <div class="thumbnail ${status.index == 0 ? 'active' : ''}" onclick="changeImage(this, '${image.imageUrl}', ${status.index})">
                                    <img src="${image.imageUrl}" alt="${product.nameProduct} view ${status.index + 1}">
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <h1 class="product-title">${product.nameProduct}</h1>
                    <div class="product-price">
                        <c:if test="${product.discountId != null && product.discountId.discountPercent != null && product.discountId.discountPercent > 0}">
                            <span style="color: #12afa3"><fmt:formatNumber value="${product.price}" pattern="#,### VND" /></span><br>
                        </c:if>
                    </div>

                    <div class="product-meta">
                        <p><strong>SKU:</strong> ${product.sku}</p>
                        <p><strong>Xuất xứ:</strong> ${product.originId.nameCountry}</p>
                    </div>

                    <div class="product-description">
                        <p style="color: black"><strong>Mô tả sản phẩm: </strong>${product.description}</p>
                    </div>

                    <div class="product-ingredients">
                        <p><strong>Thành phần: </strong>${product.ingredient}</p>
                    </div>

                    <form action="carts" method="post" class="d-flex align-items-center mt-4">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <div class="form-group mb-0 mr-3">
                            <label for="quantity" class="mr-2">Số lượng:
                                <input type="number" id="quantity" name="quantity" value="1" min="1" class="form-control quantity-input">
                            </label>
                            <button type="button" class="btn" id="decreaseQty">
                                <i class="fa fa-minus"></i>
                            </button>
                            <button type="button" class="btn" id="increaseQty">
                                <i class="fa fa-plus"></i>
                            </button>
                        </div>
                        <input type="hidden" name="action" value="add">
                        <button type="submit" class="btn btn-primary btn-lg mt-3">
                            <i class="fa fa-shopping-cart"></i> Thêm vào giỏ hàng
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="Footer.jsp"></jsp:include>
</body>

<script>
    const quantityInput = document.getElementById("quantity");
    const increaseBtn = document.getElementById("increaseQty");
    const decreaseBtn = document.getElementById("decreaseQty");
    
    increaseBtn.addEventListener("click", function () {
        let quantity = parseInt(quantityInput.value);
        quantityInput.value = quantity + 1;  // Tăng số lượng
    });

    decreaseBtn.addEventListener("click", function () {
        let quantity = parseInt(quantityInput.value);
        if (quantity > 1) {
            quantityInput.value = quantity - 1;  // Giảm số lượng nếu lớn hơn 1
        }
    });
    
</script>
</html>
