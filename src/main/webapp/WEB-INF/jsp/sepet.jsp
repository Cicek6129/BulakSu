<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sepetim - BulakSu</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=7">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/popup.css?v=1">
    <style>
        .checkout-container {
            width: 100%;
            max-width: 640px;
            margin: 1rem auto 2rem;
            padding: 0 1rem;
        }
        .checkout-card {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            border: 1.5px solid var(--line);
            box-shadow: var(--shadow-card);
        }
        .checkout-card h2 {
            color: var(--ink);
            font-family: var(--font-display);
            font-weight: 600;
            font-size: 1.35rem;
            margin: 0 0 0.25rem;
        }
        .checkout-subtitle {
            color: var(--text-muted);
            font-size: 0.85rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--line);
        }
        .cart-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.85rem 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .cart-item:last-of-type {
            border-bottom: 1px solid var(--line);
        }
        .cart-item-left {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex: 1;
            min-width: 0;
        }
        .cart-item-name {
            font-weight: 600;
            color: var(--ink);
            font-size: 0.95rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .cart-item-detail {
            font-size: 0.82rem;
            color: #94a3b8;
            white-space: nowrap;
        }
        .cart-item-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.15rem 0.5rem;
            border-radius: 999px;
            font-size: 0.65rem;
            font-weight: 700;
            letter-spacing: 0.03em;
            text-transform: uppercase;
            white-space: nowrap;
        }
        .badge-s { background: #E2F1EC; color: #11594F; }
        .badge-g { background: #FBE7DE; color: #C44520; }
        .badge-t { background: #FBF1DD; color: #8B6914; }
        .cart-item-price {
            font-family: var(--font-mono);
            color: var(--coral-dark);
            font-weight: 700;
            font-size: 1rem;
            white-space: nowrap;
            margin-left: 1rem;
        }
        .cart-summary {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            margin-top: 1.25rem;
            padding-top: 0.5rem;
        }
        .cart-summary-label {
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--ink);
        }
        .cart-summary-value {
            font-family: var(--font-mono);
            font-weight: 700;
            font-size: 1.35rem;
            color: var(--ink);
        }
        .submit-btn {
            width: 100%;
            padding: 1rem;
            background-color: var(--coral);
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 1.05rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 1.5rem;
            transition: background-color 0.2s, transform 0.15s;
            font-family: inherit;
        }
        .submit-btn:hover {
            background-color: var(--coral-dark);
            transform: translateY(-1px);
        }
        .submit-btn:disabled {
            background: #cbd5e1;
            cursor: not-allowed;
            transform: none;
        }
        .cart-empty {
            text-align: center;
            padding: 3rem 1rem;
            color: var(--text-muted);
        }
        .cart-empty-icon {
            font-size: 2.5rem;
            display: block;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        .cart-empty a {
            color: var(--teal-600);
            text-decoration: none;
            font-weight: 600;
        }
        .cart-item-remove {
            background: none;
            border: none;
            color: #cbd5e1;
            cursor: pointer;
            font-size: 1.1rem;
            padding: 0.25rem;
            transition: color 0.15s;
            margin-left: 0.5rem;
        }
        .cart-item-remove:hover {
            color: #ef4444;
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
            cart.splice(index, 1);
            localStorage.setItem(CART_KEY, JSON.stringify(cart));
            renderCart();
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

                // Visible cart row
                const row = document.createElement('div');
                row.className = 'cart-item';
                row.innerHTML =
                    '<div class="cart-item-left">' +
                        '<span class="cart-item-badge ' + tipBadgeClass(item.tip) + '">' + tipLabel(item.tip) + '</span>' +
                        '<span class="cart-item-name">' + item.name + '</span>' +
                        '<span class="cart-item-detail">' + item.qty + ' adet × ₺' + item.price.toFixed(2) + '</span>' +
                    '</div>' +
                    '<span class="cart-item-price">₺' + lineTotal.toFixed(2) + '</span>' +
                    '<button type="button" class="cart-item-remove" onclick="removeItem(' + index + ')" title="Kaldır">&times;</button>';
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
