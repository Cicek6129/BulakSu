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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=14">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/popup.css?v=1">
</head>
<body class="kiosk-body">
    <div class="kiosk-header-wrapper">
    <header class="kiosk-header">
        <div class="logo-group">
            <a href="${pageContext.request.contextPath == '' ? request.getContextPath() : pageContext.request.contextPath}/anasayfa" style="display: block; line-height: 0;">
                <img src="${pageContext.request.contextPath == '' ? request.getContextPath() : pageContext.request.contextPath}/images/logo.png" alt="BulakSu Logo" class="brand-logo" style="height: 40px; width: auto; object-fit: contain; max-width: 250px;">
            </a>
        </div>
        <div style="display: flex; align-items: center; gap: 1rem;">
            <c:set var="kullaniciSubeKilitli" value="${not empty sessionScope.kullanici and not empty sessionScope.kullanici.sube and sessionScope.kullanici.rol != 'ADMIN'}" />
            <c:set var="subeId" value="${(not empty sessionScope.kullanici and not empty sessionScope.kullanici.sube) ? sessionScope.kullanici.sube.subeId : null}" />
            <c:if test="${empty subeId}"><c:set var="subeId" value="1" /></c:if>
            
            <c:if test="${empty sessionScope.kullanici or sessionScope.kullanici.rol != 'ADMIN'}">
                <div class="compact-bar-sube" style="margin-left: 0; margin-right: 0.5rem;">
                    <c:choose>
                        <c:when test="${kullaniciSubeKilitli}">
                            <span class="compact-sube-select" style="pointer-events: none; opacity: 0.85;">
                                <c:forEach items="${subeler}" var="sube">
                                    <c:if test="${sube.subeId == subeId}">${sube.subeAdi}</c:if>
                                </c:forEach>
                            </span>
                        </c:when>
                        <c:otherwise>
                            <select id="anasayfaSubeSelect" class="compact-sube-select">
                                <c:forEach items="${subeler}" var="sube">
                                    <option value="${sube.subeId}" ${sube.subeId == subeId ? 'selected' : ''}>${sube.subeAdi}</option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty sessionScope.kullanici}">
                    <span style="font-size: 0.9rem; font-weight: 500; color: rgba(255,255,255,0.85);">
                        Hoş geldin, ${sessionScope.kullanici.rol == 'ADMIN' ? 'Sistem Yöneticisi' : sessionScope.kullanici.adSoyad}
                    </span>
                    <c:if test="${sessionScope.kullanici.rol == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin" class="admin-login-link">
                            Admin Paneli
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/cikis" class="admin-login-link" style="color: #fca5a5; border-color: rgba(252,165,165,0.3); background: rgba(220,38,38,0.2);">
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
            
            <a href="${pageContext.request.contextPath}/sepet" style="position: relative; display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; background-color: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2); border-radius: 50%; color: #fff; text-decoration: none; transition: background-color 0.2s;" title="Sepete Git">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 20px; height: 20px;">
                    <circle cx="9" cy="21" r="1"></circle>
                    <circle cx="19" cy="21" r="1"></circle>
                    <path d="M2 3h2l2.6 12.4a2 2 0 0 0 2 1.6h9.8a2 2 0 0 0 2-1.6L22 7H6"></path>
                </svg>
                <span id="headerCartCount" style="display: none; position: absolute; top: -2px; right: -2px; background-color: #dc2626; color: white; border-radius: 50%; font-size: 0.65rem; font-weight: 700; width: 16px; height: 16px; align-items: center; justify-content: center;">0</span>
            </a>
        </div>
    </header>
    </div>

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

        <%-- Zayi Butonu (Tüm Kullanıcılar İçin) --%>
        <c:if test="${not empty sessionScope.kullanici}">
            <div style="display: flex; justify-content: center; margin-top: 1rem; width: 100%; max-width: 900px; margin-left: auto; margin-right: auto;">
                <button class="kiosk-btn" style="background-color: #dc2626; color: white; width: 100%; max-width: 600px; min-height: 80px; flex-direction: row; gap: 1rem; border-radius: 12px; font-size: 1.5rem; padding: 1rem;" onclick="openZayiModal()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:32px;height:32px;margin:0;">
                        <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                    </svg>
                    <span>Zayi (Fire) Düş</span>
                </button>
            </div>
        </c:if>

    </main>

    <!-- Zayi Modal (Custom Popup) -->
    <div class="bs-popup-overlay" id="zayiModalOverlay">
        <div class="bs-popup-card" style="max-width: 500px; max-height: 80vh; overflow-y: auto; text-align: left;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <h3 class="bs-popup-title" style="margin: 0; color: #dc2626;">Zayi (Fire) Düşüm</h3>
                <button type="button" class="bs-toast-close" onclick="closeZayiModal()" style="font-size: 1.5rem;">&times;</button>
            </div>
            
            <c:if test="${empty stokListesi}">
                <p style="text-align: center; color: var(--text-muted);">Şubenizde stok bulunamadı.</p>
            </c:if>
            <c:if test="${not empty stokListesi}">
                <div style="display: flex; flex-direction: column; gap: 1rem;">
                    <c:forEach items="${stokListesi}" var="stok">
                        <div style="border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 1rem;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem;">
                                <strong>${stok.urun.urunAdi}</strong>
                                <span style="color: var(--text-muted); font-size: 0.9rem;">Mevcut: <strong>${stok.mevcutStok}</strong></span>
                            </div>
                            <form action="<%= request.getContextPath() %>/zayi-dus" method="POST" class="bs-confirm-form" data-confirm-title="Zayi Onay" data-confirm-message="Bu üründen zayi düşmek istediğinize emin misiniz?">
                                <input type="hidden" name="urunId" value="${stok.urun.urunId}">
                                <div style="display: flex; gap: 0.5rem;">
                                    <input type="number" name="miktar" min="1" max="${stok.mevcutStok}" required placeholder="Miktar" style="flex: 1; padding: 0.5rem; border: 1px solid var(--border-color); border-radius: 6px;">
                                    <button type="submit" class="bs-popup-btn bs-popup-btn-danger">Zayi Düş</button>
                                </div>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>

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
        function openZayiModal() {
            var overlay = document.getElementById('zayiModalOverlay');
            if(overlay) overlay.classList.add('active');
        }
        function closeZayiModal() {
            var overlay = document.getElementById('zayiModalOverlay');
            if(overlay) overlay.classList.remove('active');
        }

        // Initialize modal forms with AJAX to prevent page reload
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('#zayiModalOverlay .bs-confirm-form').forEach(function(form) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    var currentForm = this;
                    
                    BsPopup.confirm({
                        title: currentForm.dataset.confirmTitle || 'Emin misiniz?',
                        message: currentForm.dataset.confirmMessage || '',
                        icon: 'danger',
                        btnStyle: 'danger',
                        confirmText: 'Evet, Düş',
                        cancelText: 'İptal',
                        onConfirm: function() {
                            var formData = new URLSearchParams(new FormData(currentForm));
                            
                            fetch(currentForm.action, {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                },
                                body: formData.toString()
                            })
                            .then(response => response.text())
                            .then(text => {
                                try {
                                    var data = JSON.parse(text);
                                    if(data.success) {
                                        BsPopup.toast({ title: 'Başarılı!', message: data.message, type: 'success', duration: 4000 });
                                        
                                        // Update stock number on UI dynamically without reload
                                        var miktarInput = currentForm.querySelector('input[name="miktar"]');
                                        var miktarDusulen = parseInt(miktarInput.value);
                                        var stokTextEl = currentForm.previousElementSibling.querySelector('span strong');
                                        var mevcutStok = parseInt(stokTextEl.innerText);
                                        
                                        var yeniStok = mevcutStok - miktarDusulen;
                                        stokTextEl.innerText = yeniStok;
                                        miktarInput.max = yeniStok;
                                        miktarInput.value = ''; // clear input
                                        
                                        if(yeniStok <= 0) {
                                            currentForm.parentElement.style.opacity = '0.5';
                                            currentForm.parentElement.style.pointerEvents = 'none';
                                            currentForm.querySelector('button').disabled = true;
                                        }
                                    } else {
                                        BsPopup.toast({ title: 'Hata!', message: data.message, type: 'error', duration: 5000 });
                                    }
                                } catch (e) {
                                    console.error("Raw response:", text);
                                    BsPopup.toast({ title: 'Sunucu Hatası', message: 'Hata detayı konsola yazdırıldı.', type: 'error', duration: 5000 });
                                }
                            })
                            .catch(error => {
                                console.error("Network error:", error);
                                BsPopup.toast({ title: 'Hata!', message: 'Ağ hatası oluştu.', type: 'error', duration: 5000 });
                            });
                        }
                    });
                });
            });
        });

        function proceedToProducts(tip) {
            var subeSelect = document.getElementById('anasayfaSubeSelect');
            var subeParam = '';
            if (subeSelect && subeSelect.value) {
                subeParam = '&subeId=' + subeSelect.value;
            }
            window.location.href = '<%= request.getContextPath() %>/urunler?tip=' + tip + subeParam;
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
    <script src="<%= request.getContextPath() %>/js/popup.js?v=1"></script>
</body>
</html>
