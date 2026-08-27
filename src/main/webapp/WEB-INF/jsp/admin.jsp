<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yönetim Paneli - BulakSu</title>
    <!-- Common styles for variables, then admin specific -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css?v=7">
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
                <p class="admin-eyebrow">Sipariş Yönetimi</p>
                <h1 class="admin-title">Siparişler</h1>
            </div>
            <div class="nav-tabs">
                <a href="${pageContext.request.contextPath}/admin" class="nav-tab active">Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin/stok" class="nav-tab">Stok Durumu</a>
                <a href="${pageContext.request.contextPath}/admin/urunler" class="nav-tab">Ürün Yönetimi</a>
                <a href="${pageContext.request.contextPath}/admin/kullanicilar" class="nav-tab">Kullanıcılar</a>
                <a href="${pageContext.request.contextPath}/admin/subeler" class="nav-tab">Şubeler</a>
            </div>
        </div>

        <%-- Toplam tutarı hesapla --%>
        <c:set var="genelToplam" value="${0}" />
        <c:forEach items="${siparisler}" var="siparisOzet">
            <c:forEach items="${siparisOzet.siparisDetaylari}" var="detayOzet">
                <c:if test="${empty siparisTipi or siparisTipi == detayOzet.siparisTipi}">
                    <c:set var="genelToplam" value="${genelToplam + detayOzet.toplamFiyat}" />
                </c:if>
            </c:forEach>
        </c:forEach>

        <div class="stat-strip">
            <div class="stat-card">
                <p class="stat-label">Toplam Sipariş</p>
                <p class="stat-value">${fn:length(siparisler)}</p>
            </div>
            <div class="stat-card is-success">
                <p class="stat-label">Toplam Tutar</p>
                <p class="stat-value">₺${genelToplam}</p>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/admin" method="GET" class="filter-section" id="filterForm">
            <input type="hidden" name="siparisTipi" id="siparisTipiInput" value="${siparisTipi}">
            
            <div class="filter-group">
                <label for="subeId">Şube Filtresi</label>
                <select name="subeId" id="subeId" class="admin-select" onchange="this.form.submit()">
                    <option value="">Tüm Şubeler</option>
                    <c:forEach items="${subeler}" var="sube">
                        <option value="${sube.subeId}" <c:if test="${sube.subeId == subeId}">selected</c:if>>${sube.subeAdi}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <label for="baslangicTarih">Başlangıç Tarihi</label>
                <input type="date" name="baslangicTarih" id="baslangicTarih" class="admin-input" value="${baslangicTarih}" onchange="this.form.submit()">
            </div>

            <div class="filter-group">
                <label for="bitisTarih">Bitiş Tarihi</label>
                <input type="date" name="bitisTarih" id="bitisTarih" class="admin-input" value="${bitisTarih}" onchange="this.form.submit()">
            </div>

            <button type="button" class="admin-btn admin-btn-excel" onclick="exportExcel()">
                <svg style="width:16px;height:16px;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                Excel'e Aktar
            </button>
        </form>

        <%-- Sipariş Tipi Filtre Butonları --%>
        <div class="tip-filter-bar">
            <button type="button" class="tip-filter-btn ${empty siparisTipi ? 'active' : ''}" onclick="filterByTip('')">
                Tümü
            </button>
            <button type="button" class="tip-filter-btn tip-servis ${siparisTipi == 'S' ? 'active' : ''}" onclick="filterByTip('S')">
                🚚 Servis
            </button>
            <button type="button" class="tip-filter-btn tip-gelal ${siparisTipi == 'G' ? 'active' : ''}" onclick="filterByTip('G')">
                🏠 Gel Al
            </button>
            <button type="button" class="tip-filter-btn tip-toptan ${siparisTipi == 'T' ? 'active' : ''}" onclick="filterByTip('T')">
                📦 Toptan
            </button>
        </div>

        <div class="ticket-grid">
            <c:forEach items="${siparisler}" var="siparis">
                <article class="ticket">
                    <div class="ticket-head">
                        <div class="ticket-id-row">
                            <span class="ticket-id">#${siparis.siparisId}</span>
                            <span class="status-badge status-${siparis.siparisDurumu}">
                                ${siparis.siparisDurumu == 'TAMAMLANDI' ? 'Tamamlandı' : siparis.siparisDurumu}
                            </span>
                        </div>
                        <div class="ticket-meta">
                            <span class="ticket-branch">${siparis.sube.subeAdi}</span>
                            <span>${siparis.siparisTarihi}</span>
                        </div>
                    </div>

                    <c:set var="siparisToplam" value="${0}" />
                    <c:choose>
                        <c:when test="${not empty siparis.siparisDetaylari}">
                            <ul class="ticket-items">
                                <c:forEach items="${siparis.siparisDetaylari}" var="detay">
                                    <c:if test="${empty siparisTipi or siparisTipi == detay.siparisTipi}">
                                        <c:set var="siparisToplam" value="${siparisToplam + detay.toplamFiyat}" />
                                        <li class="ticket-item">
                                            <span class="item-qty">${detay.miktar}×</span>
                                            <span class="item-name">${detay.urun.urunAdi}</span>
                                            <span class="item-price">₺${detay.toplamFiyat}</span>
                                            <span class="item-type type-${fn:toLowerCase(detay.siparisTipi)}">
                                                ${detay.siparisTipi == 'S' ? 'Servis' : (detay.siparisTipi == 'G' ? 'Gel-Al' : 'Toptan')}
                                                · birim ₺${detay.birimFiyat}
                                            </span>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <p class="ticket-empty">Bu siparişe ait detay bulunamadı.</p>
                        </c:otherwise>
                    </c:choose>

                    <div class="ticket-foot">
                        <div class="ticket-total">
                            <span class="label">Sipariş Toplamı</span>
                            <span class="value">₺${siparisToplam}</span>
                        </div>
                        <div class="ticket-controls">
                            <form action="${pageContext.request.contextPath}/admin/siparis-sil" method="POST" onsubmit="return confirm('Bu siparişi tamamen silmek istediğinize emin misiniz?');">
                                <input type="hidden" name="siparisId" value="${siparis.siparisId}">
                                <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/admin?${pageContext.request.queryString != null ? pageContext.request.queryString : ''}">
                                <button type="submit" class="ticket-delete-btn" title="Siparişi Sil">Sil</button>
                            </form>
                        </div>
                    </div>
                </article>
            </c:forEach>

            <c:if test="${empty siparisler}">
                <div class="admin-empty">
                    <span class="empty-icon">🧾</span>
                    Seçilen kriterlere uygun sipariş bulunamadı.
                </div>
            </c:if>
        </div>
    </main>

    <script>
        function filterByTip(tip) {
            document.getElementById('siparisTipiInput').value = tip;
            document.getElementById('filterForm').submit();
        }

        function exportExcel() {
            const form = document.getElementById('filterForm');
            const subeId = form.subeId ? form.subeId.value : '';
            const bas = form.baslangicTarih ? form.baslangicTarih.value : '';
            const bit = form.bitisTarih ? form.bitisTarih.value : '';
            const stokDurum = form.stokDurum ? form.stokDurum.value : '';
            const siparisTipi = form.siparisTipi ? form.siparisTipi.value : '';

            const params = new URLSearchParams();
            if(subeId) params.append('subeId', subeId);
            if(bas) params.append('baslangicTarih', bas);
            if(bit) params.append('bitisTarih', bit);
            if(stokDurum) params.append('stokDurum', stokDurum);
            if(siparisTipi) params.append('siparisTipi', siparisTipi);

            window.location.href = '${pageContext.request.contextPath}/admin/excel?' + params.toString();
        }
    </script>
</body>
</html>
