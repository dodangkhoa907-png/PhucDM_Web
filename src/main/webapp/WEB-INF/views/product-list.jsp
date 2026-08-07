<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thực Đơn — Eight Tea | Trà mộc Cầu Đất, pha theo đơn</title>
    <meta name="description"
        content="Thực đơn Eight Tea — trà sữa, trà trái cây pha theo đơn. Trà mộc 100% Cầu Đất, cold-brew 8 tiếng, giao trong 15 phút.">
    <meta name="csrf-token" content="${sessionScope._csrf}">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="${ctx}/css/style.css?v=${initParam.assetVer}">
    <link rel="stylesheet" href="${ctx}/css/product.css?v=${initParam.assetVer}">
    <%-- Nạp SAU cùng: design system Eight Tea ghi đè da cũ (kèm @import font) --%>
    <link rel="stylesheet" href="${ctx}/css/eighttea.css?v=${initParam.assetVer}">

    <%-- Trước đây nhúng Tailwind Play CDN (script ngoài 407KB, JIT-compile ngay trên trình
         duyệt mỗi lần tải trang — chặn render, phụ thuộc mạng tới CDN ngoài). Giờ dùng bản
         build sẵn (npm run build:css, xem tailwind.config.js ở gốc repo) — cùng nội dung
         theme/preflight:false, chỉ khác là CSS tĩnh, không tốn JS/CPU phía client. --%>
    <link rel="stylesheet" href="${ctx}/css/tailwind-built.css?v=${initParam.assetVer}">

    <style>
      html { scroll-behavior: smooth; }
      /* Navbar luôn đặc ngay từ khung hình đầu tiên trên trang này — hero tối cần độ
         tương phản đủ mạnh mọi lúc, không thể đợi JS thêm class "scrolled" sau khi tải
         xong (có thể trễ vài khung hình, đủ để lộ navbar trong suốt đè lên nền tối). */
      /* Chỉ ghi đè nền/bóng/đệm cho khớp .navbar.scrolled trong eighttea.css — không
         chạm màu chữ, trạng thái active/hover hay nút tài khoản, nên header giữ nguyên
         nền sáng + chữ tối + link active xanh cả trước lẫn sau khi cuộn (không nháy màu). */
      body.has-dark-hero #navbar {
        background: var(--et-canvas) !important;
        backdrop-filter: none !important;
        -webkit-backdrop-filter: none !important;
        box-shadow: 0 1px 0 rgba(var(--et-dark-rgb),.07), 0 16px 32px -22px rgba(var(--et-dark-rgb),.22);
        padding: 13px 0 !important;
      }
      /* Ràng buộc borderless — giới hạn trong khu nội dung Tailwind để không đụng navbar/footer chung */
      .lp *, .lp *::before, .lp *::after { border: 0 !important; }
      /* Ảnh storytelling "Búp trà mộc": viền lộ khung nền (--et-canvas) quanh ảnh full-bleed,
         như ảnh lồng khung — phá lệ borderless có chủ đích cho riêng khối này, cần !important
         để thắng luật ".lp * { border:0 !important }" phía trên. */
      .lp .st-photo-frame { border: 10px solid var(--et-canvas) !important; }
      .lp .tnum { font-variant-numeric: tabular-nums; }
      .lp .no-bar { scrollbar-width: none; }
      .lp .no-bar::-webkit-scrollbar { display: none; }
      .lp a:focus-visible, .lp button:focus-visible, .lp input:focus-visible, .lp select:focus-visible {
        box-shadow:0 0 0 3px rgba(var(--et-primary-rgb),.5);
        outline: none;
      }
      @media (prefers-reduced-motion: reduce) {
        .lp * { transition-duration:.01ms !important; animation-duration:.01ms !important; }
      }
      /* Ly vẽ CSS thay cho ảnh sản phẩm hỏng. Trước đây JS gán thẳng gradient cam vào
         style của phần tử; giờ toàn bộ nằm ở đây để JS chỉ việc gắn class. Đây là hình
         minh họa khung ly (không phải màu thật của một món cụ thể) nên dùng sắc xanh. */
      .lp .et-cup-fallback {
        background: linear-gradient(178deg, var(--et-accent-muted), var(--et-primary-hover));
        clip-path: polygon(12% 0, 88% 0, 77% 100%, 23% 100%);
        border-radius: 4px 4px 12px 12px;
      }

      /* Nhãn nhấn nằm trong khối nền tối: --et-primary (#477023) trên --et-dark (#071E07)
         chỉ ~1.6:1, không đọc được với chữ nhỏ in hoa. Dùng một biến thể sáng của
         --et-accent-muted, khai báo một chỗ rồi phủ lên utility .text-accent bằng độ ưu
         tiên id (1,1,0) > class (0,1,0). Không đụng .bg-accent/15 (mảng nền mờ). */
      .lp { --et-accent-on-dark: #A9C285; }
      #thong-so .text-accent,
      .lp footer .text-accent { color: var(--et-accent-on-dark); }

      /* Thanh menu lọc nổi (sticky) — trạng thái mặc định/đang xem */
      /* Chưa chọn: nền xanh nhạt + chữ xanh đậm (không dùng viền cứng).
         Đang xem: nền xanh thương hiệu + chữ trắng — khác biệt bằng nền, không chỉ bằng màu chữ. */
      .lp .cat-tab {
        background:var(--et-primary-soft); color:var(--et-primary-hover);
        box-shadow:0 1px 2px rgba(var(--et-dark-rgb),.04), 0 4px 14px rgba(var(--et-dark-rgb),.04);
        transition: background-color .2s ease, color .2s ease, box-shadow .2s ease;
      }
      .lp .cat-tab:hover { background:var(--et-accent-muted); color:var(--et-surface); }
      .lp .cat-tab.is-active { background:var(--et-primary); color:var(--et-surface); box-shadow:0 10px 24px -8px rgba(var(--et-primary-rgb),.55); }
      .lp .cat-tab.is-active:hover { background:var(--et-primary-hover); }

      /* ── HERO — nền xanh chuyển sắc Reseda→Pakistan, ly trà vẽ tay ─────────── */
      /* Giữ nguyên hình dạng gradient cũ (cùng tâm, cùng các mốc dừng), chỉ thay dải màu
         hổ phách/nâu bằng dải xanh của bảng màu: Reseda → Fern → Dark Moss → Pakistan.
         Vẫn tối dần về rìa nên chữ trắng trên hero giữ được tương phản, và hero vẫn tách
         bạch hẳn với nền canvas sáng của phần còn lại. */
      .lp .hero-espresso {
        background:
          radial-gradient(115% 85% at 76% 26%,
            var(--et-accent-muted) 0%, var(--et-primary) 30%, var(--et-primary-hover) 62%, var(--et-dark) 100%);
      }
      @keyframes etSpin   { to { transform: rotate(360deg); } }
      @keyframes etDrift  { 0% { transform:translateY(10px) rotate(0);   opacity:0; }
                           15% { opacity:.55; }
                           85% { opacity:.35; }
                          100% { transform:translateY(-150px) rotate(200deg); opacity:0; } }
      @keyframes etRise   { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:none; } }
      @keyframes etBubble { 0% { transform:translateY(0); opacity:0; }
                           25% { opacity:.6; }
                          100% { transform:translateY(-78px); opacity:0; } }
      /* Nút "Xem ngay" — nền tối, phát sáng xanh thương hiệu khi hover, sparkle xoay/phóng to */
      .lp .et-view-btn {
        display:inline-flex; align-items:center; justify-content:center; gap:12px;
        width:100%; max-width:230px; height:64px; border-radius:999px;
        background:var(--et-dark); cursor:pointer; text-decoration:none;
        transition: all .45s ease-in-out;
      }
      .lp .et-view-sparkle { fill:#AAAAAA; transition: all .8s ease; }
      .lp .et-view-text { font-family:var(--font); font-weight:600; color:#AAAAAA; font-size:1rem; }
      .lp .et-view-btn:hover {
        background: linear-gradient(0deg,var(--et-primary-hover),var(--et-primary));
        box-shadow: inset 0 1px 0 rgba(255,255,255,.4), inset 0 -4px 0 rgba(0,0,0,.2),
                    0 0 0 4px rgba(255,255,255,.18), 0 0 90px 0 rgba(var(--et-primary-rgb),.55);
        transform: translateY(-2px);
      }
      .lp .et-view-btn:hover .et-view-text { color:#fff; }
      .lp .et-view-btn:hover .et-view-sparkle { fill:#fff; transform: scale(1.2); }
      .lp .et-arc      { animation: etSpin 26s linear infinite; transform-origin:50% 50%; }
      .lp .et-particle { animation: etDrift linear infinite; }
      .lp .et-in       { animation: etRise .85s cubic-bezier(.22,1,.36,1) both; }
      .lp .et-bub      { animation: etBubble 4.6s ease-in infinite; }
      @media (prefers-reduced-motion: reduce) {
        .lp .et-arc, .lp .et-particle, .lp .et-bub { animation: none !important; }
        .lp .et-in { animation: none !important; opacity:1; transform:none; }
      }
    </style>
</head>

<body class="bg-canvas font-sans text-ink-2 has-dark-hero">

    <%-- Navbar dùng chung (giữ nguyên logic session: badge giỏ, đăng nhập, dropdown tài khoản) --%>
    <%@ include file="/WEB-INF/views/common/customer-header.jsp" %>

<div class="lp">

    <!-- ═══════════════ HERO — trọn màn hình, nền ủ tối chuyển hổ phách ═══════════════ -->
    <section class="hero-espresso relative overflow-hidden min-h-[100svh] flex flex-col">

      <%-- Quầng sáng ấm hắt sau ly + vệt tối đáy để chữ ở dải thông tin luôn đọc được --%>
      <div class="absolute inset-0 pointer-events-none"
           style="background:radial-gradient(38% 34% at 72% 42%, rgba(255,255,255,.12) 0%, transparent 68%);"></div>
      <div class="absolute inset-x-0 bottom-0 h-52 pointer-events-none"
           style="background:linear-gradient(180deg, transparent, rgba(11,7,5,.72));"></div>

      <%-- Trân châu bay lơ lửng — thay cho hạt cà phê trong ảnh mẫu --%>
      <div class="absolute inset-0 pointer-events-none select-none" aria-hidden="true">
        <span class="et-particle absolute rounded-full" style="left:12%;top:72%;width:9px;height:9px;background:#3B2415;animation-duration:13s;animation-delay:0s;"></span>
        <span class="et-particle absolute rounded-full" style="left:23%;top:86%;width:6px;height:6px;background:#5A3A20;animation-duration:17s;animation-delay:2.4s;"></span>
        <span class="et-particle absolute rounded-full" style="left:41%;top:78%;width:11px;height:11px;background:#2C1A0F;animation-duration:15s;animation-delay:1.1s;"></span>
        <span class="et-particle absolute rounded-full" style="left:57%;top:90%;width:7px;height:7px;background:#4A2E19;animation-duration:19s;animation-delay:3.6s;"></span>
        <span class="et-particle absolute rounded-full" style="left:83%;top:80%;width:10px;height:10px;background:#33200F;animation-duration:14s;animation-delay:5s;"></span>
        <span class="et-particle absolute rounded-full" style="left:91%;top:64%;width:6px;height:6px;background:#5A3A20;animation-duration:21s;animation-delay:1.8s;"></span>
        <span class="et-particle absolute rounded-full" style="left:68%;top:88%;width:8px;height:8px;background:#3B2415;animation-duration:16s;animation-delay:6.2s;"></span>
      </div>

      <div class="relative z-10 flex-1 flex items-center w-full">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 w-full pt-20 sm:pt-28 pb-8 lg:pb-10">
          <div class="grid lg:grid-cols-12 gap-8 lg:gap-6 items-center">

            <!-- ── Chữ ── -->
            <div class="lg:col-span-6">
              <p class="et-in font-mono text-[.66rem] font-medium tracking-[.22em] uppercase text-[#A9C285] mb-6" style="animation-delay:.05s">
                Eight Tea · Thực đơn
              </p>
              <h1 class="et-in font-extrabold tracking-[-.04em] leading-[.98] text-[clamp(2.6rem,7vw,4.6rem)] text-white mb-6" style="animation-delay:.15s">
                Đậm vị trà,<br><span class="text-[#A9C285]">nhanh tận nhà.</span>
              </h1>
              <p class="et-in text-[1rem] leading-[1.75] text-[rgba(255,255,255,.78)] max-w-md mb-8" style="animation-delay:.25s">
                <c:out value="${drinkCount}"/> món pha theo đơn. Chọn size, chỉnh đường và đá
                theo khẩu vị — quầy bắt đầu pha ngay khi bạn đặt.
              </p>

              <a href="#san-pham-grid" class="et-in et-view-btn" style="animation-delay:.35s">
                <span class="et-view-text">Xem ngay</span>
              </a>
            </div>

            <!-- ── Ly trà vẽ tay + huy hiệu chữ vòng cung ── -->
            <div class="lg:col-span-6 relative flex justify-center lg:justify-end">

              <%-- Huy hiệu chữ chạy vòng tròn: 3 cam kết thật của thương hiệu --%>
              <svg class="et-arc hidden sm:block absolute left-2 lg:left-0 top-2 w-32 h-32 lg:w-40 lg:h-40 z-10 pointer-events-none select-none"
                   viewBox="0 0 200 200" aria-hidden="true">
                <defs>
                  <path id="etArcPath" fill="none"
                        d="M100,100 m-74,0 a74,74 0 1,1 148,0 a74,74 0 1,1 -148,0"/>
                </defs>
                <text fill="#A9C285" font-family="'IBM Plex Mono',monospace" font-size="13" font-weight="500" letter-spacing="1.6">
                  <textPath href="#etArcPath" startOffset="0">TRÀ LÀI • Ủ LẠNH 8 TIẾNG • PHA THEO ĐƠN • </textPath>
                </text>
              </svg>

              <%-- Ảnh thật ly Trà Sữa Lài — nền trắng đã tách bỏ (trong suốt) để nổi trên nền tối của hero --%>
              <img src="${ctx}/images/tra-lai-cup.png" alt="Ly Trà Sữa Lài Eight Tea"
                   class="et-in w-[170px] sm:w-[250px] lg:w-[320px] h-auto drop-shadow-2xl" style="animation-delay:.3s">
            </div>

          </div>
        </div>
      </div>

      <%-- Dải thông tin đáy: toàn số liệu thật, không phải nhãn trang trí --%>
      <div class="relative z-10 w-full" style="box-shadow:0 -1px 0 rgba(251,246,239,.12);">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 py-5 flex flex-wrap items-center gap-x-8 gap-y-3">
          <span class="font-mono text-[.64rem] tracking-[.14em] uppercase text-[rgba(255,255,255,.72)]">
            <strong class="text-white font-semibold"><c:out value="${drinkCount}"/></strong> món ·
            <strong class="text-white font-semibold"><c:out value="${fn:length(categories)}"/></strong> nhóm
          </span>
          <span class="font-mono text-[.64rem] tracking-[.14em] uppercase text-[rgba(255,255,255,.72)]">Size M 700ml · L 900ml</span>
          <span class="font-mono text-[.64rem] tracking-[.14em] uppercase text-[rgba(255,255,255,.72)]">Giao 20–30 phút · TP. Bà Rịa</span>
          <a href="#san-pham-grid" class="ml-auto inline-flex items-center gap-2.5 font-mono text-[.64rem] tracking-[.14em] uppercase text-[#A9C285] hover:text-white transition no-underline">
            Xem thực đơn
            <span class="w-8 h-8 rounded-full grid place-items-center" style="background:rgba(255,255,255,.14);">
              <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="12" y1="4" x2="12" y2="19"/><polyline points="6 13 12 19 18 13"/>
              </svg>
            </span>
          </a>
        </div>
      </div>
    </section>

    <!-- ═══════════════ LƯỚI SẢN PHẨM — STICKY TAB + SCROLL-SPY (không banner màu to) ═══════════════ -->
    <section id="san-pham-grid" class="pb-16 lg:pb-20" style="scroll-margin-top:80px;">

      <%-- Đếm trước số món mỗi danh mục để hiện trên tiêu đề — không xuất HTML ở bước này.
           Tính TRƯỚC nhánh rỗng/không-rỗng vì thanh lọc bên dưới giờ luôn hiện, kể cả khi
           0 kết quả — nếu không, tìm 0 kết quả là NGÕ CỤT: người dùng thấy "thử từ khóa
           khác" nhưng không có ô nào để gõ lại, phải bấm back. --%>
      <c:set var="cntTraSua" value="${0}"/>
      <c:set var="cntTraiCay" value="${0}"/>
      <c:set var="cntLatte" value="${0}"/>
      <c:set var="cntSoda" value="${0}"/>
      <c:set var="cntSuaChua" value="${0}"/>
      <c:set var="cntTopping" value="${0}"/>
      <c:forEach var="p" items="${products}">
        <c:if test="${p.categoryName == 'Trà Sữa'}"><c:set var="cntTraSua" value="${cntTraSua + 1}"/></c:if>
        <c:if test="${p.categoryName == 'Trà Trái Cây & Trà Tắc'}"><c:set var="cntTraiCay" value="${cntTraiCay + 1}"/></c:if>
        <c:if test="${p.categoryName == 'Latte'}"><c:set var="cntLatte" value="${cntLatte + 1}"/></c:if>
        <c:if test="${p.categoryName == 'Soda'}"><c:set var="cntSoda" value="${cntSoda + 1}"/></c:if>
        <c:if test="${p.categoryName == 'Sữa Chua & Sữa Tươi'}"><c:set var="cntSuaChua" value="${cntSuaChua + 1}"/></c:if>
        <c:if test="${p.categoryName == 'Topping'}"><c:set var="cntTopping" value="${cntTopping + 1}"/></c:if>
      </c:forEach>

      <!-- Thanh menu lọc nổi — sticky theo cuộn, bấm để trượt mượt đến đúng khu vực.
           Luôn render (kể cả 0 kết quả) để khách luôn có đường sửa lại tìm kiếm. -->
      <div class="sticky top-[64px] z-40 py-3 mb-10 bg-canvas/95 backdrop-blur-sm" style="box-shadow:0 1px 0 rgba(var(--et-dark-rgb),.06);">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 flex flex-col sm:flex-row gap-3 sm:items-center">
          <div class="flex gap-2 overflow-x-auto no-bar flex-1">
            <a href="#san-pham-grid" data-cat-anchor="san-pham-grid"
               class="cat-tab is-active shrink-0 font-mono text-[.68rem] font-semibold tracking-[.08em] uppercase px-4 py-2.5 rounded-full transition no-underline">Tất cả</a>
            <c:if test="${cntTraSua > 0}"><a href="#cat-tra-sua" data-cat-anchor="cat-tra-sua" class="cat-tab shrink-0 font-mono text-[.68rem] font-semibold tracking-[.08em] uppercase px-4 py-2.5 rounded-full transition no-underline">🧋 Trà Sữa</a></c:if>
            <c:if test="${cntTraiCay > 0}"><a href="#cat-trai-cay" data-cat-anchor="cat-trai-cay" class="cat-tab shrink-0 font-mono text-[.68rem] font-semibold tracking-[.08em] uppercase px-4 py-2.5 rounded-full transition no-underline">🍹 Trà Trái Cây</a></c:if>
            <c:if test="${cntLatte > 0}"><a href="#cat-latte" data-cat-anchor="cat-latte" class="cat-tab shrink-0 font-mono text-[.68rem] font-semibold tracking-[.08em] uppercase px-4 py-2.5 rounded-full transition no-underline">🥛 Latte</a></c:if>
            <c:if test="${cntSoda > 0}"><a href="#cat-soda" data-cat-anchor="cat-soda" class="cat-tab shrink-0 font-mono text-[.68rem] font-semibold tracking-[.08em] uppercase px-4 py-2.5 rounded-full transition no-underline">🫧 Soda</a></c:if>
            <c:if test="${cntSuaChua > 0}"><a href="#cat-sua-chua" data-cat-anchor="cat-sua-chua" class="cat-tab shrink-0 font-mono text-[.68rem] font-semibold tracking-[.08em] uppercase px-4 py-2.5 rounded-full transition no-underline">🍓 Sữa Chua</a></c:if>
            <c:if test="${cntTopping > 0}"><a href="#cat-topping" data-cat-anchor="cat-topping" class="cat-tab shrink-0 font-mono text-[.68rem] font-semibold tracking-[.08em] uppercase px-4 py-2.5 rounded-full transition no-underline">✨ Topping</a></c:if>
          </div>
          <form id="shopFilterForm" method="GET" action="${ctx}/san-pham" class="shrink-0 w-full sm:w-56">
            <div class="relative">
              <svg class="w-3.5 h-3.5 absolute left-4 top-1/2 -translate-y-1/2 text-muted pointer-events-none" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
              </svg>
              <input type="text" name="q" id="shopSearchInput" placeholder="Tìm món..."
                     value="${fn:escapeXml(keyword)}" maxlength="100" autocomplete="off"
                     class="w-full bg-surface shadow-soft rounded-full pl-10 pr-4 py-2.5 text-[.82rem] text-ink placeholder:text-muted focus:shadow-card transition">
            </div>
          </form>
        </div>
      </div>

      <c:if test="${empty products}">
        <div class="max-w-6xl mx-auto px-4 sm:px-6">
          <div class="bg-surface rounded-[24px] shadow-card p-12 text-center">
            <svg class="w-10 h-10 text-muted mx-auto mb-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
              <path d="M6 3h12l-1.3 15.6a2 2 0 0 1-2 1.9H9.3a2 2 0 0 1-2-1.9L6 3z"/><line x1="6.6" y1="9" x2="17.4" y2="9"/>
            </svg>
            <c:choose>
              <c:when test="${not empty keyword}">
                <p class="text-ink font-semibold mb-1">Không có món nào khớp "<c:out value="${keyword}"/>"</p>
                <p class="text-muted m-0 text-sm mb-5">Thử một từ khóa khác, hoặc xem toàn bộ thực đơn.</p>
                <a href="${ctx}/san-pham" class="inline-flex items-center gap-2 font-semibold text-[.85rem] text-accent hover:text-accent-deep transition no-underline">
                  Xoá tìm kiếm, xem tất cả
                </a>
              </c:when>
              <c:otherwise>
                <p class="text-ink font-semibold mb-1">Chưa tìm thấy sản phẩm phù hợp</p>
                <p class="text-muted m-0 text-sm">Thử đổi từ khóa tìm kiếm khác.</p>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:if>

      <c:if test="${not empty products}">
        <div class="max-w-6xl mx-auto px-4 sm:px-6">
          <p class="text-sm text-ink-2 mb-10">
            Hiển thị <strong class="text-ink font-bold"><c:out value="${drinkCount}"/></strong> sản phẩm
            <c:if test="${not empty keyword}"> cho "<c:out value="${keyword}"/>"</c:if>.
          </p>

          <c:if test="${cntTraSua > 0}">
          <div id="cat-tra-sua" class="category-section mb-16" style="scroll-margin-top:140px;">
            <div class="relative mb-6">
              <span class="absolute -top-5 -left-1 text-[4.5rem] leading-none select-none pointer-events-none opacity-[.06]" aria-hidden="true">🧋</span>
              <h3 class="relative text-ink font-extrabold text-[1.3rem]">Trà Sữa <span class="text-muted text-sm font-medium">(<c:out value="${cntTraSua}"/> món)</span></h3>
            </div>
            <div class="grid grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-5">
              <c:forEach var="p" items="${products}">
                <c:if test="${p.categoryName == 'Trà Sữa'}">
                  <%@ include file="/WEB-INF/views/common/_product-card.jspf" %>
                </c:if>
              </c:forEach>
            </div>
          </div>
          </c:if>

          <c:if test="${cntTraiCay > 0}">
          <div id="cat-trai-cay" class="category-section mb-16" style="scroll-margin-top:140px;">
            <div class="relative mb-6">
              <span class="absolute -top-5 -left-1 text-[4.5rem] leading-none select-none pointer-events-none opacity-[.06]" aria-hidden="true">🍹</span>
              <h3 class="relative text-ink font-extrabold text-[1.3rem]">Trà Trái Cây &amp; Trà Tắc <span class="text-muted text-sm font-medium">(<c:out value="${cntTraiCay}"/> món)</span></h3>
            </div>
            <div class="grid grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-5">
              <c:forEach var="p" items="${products}">
                <c:if test="${p.categoryName == 'Trà Trái Cây & Trà Tắc'}">
                  <%@ include file="/WEB-INF/views/common/_product-card.jspf" %>
                </c:if>
              </c:forEach>
            </div>
          </div>
          </c:if>

          <c:if test="${cntLatte > 0}">
          <div id="cat-latte" class="category-section mb-16" style="scroll-margin-top:140px;">
            <div class="relative mb-6">
              <span class="absolute -top-5 -left-1 text-[4.5rem] leading-none select-none pointer-events-none opacity-[.06]" aria-hidden="true">🥛</span>
              <h3 class="relative text-ink font-extrabold text-[1.3rem]">Latte <span class="text-muted text-sm font-medium">(<c:out value="${cntLatte}"/> món)</span></h3>
            </div>
            <div class="grid grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-5">
              <c:forEach var="p" items="${products}">
                <c:if test="${p.categoryName == 'Latte'}">
                  <%@ include file="/WEB-INF/views/common/_product-card.jspf" %>
                </c:if>
              </c:forEach>
            </div>
          </div>
          </c:if>

          <c:if test="${cntSoda > 0}">
          <div id="cat-soda" class="category-section mb-16" style="scroll-margin-top:140px;">
            <div class="relative mb-6">
              <span class="absolute -top-5 -left-1 text-[4.5rem] leading-none select-none pointer-events-none opacity-[.06]" aria-hidden="true">🫧</span>
              <h3 class="relative text-ink font-extrabold text-[1.3rem]">Soda <span class="text-muted text-sm font-medium">(<c:out value="${cntSoda}"/> món)</span></h3>
            </div>
            <div class="grid grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-5">
              <c:forEach var="p" items="${products}">
                <c:if test="${p.categoryName == 'Soda'}">
                  <%@ include file="/WEB-INF/views/common/_product-card.jspf" %>
                </c:if>
              </c:forEach>
            </div>
          </div>
          </c:if>

          <c:if test="${cntSuaChua > 0}">
          <div id="cat-sua-chua" class="category-section mb-16" style="scroll-margin-top:140px;">
            <div class="relative mb-6">
              <span class="absolute -top-5 -left-1 text-[4.5rem] leading-none select-none pointer-events-none opacity-[.06]" aria-hidden="true">🍓</span>
              <h3 class="relative text-ink font-extrabold text-[1.3rem]">Sữa Chua &amp; Sữa Tươi <span class="text-muted text-sm font-medium">(<c:out value="${cntSuaChua}"/> món)</span></h3>
            </div>
            <div class="grid grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-5">
              <c:forEach var="p" items="${products}">
                <c:if test="${p.categoryName == 'Sữa Chua & Sữa Tươi'}">
                  <%@ include file="/WEB-INF/views/common/_product-card.jspf" %>
                </c:if>
              </c:forEach>
            </div>
          </div>
          </c:if>

          <c:if test="${cntTopping > 0}">
          <div id="cat-topping" class="category-section" style="scroll-margin-top:140px;">
            <div class="relative mb-6">
              <span class="absolute -top-5 -left-1 text-[4.5rem] leading-none select-none pointer-events-none opacity-[.06]" aria-hidden="true">✨</span>
              <h3 class="relative text-ink font-extrabold text-[1.3rem]">Topping thêm <span class="text-muted text-sm font-medium">(<c:out value="${cntTopping}"/>)</span></h3>
            </div>
            <div class="bg-surface rounded-[24px] shadow-card p-6 sm:p-7">
              <div class="flex flex-wrap gap-3">
                <c:forEach var="p" items="${products}">
                  <c:if test="${p.categoryName == 'Topping' and not empty p.variants}">
                    <div class="flex items-center gap-3 bg-canvas rounded-2xl pl-4 pr-2 py-2">
                      <span class="text-sm font-semibold text-ink"><c:out value="${p.name}"/></span>
                      <span class="font-mono text-[.68rem] text-muted tnum">+<fmt:formatNumber value="${p.variants[0].price}" type="number" groupingUsed="true"/>đ</span>
                      <button type="button" class="btn-topping-add inline-flex items-center gap-1 bg-accent text-white font-semibold text-[.75rem] px-3 py-2 rounded-xl hover:bg-accent-deep transition"
                              data-variant-id="${p.variants[0].variantId}">
                        <svg class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                        Thêm
                      </button>
                    </div>
                  </c:if>
                </c:forEach>
              </div>
            </div>
          </div>
          </c:if>
        </div>
      </c:if>
    </section>

    <!-- ═══════════════ STORYTELLING — Z-Pattern ═══════════════ -->
    <section id="cau-chuyen" class="py-16 lg:py-24">
      <div class="max-w-6xl mx-auto px-4 sm:px-6">

        <div class="grid lg:grid-cols-2 gap-8 lg:gap-16 items-center">
          <div class="lg:order-2 st-photo-frame rounded-[28px] overflow-hidden shadow-card aspect-[4/3]">
            <img src="${ctx}/images/category/moi.jpg" alt="Trái cây tươi sơ chế tại quầy mỗi sáng" loading="lazy" class="w-full h-full object-cover">
          </div>
          <div class="lg:order-1">
            <p class="font-mono text-[.62rem] font-medium tracking-[.18em] uppercase text-accent mb-4">Nguyên liệu</p>
            <h2 class="text-ink font-extrabold tracking-[-.03em] leading-[1.08] text-[clamp(1.6rem,3.2vw,2.4rem)] mb-5">
              Trái cây cắt sáng,<br>sữa thanh trùng.
            </h2>
            <p class="text-[.98rem] leading-[1.7] text-ink-2 mb-4">
              Trái cây nhập mỗi sáng và sơ chế ngay tại quầy — vị chua ngọt trong ly đến từ
              chính quả tươi, không phải siro cô đặc.
            </p>
            <p class="text-[.98rem] leading-[1.7] text-ink-2 mb-6">
              Topping trân châu và thạch nấu thủ công theo ca, hết mẻ là nấu mẻ mới
              để luôn dẻo mềm đúng độ.
            </p>
            <div class="grid grid-cols-2 gap-px bg-mist rounded-2xl overflow-hidden shadow-soft max-w-md">
              <div class="bg-surface px-5 py-4">
                <dt class="font-mono text-[.56rem] tracking-[.14em] uppercase text-muted mb-1.5">Topping</dt>
                <dd class="font-extrabold text-ink text-[1.1rem]">Nấu mỗi ca</dd>
              </div>
              <div class="bg-surface px-5 py-4">
                <dt class="font-mono text-[.56rem] tracking-[.14em] uppercase text-muted mb-1.5">Siro cô đặc</dt>
                <dd class="font-extrabold text-ink text-[1.1rem] tnum">0%</dd>
              </div>
            </div>
          </div>
        </div>

      </div>
    </section>

    <!-- ═══════════════ FOOTER — bỏ khung "Bảng thông số" dark-card + CTA, giữ nội dung footer ═══════════════ -->
    <footer class="bg-dark text-[rgba(255,255,255,.72)] pb-10">
      <div class="max-w-6xl mx-auto px-4 sm:px-6">
        <div class="pt-10" style="box-shadow:0 -1px 0 rgba(255,255,255,.12);">
          <div class="flex flex-col sm:flex-row items-center justify-between gap-6">

            <a href="${ctx}/" class="flex items-center gap-2.5 no-underline">
              <span class="w-9 h-9 rounded-xl bg-accent grid place-items-center text-white font-extrabold text-sm">8</span>
              <span class="font-extrabold text-white tracking-tight">Eight Tea</span>
            </a>

            <div class="flex items-center gap-2.5">
              <a href="https://www.facebook.com/share/1BZV5Ap9xB/?mibextid=wwXIfr" target="_blank" rel="noopener" aria-label="Facebook"
                 class="w-10 h-10 rounded-full bg-dark-2 grid place-items-center text-[rgba(255,255,255,.78)] hover:bg-accent hover:text-white transition"><i class="fa-brands fa-facebook-f text-[15px]"></i></a>
              <a href="https://www.instagram.com/eight.tea?igsh=azhkdGxhNDk1OGk0" target="_blank" rel="noopener" aria-label="Instagram"
                 class="w-10 h-10 rounded-full bg-dark-2 grid place-items-center text-[rgba(255,255,255,.78)] hover:bg-accent hover:text-white transition"><i class="fa-brands fa-instagram text-[16px]"></i></a>
              <a href="https://www.tiktok.com/@eight.tea?_r=1&amp;_t=ZS-98OfvighJ13" target="_blank" rel="noopener" aria-label="TikTok"
                 class="w-10 h-10 rounded-full bg-dark-2 grid place-items-center text-[rgba(255,255,255,.78)] hover:bg-accent hover:text-white transition"><i class="fa-brands fa-tiktok text-[15px]"></i></a>
            </div>

            <p class="font-mono text-[.62rem] tracking-[.08em] text-[rgba(255,255,255,.55)] text-center sm:text-right m-0">
              © 2026 Eight Tea. 123 Nguyễn Đình Chiểu
            </p>
          </div>
        </div>
      </div>
    </footer>

</div><!-- /.lp -->

    <div class="toast-stack" id="toastStack" aria-live="polite"></div>
    <script src="${ctx}/js/cart.js?v=${initParam.assetVer}"></script>
    <script>
    (function () {
      'use strict';

      /* Navbar chung: đổi nền khi cuộn */
      var navbar = document.getElementById('navbar');
      if (navbar) {
        window.addEventListener('scroll', function () {
          navbar.classList.toggle('scrolled', window.scrollY > 40);
        });
        navbar.classList.add('scrolled');
      }

      var cards = Array.prototype.slice.call(document.querySelectorAll('.product-card'));

      /* ══════════════ THANH MENU LỌC NỔI — sticky + scroll-spy ══════════════
         Bấm tab trượt mượt (html{scroll-behavior:smooth}) đến đúng khu vực; khi cuộn tay,
         IntersectionObserver tự cập nhật tab đang active theo khu vực đang hiện trên màn hình. */
      var catTabs = Array.prototype.slice.call(document.querySelectorAll('.cat-tab'));
      var catSections = Array.prototype.slice.call(document.querySelectorAll('.category-section'));

      function setActiveCatTab(anchorId) {
        catTabs.forEach(function (t) {
          t.classList.toggle('is-active', t.dataset.catAnchor === anchorId);
        });
      }

      /* Tính theo vị trí cuộn thay vì IntersectionObserver: khu vực nào có mép trên vừa
         vượt qua "đường ngắm" (ngay dưới thanh tab dính) thì tab đó sáng. Cách này tất định,
         không phụ thuộc ngưỡng giao cắt nên không lỗi với khu vực cao hơn khung nhìn. */
      var SPY_LINE = 180;

      function syncCatTab() {
        if (!catSections.length) return;
        var current = null;
        for (var i = 0; i < catSections.length; i++) {
          if (catSections[i].getBoundingClientRect().top <= SPY_LINE) current = catSections[i];
        }
        // Chưa cuộn tới khu nào (còn ở hero/đầu lưới) → giữ "Tất cả"
        setActiveCatTab(current ? current.id : 'san-pham-grid');
      }

      var spyLast = 0;
      window.addEventListener('scroll', function () {
        var now = Date.now();
        if (now - spyLast < 100) return;
        spyLast = now;
        syncCatTab();
      }, { passive: true });

      // Bấm tab: sáng ngay, không đợi cuộn xong
      catTabs.forEach(function (t) {
        t.addEventListener('click', function () { setActiveCatTab(t.dataset.catAnchor); });
      });

      syncCatTab();

      /* Thêm nhanh topping độc lập (không cần chọn size/đường/đá) */
      document.querySelectorAll('.btn-topping-add').forEach(function (btn) {
        btn.addEventListener('click', function (e) {
          e.stopPropagation();
          NhietDoiXanhCart.addToCart(btn.dataset.variantId, 1, btn);
        });
      });

      /* ══════════════ FALLBACK ẢNH — thêm một lớp an toàn phía client ══════════════
         JSTL đã chọn sẵn ảnh khớp tên hoặc ly vẽ CSS ở server; nếu ảnh thật vẫn lỗi khi
         tải (link hỏng, 404...), thay bằng ly vẽ CSS thay vì để lộ icon ảnh vỡ. */
      // Hình dáng và màu ly nằm hết trong class .et-cup-fallback (xem <style> ở <head>)
      // nên JS không còn giữ mã màu nào — đổi theme chỉ phải sửa CSS.
      function cupFallback(name) {
        var span = document.createElement('span');
        span.className = 'et-cup-fallback block w-[42%] aspect-[.72/1] relative transition duration-500 group-hover:scale-105';
        span.setAttribute('role', 'img');
        span.setAttribute('aria-label', name || '');
        return span;
      }
      document.querySelectorAll('.product-card-img').forEach(function (img) {
        img.addEventListener('error', function () {
          var card = img.closest('.product-card');
          img.replaceWith(cupFallback(card ? card.dataset.name : ''));
        }, { once: true });
      });

      /* Bấm thẻ sản phẩm → sang trang chi tiết riêng (/san-pham/chi-tiet?id=).
         Trước đây mở modal tuỳ chọn ngay trên lưới, nhưng lớp phủ che mất ngữ cảnh và
         khách không rõ mình đang ở đâu; toàn bộ tuỳ chọn size/đường/đá/topping nay nằm
         trên trang chi tiết, nơi có đủ chỗ để trình bày rõ ràng. */
      cards.forEach(function (card) {
        card.addEventListener('click', function () {
          if (card.dataset.detailUrl) window.location.href = card.dataset.detailUrl;
        });
      });
    })();
    </script>

</body>
</html>
