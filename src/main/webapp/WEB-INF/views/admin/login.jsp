<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng nhập quản trị — Eight Tea</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=IBM+Plex+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
/* Bảng màu Eight Tea — thay hẳn da xanh lá "Nhiệt Đới Xanh" cũ. */
:root{
  --paper:#F2EBE1;--surface:#FFFFFF;--soft:#FAF6F0;--mist:#EFE7DC;
  --accent:#D2691E;--accent-deep:#A9531A;--accent-soft:#F7EADC;
  --ink:#2B2625;--ink-2:#6B615C;--muted:#9C918B;--dark:#120E0C;
  --fb:'Plus Jakarta Sans',system-ui,sans-serif;--fm:'IBM Plex Mono',ui-monospace,monospace;
  --ease:cubic-bezier(.22,1,.36,1);
}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--paper);color:var(--ink-2);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px;-webkit-font-smoothing:antialiased}
a{text-decoration:none;color:inherit}
button{font:inherit;cursor:pointer;border:none}

.back{
  position:fixed;top:20px;left:22px;z-index:20;display:inline-flex;align-items:center;gap:8px;
  background:var(--surface);padding:10px 18px;border-radius:999px;font-weight:600;font-size:13px;
  color:var(--ink-2);box-shadow:0 1px 2px rgba(43,38,37,.04),0 6px 18px -6px rgba(43,38,37,.14);
  transition:color .2s var(--ease),transform .2s var(--ease);
}
.back:hover{color:var(--accent);transform:translateY(-1px)}

.auth{
  width:min(880px,100%);display:grid;grid-template-columns:1.05fr .95fr;
  background:var(--surface);border-radius:28px;overflow:hidden;
  box-shadow:0 4px 10px rgba(43,38,37,.04),0 40px 80px -30px rgba(43,38,37,.3);
}
.pane{padding:46px 44px}
.brand{display:inline-flex;align-items:center;gap:10px;margin-bottom:30px}
.brand-mark{width:38px;height:38px;border-radius:12px;background:var(--accent);display:grid;place-items:center;box-shadow:0 10px 22px -8px rgba(210,105,30,.55)}
.brand-mark svg{width:19px;height:19px;fill:#fff}
.brand-txt{font-weight:800;font-size:15.5px;letter-spacing:-.02em;color:var(--ink);line-height:1.15}
.brand-txt small{display:block;font-family:var(--fm);font-size:9.5px;font-weight:500;letter-spacing:.16em;text-transform:uppercase;color:var(--muted)}

.pane h1{font-weight:800;font-size:clamp(23px,3vw,29px);line-height:1.15;letter-spacing:-.03em;color:var(--ink)}
.pane .sub{color:var(--muted);margin:9px 0 26px;font-size:13.5px}

.alert{
  border-radius:14px;padding:13px 16px;font-size:13px;font-weight:600;margin-bottom:18px;
  display:flex;gap:9px;align-items:flex-start;background:#F9E9E6;color:#A33A28;
}
.field{margin-bottom:16px}
.field label{display:block;font-family:var(--fm);font-size:10px;font-weight:500;letter-spacing:.16em;text-transform:uppercase;color:var(--muted);margin-bottom:8px}
.box{position:relative}
/* Nền lõm thay cho viền — đúng ràng buộc "không viền" của design system */
.field input{
  width:100%;padding:14px 16px;border-radius:14px;border:none;background:var(--soft);
  font:inherit;font-size:14.5px;color:var(--ink);transition:box-shadow .2s var(--ease),background-color .2s var(--ease);
}
.field input::placeholder{color:var(--muted)}
.field input:focus{outline:none;background:var(--surface);box-shadow:0 0 0 3px rgba(210,105,30,.3)}
.eye{position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;color:var(--muted);display:flex;padding:7px;border-radius:9px}
.eye:hover{color:var(--accent)}

.submit{
  width:100%;padding:15px;border-radius:999px;background:var(--accent);color:#fff;
  font-weight:700;font-size:14.5px;box-shadow:0 12px 26px -8px rgba(210,105,30,.6);
  transition:background-color .2s var(--ease),transform .2s var(--ease);
}
.submit:hover{background:var(--accent-deep);transform:translateY(-2px)}
.submit:active{transform:none}

/* Cột phải: dải nâu đen ủ trà + ly vẽ tay, cùng ngôn ngữ hình với khu khách hàng */
.side{
  position:relative;background:var(--dark);color:#fff;display:flex;flex-direction:column;
  align-items:center;justify-content:center;padding:44px 38px;overflow:hidden;text-align:center;
}
.side::before{
  content:"";position:absolute;inset:0;pointer-events:none;
  background:radial-gradient(60% 55% at 50% 12%, rgba(210,105,30,.34) 0%, transparent 70%);
}
.side svg.cup{width:118px;height:auto;position:relative;z-index:1;margin-bottom:24px}
.side h2{font-weight:800;font-size:20px;letter-spacing:-.02em;margin-bottom:10px;position:relative;z-index:1;color:#F5EFE7}
.side p{color:#9A8F88;font-size:13px;line-height:1.65;max-width:250px;position:relative;z-index:1}
.side .tag{
  font-family:var(--fm);font-size:9.5px;letter-spacing:.18em;text-transform:uppercase;
  color:#E08B45;margin-bottom:16px;position:relative;z-index:1;
}

a:focus-visible,button:focus-visible,input:focus-visible{outline:3px solid rgba(210,105,30,.5);outline-offset:2px}

@media(max-width:760px){
  .auth{grid-template-columns:1fr}
  .side{display:none}
  .pane{padding:38px 26px}
  .back{position:static;margin-bottom:14px;display:none}
}
@media(prefers-reduced-motion:reduce){*{transition-duration:.01ms !important;animation-duration:.01ms !important}}
</style>
</head>
<body>
<a href="${ctx}/" class="back"><i class="fa-solid fa-arrow-left-long"></i> Về cửa hàng</a>

<div class="auth">
  <div class="pane">
    <a href="${ctx}/" class="brand">
      <span class="brand-mark">
        <svg viewBox="0 0 24 24"><path d="M17 8C8 10 5.9 16.17 3.82 21.34l1.89.66.95-2.3c.48.17.98.3 1.34.3C19 20 22 3 22 3c-1 2-8 2.25-13 3.25S2 11.5 2 13.5s1.75 3.75 1.75 3.75C7 8 17 8 17 8z"/></svg>
      </span>
      <span class="brand-txt">Eight Tea<small>Quản trị</small></span>
    </a>

    <h1>Đăng nhập quản trị</h1>
    <p class="sub">Dành cho nhân viên và quản lý cửa hàng.</p>

    <c:if test="${not empty errorMessage}">
      <div class="alert"><i class="fa-solid fa-circle-exclamation" style="margin-top:2px"></i><span><c:out value="${errorMessage}"/></span></div>
    </c:if>

    <form method="post" action="${ctx}/admin/login" autocomplete="on">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="field">
        <label for="username">Tên đăng nhập</label>
        <div class="box">
          <input type="text" id="username" name="username" required autofocus
                 autocomplete="username" value="${fn:escapeXml(param.username)}">
        </div>
      </div>
      <div class="field">
        <label for="password">Mật khẩu</label>
        <div class="box">
          <input type="password" id="password" name="password" required autocomplete="current-password">
          <button type="button" class="eye" id="pwToggle" aria-label="Hiện mật khẩu"><i class="fa-regular fa-eye"></i></button>
        </div>
      </div>
      <button type="submit" class="submit">Đăng nhập</button>
    </form>
  </div>

  <div class="side">
    <span class="tag">Eight Tea · Quản trị</span>
    <svg class="cup" viewBox="0 0 300 430" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
      <defs>
        <linearGradient id="lgTea" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stop-color="#E9CBA4"/><stop offset="100%" stop-color="#A9611B"/>
        </linearGradient>
      </defs>
      <path d="M178,112 L216,24" stroke="#7A4318" stroke-width="18" stroke-linecap="round"/>
      <path d="M178,112 L216,24" stroke="#E8A33D" stroke-width="9" stroke-linecap="round"/>
      <path d="M67,146 L100,372 Q102,384 113,384 L187,384 Q198,384 200,372 L233,146 Z" fill="url(#lgTea)"/>
      <path d="M78,150 L104,380 L120,380 L94,150 Z" fill="#ffffff" opacity=".13"/>
      <path d="M58,124 Q150,78 242,124 Z" fill="#EFE3D4"/>
      <rect x="50" y="120" width="200" height="26" rx="9" fill="#FBF3E9"/>
      <rect x="50" y="120" width="200" height="9" rx="4.5" fill="#ffffff" opacity=".7"/>
    </svg>
    <h2>Khu vực quản trị</h2>
    <p>Quản lý đơn hàng, thực đơn và phản hồi khách hàng của Eight Tea.</p>
  </div>
</div>

<script>
(function () {
  var btn = document.getElementById('pwToggle');
  var input = document.getElementById('password');
  if (!btn || !input) return;
  btn.addEventListener('click', function () {
    var showing = input.type === 'text';
    input.type = showing ? 'password' : 'text';
    btn.setAttribute('aria-label', showing ? 'Hiện mật khẩu' : 'Ẩn mật khẩu');
    btn.innerHTML = showing
      ? '<i class="fa-regular fa-eye"></i>'
      : '<i class="fa-regular fa-eye-slash"></i>';
  });
})();
</script>
</body>
</html>
