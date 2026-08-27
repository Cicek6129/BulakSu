<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Şube Yönetimi - BulakSu</title>
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
                <p class="admin-eyebrow">Sistem</p>
                <h1 class="admin-title">Şube Yönetimi</h1>
            </div>
            <div class="nav-tabs">
                <a href="${pageContext.request.contextPath}/admin" class="nav-tab">Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin/stok" class="nav-tab">Stok Durumu</a>
                <a href="${pageContext.request.contextPath}/admin/urunler" class="nav-tab">Ürün Yönetimi</a>
                <a href="${pageContext.request.contextPath}/admin/kullanicilar" class="nav-tab">Kullanıcılar</a>
                <a href="${pageContext.request.contextPath}/admin/subeler" class="nav-tab active">Şubeler</a>
            </div>
        </div>

        <div class="stat-strip">
            <c:set var="toplamSube" value="${fn:length(subeler)}" />
            <c:set var="aktifSube" value="${0}" />
            <c:set var="pasifSube" value="${0}" />
            <c:forEach items="${subeler}" var="s">
                <c:choose>
                    <c:when test="${s.subeAktifmi}">
                        <c:set var="aktifSube" value="${aktifSube + 1}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="pasifSube" value="${pasifSube + 1}" />
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <div class="stat-card">
                <p class="stat-label">Toplam Şube</p>
                <p class="stat-value">${toplamSube}</p>
            </div>
            <div class="stat-card is-success">
                <p class="stat-label">Aktif</p>
                <p class="stat-value">${aktifSube}</p>
            </div>
            <div class="stat-card is-accent">
                <p class="stat-label">Pasif</p>
                <p class="stat-value">${pasifSube}</p>
            </div>
        </div>

        <div class="product-management-grid">

            <!-- Yeni Şube Ekle -->
            <div class="pm-card highlight-card">
                <div class="pm-card-header">
                    <h3>➕ Yeni Şube Ekle</h3>
                </div>
                <div class="pm-card-body">
                    <form action="${pageContext.request.contextPath}/admin/subeler" method="POST" class="pm-form">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="form-group">
                            <label>Şube Adı</label>
                            <input type="text" name="subeAdi" class="admin-input" required>
                        </div>
                        <div class="form-group">
                            <label>Adres</label>
                            <input type="text" name="adres" class="admin-input">
                        </div>
                        <div class="form-group-checkbox">
                            <input type="checkbox" name="subeAktifmi" id="addAktif" checked>
                            <label for="addAktif">Aktif</label>
                        </div>
                        
                        <button type="submit" class="admin-btn admin-btn-success" style="width: 100%; margin-top: 15px;">Şubeyi Ekle</button>
                    </form>
                </div>
            </div>

            <!-- Şube Güncelle -->
            <div class="pm-card">
                <div class="pm-card-header">
                    <h3>✏️ Şube Güncelle</h3>
                </div>
                <div class="pm-card-body">
                    <form action="${pageContext.request.contextPath}/admin/subeler" method="POST" class="pm-form">
                        <input type="hidden" name="action" value="update">
                        
                        <div class="form-group">
                            <label>Güncellenecek Şube</label>
                            <select name="subeId" class="admin-select" required>
                                <option value="">Seçiniz...</option>
                                <c:forEach items="${subeler}" var="s">
                                    <option value="${s.subeId}">${s.subeAdi} ${s.subeAktifmi ? '(Aktif)' : '(Pasif)'}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Yeni Şube Adı (Opsiyonel)</label>
                            <input type="text" name="subeAdi" class="admin-input">
                        </div>

                        <div class="form-group">
                            <label>Yeni Adres (Opsiyonel)</label>
                            <input type="text" name="adres" class="admin-input">
                        </div>

                        <div class="form-group-checkbox">
                            <input type="checkbox" name="subeAktifmi" id="updateAktif" checked>
                            <label for="updateAktif">Aktif</label>
                        </div>
                        
                        <button type="submit" class="admin-btn admin-btn-info" style="width: 100%; margin-top: 15px;">Şubeyi Güncelle</button>
                    </form>
                </div>
            </div>

            <!-- Şube Sil -->
            <div class="pm-card danger-card">
                <div class="pm-card-header">
                    <h3>❌ Şube Sil</h3>
                </div>
                <div class="pm-card-body">
                    <form action="${pageContext.request.contextPath}/admin/subeler" method="POST" class="pm-form" onsubmit="return confirm('Bu şubeyi tamamen silmek istediğinize emin misiniz? Şubeye ait stok kayıtları varsa bu işlem başarısız olabilir.');">
                        <input type="hidden" name="action" value="delete">
                        
                        <div class="form-group">
                            <label>Silinecek Şube</label>
                            <select name="subeId" class="admin-select" required>
                                <option value="">Seçiniz...</option>
                                <c:forEach items="${subeler}" var="s">
                                    <option value="${s.subeId}">${s.subeAdi}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <button type="submit" class="admin-btn admin-btn-danger" style="width: 100%; margin-top: 15px;">Şubeyi Sil</button>
                    </form>
                </div>
            </div>

        </div>

    </main>
</body>
</html>
