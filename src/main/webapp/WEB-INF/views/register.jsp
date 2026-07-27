<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng ký — Eight Tea</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${ctx}/css/eighttea.css?v=${initParam.assetVer}">
<style>
:root {
    --et-canvas: #FAF6F0;
    --et-surface: #FFFFFF;
    --et-surface-muted: #EFEAE2;
    --et-dark: #120E0C;
    --et-accent: #D2691E;
    --et-accent-deep: #A9531A;
    --et-ink: #2B2625;
    --et-ink-muted: #6B615C;
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
    background: var(--et-canvas);
    color: var(--et-ink);
    min-height: 100vh;
    min-height: 100dvh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
    overflow-x: hidden;
}

a { text-decoration: none; color: inherit; }
button { font: inherit; cursor: pointer; border: none; }

.back {
    position: fixed;
    top: 22px;
    left: 24px;
    z-index: 20;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: var(--et-surface);
    border: none;
    padding: 11px 22px;
    border-radius: 999px;
    font-weight: 600;
    font-size: 13.5px;
    color: var(--et-ink-muted);
    box-shadow: 0 4px 16px rgba(18, 14, 12, 0.06);
    transition: all .25s ease;
}
.back:hover {
    transform: translateX(-3px);
    color: var(--et-accent);
    box-shadow: 0 6px 20px rgba(210, 105, 30, 0.15);
}

@keyframes cardIn {
    from { opacity: 0; transform: translateY(24px) scale(.98); }
    to { opacity: 1; transform: none; }
}

.auth {
    position: relative;
    z-index: 5;
    width: min(1040px, 100%);
    display: grid;
    grid-template-columns: .9fr 1.1fr;
    background: var(--et-surface);
    border-radius: 28px;
    overflow: hidden;
    box-shadow: 0 20px 60px -15px rgba(18, 14, 12, 0.08);
    animation: cardIn .6s cubic-bezier(.16, 1, .3, 1);
}

.pane {
    padding: 48px 52px;
}

.logo {
    display: inline-flex;
    align-items: center;
    gap: 9px;
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-weight: 800;
    font-size: 22px;
    color: var(--et-dark);
    margin-bottom: 24px;
}
.logo span { color: var(--et-accent); }

.pane h1 {
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-weight: 800;
    font-size: clamp(24px, 3vw, 30px);
    line-height: 1.2;
    color: var(--et-dark);
    letter-spacing: -.02em;
}

.pane .sub {
    color: var(--et-ink-muted);
    margin: 8px 0 24px;
    font-size: 14.5px;
    line-height: 1.5;
}

.alert {
    border-radius: 14px;
    padding: 13px 16px;
    font-size: 13.5px;
    font-weight: 600;
    margin-bottom: 18px;
    display: flex;
    gap: 9px;
    align-items: flex-start;
    background: #FDF2F2;
    color: #9B1C1C;
    border: none;
}

.field {
    margin-bottom: 16px;
}
.grid2 {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
}

.field label {
    display: block;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: .06em;
    text-transform: uppercase;
    color: var(--et-ink-muted);
    margin-bottom: 7px;
}
.field .box {
    position: relative;
}
.field input {
    width: 100%;
    padding: 13px 15px;
    border-radius: 14px;
    border: none;
    background: var(--et-surface-muted);
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-size: 14.5px;
    color: var(--et-dark);
    box-shadow: inset 0 0 0 1px transparent;
    transition: background-color .2s ease, box-shadow .2s ease;
}
.field input:focus {
    outline: none;
    background: var(--et-surface);
    box-shadow: 0 0 0 4px rgba(210, 105, 30, 0.14), inset 0 0 0 1px rgba(210, 105, 30, 0.35);
}

.eye {
    position: absolute;
    right: 14px;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    color: var(--et-ink-muted);
    display: flex;
    padding: 6px;
    border-radius: 8px;
    transition: color .2s;
}
.eye:hover { color: var(--et-dark); }

.hint {
    font-size: 12px;
    color: var(--et-ink-muted);
    margin-top: 6px;
}

.submit {
    width: 100%;
    margin-top: 8px;
    padding: 15px;
    border-radius: 999px;
    background: var(--et-accent);
    color: #FFF;
    font-weight: 700;
    font-size: 15.5px;
    box-shadow: 0 8px 22px -6px rgba(210, 105, 30, 0.45);
    transition: background-color .2s ease, transform .2s ease, box-shadow .2s ease;
}
.submit:hover {
    background: var(--et-accent-deep);
    transform: translateY(-2px);
    box-shadow: 0 12px 28px -6px rgba(210, 105, 30, 0.55);
}
.submit:active {
    transform: translateY(0);
}

.alt {
    text-align: center;
    margin-top: 20px;
    font-size: 14px;
    color: var(--et-ink-muted);
}
.alt a {
    color: var(--et-accent);
    font-weight: 700;
}
.alt a:hover { text-decoration: underline; }

.side {
    position: relative;
    background: var(--et-dark);
    color: #FFF;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 52px 44px;
    overflow: hidden;
}
.side-inner {
    position: relative;
    z-index: 2;
}
.side .badge {
    width: 80px;
    height: 80px;
    border-radius: 24px;
    background: rgba(255, 255, 255, 0.08);
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 24px;
    font-size: 36px;
}
.side h2 {
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-weight: 800;
    font-size: 26px;
    text-align: center;
    margin-bottom: 12px;
    color: #FFF;
}
.side p {
    text-align: center;
    color: rgba(255, 255, 255, 0.75);
    font-size: 14.5px;
    line-height: 1.6;
    max-width: 310px;
    margin: 0 auto 28px;
}
.perk {
    display: flex;
    align-items: center;
    gap: 14px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 16px;
    padding: 14px 18px;
    margin-bottom: 12px;
    font-size: 13.5px;
    font-weight: 600;
    color: rgba(255, 255, 255, 0.9);
}
.perk .ic {
    width: 36px;
    height: 36px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(210, 105, 30, 0.25);
    color: var(--et-accent);
    font-size: 16px;
    flex: none;
}

.terms-overlay {
    position: fixed; inset: 0; z-index: 100;
    display: none; align-items: center; justify-content: center;
    background: rgba(18, 14, 12, 0.5); backdrop-filter: blur(6px); padding: 20px;
}
.terms-overlay.open { display: flex; }
.terms-panel {
    background: var(--et-surface); border-radius: 24px;
    max-width: 600px; width: 100%; max-height: 80vh;
    display: flex; flex-direction: column;
    box-shadow: 0 24px 64px rgba(18, 14, 12, 0.2); overflow: hidden;
}
.terms-hdr {
    padding: 20px 24px 16px;
    border-bottom: 1px solid var(--et-surface-muted);
    display: flex; justify-content: space-between; align-items: center;
}
.terms-hdr h2 {
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-size: 20px; font-weight: 800; color: var(--et-dark);
}
.terms-close {
    background: none; font-size: 22px; color: var(--et-ink-muted);
    padding: 4px 10px; border-radius: 8px; cursor: pointer;
}
.terms-close:hover { background: var(--et-surface-muted); color: var(--et-dark); }
.terms-body {
    padding: 24px; overflow-y: auto; font-size: 14px; line-height: 1.8; color: var(--et-ink);
}
.terms-body h3 {
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-size: 16px; font-weight: 700; margin: 18px 0 8px; color: var(--et-accent);
}
.terms-body h3:first-child { margin-top: 0; }
.terms-body ul { padding-left: 20px; margin: 8px 0; }
.terms-body li { margin-bottom: 4px; }

@media (max-width: 900px) {
    .auth { grid-template-columns: 1fr; }
    .side { display: none; }
    .pane { padding: 44px 32px; }
    .grid2 { grid-template-columns: 1fr; }
}
@media (max-width: 560px) {
    body { padding: 0; align-items: stretch; }
    .back {
        position: fixed; top: 0; left: 0; right: 0; z-index: 20;
        border-radius: 0; background: rgba(250, 246, 240, 0.95);
        backdrop-filter: blur(12px); box-shadow: none; padding: 14px 20px;
    }
    .auth { border-radius: 0; box-shadow: none; min-height: 100vh; width: 100%; }
    .pane { padding: 68px 24px 40px; }
}
</style>
</head>
<body>
<a href="${ctx}/" class="back"><i class="fa-solid fa-arrow-left"></i> Về trang chủ</a>

<div class="auth">
  <div class="side">
    <div class="side-inner">
      <div class="badge">🌱</div>
      <h2>Bắt đầu hành trình</h2>
      <p>Tạo tài khoản để lưu địa chỉ, theo dõi đơn hàng và đặt lại chỉ trong vài giây.</p>
      <div class="perk"><span class="ic"><i class="fa-solid fa-shield-halved"></i></span> Bảo mật thông tin tuyệt đối</div>
      <div class="perk"><span class="ic"><i class="fa-solid fa-location-dot"></i></span> Lưu nhiều địa chỉ giao hàng</div>
      <div class="perk"><span class="ic"><i class="fa-solid fa-bolt"></i></span> Đặt lại món yêu thích nhanh chóng</div>
    </div>
  </div>

  <div class="pane">
    <a href="${ctx}/" class="logo">Eight <span>Tea</span></a>
    <h1>Tạo tài khoản</h1>
    <p class="sub">Tham gia Eight Tea để đặt hàng nhanh hơn.</p>

    <c:if test="${not empty errorMessage}"><div class="alert"><i class="fa-solid fa-triangle-exclamation"></i> <c:out value="${errorMessage}"/></div></c:if>

    <form method="post" action="${ctx}/register" autocomplete="on">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="field">
        <label for="fullName">Họ và tên *</label>
        <div class="box"><input type="text" id="fullName" name="fullName" placeholder="Nguyễn Văn A" required autofocus value="${fn:escapeXml(param.fullName)}" autocomplete="name"></div>
      </div>
      <div class="grid2">
        <div class="field">
          <label for="email">Email *</label>
          <div class="box"><input type="email" id="email" name="email" placeholder="ban@email.com" required value="${fn:escapeXml(param.email)}" autocomplete="email"></div>
        </div>
        <div class="field">
          <label for="phone">Số điện thoại</label>
          <div class="box"><input type="tel" id="phone" name="phone" placeholder="09xx xxx xxx" value="${fn:escapeXml(param.phone)}" pattern="0[0-9]{9,10}" maxlength="11" inputmode="numeric" autocomplete="tel" title="Số điện thoại bắt đầu bằng 0, gồm 10–11 chữ số"></div>
        </div>
      </div>
      <div class="field">
        <label for="password">Mật khẩu *</label>
        <div class="box">
          <input type="password" id="password" name="password" placeholder="••••••••" required autocomplete="new-password">
          <button type="button" class="eye" onclick="togglePw('password')" aria-label="Hiện mật khẩu"><i class="fa-regular fa-eye"></i></button>
        </div>
        <p class="hint">Tối thiểu 6 ký tự, gồm chữ hoa, chữ thường và số.</p>
      </div>
      <div class="field">
        <label for="confirmPassword">Xác nhận mật khẩu *</label>
        <div class="box">
          <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••" required autocomplete="new-password">
          <button type="button" class="eye" onclick="togglePw('confirmPassword')" aria-label="Hiện mật khẩu"><i class="fa-regular fa-eye"></i></button>
        </div>
      </div>
      <div class="field" style="margin-bottom:18px">
        <label style="display:flex;align-items:flex-start;gap:10px;cursor:pointer;text-transform:none;letter-spacing:0;font-weight:500;font-size:13.5px;color:var(--et-ink)">
          <input type="checkbox" name="agreeTerms" id="agreeTerms" required style="width:18px;height:18px;margin-top:2px;accent-color:var(--et-accent);flex-shrink:0;cursor:pointer">
          <span>Tôi đồng ý với <a href="#" onclick="openModal(event,'termsModal')" style="color:var(--et-accent);font-weight:700;text-decoration:underline">Điều khoản sử dụng</a> và <a href="#" onclick="openModal(event,'privacyModal')" style="color:var(--et-accent);font-weight:700;text-decoration:underline">Chính sách bảo mật</a></span>
        </label>
      </div>
      <button type="submit" class="submit">Đăng ký</button>
    </form>
    <p class="alt">Đã có tài khoản? <a href="${ctx}/login">Đăng nhập &rarr;</a></p>
  </div>
</div>

<div class="terms-overlay" id="termsModal">
  <div class="terms-panel">
    <div class="terms-hdr"><h2>Điều khoản sử dụng</h2><button class="terms-close" onclick="closeModal('termsModal')">&times;</button></div>
    <div class="terms-body">
      <h3>1. Giới thiệu</h3>
      <p>Chào mừng bạn đến với Eight Tea. Khi sử dụng dịch vụ, bạn đồng ý tuân thủ các điều khoản dưới đây.</p>
      <h3>2. Tài khoản</h3>
      <ul>
        <li>Cung cấp thông tin chính xác khi đăng ký.</li>
        <li>Bạn chịu trách nhiệm bảo mật thông tin đăng nhập của mình.</li>
      </ul>
      <h3>3. Đặt hàng và thanh toán</h3>
      <ul>
        <li>Giá món có thể thay đổi mà không cần thông báo trước.</li>
        <li>Bạn có thể hủy đơn trước khi đơn được xác nhận giao.</li>
      </ul>
      <h3>4. Thay đổi điều khoản</h3>
      <p>Chúng tôi có quyền cập nhật điều khoản này, có hiệu lực ngay khi đăng tải.</p>
    </div>
  </div>
</div>

<div class="terms-overlay" id="privacyModal">
  <div class="terms-panel">
    <div class="terms-hdr"><h2>Chính sách bảo mật</h2><button class="terms-close" onclick="closeModal('privacyModal')">&times;</button></div>
    <div class="terms-body">
      <h3>1. Thông tin thu thập</h3>
      <ul>
        <li>Họ tên, email, số điện thoại khi đăng ký tài khoản.</li>
        <li>Địa chỉ giao hàng, lịch sử mua hàng.</li>
      </ul>
      <h3>2. Bảo mật dữ liệu</h3>
      <ul>
        <li>Mật khẩu được mã hóa (BCrypt), không ai đọc được — kể cả admin.</li>
        <li>Chỉ nhân viên được ủy quyền mới truy cập dữ liệu khách hàng.</li>
      </ul>
      <h3>3. Chia sẻ thông tin</h3>
      <p>Chúng tôi không bán hoặc chia sẻ thông tin cá nhân cho bên thứ ba, trừ khi pháp luật yêu cầu.</p>
    </div>
  </div>
</div>

<script>
function togglePw(id){
    var i = document.getElementById(id);
    if(i) { i.type = i.type === 'password' ? 'text' : 'password'; }
}
function openModal(e,id){e.preventDefault();document.getElementById(id).classList.add('open');}
function closeModal(id){document.getElementById(id).classList.remove('open');}
document.querySelectorAll('.terms-overlay').forEach(function(m){m.addEventListener('click',function(e){if(e.target===m)closeModal(m.id)});});
document.addEventListener('keydown',function(e){if(e.key==='Escape'){closeModal('termsModal');closeModal('privacyModal')}});
</script>
</body>
</html>
