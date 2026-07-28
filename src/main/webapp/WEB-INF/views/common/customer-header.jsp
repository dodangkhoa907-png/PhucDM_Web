<%@ page pageEncoding="UTF-8" %>
<%-- Shared customer navbar. Included via <%@ include %> so it shares the
     caller's pageContext/taglibs. Requires request attribute "currentPage"
     to be set by the caller's servlet for active-state highlighting
     ("products" | "cart" | "account"); Home sets nothing and highlights nothing.
     "menu" vẫn được chấp nhận cho tương thích ngược (route /thuc-don cũ đã redirect
     sang /san-pham nên currentPage="menu" không còn servlet nào set nữa). --%>
<nav class="navbar" id="navbar">
    <div class="container">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <div class="navbar-logo">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M17 8C8 10 5.9 16.17 3.82 21.34l1.89.66.95-2.3c.48.17.98.3 1.34.3C19 20 22 3 22 3c-1 2-8 2.25-13 3.25S2 11.5 2 13.5s1.75 3.75 1.75 3.75C7 8 17 8 17 8z"/>
                </svg>
            </div>
            <div class="navbar-name">Eight <span>Tea</span></div>
        </a>

        <div class="nav-links" id="navLinks">
            <button type="button" class="nav-close-btn mobile-only" id="navClose" aria-label="Đóng menu">
                <i class="fa-solid fa-xmark"></i>
            </button>
            <a href="${pageContext.request.contextPath}/" class="${empty currentPage ? 'active' : ''}">Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/san-pham"
               class="${(currentPage == 'products' || currentPage == 'menu') ? 'active' : ''}">Sản Phẩm</a>
            <c:if test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/cart"
                   class="nav-cart-link desktop-only ${currentPage == 'cart' ? 'active' : ''}" aria-label="Giỏ hàng">
                    <i class="fa-solid fa-basket-shopping"></i>
                    <span class="nav-cart-badge" id="navCartBadge"
                          ${empty sessionScope.cartCount || sessionScope.cartCount == 0 ? 'hidden' : ''}>
                        ${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}
                    </span>
                </a>
            </c:if>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <!-- Desktop: nút + dropdown hover/click -->
                    <div class="nav-user-wrap desktop-only" id="navUserWrap">
                        <button type="button" class="nav-user-trigger ${currentPage == 'account' ? 'active' : ''}" id="navUserTrigger" aria-haspopup="true" aria-expanded="false">
                            <i class="fa-solid fa-user"></i> Tài Khoản
                            <i class="fa-solid fa-chevron-down nav-user-caret"></i>
                        </button>
                        <div class="nav-user-menu" id="navUserMenu" role="menu">
                            <a href="${pageContext.request.contextPath}/account" role="menuitem"><i class="fa-solid fa-gauge"></i> Tổng quan tài khoản</a>
                            <a href="${pageContext.request.contextPath}/account/orders" role="menuitem"><i class="fa-solid fa-box"></i> Đơn hàng của tôi</a>
                            <a href="${pageContext.request.contextPath}/account/profile" role="menuitem"><i class="fa-solid fa-user"></i> Hồ sơ cá nhân</a>
                            <a href="${pageContext.request.contextPath}/account/addresses" role="menuitem"><i class="fa-solid fa-location-dot"></i> Sổ địa chỉ</a>
                            <a href="${pageContext.request.contextPath}/account/preferences" role="menuitem"><i class="fa-solid fa-heart"></i> Sở thích của tôi</a>
                            <a href="${pageContext.request.contextPath}/account/security" role="menuitem"><i class="fa-solid fa-shield-halved"></i> Bảo mật</a>
                            <div class="nav-user-menu-divider"></div>
                            <form method="post" action="${pageContext.request.contextPath}/logout" class="nav-user-logout-form">
                                <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                                <button type="submit" role="menuitem"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</button>
                            </form>
                        </div>
                    </div>
                    <!-- Mobile: bấm "Tài Khoản" vào thẳng trang tài khoản, đăng xuất ngay bên dưới — không cần dropdown -->
                    <a href="${pageContext.request.contextPath}/account" class="mobile-only ${currentPage == 'account' ? 'active' : ''}">
                        <i class="fa-solid fa-user" style="margin-right:10px"></i>Tài Khoản
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/logout" class="nav-logout-form-mobile mobile-only-flex">
                        <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                        <button type="submit" class="nav-logout-btn-mobile"><i class="fa-solid fa-right-from-bracket" style="margin-right:10px"></i>Đăng xuất</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <!-- Desktop: nút mở dropdown đăng nhập nhanh, hiệu ứng giống menu tài khoản -->
                    <div class="nav-login-wrap desktop-only" id="navLoginWrap">
                        <button type="button" class="nav-login-icon-trigger" id="navLoginTrigger" aria-haspopup="true" aria-expanded="false" aria-label="Đăng nhập">
                            <i class="fa-solid fa-user"></i>
                        </button>
                        <div class="nav-login-panel" id="navLoginPanel" role="menu">

                            <!-- VIEW 1: đăng nhập nhanh -->
                            <div class="auth-view" data-view="login">
                                <div class="nav-login-panel-head">
                                    <span class="nav-login-panel-title">Chào mừng trở lại</span>
                                    <span class="nav-login-panel-sub">Đăng nhập để đặt hàng nhanh hơn</span>
                                </div>
                                <div class="auth-mini-alert ok" id="authLoginOk">Mật khẩu đã được đặt lại thành công. Hãy đăng nhập bằng mật khẩu mới.</div>
                                <form method="post" action="${pageContext.request.contextPath}/login" class="nav-login-form">
                                    <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                                    <div class="nav-login-field">
                                        <input type="email" name="email" placeholder="Email của bạn" required>
                                    </div>
                                    <div class="nav-login-field">
                                        <input type="password" name="password" placeholder="Mật khẩu" required>
                                    </div>
                                    <button type="submit" class="nav-login-submit">Đăng nhập</button>
                                </form>
                                <div class="nav-login-panel-foot">
                                    <button type="button" class="auth-back" style="padding:0" data-goto="forgot-email">Quên mật khẩu?</button>
                                    <a href="${pageContext.request.contextPath}/register" class="nav-login-panel-cta" data-transition>Đăng ký ngay <i class="fa-solid fa-arrow-right"></i></a>
                                </div>
                            </div>

                            <!-- VIEW 2: nhập email để nhận OTP -->
                            <div class="auth-view" data-view="forgot-email" hidden>
                                <button type="button" class="auth-back" data-goto="login"><i class="fa-solid fa-arrow-left"></i> Quay lại</button>
                                <div class="nav-login-panel-head">
                                    <span class="nav-login-panel-title">Quên mật khẩu</span>
                                    <span class="nav-login-panel-sub">Nhập email để nhận mã OTP đặt lại mật khẩu</span>
                                </div>
                                <div class="auth-mini-alert err" id="forgotEmailErr"></div>
                                <form class="nav-login-form" id="forgotEmailForm">
                                    <div class="nav-login-field">
                                        <input type="email" name="email" id="forgotEmailInput" placeholder="Email của bạn" required>
                                    </div>
                                    <button type="submit" class="nav-login-submit">Gửi mã OTP</button>
                                </form>
                            </div>

                            <!-- VIEW 3: nhập mã OTP -->
                            <div class="auth-view" data-view="otp" hidden>
                                <button type="button" class="auth-back" data-goto="forgot-email"><i class="fa-solid fa-arrow-left"></i> Quay lại</button>
                                <div class="nav-login-panel-head">
                                    <span class="nav-login-panel-title">Nhập mã OTP</span>
                                    <span class="nav-login-panel-sub">Mã 6 số vừa gửi tới <b id="otpEmailLabel"></b></span>
                                </div>
                                <div class="auth-mini-alert err" id="otpErr"></div>
                                <form class="nav-login-form" id="otpForm">
                                    <div class="otp-mini-row">
                                        <input class="otp-mini-box" data-d="1" maxlength="1" inputmode="numeric" autocomplete="one-time-code">
                                        <input class="otp-mini-box" data-d="2" maxlength="1" inputmode="numeric">
                                        <input class="otp-mini-box" data-d="3" maxlength="1" inputmode="numeric">
                                        <input class="otp-mini-box" data-d="4" maxlength="1" inputmode="numeric">
                                        <input class="otp-mini-box" data-d="5" maxlength="1" inputmode="numeric">
                                        <input class="otp-mini-box" data-d="6" maxlength="1" inputmode="numeric">
                                    </div>
                                    <div class="otp-mini-meta">
                                        <span>Hết hạn sau <span class="time" id="otpTimer">5:00</span></span>
                                        <button type="button" class="otp-mini-resend" id="otpResendBtn" disabled>Gửi lại mã</button>
                                    </div>
                                    <button type="submit" class="nav-login-submit">Xác nhận</button>
                                </form>
                            </div>

                            <!-- VIEW 4: đặt mật khẩu mới -->
                            <div class="auth-view" data-view="reset" hidden>
                                <div class="nav-login-panel-head">
                                    <span class="nav-login-panel-title">Mật khẩu mới</span>
                                    <span class="nav-login-panel-sub">Tạo mật khẩu mới cho tài khoản của bạn</span>
                                </div>
                                <div class="auth-mini-alert err" id="resetErr"></div>
                                <form class="nav-login-form" id="resetForm">
                                    <div class="nav-login-field">
                                        <input type="password" name="password" id="resetPassword" placeholder="Mật khẩu mới" required>
                                    </div>
                                    <div class="mini-strength-track">
                                        <span class="mini-strength-seg" id="mseg0"></span><span class="mini-strength-seg" id="mseg1"></span><span class="mini-strength-seg" id="mseg2"></span>
                                    </div>
                                    <div class="nav-login-field" style="margin-top:8px">
                                        <input type="password" name="confirmPassword" id="resetConfirm" placeholder="Xác nhận mật khẩu mới" required>
                                    </div>
                                    <div class="mini-match" id="resetMatch"></div>
                                    <button type="submit" class="nav-login-submit" id="resetSubmitBtn" disabled>Đổi mật khẩu</button>
                                </form>
                            </div>

                        </div>
                    </div>
                    <!-- Mobile: vào thẳng trang đăng nhập đầy đủ, không cần dropdown -->
                    <a href="${pageContext.request.contextPath}/login" class="mobile-only nav-login-link-mobile" data-transition>
                        <i class="fa-solid fa-right-to-bracket" style="margin-right:10px"></i> Đăng Nhập
                    </a>
                </c:otherwise>
            </c:choose>
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/san-pham" class="nav-cta">Đặt Hàng</a>
            </c:if>
        </div>

        <!-- Mobile: giỏ hàng nằm ngoài drawer, ngay cạnh nút mở menu -->
        <div class="nav-mobile-actions mobile-only-flex">
            <c:if test="${not empty sessionScope.user}">
            <a href="${pageContext.request.contextPath}/cart"
               class="nav-cart-link nav-cart-link--icon ${currentPage == 'cart' ? 'active' : ''}" aria-label="Giỏ hàng">
                <i class="fa-solid fa-basket-shopping"></i>
                <span class="nav-cart-badge" id="navCartBadgeMobile"
                      ${empty sessionScope.cartCount || sessionScope.cartCount == 0 ? 'hidden' : ''}>
                    ${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}
                </span>
            </a>
            </c:if>
            <button class="nav-toggle" id="navToggle" aria-label="Menu">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </div>
</nav>

<div class="nav-backdrop" id="navBackdrop"></div>

<script>
    (function () {
        var navLinks = document.getElementById('navLinks');
        var navToggle = document.getElementById('navToggle');
        var navClose = document.getElementById('navClose');
        var navBackdrop = document.getElementById('navBackdrop');

        function openDrawer() {
            if (navLinks) navLinks.classList.add('active');
            if (navBackdrop) navBackdrop.classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeDrawer() {
            if (navLinks) navLinks.classList.remove('active');
            if (navBackdrop) navBackdrop.classList.remove('active');
            document.body.style.overflow = '';
        }

        function toggleDrawer(e) {
            if (e) e.stopPropagation();
            if (navLinks && navLinks.classList.contains('active')) {
                closeDrawer();
            } else {
                openDrawer();
            }
        }

        window.NhietDoiXanhToggleNav = toggleDrawer;

        if (navToggle) navToggle.onclick = toggleDrawer;
        if (navClose) navClose.onclick = closeDrawer;
        if (navBackdrop) navBackdrop.onclick = closeDrawer;

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') closeDrawer();
        });

        var wrap = document.getElementById('navUserWrap');
        var trigger = document.getElementById('navUserTrigger');
        if (wrap && trigger) {
            trigger.onclick = function (e) {
                e.stopPropagation();
                var isOpen = wrap.classList.toggle('open');
                trigger.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
            };
            document.addEventListener('click', function (e) {
                if (!wrap.contains(e.target)) {
                    wrap.classList.remove('open');
                    trigger.setAttribute('aria-expanded', 'false');
                }
            });
        }

        var loginWrap = document.getElementById('navLoginWrap');
        var loginTrigger = document.getElementById('navLoginTrigger');
        if (loginWrap && loginTrigger) {
            var loginCloseTimer = null;

            function openLoginPanel() {
                clearTimeout(loginCloseTimer);
                loginWrap.classList.add('open');
                loginTrigger.setAttribute('aria-expanded', 'true');
            }
            function closeLoginPanel() {
                loginWrap.classList.remove('open');
                loginTrigger.setAttribute('aria-expanded', 'false');
            }
            function scheduleClose() {
                clearTimeout(loginCloseTimer);
                loginCloseTimer = setTimeout(closeLoginPanel, 260);
            }

            loginTrigger.onclick = function (e) {
                e.stopPropagation();
                if (loginWrap.classList.contains('open')) {
                    closeLoginPanel();
                } else {
                    openLoginPanel();
                    var firstField = loginWrap.querySelector('input[name="email"]');
                    if (firstField) setTimeout(function () { firstField.focus(); }, 180);
                }
            };
            /* Hover: di chuột vào icon mở panel ngay, rời chuột đóng lại sau một nhịp
               ngắn (để có thể trượt chuột từ icon sang panel mà không bị đóng giữa chừng). */
            loginWrap.addEventListener('mouseenter', openLoginPanel);
            loginWrap.addEventListener('mouseleave', scheduleClose);

            document.addEventListener('click', function (e) {
                if (!loginWrap.contains(e.target)) closeLoginPanel();
            });
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') closeLoginPanel();
            });

            /* Lối vào công khai cho các script khác (vd. cart.js) khi guest bấm
               một hành động cần đăng nhập — mở dropdown auth thay vì điều hướng
               sang trang /login riêng. */
            window.openAuthLoginDropdown = function () {
                openLoginPanel();
                var firstField = loginWrap.querySelector('input[name="email"]');
                if (firstField) setTimeout(function () { firstField.focus(); }, 180);
            };
        }
    })();

    /* Hiệu ứng chuyển mượt khi bấm các link đăng nhập/đăng ký/quên mật khẩu:
       fade-out trang hiện tại trước khi điều hướng, thay vì reload đột ngột. */
    (function () {
        document.addEventListener('click', function (e) {
            var link = e.target.closest('[data-transition]');
            if (!link || e.metaKey || e.ctrlKey || e.shiftKey || link.target === '_blank') return;
            e.preventDefault();
            document.body.classList.add('page-leaving');
            setTimeout(function () { window.location.href = link.href; }, 220);
        });
    })();

    /* Panel "Quên mật khẩu" nhiều bước, gói gọn trong dropdown đăng nhập —
       gọi AJAX tới PasswordResetController (header X-Requested-With báo cho
       servlet trả JSON thay vì forward/redirect như luồng full-page cũ). */
    (function () {
        var panel = document.getElementById('navLoginPanel');
        if (!panel) return;
        var ctx = '${pageContext.request.contextPath}';
        var csrf = '${sessionScope._csrf}';
        var views = panel.querySelectorAll('.auth-view');
        var otpTimerHandle = null;
        var resendCooldownHandle = null;
        var otpExpiresAt = 0;

        function showView(name) {
            views.forEach(function (v) { v.hidden = v.getAttribute('data-view') !== name; });
        }

        panel.addEventListener('click', function (e) {
            var btn = e.target.closest('[data-goto]');
            if (!btn) return;
            showView(btn.getAttribute('data-goto'));
        });

        function postJson(path, params) {
            var body = new URLSearchParams(params || {});
            body.set('_csrf', csrf);
            return fetch(ctx + path, {
                method: 'POST',
                credentials: 'same-origin',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: body.toString()
            }).then(function (r) { return r.json(); });
        }

        function showAlert(el, msg) {
            el.textContent = msg;
            el.classList.add('show');
        }
        function hideAlert(el) { el.classList.remove('show'); }

        /* ── Bước 1: nhập email ── */
        var forgotForm = document.getElementById('forgotEmailForm');
        var forgotErr = document.getElementById('forgotEmailErr');
        var otpEmailLabel = document.getElementById('otpEmailLabel');
        if (forgotForm) {
            forgotForm.addEventListener('submit', function (e) {
                e.preventDefault();
                hideAlert(forgotErr);
                var email = document.getElementById('forgotEmailInput').value.trim();
                postJson('/forgot-password', { email: email }).then(function (data) {
                    if (data.success) {
                        otpEmailLabel.textContent = email;
                        startOtpCountdown(data.remainingMs || 300000);
                        showView('otp');
                    } else {
                        showAlert(forgotErr, data.message || 'Có lỗi xảy ra, vui lòng thử lại.');
                    }
                }).catch(function () { showAlert(forgotErr, 'Không thể kết nối máy chủ.'); });
            });
        }

        /* ── Bước 2: nhập OTP ── */
        var otpForm = document.getElementById('otpForm');
        var otpErr = document.getElementById('otpErr');
        var otpBoxes = panel.querySelectorAll('.otp-mini-box');
        var otpTimerEl = document.getElementById('otpTimer');
        var otpResendBtn = document.getElementById('otpResendBtn');

        otpBoxes.forEach(function (box, i) {
            box.addEventListener('input', function () {
                box.value = box.value.replace(/[^0-9]/g, '').slice(0, 1);
                if (box.value && otpBoxes[i + 1]) otpBoxes[i + 1].focus();
                if (Array.prototype.every.call(otpBoxes, function (b) { return b.value; })) {
                    otpForm.requestSubmit();
                }
            });
            box.addEventListener('keydown', function (e) {
                if (e.key === 'Backspace' && !box.value && otpBoxes[i - 1]) otpBoxes[i - 1].focus();
                if (e.key === 'ArrowLeft' && otpBoxes[i - 1]) otpBoxes[i - 1].focus();
                if (e.key === 'ArrowRight' && otpBoxes[i + 1]) otpBoxes[i + 1].focus();
            });
            box.addEventListener('paste', function (e) {
                var text = (e.clipboardData || window.clipboardData).getData('text').replace(/[^0-9]/g, '');
                if (!text) return;
                e.preventDefault();
                for (var k = 0; k < otpBoxes.length; k++) otpBoxes[k].value = text[k] || '';
                var last = Math.min(text.length, otpBoxes.length) - 1;
                if (last >= 0) otpBoxes[last].focus();
                if (text.length >= otpBoxes.length) otpForm.requestSubmit();
            });
        });

        function startOtpCountdown(remainingMs) {
            otpExpiresAt = Date.now() + remainingMs;
            otpResendBtn.disabled = true;
            if (otpTimerHandle) clearInterval(otpTimerHandle);
            otpTimerHandle = setInterval(tickOtp, 1000);
            tickOtp();
        }
        function tickOtp() {
            var left = Math.max(0, otpExpiresAt - Date.now());
            var s = Math.ceil(left / 1000);
            otpTimerEl.textContent = Math.floor(s / 60) + ':' + String(s % 60).padStart(2, '0');
            if (left <= 0) {
                clearInterval(otpTimerHandle);
                otpResendBtn.disabled = false;
                otpResendBtn.textContent = 'Gửi lại mã';
            }
        }
        var resendCooldownAt = 0;
        function startResendCooldown() {
            resendCooldownAt = Date.now() + 60000;
            otpResendBtn.disabled = true;
            if (resendCooldownHandle) clearInterval(resendCooldownHandle);
            resendCooldownHandle = setInterval(tickResend, 1000);
            tickResend();
        }
        function tickResend() {
            var left = Math.max(0, resendCooldownAt - Date.now());
            if (left <= 0) {
                clearInterval(resendCooldownHandle);
                otpResendBtn.disabled = false;
                otpResendBtn.textContent = 'Gửi lại mã';
            } else {
                otpResendBtn.textContent = 'Gửi lại (' + Math.ceil(left / 1000) + 's)';
            }
        }
        if (otpResendBtn) {
            otpResendBtn.addEventListener('click', function () {
                hideAlert(otpErr);
                postJson('/resend-otp', {}).then(function (data) {
                    if (data.success) {
                        startOtpCountdown(data.remainingMs || 300000);
                        startResendCooldown();
                    } else {
                        showAlert(otpErr, data.message || 'Không thể gửi lại mã, vui lòng thử lại sau.');
                    }
                });
            });
        }
        if (otpForm) {
            otpForm.addEventListener('submit', function (e) {
                e.preventDefault();
                hideAlert(otpErr);
                var params = {};
                otpBoxes.forEach(function (b) { params['d' + b.getAttribute('data-d')] = b.value; });
                postJson('/verify-otp', params).then(function (data) {
                    if (data.success) {
                        if (otpTimerHandle) clearInterval(otpTimerHandle);
                        showView('reset');
                    } else {
                        showAlert(otpErr, data.message || 'Mã OTP không chính xác.');
                        otpBoxes.forEach(function (b) { b.value = ''; });
                        otpBoxes[0].focus();
                    }
                }).catch(function () { showAlert(otpErr, 'Không thể kết nối máy chủ.'); });
            });
        }

        /* ── Bước 3: đặt mật khẩu mới ── */
        var resetForm = document.getElementById('resetForm');
        var resetErr = document.getElementById('resetErr');
        var resetPw = document.getElementById('resetPassword');
        var resetConfirm = document.getElementById('resetConfirm');
        var resetSubmitBtn = document.getElementById('resetSubmitBtn');
        var resetMatch = document.getElementById('resetMatch');
        var segs = [document.getElementById('mseg0'), document.getElementById('mseg1'), document.getElementById('mseg2')];
        /* Ba mức độ mạnh mật khẩu phải PHÂN BIỆT ĐƯỢC, không cùng một sắc xanh:
           yếu = đỏ lỗi, trung bình = cam cảnh báo, mạnh = Fern Green thương hiệu.
           Chỉ mức "mạnh" đọc từ token --et-primary; hai mức còn lại là màu
           semantic, cố ý không nằm trong bảng màu thương hiệu. */
        var etPrimary = getComputedStyle(document.documentElement)
                            .getPropertyValue('--et-primary').trim() || '#477023';
        var levelColors = ['#B4453F', '#D98324', etPrimary];

        function pwRulesPass(v) { return /[a-z]/.test(v) && /[A-Z]/.test(v) && /\d/.test(v) && v.length >= 6; }
        if (resetPw) { resetPw.addEventListener('input', function(){ updateResetStateSafe(resetPw.value); }); }
        if (resetConfirm) { resetConfirm.addEventListener('input', function(){ updateResetStateSafe(resetPw.value); }); }
        function updateResetStateSafe(v1) {
            var v2 = resetConfirm.value;
            var passed = [v1.length >= 6, /[A-Z]/.test(v1), /[a-z]/.test(v1), /\d/.test(v1)].filter(Boolean).length;
            var lvlIdx = v1 ? Math.min(Math.max(Math.ceil(passed / 4 * 3) - 1, 0), 2) : -1;
            segs.forEach(function (s, i) { s.style.background = (v1 && i <= lvlIdx) ? levelColors[lvlIdx] : ''; });
            var allPass = pwRulesPass(v1);
            if (!v2) { resetMatch.className = 'mini-match'; resetMatch.textContent = ''; resetSubmitBtn.disabled = true; return; }
            if (v1 === v2) {
                resetMatch.className = 'mini-match ok'; resetMatch.textContent = 'Mật khẩu khớp';
                resetSubmitBtn.disabled = !allPass;
            } else {
                resetMatch.className = 'mini-match bad'; resetMatch.textContent = 'Mật khẩu không khớp';
                resetSubmitBtn.disabled = true;
            }
        }
        if (resetForm) {
            resetForm.addEventListener('submit', function (e) {
                e.preventDefault();
                hideAlert(resetErr);
                postJson('/reset-password', { password: resetPw.value, confirmPassword: resetConfirm.value }).then(function (data) {
                    if (data.success) {
                        resetForm.reset();
                        panel.querySelector('#authLoginOk').classList.add('show');
                        showView('login');
                    } else {
                        showAlert(resetErr, data.message || 'Có lỗi xảy ra, vui lòng thử lại.');
                    }
                }).catch(function () { showAlert(resetErr, 'Không thể kết nối máy chủ.'); });
            });
        }
    })();
</script>



