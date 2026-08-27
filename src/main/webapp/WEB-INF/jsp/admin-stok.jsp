<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stok Yönetimi - BulakSu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css?v=6">
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
                <p class="admin-eyebrow">Depo &amp; Raf</p>
                <h1 class="admin-title">Stok Durumu</h1>
            </div>
            <div class="nav-tabs">
                <a href="${pageContext.request.contextPath}/admin" class="nav-tab">Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin/stok" class="nav-tab active">Stok Durumu</a>
                <a href="${pageContext.request.contextPath}/admin/urunler" class="nav-tab">Ürün Yönetimi</a>
                <a href="${pageContext.request.contextPath}/admin/kullanicilar" class="nav-tab">Kullanıcılar</a>
                <a href="${pageContext.request.contextPath}/admin/subeler" class="nav-tab">Şubeler</a>
            </div>
        </div>

        <%-- Listelenen stok kayıtları üzerinden özet rakamları tek geçişte hesapla --%>
        <c:set var="tukendiSayisi" value="${0}" />
        <c:set var="kritikSayisi" value="${0}" />
        <c:set var="yeterliSayisi" value="${0}" />
        <c:forEach items="${stoklar}" var="stokOzet">
            <c:choose>
                <c:when test="${stokOzet.mevcutStok == 0}">
                    <c:set var="tukendiSayisi" value="${tukendiSayisi + 1}" />
                </c:when>
                <c:when test="${stokOzet.mevcutStok <= stokOzet.kritikStokSeviyesi}">
                    <c:set var="kritikSayisi" value="${kritikSayisi + 1}" />
                </c:when>
                <c:otherwise>
                    <c:set var="yeterliSayisi" value="${yeterliSayisi + 1}" />
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <div class="stat-strip">
            <div class="stat-card">
                <p class="stat-label">Listelenen Kayıt</p>
                <p class="stat-value">${fn:length(stoklar)}</p>
            </div>
            <div class="stat-card is-success">
                <p class="stat-label">Yeterli</p>
                <p class="stat-value">${yeterliSayisi}</p>
            </div>
            <div class="stat-card is-gold">
                <p class="stat-label">Kritik Seviye</p>
                <p class="stat-value">${kritikSayisi}</p>
            </div>
            <div class="stat-card is-accent">
                <p class="stat-label">Tükendi</p>
                <p class="stat-value">${tukendiSayisi}</p>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/admin/stok" method="GET" class="filter-section" id="filterForm">
            <div class="filter-group">
                <label for="subeId">Şube Filtresi</label>
                <select name="subeId" id="subeId" class="admin-select" onchange="this.form.submit()">
                    <option value="">Tüm Şubeler</option>
                    <c:forEach items="${subeler}" var="sube">
                        <option value="${sube.subeId}" <c:if test="${sube.subeId == seciliSubeId}">selected</c:if>>${sube.subeAdi}</option>
                    </c:forEach>
                </select>
            </div>
        </form>

        <div class="shelf-grid">
            <c:forEach items="${stoklar}" var="stok">
                <c:set var="durumSinifi" value="${stok.mevcutStok == 0 ? 'is-out' : (stok.mevcutStok <= stok.kritikStokSeviyesi ? 'is-critical' : '')}" />
                <c:set var="gaugeYuzde" value="${stok.kritikStokSeviyesi > 0 ? (stok.mevcutStok * 100) / (stok.kritikStokSeviyesi * 2) : (stok.mevcutStok > 0 ? 100 : 0)}" />
                <div class="shelf-card ${durumSinifi}">
                    <div class="shelf-card-head">
                        <div>
                            <div class="shelf-product">${stok.urun.urunAdi}</div>
                            <div class="shelf-branch">${stok.sube.subeAdi}</div>
                        </div>
                        <div class="shelf-count">
                            ${stok.mevcutStok}
                            <span class="unit">adet</span>
                        </div>
                    </div>

                    <div class="shelf-gauge">
                        <div class="shelf-gauge-fill" style="width: ${gaugeYuzde}%;"></div>
                    </div>

                    <div class="shelf-foot">
                        <span>Kritik seviye: ${stok.kritikStokSeviyesi}</span>
                        <c:choose>
                            <c:when test="${stok.mevcutStok == 0}">
                                <span class="stock-out">Tükendi</span>
                            </c:when>
                            <c:when test="${stok.mevcutStok <= stok.kritikStokSeviyesi}">
                                <span class="stock-critical">Kritik</span>
                            </c:when>
                            <c:otherwise>
                                <span class="stock-ok">Yeterli</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty stoklar}">
                <div class="admin-empty">
                    <span class="empty-icon">📦</span>
                    Seçilen kriterlere uygun stok kaydı bulunamadı.
                </div>
            </c:if>
        </div>
    </main>

</body>
</html>
