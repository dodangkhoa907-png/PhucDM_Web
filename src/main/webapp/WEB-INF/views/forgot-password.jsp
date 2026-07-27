<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="isOtpStep" value="${not empty resetEmail}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${isOtpStep ? 'Xác thực OTP' : 'Quên mật khẩu'} — Eight Tea</title>
<link rel="stylesheet" href="${ctx}/css/eighttea.css?v=${initParam.assetVer}">
<style>
body{min-height:100vh;min-height:100dvh;display:flex;align-items:center;justify-content:center;padding:28px}
a{text-decoration:none;color:inherit}
.blob{position:fixed;border-radius:50%;filter:blur(60px);opacity:.35;pointer-events:none;z-index:0;animation:drift 14s ease-in-out infinite}
.blob.b1{width:340px;height:340px;background:var(--leaf-wash);top:-110px;left:-90px}
.blob.b2{width:300px;height:300px;background:var(--leaf);opacity:.14;bottom:-100px;right:-80px;animation-delay:-6s}
@keyframes drift{0%,100%{transform:translate(0,0)}50%{transform:translate(26px,-30px)}}
.back{position:fixed;top:22px;left:24px;z-index:20;display:inline-flex;align-items:center;gap:8px;background:var(--white);padding:10px 20px;border-radius:99px;font-family:var(--font);font-weight:600;font-size:13.5px;color:var(--ink-2);box-shadow:var(--shadow-sm);transition:transform .2s,color .2s}
.back:hover{transform:translateX(-3px);color:var(--leaf-deep)}
@keyframes cardIn{from{opacity:0;transform:translateY(30px) scale(.97)}to{opacity:1;transform:none}}
.auth-card{position:relative;z-index:5;width:min(480px,100%);background:var(--white);border-radius:var(--radius-lg);box-shadow:var(--shadow-lg);padding:44px 42px;animation:cardIn .6s cubic-bezier(.16,1,.3,1);text-align:center}
.badge{width:80px;height:80px;border-radius:50%;background:var(--leaf);display:flex;align-items:center;justify-content:center;margin:0 auto 20px;font-size:34px;box-shadow:var(--shadow-cta);animation:bob 5s ease-in-out infinite}
@keyframes bob{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
.auth-card h1{font-family:var(--font-display);font-weight:800;font-size:26px;color:var(--ink)}
.sub{color:var(--muted);margin:10px 0 24px;font-size:14.5px;line-height:1.6}
.alert{border-radius:14px;padding:13px 16px;font-size:13.5px;font-weight:600;margin-bottom:16px;display:flex;gap:9px;text-align:left}
.alert.err{background:#FBE3E1;color:#8E1F1F}
.field{text-align:left;margin-bottom:18px}
.field label{display:block;font-family:var(--font-mono);font-size:11px;font-weight:500;letter-spacing:.1em;text-transform:uppercase;color:var(--muted);margin-bottom:7px}
.auth-submit{width:100%;font-weight:700 !important;font-size:15.5px !important;padding:15px !important}
.alt{margin-top:20px;font-size:14px;color:var(--muted)}
.alt a{color:var(--leaf-deep);font-weight:700}
.alt a:hover{text-decoration:underline}

.email-hint{background:var(--leaf-wash);border-radius:12px;padding:10px 14px;margin-bottom:18px;font-family:var(--font);font-size:13px;color:var(--leaf-deep);font-weight:600;word-break:break-all;display:inline-flex;align-items:center;gap:6px}
.otp-wrap{display:flex;gap:8px;justify-content:center;margin-bottom:18px}
.otp-box{width:46px;height:56px;border-radius:12px;border:none;background:var(--paper);font-family:var(--font-mono);font-size:22px;font-weight:600;text-align:center;color:var(--leaf-deep);caret-color:var(--leaf);transition:box-shadow .2s,background-color .2s,transform .15s}
.otp-box:focus{outline:none;background:var(--white);box-shadow:0 0 0 3px rgba(210,105,30,.16);transform:translateY(-2px)}
.otp-box.filled{background:var(--leaf-wash)}
.otp-box.error{background:#FFF5F5;color:#BC5A24;animation:shake .4s}
@keyframes shake{0%,100%{transform:translateX(0)}20%,60%{transform:translateX(-4px)}40%,80%{transform:translateX(4px)}}
.timer{text-align:center;margin-bottom:18px;font-family:var(--font);font-size:13px;color:var(--muted);font-weight:600}
.timer .time{font-family:var(--font-mono);font-size:17px;color:var(--leaf-deep);font-weight:600;margin-left:4px}
.timer .time.expired{color:#BC5A24}
.resend-link{color:var(--leaf-deep);font-weight:700;cursor:pointer;transition:color .2s}
.resend-link:hover{color:var(--leaf);text-decoration:underline}
.resend-link.disabled{color:var(--muted);pointer-events:none;opacity:.5}

.steps{display:flex;align-items:center;justify-content:center;gap:0;margin-bottom:24px}
.step-dot{width:10px;height:10px;border-radius:50%;background:var(--mist);transition:all .3s}
.step-dot.active{width:28px;border-radius:99px;background:var(--leaf)}
.step-dot.done{background:var(--gold)}
.step-line{width:28px;height:2px;background:var(--mist);margin:0 4px}
.step-line.done{background:var(--gold)}

.paste-hint{display:none;text-align:center;margin-bottom:14px;font-family:var(--font);font-size:12px;color:var(--muted);font-weight:500}
.paste-hint button{background:var(--leaf);color:#fff;border:none;padding:6px 14px;border-radius:8px;font-size:12px;font-weight:600;margin-left:6px;cursor:pointer}

@media(max-width:520px){
  body{padding:16px 12px;align-items:flex-start;padding-top:68px}
  .back{top:14px;left:14px;padding:8px 14px;font-size:12px}
  .auth-card{padding:28px 20px;border-radius:22px;box-shadow:none}
  .badge{width:64px;height:64px;font-size:28px;margin-bottom:14px}
  .auth-card h1{font-size:22px}
  .sub{font-size:13px;margin:8px 0 18px}
  .otp-box{width:42px;height:50px;font-size:19px;border-radius:10px}
  .paste-hint{display:block}
}
</style>
</head>
<body>
<span class="blob b1"></span><span class="blob b2"></span>
<a href="${ctx}/login" class="back" data-transition>&larr; Về đăng nhập</a>

<div class="auth-card">
<c:choose>
  <c:when test="${isOtpStep}">
    <div class="steps">
      <span class="step-dot done"></span><span class="step-line done"></span>
      <span class="step-dot active"></span><span class="step-line"></span>
      <span class="step-dot"></span>
    </div>

    <div class="badge">📲</div>
    <h1>Xác thực OTP</h1>
    <p class="sub">Nhập mã 6 chữ số đã gửi đến email của bạn.</p>
    <div class="email-hint">📧 ${resetEmail}</div>

    <c:if test="${not empty errorMessage}"><div class="alert err">⚠️ <c:out value="${errorMessage}"/></div></c:if>

    <div class="paste-hint" id="pasteHint">Đã copy mã OTP? <button type="button" id="pasteBtn">Dán mã</button></div>

    <form method="post" action="${ctx}/verify-otp" id="otpForm">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="otp-wrap" id="otpWrap">
        <input type="text" name="d1" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" autocomplete="one-time-code" autofocus>
        <input type="text" name="d2" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]">
        <input type="text" name="d3" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]">
        <input type="text" name="d4" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]">
        <input type="text" name="d5" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]">
        <input type="text" name="d6" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]">
      </div>
      <div class="timer" id="timerArea"><span id="timerText">Mã hết hạn sau <span class="time" id="countdown"></span></span></div>
      <button type="submit" class="submit auth-submit" id="verifyBtn">Xác nhận mã OTP</button>
    </form>

    <p class="alt" style="margin-top:14px"><a class="resend-link disabled" id="resendLink" href="${ctx}/resend-otp">Gửi lại mã</a></p>
    <p class="alt"><a href="${ctx}/forgot-password" data-transition>&larr; Quay lại nhập email</a></p>

    <script>
    (function(){
      var boxes = document.querySelectorAll('.otp-box');
      var form = document.getElementById('otpForm');

      function fillBoxes(data){
        for(var j=0;j<Math.min(data.length,boxes.length);j++){ boxes[j].value=data[j]; boxes[j].classList.add('filled'); }
        var next=Math.min(data.length,boxes.length-1);
        boxes[next].focus();
        if(data.length>=6){
          var all=true; boxes.forEach(function(b){if(!b.value)all=false;});
          if(all) setTimeout(function(){form.submit();},200);
        }
      }

      boxes.forEach(function(box, i){
        box.addEventListener('input', function(){
          var v = this.value.replace(/[^0-9]/g,''); this.value = v;
          if(v){ this.classList.add('filled'); this.classList.remove('error'); if(i < boxes.length - 1) boxes[i+1].focus(); }
          else { this.classList.remove('filled'); }
        });
        box.addEventListener('keydown', function(e){
          if(e.key === 'Backspace' && !this.value && i > 0){ boxes[i-1].focus(); boxes[i-1].value=''; boxes[i-1].classList.remove('filled'); }
          if(e.key === 'ArrowLeft' && i > 0) boxes[i-1].focus();
          if(e.key === 'ArrowRight' && i < boxes.length-1) boxes[i+1].focus();
        });
        box.addEventListener('paste', function(e){ e.preventDefault(); var data=(e.clipboardData||window.clipboardData).getData('text').replace(/[^0-9]/g,''); fillBoxes(data); });
        box.addEventListener('focus', function(){ this.select(); });
      });

      var pasteBtn = document.getElementById('pasteBtn');
      if(pasteBtn){
        pasteBtn.addEventListener('click', function(){
          if(navigator.clipboard && navigator.clipboard.readText){
            navigator.clipboard.readText().then(function(text){ var data=text.replace(/[^0-9]/g,''); if(data.length>0) fillBoxes(data); }).catch(function(){});
          }
        });
      }

      <c:if test="${not empty errorMessage}">boxes.forEach(function(b){ b.classList.add('error'); });</c:if>

      var remaining = ${remainingMs};
      var countdownEl = document.getElementById('countdown');
      var timerText = document.getElementById('timerText');
      var resendLink = document.getElementById('resendLink');

      function pad(n){ return n < 10 ? '0' + n : '' + n; }
      function tick(){
        if(remaining <= 0){
          countdownEl.textContent = '00:00'; countdownEl.classList.add('expired');
          timerText.innerHTML = 'Mã OTP đã hết hạn'; resendLink.classList.remove('disabled');
          return;
        }
        var m = Math.floor(remaining / 60000), s = Math.floor((remaining % 60000) / 1000);
        countdownEl.textContent = pad(m) + ':' + pad(s);
        remaining -= 1000;
        setTimeout(tick, 1000);
      }
      tick();

      boxes[boxes.length-1].addEventListener('input', function(){
        var all = true; boxes.forEach(function(b){ if(!b.value) all = false; });
        if(all) setTimeout(function(){ form.submit(); }, 150);
      });
    })();
    </script>
  </c:when>

  <c:otherwise>
    <div class="steps">
      <span class="step-dot active"></span><span class="step-line"></span>
      <span class="step-dot"></span><span class="step-line"></span>
      <span class="step-dot"></span>
    </div>

    <div class="badge">🔑</div>
    <h1>Quên mật khẩu?</h1>
    <p class="sub">Nhập email đã đăng ký — chúng tôi sẽ gửi mã OTP 6 chữ số để xác thực (hiệu lực 5 phút).</p>

    <c:if test="${not empty errorMessage}"><div class="alert err">⚠️ <c:out value="${errorMessage}"/></div></c:if>

    <form method="post" action="${ctx}/forgot-password">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="field">
        <label for="email">Địa chỉ email</label>
        <input type="email" id="email" name="email" placeholder="ban@email.com" required autofocus value="${fn:escapeXml(param.email)}">
      </div>
      <button type="submit" class="submit auth-submit">Gửi mã OTP</button>
    </form>
    <p class="alt">Chưa có tài khoản? <a href="${ctx}/register" data-transition>Đăng ký ngay &rarr;</a></p>
  </c:otherwise>
</c:choose>
</div>
<script>
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
