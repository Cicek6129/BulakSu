<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ürünler - BulakSu</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=13">
</head>
<body>
    <!-- Tek kompakt üst bar: logo + hizmet tipi + şube seçimi + sepet -->
    <div class="compact-bar-wrapper">
    <header class="compact-bar">
        <div class="logo-group">
            <a href="${pageContext.request.contextPath == '' ? request.getContextPath() : pageContext.request.contextPath}/anasayfa" style="display: block; line-height: 0;">
                <img src="${pageContext.request.contextPath == '' ? request.getContextPath() : pageContext.request.contextPath}/images/logo.png" alt="BulakSu Logo" class="brand-logo" style="height: 40px; width: auto; object-fit: contain; max-width: 250px;">
            </a>
        </div>

        <span class="compact-bar-badge
            <c:choose>
                <c:when test="${tip == 'S'}"> badge-servis</c:when>
                <c:when test="${tip == 'G'}"> badge-gelal</c:when>
                <c:when test="${tip == 'T'}"> badge-toptan</c:when>
            </c:choose>">
            <c:choose>
                <c:when test="${tip == 'S'}">Servis</c:when>
                <c:when test="${tip == 'G'}">Gel Al</c:when>
                <c:when test="${tip == 'T'}">Toptan</c:when>
            </c:choose>
        </span>

        <div class="compact-bar-sube">
            <c:choose>
                <c:when test="${kullaniciSubeKilitli}">
                    <%-- Kullanıcı şubeye kilitli — sadece şube adını göster --%>
                    <span class="compact-sube-select" style="pointer-events: none; opacity: 0.85;">
                        <c:forEach items="${subeler}" var="sube">
                            ${sube.subeAdi}
                        </c:forEach>
                    </span>
                </c:when>
                <c:otherwise>
                    <select id="subeSelect" class="compact-sube-select" onchange="changeSube(this.value)">
                        <option value="">Mağaza seçiniz...</option>
                        <c:forEach items="${subeler}" var="sube">
                            <option value="${sube.subeId}" ${sube.subeId == subeId ? 'selected' : ''}>${sube.subeAdi}</option>
                        </c:forEach>
                    </select>
                </c:otherwise>
            </c:choose>
        </div>

        <button type="button" class="compact-bar-cart" onclick="goToCart()" aria-label="Sepete git">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="9" cy="21" r="1"></circle>
                <circle cx="20" cy="21" r="1"></circle>
                <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
            </svg>
            <span id="headerCartBadge" class="compact-cart-badge">0</span>
        </button>
    </header>
    </div>

    <main class="main-content" style="padding-top: 1.5rem;">
        <div class="products-grid compact-grid">
            <c:forEach items="${urunler}" var="urun">
                <c:set var="guncelFiyat" value="0" />
                <c:set var="fiyatBulundu" value="false" />
                <c:set var="gorselUrl" value="${not empty urun.gorselUrl ? urun.gorselUrl : 'https://via.placeholder.com/150'}" />
                
                <c:if test="${not empty subeId}">
                    <c:forEach items="${fiyatlar}" var="fiyat">
                        <c:if test="${fiyat.urun.urunId == urun.urunId}">
                            <c:set var="fiyatBulundu" value="true" />
                            <c:choose>
                                <c:when test="${tip == 'S'}"><c:set var="guncelFiyat" value="${fiyat.fiyatServis}" /></c:when>
                                <c:when test="${tip == 'G'}"><c:set var="guncelFiyat" value="${fiyat.fiyatGelAl}" /></c:when>
                                <c:when test="${tip == 'T'}"><c:set var="guncelFiyat" value="${fiyat.fiyatToptan}" /></c:when>
                            </c:choose>
                        </c:if>
                    </c:forEach>
                </c:if>
                
                <c:set var="mevcutStok" value="${stokMap[urun.urunId]}" />
                <c:set var="kritikStok" value="${kritikStokMap[urun.urunId]}" />
                <c:set var="stokYok" value="${mevcutStok == null || mevcutStok <= 0}" />
                <c:set var="stokKritik" value="${!stokYok && kritikStok != null && mevcutStok <= kritikStok}" />
                
                <div class="product-card${stokYok ? ' is-out-of-stock' : ''}${stokKritik ? ' is-low-stock' : ''}">
                    <div class="product-image-container">
                        <c:choose>
                            <c:when test="${not empty urun.gorselUrl}">
                                <img src="${urun.gorselUrl}" alt="${urun.urunAdi}" class="product-image">
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/150" alt="Görsel Yok" class="product-image">
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${stokYok}">
                            <div class="out-of-stock-overlay">
                                <span class="out-of-stock-badge">Tükendi</span>
                            </div>
                        </c:if>
                        <c:if test="${stokKritik}">
                            <div class="low-stock-badge-wrapper">
                                <span class="low-stock-badge">⚠ Stok Azalıyor</span>
                            </div>
                        </c:if>
                    </div>
                    
                    <div class="product-details">
                        <div class="price-row">
                            <c:choose>
                                <c:when test="${fiyatBulundu}">
                                    <span class="current-price"${stokYok ? ' style="color: #94a3b8;"' : ''}>₺${guncelFiyat}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="current-price" style="font-size: 1rem; color: #ef4444;">Şube Seçiniz</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="product-name">${urun.urunAdi}</div>
                        <div class="product-weight">Adet</div>
                    </div>
                    
                    <div class="product-action-bottom">
                        <c:choose>
                            <c:when test="${stokYok && fiyatBulundu}">
                                <button type="button" class="btn-primary" style="padding: 0.5rem 1rem; font-size: 0.9rem; width: 100%; border-radius: 8px; background: #cbd5e1; cursor: not-allowed;" disabled>Stokta Yok</button>
                            </c:when>
                            <c:when test="${fiyatBulundu}">
                                <button type="button" class="btn-primary" style="padding: 0.5rem 1rem; font-size: 0.9rem; width: 100%; border-radius: 8px;" onclick="openQtyModal(${urun.urunId}, '${urun.urunAdi.replace('\'', '\\\'')}', ${guncelFiyat}, '${gorselUrl}', ${mevcutStok != null ? mevcutStok : 0})">Sepete Ekle</button>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>

    <script>
        function changeSube(subeId) {
            if (subeId) {
                window.location.href = '<%= request.getContextPath() %>/urunler?tip=${tip}&subeId=' + subeId;
            }
        }
        function goToCart() {
            window.location.href = '<%= request.getContextPath() %>/sepet';
        }
    </script>

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
        <button type="button" class="checkout-btn" onclick="goToCart()">Sepete Git &rarr;</button>
    </div>

    <!-- Quantity Modal -->
    <div class="modal-overlay" id="qtyModal">
        <div class="modal-content" style="max-width: 360px; border-radius: 24px; overflow: hidden; border: none; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);">
            <div class="modal-header" style="background: white; border-bottom: none; padding: 1.25rem 1.25rem 0; display: flex; justify-content: flex-end;">
                <button type="button" class="modal-close" onclick="closeQtyModal()" style="background: #f1f5f9; border-radius: 50%; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; color: #475569; font-size: 1.25rem; transition: all 0.2s;">&times;</button>
            </div>
            <div class="modal-body" style="text-align: center; padding: 0 2rem 2.5rem 2rem;">
                <img id="modalProductImage" src="" alt="Ürün" style="width: 160px; height: 160px; object-fit: contain; margin: 0 auto 1.25rem auto; display: block; background: #f8fafc; border-radius: 20px; padding: 15px; box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);">
                <h3 id="modalProductName" style="font-family: var(--font-display); font-size: 1.4rem; color: var(--ink); margin-bottom: 0.5rem; line-height: 1.3;">Ürün Adı</h3>
                <p id="modalProductPrice" style="font-family: var(--font-mono); font-size: 1.35rem; color: var(--coral-dark); font-weight: 700; margin-bottom: 0.5rem;">₺0.00</p>
                <p id="modalStockInfo" style="font-size: 0.85rem; color: #64748b; margin-bottom: 1.25rem;">Stok: 0 adet</p>
                <p id="stockWarning" style="display: none; background: #fef2f2; color: #dc2626; padding: 0.5rem 1rem; border-radius: 8px; font-size: 0.85rem; font-weight: 500; margin-bottom: 1rem;">⚠️ Uyarı</p>
                
                <div class="qty-control" style="margin: 0 auto 2rem auto; transform: scale(1.2); box-shadow: 0 2px 5px rgba(0,0,0,0.05); border-color: #e2e8f0; border-radius: 8px;">
                    <button type="button" class="qty-btn" onclick="updateModalQty(-1)" style="color: var(--text-muted); font-size: 1.4rem;">-</button>
                    <input type="number" id="modalQtyInput" value="1" min="0" class="qty-input" style="font-size: 1.1rem; width: 44px;">
                    <button type="button" class="qty-btn" onclick="updateModalQty(1)" style="color: var(--coral); font-size: 1.3rem;">+</button>
                </div>
                
                <button type="button" class="btn-primary" style="width: 100%; border-radius: 50px; padding: 1rem; font-size: 1.1rem; box-shadow: 0 4px 14px rgba(225, 85, 43, 0.3);" onclick="confirmQtyModal()">Sepete Onayla</button>
            </div>
        </div>
    </div>

    <script>
        // Global cart — localStorage based
        const CART_KEY = 'bulaksu_cart';
        const CURRENT_TIP = '${tip}';
        const CURRENT_SUBE_ID = ${subeId};

        function getCart() {
            try { return JSON.parse(localStorage.getItem(CART_KEY)) || []; }
            catch(e) { return []; }
        }
        function saveCart(cart) {
            localStorage.setItem(CART_KEY, JSON.stringify(cart));
        }

        let currentModalProduct = null;
        let currentMaxStock = 0;

        function openQtyModal(id, name, price, imageUrl, maxStock) {
            currentModalProduct = { id: id, name: name, price: price, imageUrl: imageUrl };
            currentMaxStock = maxStock || 0;
            document.getElementById('modalProductName').innerText = name;
            document.getElementById('modalProductPrice').innerText = '₺' + price.toFixed(2);
            document.getElementById('modalProductImage').src = imageUrl;
            
            // Stok bilgisini modal'da göster
            const stockInfo = document.getElementById('modalStockInfo');
            if (stockInfo) {
                stockInfo.innerText = 'Stok: ' + currentMaxStock + ' adet';
                stockInfo.style.color = currentMaxStock <= 5 ? '#ef4444' : '#64748b';
            }
            
            const cart = getCart();
            // Match by id AND tip (same product can have different prices per tip)
            const existingItem = cart.find(item => item.id === id && item.tip === CURRENT_TIP);
            document.getElementById('modalQtyInput').value = existingItem ? existingItem.qty : 1;
            
            document.getElementById('qtyModal').classList.add('active');
        }
        
        function closeQtyModal() {
            document.getElementById('qtyModal').classList.remove('active');
            currentModalProduct = null;
        }
        
        function updateModalQty(change) {
            const input = document.getElementById('modalQtyInput');
            let current = parseInt(input.value) || 0;
            let newVal = current + change;
            if (newVal < 0) newVal = 0;
            if (newVal > currentMaxStock) {
                newVal = currentMaxStock;
                showStockWarning('Maksimum stok miktarı: ' + currentMaxStock + ' adet');
            }
            input.value = newVal;
        }
        
        function showStockWarning(message) {
            const warning = document.getElementById('stockWarning');
            if (warning) {
                warning.innerText = message;
                warning.style.display = 'block';
                setTimeout(() => { warning.style.display = 'none'; }, 3000);
            }
        }
        
        function confirmQtyModal() {
            if (!currentModalProduct) return;
            const qty = parseInt(document.getElementById('modalQtyInput').value) || 0;
            
            let cart = getCart();
            const existingIndex = cart.findIndex(item => item.id === currentModalProduct.id && item.tip === CURRENT_TIP);
            const eskiMiktar = (existingIndex > -1) ? cart[existingIndex].qty : 0;
            
            if (qty === eskiMiktar) {
                closeQtyModal();
                return;
            }
            
            // Ürün tamamen sepetten çıkarılıyorsa (miktar 0)
            if (qty === 0 && existingIndex > -1) {
                fetch('<%= request.getContextPath() %>/sepet-stok', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=cikar&urunId=' + currentModalProduct.id + '&subeId=' + CURRENT_SUBE_ID + '&miktar=' + eskiMiktar
                })
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        cart.splice(existingIndex, 1);
                        saveCart(cart);
                        if (typeof data.mevcutStok !== 'undefined') {
                            currentMaxStock = data.mevcutStok;
                            const stockInfo = document.getElementById('modalStockInfo');
                            if (stockInfo) {
                                stockInfo.innerText = 'Stok: ' + data.mevcutStok + ' adet';
                            }
                        }
                        updateCartUI();
                        closeQtyModal();
                    }
                })
                .catch(() => { showStockWarning('Bir hata oluştu, tekrar deneyin.'); });
                return;
            }
            
            // Yeni ekleme veya güncelleme
            if (existingIndex > -1) {
                // Güncelleme — fark hesapla
                fetch('<%= request.getContextPath() %>/sepet-stok', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=guncelle&urunId=' + currentModalProduct.id + '&subeId=' + CURRENT_SUBE_ID + '&miktar=' + qty + '&eskiMiktar=' + eskiMiktar
                })
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        cart[existingIndex].qty = qty;
                        saveCart(cart);
                        if (typeof data.mevcutStok !== 'undefined') {
                            currentMaxStock = data.mevcutStok;
                            const stockInfo = document.getElementById('modalStockInfo');
                            if (stockInfo) {
                                stockInfo.innerText = 'Stok: ' + data.mevcutStok + ' adet';
                            }
                        }
                        updateCartUI();
                        closeQtyModal();
                    } else {
                        showStockWarning(data.error || 'Yetersiz stok!');
                        if (typeof data.mevcutStok !== 'undefined') {
                            currentMaxStock = data.mevcutStok;
                            const stockInfo = document.getElementById('modalStockInfo');
                            if (stockInfo) {
                                stockInfo.innerText = 'Stok: ' + data.mevcutStok + ' adet';
                            }
                        }
                    }
                })
                .catch(() => { showStockWarning('Bir hata oluştu, tekrar deneyin.'); });
            } else {
                // Yeni ekleme
                fetch('<%= request.getContextPath() %>/sepet-stok', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=ekle&urunId=' + currentModalProduct.id + '&subeId=' + CURRENT_SUBE_ID + '&miktar=' + qty
                })
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        cart.push({
                            id: currentModalProduct.id,
                            name: currentModalProduct.name,
                            price: currentModalProduct.price,
                            imageUrl: currentModalProduct.imageUrl,
                            qty: qty,
                            tip: CURRENT_TIP,
                            subeId: CURRENT_SUBE_ID
                        });
                        saveCart(cart);
                        if (typeof data.mevcutStok !== 'undefined') {
                            currentMaxStock = data.mevcutStok;
                            const stockInfo = document.getElementById('modalStockInfo');
                            if (stockInfo) {
                                stockInfo.innerText = 'Stok: ' + data.mevcutStok + ' adet';
                            }
                        }
                        updateCartUI();
                        closeQtyModal();
                    } else {
                        showStockWarning(data.error || 'Yetersiz stok!');
                        if (typeof data.mevcutStok !== 'undefined') {
                            currentMaxStock = data.mevcutStok;
                            const stockInfo = document.getElementById('modalStockInfo');
                            if (stockInfo) {
                                stockInfo.innerText = 'Stok: ' + data.mevcutStok + ' adet';
                            }
                        }
                    }
                })
                .catch(() => { showStockWarning('Bir hata oluştu, tekrar deneyin.'); });
            }
        }
        
        function updateCartUI() {
            const cart = getCart();
            const cartDiv = document.getElementById('floatingCart');
            const headerBadge = document.getElementById('headerCartBadge');
            
            if (cart.length > 0) {
                cartDiv.style.display = 'flex';
                let total = 0;
                let count = 0;
                cart.forEach(item => {
                    total += (item.price * item.qty);
                    count += item.qty;
                });
                
                document.getElementById('cartItemCount').innerText = count + ' Ürün';
                document.getElementById('cartTotalText').innerText = '₺' + total.toFixed(2);
                
                if(headerBadge) {
                    headerBadge.innerText = count;
                    headerBadge.classList.add('is-visible');
                }
            } else {
                cartDiv.style.display = 'none';
                if(headerBadge) headerBadge.classList.remove('is-visible');
            }
        }

        // Sayfa yüklendiğinde sepet durumunu güncelle
        document.addEventListener('DOMContentLoaded', updateCartUI);
    </script>
</body>
</html>
