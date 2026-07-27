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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${ctx}/css/eighttea.css?v=${initParam.assetVer}">
<style>
body{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:28px;overflow-x:hidden}
a{text-decoration:none;color:inherit}
.blob{position:fixed;border-radius:50%;filter:blur(60px);opacity:.35;pointer-events:none;z-index:0;animation:drift 14s ease-in-out infinite}
.blob.b1{width:380px;height:380px;background:var(--leaf-bright);opacity:.18;top:-120px;right:-100px}
.blob.b2{width:320px;height:320px;background:var(--leaf-wash);bottom:-100px;left:-80px;animation-delay:-6s}
@keyframes drift{0%,100%{transform:translate(0,0)}50%{transform:translate(26px,-30px)}}
.back{position:fixed;top:22px;left:24px;z-index:20;display:inline-flex;align-items:center;gap:8px;background:var(--white);padding:10px 20px;border-radius:99px;font-family:var(--font);font-weight:600;font-size:13.5px;color:var(--ink-2);box-shadow:var(--shadow-sm);transition:transform .2s,color .2s}
.back:hover{transform:translateX(-3px);color:var(--leaf-deep)}
@keyframes cardIn{from{opacity:0;transform:translateY(30px) scale(.97)}to{opacity:1;transform:none}}
.auth-card{position:relative;z-index:5;width:min(520px,100%);background:var(--white);border-radius:var(--radius-lg);box-shadow:var(--shadow-lg);padding:46px 42px;animation:cardIn .6s cubic-bezier(.16,1,.3,1)}
.logo{display:inline-flex;align-items:center;gap:9px;font-family:var(--font-display);font-weight:800;font-size:22px;color:var(--ink);margin-bottom:18px}
.logo span{color:var(--leaf)}
.auth-card h1{font-family:var(--font-display);font-weight:800;font-size:clamp(24px,3vw,28px);line-height:1.15;color:var(--ink)}
.auth-card .sub{color:var(--muted);margin:8px 0 22px;font-size:14px}
.alert{border-radius:14px;padding:13px 16px;font-size:13.5px;font-weight:600;margin-bottom:16px;display:flex;gap:9px;align-items:flex-start;background:#FBE3E1;color:#8E1F1F}
.field{margin-bottom:14px}
.grid2{display:grid;grid-template-columns:1fr 1fr;gap:14px}
.field label{display:block;font-family:var(--font-mono);font-size:11px;font-weight:500;letter-spacing:.1em;text-transform:uppercase;color:var(--muted);margin-bottom:6px}
.field .box{position:relative}
.field .box.has-eye input{padding-right:44px}
.eye{position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--muted);display:flex;padding:4px;cursor:pointer;z-index:2}
.hint{font-size:12px;color:var(--muted);margin-top:5px}
.auth-submit{width:100%;margin-top:8px;font-weight:700 !important;font-size:15.5px !important;padding:15px !important}
.alt{text-align:center;margin-top:20px;font-size:14px;color:var(--muted)}
.alt a{color:var(--leaf-deep);font-weight:700}
.alt a:hover{text-decoration:underline}
.terms-check{display:flex;align-items:flex-start;gap:10px;cursor:pointer;text-transform:none;letter-spacing:0;font-weight:500;font-size:13.5px;color:var(--ink);font-family:var(--font)}
.terms-check input{width:18px;height:18px;margin-top:2px;accent-color:var(--leaf);flex-shrink:0;cursor:pointer}
.terms-check a{color:var(--leaf-deep);font-weight:700;text-decoration:underline}
.terms-overlay{position:fixed;inset:0;z-index:100;display:none;align-items:center;justify-content:center;background:rgba(18,14,12,.55);backdrop-filter:blur(4px);padding:20px}
.terms-overlay.open{display:flex}
.terms-panel{background:var(--white);border-radius:var(--radius-lg);max-width:600px;width:100%;max-height:80vh;display:flex;flex-direction:column;box-shadow:var(--shadow-lg);overflow:hidden}
.terms-hdr{padding:20px 24px 16px;display:flex;justify-content:space-between;align-items:center}
.terms-hdr h2{font-family:var(--font-display);font-size:20px;font-weight:800;color:var(--ink)}
.terms-close{background:none;border:none;font-size:22px;color:var(--muted);padding:4px 8px;border-radius:8px;cursor:pointer}
.terms-close:hover{background:var(--paper-2)}
.terms-body{padding:24px;overflow-y:auto;font-family:var(--font);font-size:14px;line-height:1.8;color:var(--ink)}
.terms-body h3{font-family:var(--font-display);font-size:16px;font-weight:700;margin:18px 0 8px;color:var(--leaf-deep)}
.terms-body h3:first-child{margin-top:0}
.terms-body ul{padding-left:20px;margin:8px 0}
.terms-body li{margin-bottom:4px}
@media(max-width:560px){
  .grid2{grid-template-columns:1fr}
  body{padding:0;align-items:stretch;flex-direction:column}
  .blob{display:none}
  .back{position:fixed;top:0;left:0;right:0;z-index:20;margin:0;border-radius:0;background:rgba(250,246,240,.94);backdrop-filter:blur(12px);box-shadow:none;padding:14px 20px;font-size:13px;color:var(--leaf-deep)}
  .auth-card{border-radius:0;box-shadow:none;min-height:100vh;width:100%;padding:70px 24px 40px}
  .auth-card h1{font-size:24px}
}
</style>
</head>
<body>
<span class="blob b1"></span><span class="blob b2"></span>
<a href="${ctx}/" class="back">← Về trang chủ</a>

<div class="auth-card">
  <a href="${ctx}/" class="logo">Eight <span>Tea</span></a>
  <h1>Tạo tài khoản</h1>
  <p class="sub">Tham gia Eight Tea để đặt hàng nhanh hơn.</p>

  <c:if test="${not empty errorMessage}"><div class="alert">⚠️ <c:out value="${errorMessage}"/></div></c:if>

  <form method="post" action="${ctx}/register" autocomplete="on">
    <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
    <div class="field">
      <label for="fullName">Họ và tên *</label>
      <div class="box"><input type="text" id="fullName" name="fullName" placeholder="Nguyễn Văn A" required autofocus value="${fn:escapeXml(param.fullName)}"></div>
    </div>
    <div class="grid2">
      <div class="field">
        <label for="email">Email *</label>
        <div class="box"><input type="email" id="email" name="email" placeholder="ban@email.com" required value="${fn:escapeXml(param.email)}"></div>
      </div>
      <div class="field">
        <label for="phone">Số điện thoại</label>
        <div class="box"><input type="tel" id="phone" name="phone" placeholder="09xx xxx xxx" value="${fn:escapeXml(param.phone)}" pattern="0[0-9]{9,10}" maxlength="11" inputmode="numeric" title="Số điện thoại bắt đầu bằng 0, gồm 10–11 chữ số"></div>
      </div>
    </div>
    <div class="field">
      <label for="password">Mật khẩu *</label>
      <div class="box has-eye">
        <input type="password" id="password" name="password" placeholder="••••••••" required>
        <button type="button" class="eye" onclick="togglePw('password')" aria-label="Hiện mật khẩu"><i class="fa-regular fa-eye"></i></button>
      </div>
      <p class="hint">Tối thiểu 6 ký tự, gồm chữ hoa, chữ thường và số.</p>
    </div>
    <div class="field">
      <label for="confirmPassword">Xác nhận mật khẩu *</label>
      <div class="box has-eye">
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••" required>
        <button type="button" class="eye" onclick="togglePw('confirmPassword')" aria-label="Hiện mật khẩu"><i class="fa-regular fa-eye"></i></button>
      </div>
    </div>
    <div class="field" style="margin-bottom:16px">
      <label class="terms-check">
        <input type="checkbox" name="agreeTerms" id="agreeTerms" required>
        <span>Tôi đồng ý với <a href="#" onclick="openModal(event,'termsModal')">Điều khoản sử dụng</a> và <a href="#" onclick="openModal(event,'privacyModal')">Chính sách bảo mật</a></span>
      </label>
    </div>
    <button type="submit" class="submit auth-submit">Đăng ký</button>
  </form>
  <p class="alt">Đã có tài khoản? <a href="${ctx}/login" data-transition>Đăng nhập →</a></p>
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
function togglePw(id){var i=document.getElementById(id);i.type=i.type==='password'?'text':'password';}
function openModal(e,id){e.preventDefault();document.getElementById(id).classList.add('open');}
function closeModal(id){document.getElementById(id).classList.remove('open');}
document.querySelectorAll('.terms-overlay').forEach(function(m){m.addEventListener('click',function(e){if(e.target===m)closeModal(m.id)});});
document.addEventListener('keydown',function(e){if(e.key==='Escape'){closeModal('termsModal');closeModal('privacyModal')}});
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
