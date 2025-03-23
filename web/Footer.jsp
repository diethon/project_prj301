<%-- 
    Document   : Footer
    Created on : Mar 9, 2025, 10:20:05 PM
    Author     : 84395
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Footer</title>
    <link rel="stylesheet" href="css/footer.css">
   
</head>

<body>
    <footer>
        <div class="footer-container">
            <div class="footer-column">
                <img src="<%= request.getContextPath() %>/img/logo.png" alt="MEDIC Logo">
                <p>Here you’ll be able to find everything you need for proper health care, including the latest inventions in this field. Lift chairs, scooters, wheelchairs and transport chairs, walkers and rollators, canes and crutches, all kinds of mobility equipment.</p>
            </div>

            <div class="footer-column">
                <h3>CATEGORIES</h3>
                <a href="#">Combination Deals</a>
                <a href="#">Dental Supplies</a>
                <a href="#">Diabetic</a>
                <a href="#">Diagnostic Supplies</a>
                <a href="#">Surgical Equipment</a>
            </div>

            <div class="footer-column">
                <h3>INFORMATION</h3>
                <a href="#">About Us</a>
                <a href="#">New Products</a>
                <a href="#">Contact Us</a>
                <a href="#">Sitemap</a>
                <a href="#">Top Sellers</a>
            </div>

            <div class="footer-column">
                <h3>YOUR ACCOUNT</h3>
                <a href="#">Personal Info</a>
                <a href="#">Orders</a>
                <a href="#">Credit Slips</a>
                <a href="#">Addresses</a>
                <a href="#">My Wishlist</a>
            </div>

            <div class="footer-column contact">
                <h3>CONTACTS</h3>
                <p>SmartCare</p>
                <p>Viet Nam</p>
                <a href="tel:80023456789">800-2345-6789</a>
                <a href="mailto:demo@demo.com">demo@demo.com</a>
            </div>
        </div>
    </footer>

    <p class="copyright">&copy; 2025 Ecommerce software by Truong Thon - FPTU</p>
</body>

</html>

