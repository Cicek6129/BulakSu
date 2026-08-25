<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kullanıcı Yönetimi - BulakSu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css?v=6">
</head>
<body class="admin-mode">
    <div class="bg-particles">
        <div class="particle"></div><div class="particle"></div><div class="particle"></div>
        <div class="particle"></div><div class="particle"></div><div class="particle"></div>
    </div>

    <header class="admin-header">
        <div class="admin-logo">
            <span class="admin-logo-mark">🛒</span>
            BulakSu Yönetim
        </div>
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
                <h1 class="admin-title">Kullanıcı Yönetimi</h1>
            </div>
            <div class="nav-tabs">
                <a href="${pageContext.request.contextPath}/admin" class="nav-tab">Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin/stok" class="nav-tab">Stok Durumu</a>
                <a href="${pageContext.request.contextPath}/admin/urunler" class="nav-tab">Ürün Yönetimi</a>
                <a href="${pageContext.request.contextPath}/admin/kullanicilar" class="nav-tab active">Kullanıcılar</a>
                <a href="${pageContext.request.contextPath}/admin/subeler" class="nav-tab">Şubeler</a>
            </div>
        </div>

        <div class="product-management-grid">

            <!-- Yeni Kullanıcı Ekle -->
            <div class="pm-card highlight-card">
                <div class="pm-card-header">
                    <h3>➕ Yeni Kullanıcı Ekle</h3>
                </div>
                <div class="pm-card-body">
                    <form action="${pageContext.request.contextPath}/admin/kullanicilar" method="POST" class="pm-form">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="pm-card-body double-col" style="padding:0;">
                            <div class="form-group">
                                <label>Ad Soyad</label>
                                <input type="text" name="adSoyad" class="admin-input" required>
                            </div>
                            <div class="form-group">
                                <label>Telefon</label>
                                <input type="text" name="telefon" class="admin-input">
                            </div>
                            <div class="form-group">
                                <label>E-posta (Giriş ID)</label>
                                <input type="email" name="email" class="admin-input" required>
                            </div>
                            <div class="form-group">
                                <label>Şifre</label>
                                <input type="password" name="sifre" class="admin-input" required>
                            </div>
                        </div>
                        
                        <div class="form-group" style="margin-top: 10px;">
                            <label>Atanacak Şube</label>
                            <select name="subeId" class="admin-select">
                                <option value="">Tüm Şubeler (Admin)</option>
                                <c:forEach items="${subeler}" var="s">
                                    <option value="${s.subeId}">${s.subeAdi}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <button type="submit" class="admin-btn admin-btn-success" style="width: 100%; margin-top: 15px;">Kullanıcıyı Ekle</button>
                    </form>
                </div>
            </div>

            <!-- Kullanıcı Güncelle -->
            <div class="pm-card">
                <div class="pm-card-header">
                    <h3>✏️ Kullanıcı Güncelle</h3>
                </div>
                <div class="pm-card-body">
                    <form action="${pageContext.request.contextPath}/admin/kullanicilar" method="POST" class="pm-form">
                        <input type="hidden" name="action" value="update">
                        
                        <div class="form-group">
                            <label>Güncellenecek Kullanıcı</label>
                            <select name="kullaniciId" class="admin-select" required>
                                <option value="">Seçiniz...</option>
                                <c:forEach items="${kullanicilar}" var="k">
                                    <option value="${k.kullaniciId}">${k.adSoyad} (${k.email}) ${not empty k.sube ? '— '.concat(k.sube.subeAdi) : '— Tüm Şubeler'}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Yeni Ad Soyad (Opsiyonel)</label>
                            <input type="text" name="adSoyad" class="admin-input">
                        </div>

                        <div class="form-group">
                            <label>Yeni E-posta (Opsiyonel)</label>
                            <input type="email" name="email" class="admin-input">
                        </div>

                        <div class="form-group">
                            <label>Yeni Şifre (Opsiyonel)</label>
                            <input type="password" name="sifre" class="admin-input">
                        </div>

                        <div class="form-group">
                            <label>Şube Ataması</label>
                            <select name="subeId" class="admin-select">
                                <option value="">Tüm Şubeler (Admin)</option>
                                <c:forEach items="${subeler}" var="s">
                                    <option value="${s.subeId}">${s.subeAdi}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <button type="submit" class="admin-btn admin-btn-info" style="width: 100%; margin-top: 15px;">Kullanıcıyı Güncelle</button>
                    </form>
                </div>
            </div>

            <!-- Kullanıcı Sil -->
            <div class="pm-card danger-card">
                <div class="pm-card-header">
                    <h3>❌ Kullanıcı Sil</h3>
                </div>
                <div class="pm-card-body">
                    <form action="${pageContext.request.contextPath}/admin/kullanicilar" method="POST" class="pm-form" onsubmit="return confirm('Bu kullanıcıyı tamamen silmek istediğinize emin misiniz?');">
                        <input type="hidden" name="action" value="delete">
                        
                        <div class="form-group">
                            <label>Silinecek Kullanıcı</label>
                            <select name="kullaniciId" class="admin-select" required>
                                <option value="">Seçiniz...</option>
                                <c:forEach items="${kullanicilar}" var="k">
                                    <option value="${k.kullaniciId}">${k.adSoyad} ${not empty k.sube ? '— '.concat(k.sube.subeAdi) : ''}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <button type="submit" class="admin-btn admin-btn-danger" style="width: 100%; margin-top: 15px;">Kullanıcıyı Sil</button>
                    </form>
                </div>
            </div>

        </div>

    </main>
</body>
</html>
