<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đặt lại mật khẩu — Eight Tea</title>
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

.card {
    position: relative;
    z-index: 5;
    width: min(480px, 100%);
    background: var(--et-surface);
    border-radius: 28px;
    box-shadow: 0 20px 60px -15px rgba(18, 14, 12, 0.08);
    padding: 44px 40px;
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
    margin: 0 auto 18px;
    font-size: 32px;
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
    margin: 8px 0 22px;
    font-size: 13.5px;
    line-height: 1.6;
}

.alert {
    border-radius: 14px;
    padding: 12px 14px;
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 16px;
    display: flex;
    gap: 9px;
    text-align: left;
    background: #FDF2F2;
    color: #9B1C1C;
    border: none;
}

.field {
    text-align: left;
    margin-bottom: 16px;
}
.field label {
    display: block;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: .06em;
    text-transform: uppercase;
    color: var(--et-ink-muted);
    margin-bottom: 6px;
}
.field .box {
    position: relative;
}
.field input {
    width: 100%;
    padding: 13px 44px 13px 14px;
    border-radius: 14px;
    border: none;
    background: var(--et-surface-muted);
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-size: 14px;
    color: var(--et-dark);
    box-shadow: inset 0 0 0 1px transparent;
    transition: background-color .2s ease, box-shadow .2s ease;
}
.field input:focus {
    outline: none;
    background: var(--et-surface);
    box-shadow: 0 0 0 4px rgba(210, 105, 30, 0.14), inset 0 0 0 1px rgba(210, 105, 30, 0.35);
}
.field input.err-border {
    box-shadow: 0 0 0 3px rgba(155, 28, 28, 0.15);
}

.eye {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    color: var(--et-ink-muted);
    display: flex;
    padding: 4px;
}

.steps {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0;
    margin-bottom: 22px;
}
.step-dot {
    width: 10px; height: 10px; border-radius: 50%;
    background: var(--et-surface-muted); transition: all .3s ease;
}
.step-dot.active { width: 28px; border-radius: 999px; background: var(--et-accent); }
.step-dot.done { background: var(--et-dark); }
.step-line { width: 28px; height: 2px; background: var(--et-surface-muted); margin: 0 4px; }
.step-line.done { background: var(--et-dark); }

.strength-wrap {
    margin-top: 10px;
}
.strength-track {
    display: flex;
    gap: 4px;
}
.strength-seg {
    flex: 1;
    height: 4px;
    border-radius: 999px;
    background: var(--et-surface-muted);
    transition: background-color .3s ease;
}
.strength-label {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 6px;
}
.strength-text {
    font-size: 11px;
    font-weight: 700;
    transition: color .3s ease;
}
.strength-pct {
    font-size: 11px;
    color: var(--et-ink-muted);
    font-weight: 600;
}

.pw-rules {
    background: var(--et-surface-muted);
    border-radius: 14px;
    padding: 14px 16px;
    margin-top: 12px;
    text-align: left;
}
.pw-rules-title {
    font-size: 10.5px;
    font-weight: 800;
    letter-spacing: .06em;
    text-transform: uppercase;
    color: var(--et-ink-muted);
    margin-bottom: 8px;
}
.pw-rule {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 5px 0;
    font-size: 12.5px;
    font-weight: 500;
    color: var(--et-ink-muted);
    transition: color .3s ease;
}
.pw-rule + .pw-rule {
    border-top: 1px solid rgba(18, 14, 12, 0.05);
}
.pw-rule.pass {
    color: var(--et-accent);
}
.pw-rule .icon {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    font-size: 11px;
    font-weight: 700;
    transition: all .3s ease;
    background: var(--et-surface);
    color: var(--et-ink-muted);
}
.pw-rule.pass .icon {
    background: var(--et-accent);
    color: #FFF;
    animation: popIn .3s cubic-bezier(.34, 1.56, .64, 1);
}
@keyframes popIn {
    0% { transform: scale(0); }
    60% { transform: scale(1.2); }
    100% { transform: scale(1); }
}

.match-row {
    display: flex;
    align-items: center;
    gap: 7px;
    margin-top: 8px;
    font-size: 12px;
    font-weight: 600;
    min-height: 18px;
    transition: all .3s ease;
}
.match-row.ok { color: var(--et-accent); }
.match-row.bad { color: #9B1C1C; }
.match-row .dot {
    width: 7px; height: 7px; border-radius: 50%; flex-shrink: 0;
}
.match-row.ok .dot { background: var(--et-accent); }
.match-row.bad .dot { background: #9B1C1C; }

.submit {
    width: 100%;
    margin-top: 18px;
    padding: 15px;
    border-radius: 999px;
    background: var(--et-accent);
    color: #FFF;
    font-weight: 700;
    font-size: 15px;
    box-shadow: 0 8px 22px -6px rgba(210, 105, 30, 0.45);
    transition: background-color .2s ease, transform .2s ease, opacity .2s ease;
}
.submit:hover:not(:disabled) {
    background: var(--et-accent-deep);
    transform: translateY(-2px);
}
.submit:disabled {
    opacity: .45;
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
}

@media (max-width: 520px) {
    body { padding: 16px 12px; align-items: flex-start; padding-top: 68px; }
    .back { position: fixed; top: 0; left: 0; right: 0; border-radius: 0; box-shadow: none; padding: 14px 20px; }
    .card { padding: 28px 20px; border-radius: 24px; }
    .badge { width: 68px; height: 68px; font-size: 28px; margin-bottom: 14px; }
    h1 { font-size: 22px; }
}
</style>
</head>
<body>
<a href="${ctx}/login" class="back"><i class="fa-solid fa-arrow-left"></i> Về đăng nhập</a>

<div class="card">
  <div class="steps">
    <span class="step-dot done"></span><span class="step-line done"></span>
    <span class="step-dot done"></span><span class="step-line done"></span>
    <span class="step-dot active"></span>
  </div>

  <div class="badge">🔒</div>
  <h1>Đặt lại mật khẩu</h1>
  <p class="sub">Tạo mật khẩu mới cho tài khoản của bạn. Sau khi đổi thành công, bạn sẽ được đưa về trang đăng nhập.</p>

  <c:if test="${not empty errorMessage}"><div class="alert"><i class="fa-solid fa-triangle-exclamation"></i> <c:out value="${errorMessage}"/></div></c:if>

  <form method="post" action="${ctx}/reset-password" id="resetForm">
    <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
    <div class="field">
      <label for="password">Mật khẩu mới</label>
      <div class="box">
        <input type="password" id="password" name="password" placeholder="••••••••" required autofocus autocomplete="new-password">
        <button type="button" class="eye" onclick="togglePw('password',this)" aria-label="Hiện mật khẩu"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/><circle cx="12" cy="12" r="3"/></svg></button>
      </div>

      <div class="strength-wrap">
        <div class="strength-track">
          <span class="strength-seg" id="seg0"></span><span class="strength-seg" id="seg1"></span><span class="strength-seg" id="seg2"></span>
        </div>
        <div class="strength-label"><span class="strength-text" id="strengthText"></span><span class="strength-pct" id="strengthPct"></span></div>
      </div>

      <div class="pw-rules">
        <div class="pw-rules-title">Yêu cầu mật khẩu</div>
        <div class="pw-rule" id="rule-len"><span class="icon">&mdash;</span><span>Ít nhất <b>6 ký tự</b></span></div>
        <div class="pw-rule" id="rule-upper"><span class="icon">&mdash;</span><span>Có chữ <b>hoa</b> (A-Z)</span></div>
        <div class="pw-rule" id="rule-lower"><span class="icon">&mdash;</span><span>Có chữ <b>thường</b> (a-z)</span></div>
        <div class="pw-rule" id="rule-digit"><span class="icon">&mdash;</span><span>Có <b>chữ số</b> (0-9)</span></div>
      </div>
    </div>

    <div class="field">
      <label for="confirmPassword">Xác nhận mật khẩu mới</label>
      <div class="box">
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••" required autocomplete="new-password">
        <button type="button" class="eye" onclick="togglePw('confirmPassword',this)" aria-label="Hiện mật khẩu"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/><circle cx="12" cy="12" r="3"/></svg></button>
      </div>
      <div class="match-row" id="matchRow"></div>
    </div>

    <button type="submit" class="submit" id="submitBtn" disabled>Đổi mật khẩu</button>
  </form>
</div>

<script>
function togglePw(id, btn){
  var inp = document.getElementById(id);
  var show = inp.type === 'password';
  inp.type = show ? 'text' : 'password';
  var svg = btn.querySelector('svg');
  if(svg) svg.style.opacity = show ? '.5' : '1';
}

(function(){
  var pw = document.getElementById('password');
  var confirm = document.getElementById('confirmPassword');
  var submitBtn = document.getElementById('submitBtn');
  var matchRow = document.getElementById('matchRow');

  var rules = {
    len:   { el: document.getElementById('rule-len'),   test: function(v){ return v.length >= 6; } },
    upper: { el: document.getElementById('rule-upper'), test: function(v){ return /[A-Z]/.test(v); } },
    lower: { el: document.getElementById('rule-lower'), test: function(v){ return /[a-z]/.test(v); } },
    digit: { el: document.getElementById('rule-digit'), test: function(v){ return /\d/.test(v); } }
  };

  var segs = [document.getElementById('seg0'), document.getElementById('seg1'), document.getElementById('seg2')];
  var strengthText = document.getElementById('strengthText');
  var strengthPct = document.getElementById('strengthPct');
  var levels = [
    { color: '#9B1C1C', label: 'Yếu' },
    { color: '#D97706', label: 'Trung bình' },
    { color: '#D2691E', label: 'Mạnh' }
  ];

  function checkRules(){
    var v = pw.value, passed = 0;
    for(var key in rules){
      var r = rules[key], ok = r.test(v);
      r.el.className = 'pw-rule ' + (ok ? 'pass' : '');
      r.el.querySelector('.icon').textContent = ok ? '✓' : '—';
      if(ok) passed++;
    }
    if(!v){
      segs.forEach(function(s){ s.style.background = ''; });
      strengthText.textContent = ''; strengthPct.textContent = '';
    } else {
      var lvlIdx = Math.min(Math.max(Math.ceil(passed/4*3)-1,0),2);
      var lvl = levels[lvlIdx];
      segs.forEach(function(s, i){ s.style.background = i <= lvlIdx ? lvl.color : ''; });
      strengthText.textContent = lvl.label; strengthText.style.color = lvl.color;
      strengthPct.textContent = Math.round(passed/4*100) + '%';
    }
    checkMatch();
  }

  function checkMatch(){
    var v1 = pw.value, v2 = confirm.value;
    var allPass = true;
    for(var key in rules){ if(!rules[key].test(v1)){ allPass = false; break; } }

    if(!v2){
      matchRow.className = 'match-row'; matchRow.innerHTML = '';
      confirm.classList.remove('err-border'); submitBtn.disabled = true;
      return;
    }
    if(v1 === v2){
      matchRow.className = 'match-row ok'; matchRow.innerHTML = '<span class="dot"></span> Mật khẩu khớp';
      confirm.classList.remove('err-border'); submitBtn.disabled = !allPass;
    } else {
      matchRow.className = 'match-row bad'; matchRow.innerHTML = '<span class="dot"></span> Mật khẩu không khớp';
      confirm.classList.add('err-border'); submitBtn.disabled = true;
    }
  }

  pw.addEventListener('input', checkRules);
  confirm.addEventListener('input', checkMatch);
})();
</script>
</body>
</html>
