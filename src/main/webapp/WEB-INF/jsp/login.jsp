<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giriş - BulakSu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Fraunces:opsz,wght@9..144,600;9..144,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-login.css">
</head>
<body>
    <div class="bg-particles">
        <div class="particle"></div><div class="particle"></div><div class="particle"></div>
        <div class="particle"></div><div class="particle"></div><div class="particle"></div>
    </div>

    <div class="login-wrapper">
        <div class="login-brand">
            <div class="brand-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="9" cy="21" r="1"></circle>
                    <circle cx="19" cy="21" r="1"></circle>
                    <path d="M2 3h2l2.6 12.4a2 2 0 0 0 2 1.6h9.8a2 2 0 0 0 2-1.6L22 7H6"></path>
                </svg>
            </div>
            <h1 class="brand-name">BulakSu</h1>
            <p class="brand-subtitle">Giriş Ekranı</p>
        </div>

        <div class="login-card">
            <div class="card-header">
                <h2>Giriş Yap</h2>
                <p>Devam etmek için giriş yapın</p>
            </div>

            <c:if test="${not empty userHata}">
                <div class="error-message">
                    <span>${userHata}</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/giris" method="POST" class="login-form">
                <input type="hidden" name="loginType" value="user">
                <div class="form-group">
                    <label for="email">E-posta veya Kullanıcı Adı</label>
                    <div class="input-wrapper">
                        <input type="text" id="email" name="email" placeholder="E-posta veya Kullanıcı Adı" value="${email}" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="sifre-user">Şifre</label>
                    <div class="input-wrapper">
                        <input type="password" id="sifre-user" name="sifre" placeholder="Şifreniz" required>
                    </div>
                </div>

                <button type="submit" class="login-btn">
                    <span class="btn-text">Giriş Yap</span>
                </button>
            </form>
        </div>

        <div class="login-footer">
            <p>&copy; 2026 BulakSu. Tüm hakları saklıdır.</p>
        </div>
    </div>
</body>
</html>
