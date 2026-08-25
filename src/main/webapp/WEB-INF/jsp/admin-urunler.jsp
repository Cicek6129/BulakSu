<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ürün Yönetimi - BulakSu</title>
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
                <p class="admin-eyebrow">Katalog</p>
                <h1 class="admin-title">Ürün Yönetimi</h1>
            </div>
            <div class="nav-tabs">
                <a href="${pageContext.request.contextPath}/admin" class="nav-tab">Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin/stok" class="nav-tab">Stok Durumu</a>
                <a href="${pageContext.request.contextPath}/admin/urunler" class="nav-tab active">Ürün Yönetimi</a>
                <a href="${pageContext.request.contextPath}/admin/kullanicilar" class="nav-tab">Kullanıcılar</a>
                <a href="${pageContext.request.contextPath}/admin/subeler" class="nav-tab">Şubeler</a>
            </div>
        </div>

        <div class="product-management-grid">

            <!-- Yeni Ürün Ekle -->
            <div class="pm-card">
                <div class="pm-card-header">
                    <h3>➕ Yeni Ürün Ekle</h3>
                </div>
                <div class="pm-card-body">
                    <form action="${pageContext.request.contextPath}/admin/urunler" method="POST" class="pm-form">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="form-group">
                            <label>Ürün Adı</label>
                            <input type="text" name="urunAdi" class="admin-input" required>
                        </div>
                        
                        <div class="form-group">
                            <label>Görsel URL (Opsiyonel)</label>
                            <input type="text" name="gorselUrl" class="admin-input" placeholder="https://...">
                        </div>
                        
                        <div class="form-group-checkbox">
                            <input type="checkbox" name="urunSatistami" id="addSatista" checked>
                            <label for="addSatista">Satışta mı?</label>
                        </div>
                        
                        <button type="submit" class="admin-btn admin-btn-primary" style="width: 100%; margin-top: 15px;">Ürünü Ekle</button>
                    </form>
                </div>
            </div>

            <!-- Ürün Güncelle -->
            <div class="pm-card">
                <div class="pm-card-header">
                    <h3>✏️ Ürün Güncelle</h3>
                </div>
                <div class="pm-card-body">
                    <form action="${pageContext.request.contextPath}/admin/urunler" method="POST" class="pm-form">
                        <input type="hidden" name="action" value="update">
                        
                        <div class="form-group">
                            <label>Güncellenecek Ürün</label>
                            <select name="urunId" class="admin-select" required>
                                <option value="">Seçiniz...</option>
                                <c:forEach items="${urunler}" var="u">
                                    <option value="${u.urunId}">${u.urunAdi}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Yeni Ad (Opsiyonel)</label>
                            <input type="text" name="urunAdi" class="admin-input">
                        </div>

                        <div class="form-group">
                            <label>Yeni Görsel URL (Opsiyonel)</label>
                            <input type="text" name="gorselUrl" class="admin-input">
                        </div>
                        
                        <div class="form-group-checkbox">
                            <input type="checkbox" name="urunSatistami" id="updSatista" checked>
                            <label for="updSatista">Satışta mı?</label>
                        </div>
                        
                        <button type="submit" class="admin-btn admin-btn-info" style="width: 100%; margin-top: 15px;">Ürünü Güncelle</button>
                    </form>
                </div>
            </div>

            <!-- Stok Güncelle -->
            <div class="pm-card highlight-card">
                <div class="pm-card-header">
                    <h3>📦 Stok Güncelle</h3>
                    <p>Şube bazında ürün stoklarını güncelleyin</p>
                </div>
                <div class="pm-card-body">
                    <form action="${pageContext.request.contextPath}/admin/urunler" method="POST" class="pm-form">
                        <input type="hidden" name="action" value="updateStock">
                        
                        <div class="form-group">
                            <label>Şube</label>
                            <select name="subeId" id="stokSubeId" class="admin-select" required>
                                <option value="">Şube Seçiniz...</option>
                                <c:forEach items="${subeler}" var="s">
                                    <option value="${s.subeId}">${s.subeAdi}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Ürün</label>
                            <select name="urunId" id="stokUrunId" class="admin-select" required>
                                <option value="">Ürün Seçiniz...</option>
                                <c:forEach items="${urunler}" var="u">
                                    <option value="${u.urunId}">${u.urunAdi}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Mevcut Stok Miktarı</label>
                            <input type="number" name="mevcutStok" id="stokMevcut" class="admin-input" min="0" value="0" required>
                        </div>

                        <div class="form-group">
                            <label>Kritik Stok Seviyesi</label>
                            <input type="number" name="kritikStok" id="stokKritik" class="admin-input" min="0" value="0" required>
                        </div>
                        
                        <button type="submit" class="admin-btn admin-btn-success" style="width: 100%; margin-top: 15px;">Stoku Güncelle</button>
                    </form>
                </div>
            </div>

            <!-- Ürün Sil -->
            <div class="pm-card danger-card">
                <div class="pm-card-header">
                    <h3>❌ Ürün Sil</h3>
                </div>
                <div class="pm-card-body">
                    <form action="${pageContext.request.contextPath}/admin/urunler" method="POST" class="pm-form" onsubmit="return confirm('Bu ürünü silmek istediğinize emin misiniz?');">
                        <input type="hidden" name="action" value="delete">
                        
                        <div class="form-group">
                            <label>Silinecek Ürün</label>
                            <select name="urunId" class="admin-select" required>
                                <option value="">Seçiniz...</option>
                                <c:forEach items="${urunler}" var="u">
                                    <option value="${u.urunId}">${u.urunAdi}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <button type="submit" class="admin-btn admin-btn-danger" style="width: 100%; margin-top: 15px;">Ürünü Sil</button>
                    </form>
                </div>
            </div>

        </div>

    </main>

    <script>
        // Update form auto-fill for convenience (Optional improvement)
        const updateSelect = document.querySelectorAll('select[name="urunId"]')[0];
        if (updateSelect) {
            updateSelect.addEventListener('change', function(e) {
                const selectedText = this.options[this.selectedIndex].text;
                if(this.value) {
                    this.form.querySelector('input[name="urunAdi"]').value = selectedText;
                } else {
                    this.form.querySelector('input[name="urunAdi"]').value = '';
                }
            });
        }

        // AJAX for fetching stock data
        const stokSubeSelect = document.getElementById('stokSubeId');
        const stokUrunSelect = document.getElementById('stokUrunId');
        const stokMevcutInput = document.getElementById('stokMevcut');
        const stokKritikInput = document.getElementById('stokKritik');

        function fetchStokData() {
            const subeId = stokSubeSelect.value;
            const urunId = stokUrunSelect.value;

            if (subeId && urunId) {
                fetch("${pageContext.request.contextPath}/admin/urunler?action=getStock&subeId=" + subeId + "&urunId=" + urunId)
                    .then(response => response.json())
                    .then(data => {
                        stokMevcutInput.value = data.mevcutStok;
                        stokKritikInput.value = data.kritikStok;
                    })
                    .catch(err => console.error("Error fetching stock:", err));
            } else {
                stokMevcutInput.value = 0;
                stokKritikInput.value = 0;
            }
        }

        stokSubeSelect.addEventListener('change', fetchStokData);
        stokUrunSelect.addEventListener('change', fetchStokData);
    </script>
</body>
</html>
