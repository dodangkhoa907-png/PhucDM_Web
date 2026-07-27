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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${ctx}/css/eighttea.css?v=${initParam.assetVer}">
<style>
body{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:28px;overflow-x:hidden}
a{text-decoration:none;color:inherit}
.blob{position:fixed;border-radius:50%;filter:blur(60px);opacity:.35;pointer-events:none;z-index:0;animation:drift 14s ease-in-out infinite}
.blob.b1{width:380px;height:380px;background:var(--leaf-wash);top:-120px;left:-100px}
.blob.b2{width:320px;height:320px;background:var(--leaf-bright);opacity:.16;bottom:-100px;right:-80px;animation-delay:-6s}
@keyframes drift{0%,100%{transform:translate(0,0)}50%{transform:translate(26px,-30px)}}
.back{position:fixed;top:22px;left:24px;z-index:20;display:inline-flex;align-items:center;gap:8px;background:var(--white);padding:10px 20px;border-radius:99px;font-family:var(--font);font-weight:600;font-size:13.5px;color:var(--ink-2);box-shadow:var(--shadow-sm);transition:transform .2s,color .2s}
.back:hover{transform:translateX(-3px);color:var(--leaf-deep)}
@keyframes cardIn{from{opacity:0;transform:translateY(30px) scale(.97)}to{opacity:1;transform:none}}
.auth-card{position:relative;z-index:5;width:min(440px,100%);background:var(--white);border-radius:var(--radius-lg);box-shadow:var(--shadow-lg);padding:48px 42px;animation:cardIn .6s cubic-bezier(.16,1,.3,1)}
.logo{display:inline-flex;align-items:center;gap:9px;font-family:var(--font-display);font-weight:800;font-size:22px;color:var(--ink);margin-bottom:24px}
.logo span{color:var(--leaf)}
.auth-card h1{font-family:var(--font-display);font-weight:800;font-size:clamp(24px,3vw,30px);line-height:1.15;color:var(--ink)}
.auth-card .sub{color:var(--muted);margin:10px 0 26px;font-size:14.5px}
.alert{border-radius:14px;padding:13px 16px;font-size:13.5px;font-weight:600;margin-bottom:18px;display:flex;gap:9px;align-items:flex-start}
.alert.err{background:#FBE3E1;color:#8E1F1F}
.alert.ok{background:#E7F6EC;color:#187A43}
.field{margin-bottom:16px}
.field label{display:block;font-family:var(--font-mono);font-size:11px;font-weight:500;letter-spacing:.1em;text-transform:uppercase;color:var(--muted);margin-bottom:7px}
.field .box{position:relative}
.field .box.has-eye input{padding-right:44px}
.eye{position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--muted);display:flex;padding:4px;cursor:pointer;z-index:2}
.row{display:flex;align-items:center;justify-content:space-between;margin:2px 0 22px;font-size:13.5px}
.row label{display:flex;align-items:center;gap:7px;color:var(--ink-2);font-weight:600;cursor:pointer;text-transform:none;letter-spacing:0;font-family:var(--font)}
.row a{color:var(--leaf-deep);font-weight:700}
.row a:hover{text-decoration:underline}
.auth-submit{width:100%;font-weight:700 !important;font-size:15.5px !important;padding:15px !important}
.alt{text-align:center;margin-top:24px;font-size:14px;color:var(--muted)}
.alt a{color:var(--leaf-deep);font-weight:700}
.alt a:hover{text-decoration:underline}
@media(max-width:520px){
  body{padding:0;align-items:stretch;flex-direction:column}
  .blob{display:none}
  .back{position:fixed;top:0;left:0;right:0;z-index:20;margin:0;border-radius:0;background:rgba(250,246,240,.94);backdrop-filter:blur(12px);box-shadow:none;padding:14px 20px;font-size:13px;color:var(--leaf-deep)}
  .auth-card{border-radius:0;box-shadow:none;min-height:100vh;width:100%;padding:74px 26px 40px;display:flex;flex-direction:column;justify-content:center}
  .auth-card h1{font-size:26px}
  .row{flex-direction:column;align-items:flex-start;gap:10px}
}
</style>
</head>
<body>
<span class="blob b1"></span><span class="blob b2"></span>
<a href="${ctx}/" class="back">← Về trang chủ</a>

<div class="auth-card">
  <a href="${ctx}/" class="logo">Eight <span>Tea</span></a>
  <h1>Chào mừng trở lại!</h1>
  <p class="sub">Đăng nhập để đặt hàng nhanh hơn và theo dõi đơn của bạn.</p>

  <c:if test="${param.reset == 'success'}"><div class="alert ok">✅ Mật khẩu đã được đặt lại thành công. Hãy đăng nhập bằng mật khẩu mới.</div></c:if>
  <c:if test="${not empty errorMessage}"><div class="alert err">⚠️ <c:out value="${errorMessage}"/></div></c:if>

  <form method="post" action="${ctx}/login" autocomplete="on">
    <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
    <div class="field">
      <label for="email">Địa chỉ email</label>
      <div class="box"><input type="email" id="email" name="email" placeholder="ban@email.com" required autofocus value="${fn:escapeXml(param.email)}"></div>
    </div>
    <div class="field">
      <label for="password">Mật khẩu</label>
      <div class="box has-eye">
        <input type="password" id="password" name="password" placeholder="••••••••" required>
        <button type="button" class="eye" onclick="togglePw('password')" aria-label="Hiện mật khẩu"><i class="fa-regular fa-eye"></i></button>
      </div>
    </div>
    <div class="row">
      <label><input type="checkbox" name="remember"> Ghi nhớ đăng nhập</label>
      <a href="${ctx}/forgot-password" data-transition>Quên mật khẩu?</a>
    </div>
    <button type="submit" class="submit auth-submit">Đăng nhập</button>
  </form>
  <p class="alt">Chưa có tài khoản? <a href="${ctx}/register" data-transition>Đăng ký ngay →</a></p>
</div>

<script>
function togglePw(id){var i=document.getElementById(id);i.type=i.type==='password'?'text':'password';}
document.addEventListener('click', function(e){
  var link = e.target.closest('[data-transition]');
  if(!link || e.metaKey || e.ctrlKey || e.shiftKey) return;
  e.preventDefault();
  document.body.classList.add('page-leaving');
  setTimeout(function(){ window.location.href = link.href; }, 220);
});
</script>
</body>
</html>
