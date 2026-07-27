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
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=IBM+Plex+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
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

.card {
    position: relative;
    z-index: 5;
    width: min(480px, 100%);
    background: var(--et-surface);
    border-radius: 28px;
    box-shadow: 0 20px 60px -15px rgba(18, 14, 12, 0.08);
    padding: 46px 44px;
    animation: cardIn .6s cubic-bezier(.16, 1, .3, 1);
    text-align: center;
}

.badge {
    width: 80px;
    height: 80px;
    border-radius: 24px;
    background: var(--et-dark);
    color: #FFF;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 20px;
    font-size: 34px;
}

h1 {
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-weight: 800;
    font-size: 26px;
    color: var(--et-dark);
    letter-spacing: -.02em;
}

.sub {
    color: var(--et-ink-muted);
    margin: 10px 0 24px;
    font-size: 14.5px;
    line-height: 1.6;
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
    text-align: left;
    border: none;
}
.alert.err {
    background: #FDF2F2;
    color: #9B1C1C;
}

.field {
    text-align: left;
    margin-bottom: 20px;
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
    margin-top: 20px;
    font-size: 14px;
    color: var(--et-ink-muted);
}
.alt a {
    color: var(--et-accent);
    font-weight: 700;
}
.alt a:hover { text-decoration: underline; }

.email-hint {
    background: var(--et-surface-muted);
    border-radius: 12px;
    padding: 10px 16px;
    margin-bottom: 20px;
    font-size: 13.5px;
    color: var(--et-dark);
    font-weight: 600;
    word-break: break-all;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.otp-wrap {
    display: flex;
    gap: 10px;
    justify-content: center;
    margin-bottom: 22px;
}
.otp-box {
    width: 48px;
    height: 58px;
    border-radius: 14px;
    border: none !important;
    background: var(--et-surface-muted);
    font-family: 'IBM Plex Mono', monospace !important;
    font-size: 22px;
    font-weight: 700;
    text-align: center;
    color: var(--et-dark);
    caret-color: var(--et-accent);
    box-shadow: inset 0 0 0 1px transparent;
    transition: background-color .2s ease, box-shadow .2s ease, transform .15s ease;
}
.otp-box:focus {
    outline: none;
    background: var(--et-surface);
    box-shadow: 0 0 0 4px rgba(210, 105, 30, 0.14), inset 0 0 0 1px rgba(210, 105, 30, 0.35) !important;
    transform: translateY(-2px);
}
.otp-box.filled {
    background: var(--et-surface);
    box-shadow: inset 0 0 0 2px var(--et-accent);
}
.otp-box.error {
    background: #FDF2F2;
    box-shadow: inset 0 0 0 2px #9B1C1C;
    animation: shake .4s;
}
@keyframes shake {
    0%, 100% { transform: translateX(0); }
    20%, 60% { transform: translateX(-4px); }
    40%, 80% { transform: translateX(4px); }
}

.timer {
    text-align: center;
    margin-bottom: 20px;
    font-size: 13.5px;
    color: var(--et-ink-muted);
    font-weight: 500;
}
.timer .time {
    font-family: 'IBM Plex Mono', monospace;
    font-size: 16px;
    color: var(--et-accent);
    font-weight: 700;
    margin-left: 6px;
}
.timer .time.expired { color: #9B1C1C; }

.resend-link {
    color: var(--et-accent);
    font-weight: 700;
    cursor: pointer;
    transition: color .2s;
}
.resend-link:hover { color: var(--et-accent-deep); text-decoration: underline; }
.resend-link.disabled { color: var(--et-ink-muted); pointer-events: none; opacity: .5; }

.steps {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0;
    margin-bottom: 26px;
}
.step-dot {
    width: 10px; height: 10px; border-radius: 50%;
    background: var(--et-surface-muted); transition: all .3s ease;
}
.step-dot.active { width: 28px; border-radius: 999px; background: var(--et-accent); }
.step-dot.done { background: var(--et-dark); }
.step-line { width: 28px; height: 2px; background: var(--et-surface-muted); margin: 0 4px; }
.step-line.done { background: var(--et-dark); }

.paste-hint {
    display: none; text-align: center; margin-bottom: 14px;
    font-size: 12.5px; color: var(--et-ink-muted); font-weight: 500;
}
.paste-hint button {
    background: var(--et-dark); color: #FFF; border: none;
    padding: 6px 14px; border-radius: 999px; font-size: 12px; font-weight: 600; margin-left: 6px;
}

@media (max-width: 520px) {
    body { padding: 16px 12px; align-items: flex-start; padding-top: 68px; }
    .back { position: fixed; top: 0; left: 0; right: 0; border-radius: 0; box-shadow: none; padding: 14px 20px; }
    .card { padding: 32px 22px; border-radius: 24px; }
    .badge { width: 68px; height: 68px; font-size: 28px; margin-bottom: 16px; }
    h1 { font-size: 22px; }
    .sub { font-size: 13.5px; margin: 8px 0 20px; }
    .otp-box { width: 42px; height: 52px; font-size: 20px; border-radius: 12px; }
    .paste-hint { display: block; }
}
</style>
</head>
<body>
<a href="${ctx}/login" class="back"><i class="fa-solid fa-arrow-left"></i> Về đăng nhập</a>

<div class="card">
<c:choose>
  <c:when test="${isOtpStep}">
    <div class="steps">
      <span class="step-dot done"></span><span class="step-line done"></span>
      <span class="step-dot active"></span><span class="step-line"></span>
      <span class="step-dot"></span>
    </div>

    <div class="badge">📱</div>
    <h1>Xác thực OTP</h1>
    <p class="sub">Nhập mã 6 chữ số đã gửi đến email của bạn.</p>
    <div class="email-hint"><i class="fa-regular fa-envelope"></i> ${resetEmail}</div>

    <c:if test="${not empty errorMessage}"><div class="alert err"><i class="fa-solid fa-triangle-exclamation"></i> <c:out value="${errorMessage}"/></div></c:if>

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
      <button type="submit" class="submit" id="verifyBtn">Xác nhận mã OTP</button>
    </form>

    <p class="alt" style="margin-top:16px"><a class="resend-link disabled" id="resendLink" href="${ctx}/resend-otp">Gửi lại mã</a></p>
    <p class="alt"><a href="${ctx}/forgot-password">&larr; Quay lại nhập email</a></p>

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

    <c:if test="${not empty errorMessage}"><div class="alert err"><i class="fa-solid fa-triangle-exclamation"></i> <c:out value="${errorMessage}"/></div></c:if>

    <form method="post" action="${ctx}/forgot-password">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="field">
        <label for="email">Địa chỉ email</label>
        <input type="email" id="email" name="email" placeholder="ban@email.com" required autofocus value="${fn:escapeXml(param.email)}" autocomplete="email">
      </div>
      <button type="submit" class="submit">Gửi mã OTP</button>
    </form>
    <p class="alt">Chưa có tài khoản? <a href="${ctx}/register">Đăng ký ngay &rarr;</a></p>
  </c:otherwise>
</c:choose>
</div>
</body>
</html>
