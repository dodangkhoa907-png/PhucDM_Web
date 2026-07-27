<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng nhập — Eight Tea</title>
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
    width: min(980px, 100%);
    display: grid;
    grid-template-columns: 1.05fr .95fr;
    background: var(--et-surface);
    border-radius: 28px;
    overflow: hidden;
    box-shadow: 0 20px 60px -15px rgba(18, 14, 12, 0.08);
    animation: cardIn .6s cubic-bezier(.16, 1, .3, 1);
}

.pane {
    padding: 52px 54px;
}

.logo {
    display: inline-flex;
    align-items: center;
    gap: 9px;
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-weight: 800;
    font-size: 22px;
    color: var(--et-dark);
    margin-bottom: 28px;
}
.logo span { color: var(--et-accent); }

.pane h1 {
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-weight: 800;
    font-size: clamp(24px, 3vw, 32px);
    line-height: 1.2;
    color: var(--et-dark);
    letter-spacing: -.02em;
}

.pane .sub {
    color: var(--et-ink-muted);
    margin: 10px 0 28px;
    font-size: 14.5px;
    line-height: 1.5;
}

.alert {
    border-radius: 14px;
    padding: 13px 16px;
    font-size: 13.5px;
    font-weight: 600;
    margin-bottom: 20px;
    display: flex;
    gap: 9px;
    align-items: flex-start;
    border: none;
}
.alert.err {
    background: #FDF2F2;
    color: #9B1C1C;
}
.alert.ok {
    background: #F0FDF4;
    color: #166534;
}

.field {
    margin-bottom: 18px;
}
.field label {
    display: block;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: .06em;
    text-transform: uppercase;
    color: var(--et-ink-muted);
    margin-bottom: 8px;
}
.field .box {
    position: relative;
}
.field input {
    width: 100%;
    padding: 14px 16px;
    border-radius: 14px;
    border: none;
    background: var(--et-surface-muted);
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-size: 15px;
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

.row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: 6px 0 24px;
    font-size: 13.5px;
}
.row label {
    display: flex;
    align-items: center;
    gap: 8px;
    color: var(--et-ink-muted);
    font-weight: 500;
    cursor: pointer;
}
.row label input[type="checkbox"] {
    accent-color: var(--et-accent);
    width: 16px;
    height: 16px;
    cursor: pointer;
}
.row a {
    color: var(--et-accent);
    font-weight: 600;
}
.row a:hover { text-decoration: underline; }

.submit {
    width: 100%;
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
    margin-top: 24px;
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
    padding: 52px 46px;
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

@media (max-width: 860px) {
    .auth { grid-template-columns: 1fr; }
    .side { display: none; }
    .pane { padding: 44px 32px; }
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
    .row { flex-direction: column; align-items: flex-start; gap: 12px; }
}
</style>
</head>
<body>
<a href="${ctx}/" class="back"><i class="fa-solid fa-arrow-left"></i> Về trang chủ</a>

<div class="auth">
  <div class="pane">
    <a href="${ctx}/" class="logo">Eight <span>Tea</span></a>
    <h1>Chào mừng trở lại!</h1>
    <p class="sub">Đăng nhập để đặt hàng nhanh hơn và theo dõi đơn của bạn.</p>

    <c:if test="${param.reset == 'success'}"><div class="alert ok"><i class="fa-solid fa-circle-check"></i> Mật khẩu đã được đặt lại thành công. Hãy đăng nhập bằng mật khẩu mới.</div></c:if>
    <c:if test="${not empty errorMessage}"><div class="alert err"><i class="fa-solid fa-triangle-exclamation"></i> <c:out value="${errorMessage}"/></div></c:if>

    <form method="post" action="${ctx}/login" autocomplete="on">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="field">
        <label for="email">Địa chỉ email</label>
        <div class="box"><input type="email" id="email" name="email" placeholder="ban@email.com" required autofocus value="${fn:escapeXml(param.email)}" autocomplete="email"></div>
      </div>
      <div class="field">
        <label for="password">Mật khẩu</label>
        <div class="box">
          <input type="password" id="password" name="password" placeholder="••••••••" required autocomplete="current-password">
          <button type="button" class="eye" onclick="togglePw('password')" aria-label="Hiện mật khẩu"><i class="fa-regular fa-eye"></i></button>
        </div>
      </div>
      <div class="row">
        <label><input type="checkbox" name="remember"> Ghi nhớ đăng nhập</label>
        <a href="${ctx}/forgot-password">Quên mật khẩu?</a>
      </div>
      <button type="submit" class="submit">Đăng nhập</button>
    </form>
    <p class="alt">Chưa có tài khoản? <a href="${ctx}/register">Đăng ký ngay &rarr;</a></p>
  </div>

  <div class="side">
    <div class="side-inner">
      <div class="badge">🍵</div>
      <h2>Eight Tea</h2>
      <p>Trà sữa đậm vị, topping giòn ngon — giao tận tay trong 20–30 phút.</p>
      <div class="perk"><span class="ic"><i class="fa-solid fa-leaf"></i></span> 100% lá trà tươi & nguyên liệu chọn lọc</div>
      <div class="perk"><span class="ic"><i class="fa-solid fa-bolt"></i></span> Giao hỏa tốc nóng/lạnh chuẩn vị</div>
      <div class="perk"><span class="ic"><i class="fa-solid fa-gift"></i></span> Tích điểm đổi quà & ưu đãi thành viên</div>
    </div>
  </div>
</div>

<script>
function togglePw(id){
    var i = document.getElementById(id);
    if(i) { i.type = i.type === 'password' ? 'text' : 'password'; }
}
</script>
</body>
</html>
