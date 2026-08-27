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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-login.css?v=4">
</head>
<body>
    <div class="bg-particles">
        <div class="particle"></div><div class="particle"></div><div class="particle"></div>
        <div class="particle"></div><div class="particle"></div><div class="particle"></div>
    </div>

    <div class="login-wrapper">
        <div class="login-brand">
            <div class="brand-logo-wrapper">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="BulakSu Logo" class="brand-logo-img" style="height: 55px; width: auto; max-width: 200px;">
            </div>
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
