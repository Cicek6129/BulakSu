<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zayi İşlemleri - BulakSu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css?v=6">
    <style>
        .zayi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.25rem;
        }
        .zayi-input-group {
            display: flex;
            gap: 0.5rem;
            margin-top: 0.75rem;
        }
        .zayi-input {
            width: 80px;
            padding: 0.4rem 0.5rem;
            border: 1px solid var(--admin-border);
            border-radius: var(--admin-radius-sm);
            text-align: center;
        }
    </style>
</head>
<body class="admin-mode">
    <div class="bg-particles">
        <div class="particle"></div><div class="particle"></div><div class="particle"></div>
        <div class="particle"></div><div class="particle"></div><div class="particle"></div>
    </div>

    <header class="admin-header">
        <a href="${pageContext.request.contextPath}/anasayfa" class="admin-logo">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="BulakSu Yönetim" class="admin-brand-logo" style="height: 36px; width: auto; object-fit: contain; max-width: 200px;">
        </a>
        <div class="admin-header-actions">
            <span class="admin-welcome">Hoş geldiniz, <strong>${sessionScope.kullanici.rol == 'ADMIN' ? 'Sistem Yöneticisi' : sessionScope.kullanici.adSoyad}</strong></span>
            <a href="${pageContext.request.contextPath}/anasayfa" class="admin-pill-link">Ana Sayfa</a>
            <a href="${pageContext.request.contextPath}/admin/cikis" class="admin-pill-link is-danger">Çıkış Yap</a>
        </div>
    </header>

    <main class="admin-container">
        <div class="admin-page-head">
            <div>
                <p class="admin-eyebrow">Fire ve Atık Yönetimi</p>
                <h1 class="admin-title">Zayi İşlemleri</h1>
            </div>
            <div class="nav-tabs">
                <a href="${pageContext.request.contextPath}/admin" class="nav-tab">Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin/stok" class="nav-tab">Stok Durumu</a>
                <a href="${pageContext.request.contextPath}/admin/urunler" class="nav-tab">Ürün Yönetimi</a>
                <a href="${pageContext.request.contextPath}/admin/kullanicilar" class="nav-tab">Kullanıcılar</a>
                <a href="${pageContext.request.contextPath}/admin/subeler" class="nav-tab">Şubeler</a>
                <a href="${pageContext.request.contextPath}/admin/zayi" class="nav-tab active" style="color:var(--admin-danger);">Zayi (Atık)</a>
            </div>
        </div>

        <c:if test="${param.success == 'true'}">
            <div style="background: var(--admin-success-tint); color: var(--admin-success-deep); padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid rgba(16, 185, 129, 0.2);">
                Zayi düşümü başarıyla kaydedildi.
            </div>
        </c:if>
        <c:if test="${param.error == 'yetersiz'}">
            <div style="background: var(--admin-danger-tint); color: var(--admin-danger-deep); padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid rgba(220, 38, 38, 0.2);">
                Hata: Girdiğiniz miktar mevcut stoktan fazla olamaz!
            </div>
        </c:if>
        <c:if test="${param.error == 'true'}">
            <div style="background: var(--admin-warning); color: #fff; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">
                İşlem sırasında bir hata oluştu.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/zayi" method="GET" class="filter-section">
            <div class="filter-group">
                <label for="subeId">Zayi Düşülecek Şube</label>
                <select name="subeId" id="subeId" class="admin-select" onchange="this.form.submit()">
                    <c:forEach items="${subeler}" var="sube">
                        <option value="${sube.subeId}" <c:if test="${sube.subeId == seciliSubeId}">selected</c:if>>
                            ${sube.subeAdi}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </form>

        <div class="zayi-grid">
            <c:forEach items="${stokListesi}" var="stok">
                <div class="shelf-card">
                    <div class="shelf-card-head">
                        <div>
                            <div class="shelf-product">${stok.urun.urunAdi}</div>
                            <div class="shelf-branch">Mevcut Stok: <strong>${stok.mevcutStok}</strong> adet</div>
                        </div>
                    </div>
                    
                    <form action="${pageContext.request.contextPath}/admin/zayi" method="POST" onsubmit="return confirm('Bu üründen zayi düşmek istediğinize emin misiniz?');">
                        <input type="hidden" name="urunId" value="${stok.urun.urunId}">
                        <input type="hidden" name="subeId" value="${seciliSubeId}">
                        <div class="zayi-input-group">
                            <input type="number" name="miktar" class="zayi-input" min="1" max="${stok.mevcutStok}" required placeholder="Miktar">
                            <button type="submit" class="admin-btn admin-btn-danger" style="flex:1;">Zayi Düş</button>
                        </div>
                    </form>
                </div>
            </c:forEach>
            <c:if test="${empty stokListesi}">
                <div class="admin-empty">
                    Seçili şubede zayi düşülebilecek stok bulunmuyor.
                </div>
            </c:if>
        </div>

    </main>
</body>
</html>
