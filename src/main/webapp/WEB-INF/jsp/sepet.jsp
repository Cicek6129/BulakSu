<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sepetim - BulakSu</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=14">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/popup.css?v=1">
    <style>
        .checkout-container {
            width: 100%;
            max-width: 720px;
            margin: 2rem auto 4rem;
            padding: 0 1rem;
        }
        .checkout-card {
            background: transparent;
            padding: 0;
            border: none;
            box-shadow: none;
        }
        .checkout-card h2 {
            color: var(--ink);
            font-family: var(--font-display);
            font-weight: 700;
            font-size: 1.75rem;
            margin: 0 0 0.5rem;
        }
        .checkout-subtitle {
            color: var(--text-muted);
            font-size: 0.95rem;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 2px solid #e2e8f0;
        }
        .cart-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.25rem 1.5rem;
            margin-bottom: 1rem;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            transition: all 0.2s ease;
        }
        .cart-item:hover {
            border-color: var(--teal-400);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
            transform: translateY(-2px);
        }
        .cart-item:last-of-type {
            margin-bottom: 0;
        }
        .cart-item-left {
            display: flex;
            align-items: center;
            gap: 1.25rem;
            flex: 1;
            min-width: 0;
        }
        .cart-item-image-wrapper {
            width: 68px;
            height: 68px;
            background: #f1f5f9;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 8px;
            border: 1px solid #e2e8f0;
            flex-shrink: 0;
        }
        .cart-item-image {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }
        .cart-item-info {
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
            align-items: flex-start;
        }
        .cart-item-name {
            font-weight: 700;
            color: var(--ink);
            font-size: 1.1rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .cart-item-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.2rem 0.6rem;
            border-radius: 999px;
            font-size: 0.65rem;
            font-weight: 800;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            white-space: nowrap;
        }
        .badge-s { background: #E2F1EC; color: #11594F; }
        .badge-g { background: #FBE7DE; color: #C44520; }
        .badge-t { background: #FBF1DD; color: #8B6914; }
        .cart-item-right {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }
        .cart-qty-controls {
            display: flex;
            align-items: center;
            gap: 0;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            overflow: hidden;
            flex-shrink: 0;
        }
        .cart-qty-btn {
            background: #f8fafc;
            border: none;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 1.2rem;
            color: #475569;
            transition: background 0.15s;
        }
        .cart-qty-btn:hover {
            background: #e2e8f0;
        }
        .cart-qty-btn.qty-minus {
            color: #94a3b8;
        }
        .cart-qty-btn.qty-plus {
            color: var(--coral);
        }
        .cart-qty-value {
            font-size: 1rem;
            font-weight: 700;
            width: 40px;
            text-align: center;
            color: var(--ink);
            background: white;
        }
        .cart-item-price-col {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            min-width: 90px;
        }
        .cart-item-price {
            font-family: var(--font-mono);
            color: var(--coral-dark);
            font-weight: 800;
            font-size: 1.15rem;
            white-space: nowrap;
        }
        .cart-item-unit-price {
            font-size: 0.75rem;
            color: #94a3b8;
            margin-top: 0.15rem;
        }
        .cart-item-remove {
            background: #fef2f2;
            border: none;
            color: #ef4444;
            cursor: pointer;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        .cart-item-remove:hover {
            background: #ef4444;
            color: white;
            transform: scale(1.1);
        }
        .cart-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 2rem;
            padding: 1.5rem 2rem;
            background: white;
            border-radius: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            border: 1px solid #e2e8f0;
        }
        .cart-summary-label {
            font-weight: 700;
            font-size: 1.35rem;
            color: var(--ink);
        }
        .cart-summary-value {
            font-family: var(--font-mono);
            font-weight: 800;
            font-size: 1.75rem;
            color: var(--coral-dark);
        }
        .submit-btn {
            width: 100%;
            padding: 1.25rem;
            background-color: var(--coral);
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 1.15rem;
            font-weight: 700;
            cursor: pointer;
            margin-top: 1.5rem;
            transition: all 0.2s ease;
            box-shadow: 0 8px 24px rgba(225, 85, 43, 0.25);
        }
        .submit-btn:hover {
            background-color: var(--coral-dark);
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(225, 85, 43, 0.35);
        }
        .submit-btn:disabled {
            background: #cbd5e1;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        .cart-empty {
            text-align: center;
            padding: 4rem 1rem;
            background: white;
            border-radius: 20px;
            border: 1px dashed #cbd5e1;
            color: var(--text-muted);
        }
        .cart-empty-icon {
            font-size: 3rem;
            display: block;
            margin-bottom: 1.25rem;
            opacity: 0.5;
        }
        .cart-empty a {
            color: var(--teal-600);
            text-decoration: none;
            font-weight: 700;
            font-size: 1.1rem;
            display: inline-block;
            margin-top: 1rem;
            background: #f1f5f9;
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            transition: all 0.2s;
        }
        .cart-empty a:hover {
            background: #e2e8f0;
            color: var(--teal-700);
        }
    </style>
</head>
<body>
    <!-- Kompakt üst bar -->
    <div class="compact-bar-wrapper">
    <header class="compact-bar">
        <div class="logo-group">
            <a href="${pageContext.request.contextPath == '' ? request.getContextPath() : pageContext.request.contextPath}/anasayfa" style="display: block; line-height: 0;">
                <img src="${pageContext.request.contextPath == '' ? request.getContextPath() : pageContext.request.contextPath}/images/logo.png" alt="BulakSu Logo" class="brand-logo" style="height: 40px; width: auto; object-fit: contain; max-width: 250px;">
            </a>
        </div>

        <span class="compact-bar-badge badge-servis">Sipariş</span>

        <div class="compact-bar-sube">
            <a href="<%= request.getContextPath() %>/anasayfa" style="color: #fff; font-size: 0.85rem; font-weight: 500; text-decoration: none; display: flex; align-items: center; gap: 4px;">
                &larr; Ana Sayfa
            </a>
        </div>
    </header>
    </div>

    <main class="main-content" style="padding-top: 0;">
        <div class="checkout-container">
            <div class="checkout-card">
                <h2>🛒 Sepetim</h2>
                <p class="checkout-subtitle" id="cartSubtitle">Yükleniyor...</p>

                <div id="cartItemsContainer"></div>

                <div class="cart-summary" id="cartSummary" style="display: none;">
                    <span class="cart-summary-label">Toplam:</span>
                    <span class="cart-summary-value" id="cartTotal">₺0.00</span>
                </div>

                <form action="<%= request.getContextPath() %>/siparis" method="POST" id="checkoutForm" style="display: none;">
                    <div id="hiddenInputsContainer"></div>
                    <button type="submit" class="submit-btn" id="submitBtn">Siparişi Tamamla</button>
                </form>

                <div id="cartEmpty" style="display: none;" class="cart-empty">
                    <span class="cart-empty-icon">🛒</span>
                    Sepetiniz boş.<br>
                    <a href="<%= request.getContextPath() %>/anasayfa">Alışverişe başlayın →</a>
                </div>
            </div>
        </div>
    </main>

    <script>
        const CART_KEY = 'bulaksu_cart';
        const CTX = '<%= request.getContextPath() %>';

        function getCart() {
            try { return JSON.parse(localStorage.getItem(CART_KEY)) || []; }
            catch(e) { return []; }
        }

        function tipLabel(tip) {
            if (tip === 'S') return 'Servis';
            if (tip === 'G') return 'Gel Al';
            if (tip === 'T') return 'Toptan';
            return tip;
        }
        function tipBadgeClass(tip) {
            if (tip === 'S') return 'badge-s';
            if (tip === 'G') return 'badge-g';
            if (tip === 'T') return 'badge-t';
            return '';
        }

        function removeItem(index) {
            let cart = getCart();
            if (index < 0 || index >= cart.length) return;
            const item = cart[index];
            
            // Silme onay popup'ı
            BsPopup.confirm({
                title: 'Ürünü Kaldır',
                message: item.name + ' (' + item.qty + ' adet) sepetten kaldırılacak. Emin misiniz?',
                icon: 'warning',
                btnStyle: 'danger',
                confirmText: 'Evet, Kaldır',
                cancelText: 'İptal',
                onConfirm: function() {
                    // Stok iade et — SQL: UPDATE sube_stoklari SET mevcut_stok = mevcut_stok + miktar
                    fetch(CTX + '/sepet-stok', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'action=cikar&urunId=' + item.id + '&subeId=' + (item.subeId || 1) + '&miktar=' + item.qty
                    })
                    .then(r => r.json())
                    .then(data => {
                        let c = getCart();
                        c.splice(index, 1);
                        localStorage.setItem(CART_KEY, JSON.stringify(c));
                        renderCart();
                    })
                    .catch(() => {
                        let c = getCart();
                        c.splice(index, 1);
                        localStorage.setItem(CART_KEY, JSON.stringify(c));
                        renderCart();
                    });
                }
            });
        }

        function updateItemQty(index, change) {
            let cart = getCart();
            if (index < 0 || index >= cart.length) return;
            const item = cart[index];
            const eskiMiktar = item.qty;
            const yeniMiktar = eskiMiktar + change;
            
            if (yeniMiktar <= 0) {
                // Miktar 0'a düştüyse silme popup'ı göster
                removeItem(index);
                return;
            }
            
            // Stok güncelle — SQL ile fark hesapla
            fetch(CTX + '/sepet-stok', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=guncelle&urunId=' + item.id + '&subeId=' + (item.subeId || 1) + '&miktar=' + yeniMiktar + '&eskiMiktar=' + eskiMiktar
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    let c = getCart();
                    c[index].qty = yeniMiktar;
                    localStorage.setItem(CART_KEY, JSON.stringify(c));
                    renderCart();
                } else {
                    BsPopup.toast({ title: 'Uyarı', message: data.error || 'Yetersiz stok!', type: 'warning', duration: 3000 });
                }
            })
            .catch(() => {
                BsPopup.toast({ title: 'Hata', message: 'Bir hata oluştu.', type: 'error', duration: 3000 });
            });
        }

        function renderCart() {
            const cart = getCart();
            const container = document.getElementById('cartItemsContainer');
            const hiddenContainer = document.getElementById('hiddenInputsContainer');
            const summaryDiv = document.getElementById('cartSummary');
            const formDiv = document.getElementById('checkoutForm');
            const emptyDiv = document.getElementById('cartEmpty');
            const subtitle = document.getElementById('cartSubtitle');

            container.innerHTML = '';
            hiddenContainer.innerHTML = '';

            if (!cart || cart.length === 0) {
                summaryDiv.style.display = 'none';
                formDiv.style.display = 'none';
                emptyDiv.style.display = 'block';
                subtitle.innerText = '0 ürün';
                return;
            }

            emptyDiv.style.display = 'none';
            summaryDiv.style.display = 'flex';
            formDiv.style.display = 'block';

            let total = 0;
            let totalCount = 0;

            cart.forEach(function(item, index) {
                const lineTotal = item.price * item.qty;
                total += lineTotal;
                totalCount += item.qty;

                const rawImg = item.imageUrl;
                let imageUrl = CTX + '/images/logo.png';
                if (rawImg && rawImg !== 'undefined' && rawImg !== 'null' && rawImg.trim() !== '') {
                    imageUrl = rawImg;
                }
                
                // Visible cart row
                const row = document.createElement('div');
                row.className = 'cart-item';
                row.innerHTML =
                    '<div class="cart-item-left">' +
                        '<div class="cart-item-image-wrapper">' +
                            '<img src="' + imageUrl + '" alt="' + item.name + '" class="cart-item-image" onerror="this.src=\'' + CTX + '/images/logo.png\'">' +
                        '</div>' +
                        '<div class="cart-item-info">' +
                            '<span class="cart-item-name">' + item.name + '</span>' +
                            '<span class="cart-item-badge ' + tipBadgeClass(item.tip) + '">' + tipLabel(item.tip) + '</span>' +
                        '</div>' +
                    '</div>' +
                    '<div class="cart-item-right">' +
                        '<div class="cart-qty-controls">' +
                            '<button type="button" class="cart-qty-btn qty-minus" onclick="updateItemQty(' + index + ', -1)">−</button>' +
                            '<span class="cart-qty-value">' + item.qty + '</span>' +
                            '<button type="button" class="cart-qty-btn qty-plus" onclick="updateItemQty(' + index + ', 1)">+</button>' +
                        '</div>' +
                        '<div class="cart-item-price-col">' +
                            '<span class="cart-item-price">₺' + lineTotal.toFixed(2) + '</span>' +
                            '<span class="cart-item-unit-price">₺' + Number(item.price).toFixed(2) + ' / adet</span>' +
                        '</div>' +
                        '<button type="button" class="cart-item-remove" onclick="removeItem(' + index + ')" title="Kaldır">' +
                            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>' +
                        '</button>' +
                    '</div>';
                container.appendChild(row);

                // Hidden inputs for form
                hiddenContainer.innerHTML +=
                    '<input type="hidden" name="urunId" value="' + item.id + '">' +
                    '<input type="hidden" name="miktar" value="' + item.qty + '">' +
                    '<input type="hidden" name="fiyat" value="' + item.price + '">' +
                    '<input type="hidden" name="siparisTipiDetay" value="' + (item.tip || 'G') + '">' +
                    '<input type="hidden" name="subeIdDetay" value="' + (item.subeId || 1) + '">';
            });

            subtitle.innerText = totalCount + ' ürün';
            document.getElementById('cartTotal').innerText = '₺' + total.toFixed(2);
        }

        // Sipariş tamamlama - custom popup ile onay
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            e.preventDefault();
            var form = this;
            BsPopup.confirm({
                title: 'Siparişi Tamamla',
                message: 'Siparişi onaylamak istediğinize emin misiniz?',
                icon: 'info',
                btnStyle: 'confirm',
                confirmText: 'Evet, Tamamla',
                cancelText: 'İptal',
                onConfirm: function() {
                    localStorage.removeItem(CART_KEY);
                    form.submit();
                }
            });
        });

        document.addEventListener('DOMContentLoaded', renderCart);
    </script>
    <script src="<%= request.getContextPath() %>/js/popup.js?v=1"></script>
</body>
</html>
