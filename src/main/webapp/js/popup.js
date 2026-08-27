/* ============================================================
   BulakSu – Custom Popup / Modal & Toast JS
   ============================================================ */

var BsPopup = (function () {
    'use strict';

    // Toast container (lazily created)
    var toastContainer = null;

    function getToastContainer() {
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'bs-toast-container';
            document.body.appendChild(toastContainer);
        }
        return toastContainer;
    }

    // ── CONFIRM POPUP ──────────────────────────────────────────
    function confirm(options) {
        var title = options.title || 'Emin misiniz?';
        var message = options.message || '';
        var confirmText = options.confirmText || 'Evet';
        var cancelText = options.cancelText || 'İptal';
        var iconType = options.icon || 'warning'; // warning, danger, success, info
        var btnStyle = options.btnStyle || 'confirm'; // confirm, danger, success
        var onConfirm = options.onConfirm || function () {};
        var onCancel = options.onCancel || function () {};

        var iconEmoji = '⚠️';
        if (iconType === 'danger') iconEmoji = '🗑️';
        else if (iconType === 'success') iconEmoji = '✅';
        else if (iconType === 'info') iconEmoji = 'ℹ️';

        var overlay = document.createElement('div');
        overlay.className = 'bs-popup-overlay';
        overlay.innerHTML =
            '<div class="bs-popup-card">' +
                '<div class="bs-popup-icon icon-' + iconType + '">' + iconEmoji + '</div>' +
                '<h3 class="bs-popup-title">' + title + '</h3>' +
                '<p class="bs-popup-message">' + message + '</p>' +
                '<div class="bs-popup-actions">' +
                    '<button type="button" class="bs-popup-btn bs-popup-btn-cancel">' + cancelText + '</button>' +
                    '<button type="button" class="bs-popup-btn bs-popup-btn-' + btnStyle + '">' + confirmText + '</button>' +
                '</div>' +
            '</div>';

        document.body.appendChild(overlay);

        // Animate in
        requestAnimationFrame(function () {
            overlay.classList.add('active');
        });

        var confirmBtn = overlay.querySelector('.bs-popup-btn-' + btnStyle);
        var cancelBtn = overlay.querySelector('.bs-popup-btn-cancel');

        function close() {
            overlay.classList.remove('active');
            setTimeout(function () {
                if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
            }, 300);
        }

        confirmBtn.addEventListener('click', function () {
            close();
            onConfirm();
        });

        cancelBtn.addEventListener('click', function () {
            close();
            onCancel();
        });

        // ESC tuşu ile kapat
        function escHandler(e) {
            if (e.key === 'Escape') {
                close();
                onCancel();
                document.removeEventListener('keydown', escHandler);
            }
        }
        document.addEventListener('keydown', escHandler);

        // Overlay tıklayınca kapat
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) {
                close();
                onCancel();
            }
        });
    }

    // ── ALERT POPUP (tek butonlu) ──────────────────────────────
    function alert(options) {
        var title = options.title || 'Bilgi';
        var message = options.message || '';
        var btnText = options.btnText || 'Tamam';
        var iconType = options.icon || 'info';
        var btnStyle = options.btnStyle || 'confirm';
        var onClose = options.onClose || function () {};

        var iconEmoji = 'ℹ️';
        if (iconType === 'danger') iconEmoji = '❌';
        else if (iconType === 'success') iconEmoji = '✅';
        else if (iconType === 'warning') iconEmoji = '⚠️';

        var overlay = document.createElement('div');
        overlay.className = 'bs-popup-overlay';
        overlay.innerHTML =
            '<div class="bs-popup-card">' +
                '<div class="bs-popup-icon icon-' + iconType + '">' + iconEmoji + '</div>' +
                '<h3 class="bs-popup-title">' + title + '</h3>' +
                '<p class="bs-popup-message">' + message + '</p>' +
                '<div class="bs-popup-actions">' +
                    '<button type="button" class="bs-popup-btn bs-popup-btn-' + btnStyle + '">' + btnText + '</button>' +
                '</div>' +
            '</div>';

        document.body.appendChild(overlay);

        requestAnimationFrame(function () {
            overlay.classList.add('active');
        });

        var btn = overlay.querySelector('.bs-popup-btn-' + btnStyle);

        function close() {
            overlay.classList.remove('active');
            setTimeout(function () {
                if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
            }, 300);
        }

        btn.addEventListener('click', function () {
            close();
            onClose();
        });

        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) {
                close();
                onClose();
            }
        });

        function escHandler(e) {
            if (e.key === 'Escape') {
                close();
                onClose();
                document.removeEventListener('keydown', escHandler);
            }
        }
        document.addEventListener('keydown', escHandler);
    }

    // ── TOAST BİLDİRİM ────────────────────────────────────────
    function toast(options) {
        var title = options.title || '';
        var message = options.message || '';
        var type = options.type || 'info'; // success, error, warning, info
        var duration = options.duration || 4000;

        var iconEmoji = 'ℹ️';
        if (type === 'success') iconEmoji = '✅';
        else if (type === 'error') iconEmoji = '❌';
        else if (type === 'warning') iconEmoji = '⚠️';

        var container = getToastContainer();

        var toastEl = document.createElement('div');
        toastEl.className = 'bs-toast toast-' + type;
        toastEl.style.position = 'relative';
        toastEl.innerHTML =
            '<span class="bs-toast-icon">' + iconEmoji + '</span>' +
            '<div class="bs-toast-content">' +
                '<div class="bs-toast-title">' + title + '</div>' +
                (message ? '<div class="bs-toast-msg">' + message + '</div>' : '') +
            '</div>' +
            '<button type="button" class="bs-toast-close">&times;</button>' +
            '<div class="bs-toast-progress" style="width: 100%;"></div>';

        container.appendChild(toastEl);

        // Animate in
        requestAnimationFrame(function () {
            toastEl.classList.add('show');
        });

        // Progress bar
        var progress = toastEl.querySelector('.bs-toast-progress');
        progress.style.transitionDuration = duration + 'ms';
        requestAnimationFrame(function () {
            setTimeout(function () {
                progress.style.width = '0%';
            }, 50);
        });

        function removeToast() {
            toastEl.classList.remove('show');
            toastEl.classList.add('hide');
            setTimeout(function () {
                if (toastEl.parentNode) toastEl.parentNode.removeChild(toastEl);
            }, 350);
        }

        // Auto dismiss
        var timer = setTimeout(removeToast, duration);

        // Close button
        toastEl.querySelector('.bs-toast-close').addEventListener('click', function () {
            clearTimeout(timer);
            removeToast();
        });
    }

    // ── FORM CONFIRM HELPER ────────────────────────────────────
    // Form submit'i yakalar, özel popup gösterir, onaylanınca submit eder
    function confirmForm(formEl, options) {
        var confirmed = false;
        formEl.addEventListener('submit', function (e) {
            if (confirmed) {
                confirmed = false; // Reset for potential future use
                return true; // Allow form to submit normally
            }
            e.preventDefault();
            var self = this;
            confirm({
                title: options.title || 'Emin misiniz?',
                message: options.message || '',
                icon: options.icon || 'danger',
                btnStyle: options.btnStyle || 'danger',
                confirmText: options.confirmText || 'Evet, Sil',
                cancelText: options.cancelText || 'İptal',
                onConfirm: function () {
                    confirmed = true;
                    // requestSubmit kullanarak submit event'i tetikle (submit butonuyla)
                    if (self.requestSubmit) {
                        self.requestSubmit();
                    } else {
                        self.submit();
                    }
                }
            });
        });
    }

    // ── URL'den success/error parametrelerini oku ve toast göster ──
    function checkUrlParams() {
        var params = new URLSearchParams(window.location.search);

        if (params.get('success') === 'true') {
            toast({
                title: 'Başarılı!',
                message: 'İşlem başarıyla tamamlandı.',
                type: 'success',
                duration: 4000
            });
            // URL'den parametreleri temizle
            cleanUrl();
        }

        if (params.get('error')) {
            var errorType = params.get('error');
            var mesaj = params.get('mesaj') || '';
            var title = 'Hata!';
            var message = 'İşlem sırasında bir hata oluştu.';

            if (errorType === 'empty') {
                title = 'Sepet Boş';
                message = 'Sipariş vermek için sepetinize ürün ekleyin.';
            } else if (errorType === 'stok') {
                title = 'Yetersiz Stok';
                message = mesaj || 'Seçilen ürün için yeterli stok bulunmuyor.';
            } else if (errorType === 'yetersiz') {
                title = 'Yetersiz Stok';
                message = 'Girdiğiniz miktar mevcut stoktan fazla olamaz!';
            }

            toast({
                title: title,
                message: message,
                type: 'error',
                duration: 5000
            });
            cleanUrl();
        }
    }

    function cleanUrl() {
        if (window.history && window.history.replaceState) {
            var url = window.location.pathname;
            window.history.replaceState({}, document.title, url);
        }
    }

    // Public API
    return {
        confirm: confirm,
        alert: alert,
        toast: toast,
        confirmForm: confirmForm,
        checkUrlParams: checkUrlParams
    };
})();

// Sayfa yüklendiğinde URL parametrelerini kontrol et
document.addEventListener('DOMContentLoaded', function () {
    BsPopup.checkUrlParams();
});
