<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BulakSu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Bulletproof CSS include -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=6">
</head>
<body class="kiosk-body">
    <header class="kiosk-header">
        <div class="logo-group">
            <span class="logo-mark" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="9" cy="21" r="1"></circle>
                    <circle cx="19" cy="21" r="1"></circle>
                    <path d="M2 3h2l2.6 12.4a2 2 0 0 0 2 1.6h9.8a2 2 0 0 0 2-1.6L22 7H6"></path>
                </svg>
            </span>
            <span class="logo-text">BulakSu</span>
        </div>
        <div style="display: flex; align-items: center; gap: 1rem;">
            <c:choose>
                <c:when test="${not empty sessionScope.kullanici}">
                    <span style="font-size: 0.9rem; font-weight: 500; color: #11594F;">
                        Hoş geldin, ${sessionScope.kullanici.rol == 'ADMIN' ? 'Sistem Yöneticisi' : sessionScope.kullanici.adSoyad}
                    </span>
                    <c:if test="${sessionScope.kullanici.rol == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin" class="admin-login-link">
                            Admin Paneli
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/cikis" class="admin-login-link" style="color: #dc2626; border-color: rgba(220,38,38,0.2); background: rgba(220,38,38,0.05);">
                        Çıkış Yap
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/giris" class="admin-login-link">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:16px;height:16px;">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        Giriş Yap
                    </a>
                </c:otherwise>
            </c:choose>
            
            <a href="${pageContext.request.contextPath}/sepet" style="position: relative; display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; background-color: #f1f5f9; border-radius: 50%; color: #11594F; text-decoration: none; transition: background-color 0.2s;" title="Sepete Git">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 20px; height: 20px;">
                    <circle cx="9" cy="21" r="1"></circle>
                    <circle cx="19" cy="21" r="1"></circle>
                    <path d="M2 3h2l2.6 12.4a2 2 0 0 0 2 1.6h9.8a2 2 0 0 0 2-1.6L22 7H6"></path>
                </svg>
                <span id="headerCartCount" style="display: none; position: absolute; top: -2px; right: -2px; background-color: #dc2626; color: white; border-radius: 50%; font-size: 0.65rem; font-weight: 700; width: 16px; height: 16px; align-items: center; justify-content: center;">0</span>
            </a>
        </div>
    </header>

    <main class="kiosk-main">

        <div class="kiosk-buttons">
            <button class="kiosk-btn kiosk-btn-servis" onclick="proceedToProducts('S')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M5 17h14M5 17a2 2 0 1 0 4 0M5 17a2 2 0 1 1 4 0m6 0a2 2 0 1 0 4 0m-4 0a2 2 0 1 1 4 0M3 17V9l2-5h9l3 5h2a2 2 0 0 1 2 2v6h-2M3 17h2M14 9V4"></path>
                </svg>
                <span>Servis</span>
            </button>

            <button class="kiosk-btn kiosk-btn-gelal" onclick="proceedToProducts('G')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 9l1.5-5h15L21 9M3 9v10a1 1 0 0 0 1 1h5v-6h6v6h5a1 1 0 0 0 1-1V9M3 9h18"></path>
                </svg>
                <span>Gel Al</span>
            </button>

            <button class="kiosk-btn kiosk-btn-toptan" onclick="proceedToProducts('T')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 8l-9-5-9 5 9 5 9-5Z"></path>
                    <path d="M3 8v8l9 5 9-5V8M12 13v8"></path>
                </svg>
                <span>Toptan</span>
            </button>
        </div>

        <%-- Zayi Butonu (Sadece Admin Görebilir) --%>
        <c:if test="${sessionScope.kullanici.rol == 'ADMIN'}">
            <div style="display: flex; justify-content: center; margin-top: 1rem; width: 100%; max-width: 900px; margin-left: auto; margin-right: auto;">
                <button class="kiosk-btn" style="background-color: #dc2626; color: white; width: 100%; max-width: 600px; min-height: 80px; flex-direction: row; gap: 1rem; border-radius: 12px; font-size: 1.5rem; padding: 1rem;" onclick="window.location.href='${pageContext.request.contextPath}/admin/zayi'">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:32px;height:32px;margin:0;">
                        <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                    </svg>
                    <span>Zayi (Fire) Düş</span>
                </button>
            </div>
        </c:if>

    </main>

    <!-- Floating Cart Bar — localStorage'dan okuyor -->
    <div class="floating-cart" id="floatingCart" style="display: none;">
        <div class="cart-info">
            <div style="display: flex; align-items: center; gap: 0.5rem;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#E1552B" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="9" cy="21" r="1"></circle>
                    <circle cx="20" cy="21" r="1"></circle>
                    <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                </svg>
                <span style="font-size: 0.95rem; font-weight: 600; color: #fff;" id="cartItemCount">0 Ürün</span>
            </div>
            <span class="cart-total" id="cartTotalText">₺0.00</span>
        </div>
        <button type="button" class="checkout-btn" onclick="window.location.href='<%= request.getContextPath() %>/sepet'">Sepete Git &rarr;</button>
    </div>

    <script>
        function proceedToProducts(tip) {
            window.location.href = '<%= request.getContextPath() %>/urunler?tip=' + tip;
        }

        // Ana sayfada sepet durumunu göster
        (function() {
            var CART_KEY = 'bulaksu_cart';
            var cart = [];
            try { cart = JSON.parse(localStorage.getItem(CART_KEY)) || []; } catch(e) {}
            
            if (cart.length > 0) {
                var cartDiv = document.getElementById('floatingCart');
                cartDiv.style.display = 'flex';
                var total = 0, count = 0;
                cart.forEach(function(item) {
                    total += (item.price * item.qty);
                    count += item.qty;
                });
                document.getElementById('cartItemCount').innerText = count + ' Ürün';
                document.getElementById('cartTotalText').innerText = '₺' + total.toFixed(2);
                
                var headerBadge = document.getElementById('headerCartCount');
                if (headerBadge) {
                    headerBadge.style.display = 'flex';
                    headerBadge.innerText = count;
                }
            }
        })();
    </script>
</body>
</html>
