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
    <title>Eight Tea — Đậm vị trà, nhanh tận nhà</title>
    <meta name="description" content="Eight Tea — trà sữa, trà trái cây và latte pha theo đơn. Trà mộc Cầu Đất, giao 20–30 phút tại TP. Bà Rịa.">
    <meta name="csrf-token" content="${sessionScope._csrf}">

    <%-- SEO: thẻ chia sẻ mạng xã hội. Khi dán link lên Facebook/Zalo/Messenger sẽ hiện
         đúng tên quán, mô tả và ảnh logo thay vì link trần. --%>
    <c:set var="siteUrl" value="${pageContext.request.scheme}://${header.host}${ctx}"/>
    <meta property="og:type"        content="website">
    <meta property="og:site_name"   content="Eight Tea">
    <meta property="og:locale"      content="vi_VN">
    <meta property="og:title"       content="Eight Tea — Đậm vị trà, nhanh tận nhà">
    <meta property="og:description" content="Trà sữa, trà trái cây và latte pha theo đơn. Giao 20–30 phút tại TP. Bà Rịa.">
    <meta property="og:url"         content="${siteUrl}/">
    <meta property="og:image"       content="${siteUrl}/images/logo-full.jpg">
    <meta name="twitter:card"       content="summary_large_image">
    <link rel="canonical" href="${siteUrl}/">

    <%-- SEO: dữ liệu có cấu trúc cho Google hiểu đây là quán ăn uống có địa chỉ thật.
         Chỉ khai báo thông tin đã xác thực (địa chỉ + hotline đang hiển thị ở chân trang);
         KHÔNG khai báo giờ mở cửa vì chưa xác nhận lại giờ hiện hành. --%>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "CafeOrCoffeeShop",
      "name": "Eight Tea",
      "description": "Trà sữa, trà trái cây và latte pha theo đơn tại TP. Bà Rịa.",
      "url": "${siteUrl}/",
      "image": "${siteUrl}/images/logo-full.jpg",
      "telephone": "+84364523553",
      "servesCuisine": "Trà sữa",
      "priceRange": "15.000₫ - 42.000₫",
      "address": {
        "@type": "PostalAddress",
        "streetAddress": "139 Võ Văn Kiệt, P. Tam Long",
        "addressLocality": "TP. Bà Rịa",
        "addressRegion": "Bà Rịa - Vũng Tàu",
        "addressCountry": "VN"
      },
      "sameAs": [
        "https://www.facebook.com/share/1BZV5Ap9xB/?mibextid=wwXIfr",
        "https://www.instagram.com/eight.tea",
        "https://www.tiktok.com/@eight.tea"
      ]
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <%-- Bổ sung trục nghiêng (italic) + nét mảnh cho Plus Jakarta Sans: bản nạp trong
         eighttea.css chỉ có 400–800 thẳng, thiếu thì trình duyệt phải "bẻ nghiêng" giả. --%>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:ital,wght@0,300;0,500;0,700;0,800;1,300;1,400&display=swap" rel="stylesheet">
    <%-- Baloo 2 — chữ tròn kiểu "bong bóng", dùng riêng cho tên món trong khu trình chiếu.
         Chọn font này vì đúng chất "trà sữa TRÂN CHÂU" (bong bóng), có bộ dấu tiếng Việt đầy đủ
         (Google Fonts subset "vietnamese" chuẩn), và tách biệt rõ với Plus Jakarta Sans của phần thân. --%>
    <link href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@600..800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="${ctx}/css/style.css?v=${initParam.assetVer}">
    <link rel="stylesheet" href="${ctx}/css/product.css?v=${initParam.assetVer}">
    <link rel="stylesheet" href="${ctx}/css/eighttea.css?v=${initParam.assetVer}">

    <%-- Trước đây nhúng Tailwind Play CDN (script ngoài 407KB, JIT-compile ngay trên trình
         duyệt mỗi lần tải trang — chặn render, phụ thuộc mạng tới CDN ngoài). Giờ dùng bản
         build sẵn (npm run build:css, xem tailwind.config.js ở gốc repo) — cùng nội dung
         theme/preflight:false, chỉ khác là CSS tĩnh, không tốn JS/CPU phía client. --%>
    <link rel="stylesheet" href="${ctx}/css/tailwind-built.css?v=${initParam.assetVer}">

    <style>
      html { scroll-behavior: smooth; }

      /* Navbar đặc ngay từ khung hình đầu — không đợi JS gắn class "scrolled".
         Chỉ ghi đè nền/đệm/bóng cho khớp .navbar.scrolled trong eighttea.css; KHÔNG
         đụng tới màu chữ, trạng thái active/hover hay nút tài khoản (đã chuẩn hóa ở
         bước trước) nên header trước và sau khi cuộn không đổi màu. */
      body.hp #navbar {
        background:var(--et-canvas) !important; backdrop-filter:none !important; -webkit-backdrop-filter:none !important;
        padding:13px 0 !important;
        box-shadow:0 1px 0 rgba(var(--et-dark-rgb),.07), 0 16px 32px -22px rgba(var(--et-dark-rgb),.22);
      }

      /* Không viền — phân tầng bằng nền + bóng, đồng bộ với phần còn lại của site. */
      .hp-scope *, .hp-scope *::before, .hp-scope *::after { border:0 !important; }
      .hp-scope .tnum { font-variant-numeric: tabular-nums; }

      /* ── Trình chiếu: các slide xếp chồng, chỉ slide đang bật mới nhận thao tác ── */
      .hs-stage { position:relative; }
      .hs-slide { opacity:0; visibility:hidden; pointer-events:none; position:absolute; inset:0; }
      .hs-slide.is-on { opacity:1; visibility:visible; pointer-events:auto; position:relative; }
      /* Vào từ phải khi bấm "kế tiếp", từ trái khi bấm "trước" — chỉ animate 1 lớp cha
         nên chữ, giá và ly chuyển động đồng thời trên cùng một compositor layer. */
      .hs-slide.enter-r { animation: hsInR .45s cubic-bezier(.22,1,.36,1) both; }
      .hs-slide.enter-l { animation: hsInL .45s cubic-bezier(.22,1,.36,1) both; }
      @keyframes hsInR { from { opacity:0; transform:translate3d(15px,0,0); }  to { opacity:1; transform:none; } }
      @keyframes hsInL { from { opacity:0; transform:translate3d(-15px,0,0); } to { opacity:1; transform:none; } }

      /* Tên món trong khu trình chiếu — đang thử UVN Mot Moi (serif tương phản nét cao,
         file cục bộ, đã kiểm tra cmap: đủ toàn bộ dấu tiếng Việt đang dùng trong tên món
         thật, không thiếu ký tự nào). Bản trước đã thử SFU Salut (đậm, cách điệu) — file
         vẫn còn trong /fonts nếu muốn quay lại. Baloo 2 giữ làm phương án dự phòng cuối.
         KHÔNG dùng theme.extend.fontFamily của Tailwind Play CDN cho key mới: đã kiểm chứng
         CDN tạo ra ".font-display{}" rỗng (không đọc lại key lạ sau khi DOM đã có class đó
         từ lúc tải trang), nên khai báo trực tiếp tại đây — chắc chắn thắng vì h1 trong
         eighttea.css chỉ là selector phần tử (0,0,1), thấp hơn class (0,1,0). */
      @font-face {
        font-family: 'UVN Mot Moi';
        src: url('${ctx}/fonts/UVNMotMoi.ttf') format('truetype');
        font-weight: 400;
        font-style: normal;
        font-display: swap;
      }
      /* Dùng chung cho tiêu đề hero (.hs-title-font) và tiêu đề khối kể chuyện
         (.st-title) — cùng một khuôn mặt chữ thì toàn trang mới đọc như một bộ. */
      .hp-scope .hs-title-font,
      .hp-scope .st-title {
        font-family: 'UVN Mot Moi', 'Baloo 2', system-ui, sans-serif !important;
        /* Font chỉ có 1 lát cắt (400) — ép 800 sẽ khiến trình duyệt tự "giả đậm"
           (synthetic bold). Với serif tương phản nét cao như thế này, giả đậm sẽ làm
           nét mảnh bị nhòe/gãy nét rất rõ, nên càng phải giữ đúng 400.
           Muốn đậm hơn mà không vỡ nét: tô dày viền chữ trùng màu chữ (text-stroke)
           thay vì đổi font-weight — dày đều mọi hướng, không lệch nét như giả đậm. */
        font-weight: 400 !important;
        -webkit-text-stroke: .6px currentColor;
        text-stroke: .6px currentColor;
      }

      /* Chấm chỉ vị trí: chấm đang xem kéo dài thành gạch */
      .hs-dot { width:8px; height:8px; border-radius:999px; background:var(--et-border); transition:width .3s ease, background-color .3s ease; }
      .hs-dot.is-on { width:32px; background:var(--et-primary); }

      /* Mũi tên kính mờ */
      .hs-arrow {
        background:rgba(255,255,255,.8);
        backdrop-filter:blur(12px); -webkit-backdrop-filter:blur(12px);
        box-shadow:0 4px 18px -6px rgba(11,7,5,.35);
        transition: transform .2s ease, background-color .2s ease, color .2s ease;
      }
      .hs-arrow:hover { background:#fff; transform:translateY(-50%) scale(1.1); }
      .hs-arrow:active { transform:translateY(-50%) scale(.95); }
      /* Bản mũi tên nằm trong hàng điều khiển (không dùng translateY) */
      .hs-arrow-inline {
        background:rgba(255,255,255,.85);
        box-shadow:0 2px 10px -3px rgba(11,7,5,.25);
        transition: transform .2s ease, background-color .2s ease;
      }
      .hs-arrow-inline:hover { background:#fff; transform:scale(1.1); }
      .hs-arrow-inline:active { transform:scale(.95); }

      /* Nút chính: nảy nhẹ + gợn sóng khi bấm */
      .btn-add-hero { position:relative; overflow:hidden; transition: all .3s ease-out; }
      .btn-add-hero:hover { transform:scale(1.03); filter:brightness(1.08); }
      .btn-add-hero:active { transform:scale(.97); }
      .hs-ripple {
        position:absolute; border-radius:999px; background:rgba(255,255,255,.45);
        transform:scale(0); pointer-events:none; animation:hsRipple .6s ease-out forwards;
      }
      @keyframes hsRipple { to { transform:scale(2.6); opacity:0; } }

      /* Gạch chân mở rộng cho link phụ */
      .hs-underline { position:relative; text-decoration:none; }
      .hs-underline::after {
        content:''; position:absolute; left:0; bottom:-8px; height:2px; width:100%;
        background:currentColor; transform:scaleX(0); transform-origin:left;
        transition: transform .35s cubic-bezier(.22,1,.36,1);
      }
      .hs-underline:hover::after { transform:scaleX(1); }

      /* Quầng sáng bám theo con trỏ */
      .hs-glow {
        background: radial-gradient(600px circle at var(--x,50%) var(--y,50%), rgba(var(--et-primary-rgb),.14), transparent 40%);
      }

      /* Ô tìm kiếm — eighttea.css đặt `input[type="text"] { padding; border-radius;
         background:!important }` với độ ưu tiên (0,1,1) cao hơn class Tailwind (0,1,0),
         nên bo tròn/đệm trái/nền của Tailwind bị nuốt. Ghi đè tường minh tại đây. */
      .hp-scope .hs-search input[type="text"] {
        padding: 14px 20px 14px 48px !important;
        border-radius: 999px !important;
        background: rgba(255,255,255,.78) !important;
        box-shadow: 0 1px 2px rgba(var(--et-dark-rgb),.05), 0 6px 18px -6px rgba(var(--et-dark-rgb),.12) !important;
        font-size: .9rem;
      }
      /* Khi gõ: nền trắng + vòng sáng xanh thương hiệu thay cho bóng nâu cũ. */
      .hp-scope .hs-search input[type="text"]:focus {
        background: var(--et-surface) !important;
        box-shadow: 0 0 0 3px rgba(var(--et-primary-rgb),.28), 0 16px 34px -14px rgba(var(--et-dark-rgb),.22) !important;
      }

      /* ── Khối kể chuyện (Section 3) ─────────────────────────────────────
         Khung vòm: bo tròn hẳn nửa trên, bo nhẹ nửa dưới. Dùng chung cho cả ảnh
         chụp (khối 01) lẫn hình vẽ (khối 02) — hai chất liệu khác nhau nhưng
         chung một khuôn nên vẫn đọc như một bộ. */
      .hp-scope .st-arch { border-radius: 999px 999px 30px 30px; overflow: hidden; }

      /* Số thứ tự khổ lớn chìm sau tiêu đề — mốc thị giác, không phải chữ để đọc,
         nên để tương phản rất thấp và aria-hidden ở phần HTML. */
      .hp-scope .st-ghost {
        font-family: 'UVN Mot Moi', 'Baloo 2', system-ui, sans-serif;
        line-height: .78; color: var(--et-border); user-select: none;
      }

      .hp-scope a:focus-visible, .hp-scope button:focus-visible, .hp-scope input:focus-visible {
        outline:3px solid rgba(var(--et-primary-rgb),.55); outline-offset:3px;
      }

      /* Nhãn nhấn trong khối nền tối. --et-primary (#477023) đặt trên --et-dark
         (#071E07) chỉ đạt ~1.6:1 — không đọc được, mà đây lại là chữ nhỏ in hoa.
         Dùng một biến thể sáng của --et-accent-muted, khai báo đúng MỘT chỗ và
         phủ lên utility .text-accent bằng độ ưu tiên id (1,1,0) > class (0,1,0),
         nên không phải sửa rải rác trong markup. Nền tối vẫn giữ nguyên token.
         Không áp dụng cho .bg-accent/15 (mảng nền mờ, không phải chữ). */
      .hp-scope { --et-accent-on-dark: #A9C285; }
      #thong-so .text-accent,
      .hp-scope footer .text-accent { color: var(--et-accent-on-dark); }

      /* Thẻ thông số trong khối nền tối. Trước đây mỗi thẻ lặp lại một chuỗi
         shadow-[...] rất dài của Tailwind; gom về một class để đọc được token
         --et-* (arbitrary value của Tailwind Play CDN không đọc biến CSS ổn định)
         và để đổi màu một chỗ thay vì bốn chỗ. */
      .hp-scope .hp-spec-card { transition: transform .3s ease, background-color .3s ease, box-shadow .3s ease; }
      .hp-scope .hp-spec-card:hover {
        transform: translateY(-4px);
        /* Sáng lên một chút so với nền thẻ (giống hiệu ứng cũ) bằng cách phủ một lớp
           xanh rất mờ lên chính token nền — không cần thêm hex ngoài bảng màu. */
        background: linear-gradient(rgba(var(--et-primary-rgb),.14), rgba(var(--et-primary-rgb),.14)), var(--et-dark-surface);
        box-shadow: inset 0 0 0 1.5px rgba(var(--et-primary-rgb),.75),
                    0 22px 46px -22px rgba(var(--et-primary-rgb),.45);
      }

      /* Chấm "đang mở" ở banner chốt đơn (Section 4) — vòng sóng giãn ra rồi mờ dần,
         lặp lại chậm rãi. Chỉ một điểm chuyển động trong cả khối tối, không rải rác. */
      .hp-pulse { animation: hpPulse 2.2s cubic-bezier(0,0,.2,1) infinite; }
      @keyframes hpPulse {
        0%   { transform: scale(1);   opacity: .75; }
        75%  { transform: scale(2.4); opacity: 0; }
        100% { transform: scale(2.4); opacity: 0; }
      }

      @media (prefers-reduced-motion: reduce) {
        html { scroll-behavior:auto; }
        .hs-slide.enter-r, .hs-slide.enter-l { animation:none; }
        .btn-add-hero:hover, .btn-add-hero:active { transform:none; }
        .hs-arrow:hover { transform:translateY(-50%); }
        .hs-ripple { display:none; }
        .hs-glow { display:none; }
        .hp-pulse { animation:none; opacity:0; }
      }
    </style>
</head>

<body class="hp bg-canvas font-sans text-ink-2">

    <%@ include file="/WEB-INF/views/common/customer-header.jsp" %>

<div class="hp-scope">

  <!-- ══════════════ SECTION 1 — TRÌNH CHIẾU MÓN NỔI BẬT ══════════════ -->
  <section id="section-1" class="relative overflow-hidden min-h-[100svh] flex flex-col bg-canvas">

    <%-- Nền mềm: dùng gradient toả nên không lộ mép tròn cứng như khối đặc --%>
    <div class="absolute inset-0 pointer-events-none" aria-hidden="true"
         style="background:
           radial-gradient(520px circle at 4% 14%, var(--et-surface-muted) 0%, transparent 66%),
           radial-gradient(420px circle at 26% 98%, var(--et-surface-muted) 0%, transparent 68%);"></div>

    <%-- Cột điểm nhấn tối bên phải — ly trà sẽ đè lên đúng đường ranh giới này.
         Bo cong lớn theo trục dọc để tạo đường cong mềm thay vì mép bo nhỏ cứng. --%>
    <div class="hidden lg:block absolute top-0 right-0 h-full w-[38%] bg-dark pointer-events-none"
         style="border-radius:46% 0 0 46% / 22% 0 0 22%;" aria-hidden="true"></div>

    <%-- Quầng sáng ấm bám theo con trỏ (JS cập nhật --x / --y) --%>
    <div id="hsGlow" class="hs-glow absolute inset-0 pointer-events-none" aria-hidden="true"></div>

    <div class="relative z-10 flex-1 flex flex-col max-w-6xl mx-auto w-full px-4 sm:px-6 pt-16 sm:pt-24 pb-4 lg:pb-10">

      <%-- Thanh tìm kiếm: căn giữa RIÊNG phần nền sáng, không phải giữa trang,
           nên không bao giờ trườn sang cột tối bên phải. --%>
      <div class="shrink-0 w-full lg:w-[60%] mb-10 lg:mb-6">
        <form method="GET" action="${ctx}/san-pham" class="hs-search w-full max-w-sm mx-auto">
          <div class="relative">
            <svg class="w-4 h-4 absolute left-5 top-1/2 -translate-y-1/2 text-muted pointer-events-none z-10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input type="text" name="q" maxlength="100" autocomplete="off"
                   placeholder="Tìm món yêu thích của bạn..."
                   class="w-full text-ink placeholder:text-muted transition">
          </div>
        </form>
      </div>

      <c:choose>
        <c:when test="${empty heroSlides}">
          <div class="flex-1 grid place-items-center">
            <p class="text-muted">Thực đơn đang được cập nhật.</p>
          </div>
        </c:when>
        <c:otherwise>

        <div class="hs-stage flex-1" id="hsStage">
          <c:forEach var="p" items="${heroSlides}" varStatus="s">

            <%-- Bảng màu ly theo nhóm món, để mỗi slide ra một thức uống khác nhau --%>
            <c:set var="teaTop"    value="#E9CBA4"/>
            <c:set var="teaBottom" value="#A9611B"/>
            <c:set var="hasBoba"   value="${true}"/>
            <c:set var="hasFoam"   value="${true}"/>
            <c:if test="${p.categoryName == 'Trà Trái Cây & Trà Tắc'}">
              <c:set var="teaTop" value="#F7D46B"/><c:set var="teaBottom" value="#DE9226"/>
              <c:set var="hasBoba" value="${false}"/><c:set var="hasFoam" value="${false}"/>
            </c:if>
            <c:if test="${p.categoryName == 'Soda'}">
              <c:set var="teaTop" value="#8FD3E4"/><c:set var="teaBottom" value="#2F8FA9"/>
              <c:set var="hasBoba" value="${false}"/><c:set var="hasFoam" value="${false}"/>
            </c:if>
            <c:if test="${p.categoryName == 'Latte'}">
              <c:set var="teaTop" value="#E4C6A2"/><c:set var="teaBottom" value="#8C5A2B"/>
              <c:set var="hasBoba" value="${false}"/>
            </c:if>
            <c:if test="${p.categoryName == 'Sữa Chua & Sữa Tươi'}">
              <c:set var="teaTop" value="#F6E7D6"/><c:set var="teaBottom" value="#DFB77C"/>
              <c:set var="hasBoba" value="${false}"/>
            </c:if>

            <div class="hs-slide ${s.first ? 'is-on' : ''}" data-slide="${s.index}">
              <div class="grid lg:grid-cols-2 gap-4 lg:gap-4 items-center h-full">

                <!-- ── Cột trái: thông tin & chốt đơn ── -->
                <div class="order-2 lg:order-1 lg:pr-6">
                  <p class="font-mono text-[.66rem] font-medium tracking-[.2em] uppercase text-accent mb-5">
                    Nổi bật · <span class="tnum">0${s.count}</span> / <span class="tnum">0${fn:length(heroSlides)}</span>
                  </p>

                  <%-- font-display (Baloo 2) — chữ tròn "bong bóng" cho đúng chất trân châu,
                       tách hẳn khỏi Plus Jakarta Sans của phần thân. text-wrap:balance để
                       trình duyệt chia đều 2 dòng, tránh kiểu vắt chữ xấu. --%>
                  <h1 class="hs-title-font text-dark font-extrabold uppercase leading-[0.95] tracking-[.045em] text-[clamp(2.6rem,7.5vw,5.6rem)] mb-4 max-w-[15ch]"
                      style="text-wrap:balance;">
                    <c:out value="${p.name}"/>
                  </h1>

                  <p class="flex items-baseline gap-2 mb-5">
                    <span class="text-dark font-extrabold text-3xl sm:text-4xl tracking-[-.02em] tnum">
                      <fmt:formatNumber value="${p.fromPrice}" type="number" groupingUsed="true"/><span class="text-[.62em] align-super ml-0.5">đ</span>
                    </span>
                    <span class="font-mono text-[.68rem] tracking-[.14em] uppercase text-muted">/ Size M</span>
                  </p>

                  <p class="text-sm leading-relaxed text-ink-2 max-w-md mb-6 lg:mb-8">
                    <c:out value="${not empty p.description ? p.description : 'Pha theo đơn, chọn size và chỉnh đường đá theo khẩu vị.'}"/>
                  </p>

                  <div class="flex flex-wrap items-center gap-x-8 gap-y-4">
                    <button type="button"
                            class="btn-add-hero inline-flex items-center gap-2.5 bg-accent text-white font-bold text-[.88rem] tracking-wide uppercase px-8 py-3.5 rounded-full shadow-cta"
                            data-variant-id="${p.variants[0].variantId}">
                      <svg class="w-[17px] h-[17px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M6.5 8h11l1 12.2a2 2 0 0 1-2 2.1H7.5a2 2 0 0 1-2-2.1L6.5 8z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>
                      </svg>
                      Thêm vào giỏ hàng
                    </button>
                    <a href="${ctx}/cart" class="hs-underline text-[.92rem] font-semibold text-dark hover:text-accent transition-colors">
                      Xem giỏ hàng
                    </a>
                  </div>
                </div>

                <!-- ── Cột phải: ly trà đè lên ranh giới sáng/tối ── -->
                <div class="order-1 lg:order-2 flex justify-center lg:justify-start lg:pl-4">
                  <c:choose>
                  <c:when test="${not empty p.imageUrl}">
                    <%-- Ảnh chụp thật. width/height khai báo sẵn để trình duyệt giữ chỗ đúng
                         tỉ lệ ngay từ đầu, tránh nội dung nhảy khi ảnh tải xong (CLS).
                         KHÔNG lazy-load: đây là ảnh lớn nhất trong khung nhìn đầu tiên,
                         hoãn tải sẽ làm chậm chính chỉ số LCP. --%>
                    <img src="${ctx}${p.imageUrl}" alt="${fn:escapeXml(p.name)}"
                         width="600" height="770" decoding="async" fetchpriority="high"
                         class="w-[310px] sm:w-[475px] lg:w-[670px] max-w-none h-auto object-contain rotate-[13deg] -translate-x-[70px] drop-shadow-[0_25px_45px_rgba(0,0,0,0.45)]">
                  </c:when>
                  <c:otherwise>
                  <svg class="w-[220px] sm:w-[340px] lg:w-[480px] h-auto drop-shadow-[0_25px_45px_rgba(0,0,0,0.45)]"
                       viewBox="0 0 300 430" fill="none" xmlns="http://www.w3.org/2000/svg"
                       role="img" aria-label="Ly ${fn:escapeXml(p.name)}">
                    <defs>
                      <linearGradient id="hsTea${s.index}" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%"   stop-color="${teaTop}"/>
                        <stop offset="100%" stop-color="${teaBottom}"/>
                      </linearGradient>
                      <linearGradient id="hsGlass${s.index}" x1="0" y1="0" x2="1" y2="0">
                        <stop offset="0%"   stop-color="#ffffff" stop-opacity=".30"/>
                        <stop offset="45%"  stop-color="#ffffff" stop-opacity=".05"/>
                        <stop offset="100%" stop-color="#ffffff" stop-opacity=".18"/>
                      </linearGradient>
                      <clipPath id="hsClip${s.index}">
                        <path d="M67,146 L100,372 Q102,384 113,384 L187,384 Q198,384 200,372 L233,146 Z"/>
                      </clipPath>
                    </defs>

                    <!-- ống hút -->
                    <path d="M178,112 L216,24" stroke="#A9531A" stroke-width="18" stroke-linecap="round"/>
                    <path d="M178,112 L216,24" stroke="#E8A33D" stroke-width="9"  stroke-linecap="round"/>

                    <g clip-path="url(#hsClip${s.index})">
                      <c:if test="${hasFoam}">
                        <rect x="50" y="138" width="200" height="72" fill="#F8EBDA"/>
                        <path d="M50,206 C86,192 112,222 148,208 C184,193 214,220 250,206 L250,242 L50,242 Z" fill="#F0D8B6"/>
                      </c:if>
                      <rect x="50" y="${hasFoam ? 236 : 138}" width="200" height="200" fill="url(#hsTea${s.index})"/>

                      <c:if test="${hasBoba}">
                        <g fill="#241610">
                          <circle cx="124" cy="358" r="11"/><circle cx="152" cy="351" r="11"/><circle cx="180" cy="358" r="11"/>
                          <circle cx="115" cy="375" r="11"/><circle cx="144" cy="373" r="11"/><circle cx="173" cy="375" r="11"/>
                        </g>
                        <g fill="#5A4030" opacity=".85">
                          <circle cx="120" cy="354" r="3"/><circle cx="148" cy="347" r="3"/><circle cx="176" cy="354" r="3"/>
                        </g>
                      </c:if>
                      <c:if test="${!hasBoba}">
                        <%-- Không topping: viên đá trong ly --%>
                        <g fill="#ffffff" opacity=".30">
                          <rect x="108" y="252" width="34" height="34" rx="7" transform="rotate(-14 125 269)"/>
                          <rect x="152" y="292" width="30" height="30" rx="6" transform="rotate(11 167 307)"/>
                          <rect x="118" y="322" width="28" height="28" rx="6" transform="rotate(22 132 336)"/>
                        </g>
                      </c:if>

                      <path d="M78,140 L106,384 L122,384 L94,140 Z" fill="#ffffff" opacity=".11"/>
                    </g>

                    <path d="M62,140 L96,376 Q98,390 112,390 L188,390 Q202,390 204,376 L238,140 Z" fill="url(#hsGlass${s.index})"/>

                    <path d="M58,124 Q150,78 242,124 Z" fill="#EFE3D4"/>
                    <rect x="50" y="120" width="200" height="26" rx="9" fill="#FBF3E9"/>
                    <rect x="50" y="120" width="200" height="9"  rx="4.5" fill="#ffffff" opacity=".7"/>
                  </svg>
                  </c:otherwise>
                  </c:choose>
                </div>

              </div>
            </div>
          </c:forEach>
        </div>

        <%-- Hàng điều khiển: chấm vị trí + mũi tên (mũi tên ở đây dùng cho màn < xl,
             nơi lề ngoài khung nội dung quá hẹp để đặt mũi tên nổi mà không đè tiêu đề).
             Chỉ hiện khi có từ 2 món trở lên — 1 món thì nút chuyển slide vô nghĩa. --%>
        <c:if test="${fn:length(heroSlides) > 1}">
        <div class="flex items-center gap-5 shrink-0 pt-3 lg:pt-6">
          <div class="flex items-center gap-2" id="hsDots">
            <c:forEach var="p" items="${heroSlides}" varStatus="s">
              <button type="button" class="hs-dot ${s.first ? 'is-on' : ''}" data-go="${s.index}"
                      aria-label="Xem món ${s.count}"></button>
            </c:forEach>
          </div>
          <div class="flex items-center gap-2 2xl:hidden">
            <button type="button" aria-label="Món trước"
                    class="hs-prev hs-arrow-inline grid place-items-center w-10 h-10 rounded-full text-dark">
              <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 5 8 12 15 19"/></svg>
            </button>
            <button type="button" aria-label="Món kế tiếp"
                    class="hs-next hs-arrow-inline grid place-items-center w-10 h-10 rounded-full text-dark">
              <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 5 16 12 9 19"/></svg>
            </button>
          </div>
        </div>
        </c:if>

        </c:otherwise>
      </c:choose>
    </div>

    <%-- Mũi tên nổi hai mép màn hình — chỉ bật từ 2xl (≥1536px). Ở 1280px lề ngoài khung
         nội dung chỉ còn 64px, nút 48px đặt vào đó chỉ cách tiêu đề 2px → quá sát, dễ chạm
         nhau khi đổi font/hiện thanh cuộn. Dưới ngưỡng này dùng mũi tên trong hàng điều khiển. --%>
    <c:if test="${fn:length(heroSlides) > 1}">
      <button type="button" aria-label="Món trước"
              class="hs-prev hs-arrow hidden 2xl:grid place-items-center absolute left-4 top-1/2 -translate-y-1/2 w-12 h-12 rounded-full text-dark z-20">
        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 5 8 12 15 19"/></svg>
      </button>
      <button type="button" aria-label="Món kế tiếp"
              class="hs-next hs-arrow hidden 2xl:grid place-items-center absolute right-4 top-1/2 -translate-y-1/2 w-12 h-12 rounded-full text-dark z-20">
        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 5 16 12 9 19"/></svg>
      </button>
    </c:if>
  </section>

  <!-- ══════════════ SECTION 2 — MÓN TỦ CỦA QUÁN ══════════════
       Bục xếp hạng: món 01 ở giữa, ly to hơn và nhô cao hơn hai bên — số thứ tự ở đây
       mang thông tin thật (thứ hạng quán xếp), không phải số trang trí.
       Danh sách do HomeController chọn, đã LOẠI TRỪ 3 món của khu trình chiếu đầu trang. -->
  <section id="section-2" class="relative overflow-hidden py-24 lg:py-32 bg-shade">
    <div class="relative z-10 max-w-6xl mx-auto px-4 sm:px-6">

      <div class="flex items-center gap-4 mb-7">
        <span class="font-mono text-[.7rem] font-semibold tracking-[.2em] text-muted tnum">02</span>
        <span class="font-mono text-[.62rem] font-semibold tracking-[.16em] uppercase text-accent bg-surface shadow-soft px-4 py-2 rounded-full">
          Món tủ của quán
        </span>
      </div>

      <div class="max-w-2xl mb-14 lg:mb-16">
        <h2 class="st-title text-dark uppercase leading-[1.04] tracking-[.03em] text-[clamp(1.8rem,4vw,2.9rem)] mb-4"
            style="text-wrap:balance;">
          Ba món quán gọi tên đầu tiên
        </h2>
        <p class="text-[.95rem] leading-relaxed text-ink-2">
          Không phải món nào cũng hợp khẩu vị lần đầu. Đây là ba ly quán tự tin đưa ra khi khách
          hỏi “nên uống gì?” — mỗi ly một nhóm vị khác nhau.
        </p>
      </div>

      <c:choose>
        <c:when test="${empty highlightPicks}">
          <p class="text-muted">Thực đơn đang được cập nhật.</p>
        </c:when>
        <c:otherwise>

        <div class="grid sm:grid-cols-3 gap-5 lg:gap-6 items-end">
          <c:forEach var="p" items="${highlightPicks}" varStatus="s">

            <%-- Màu nước theo nhóm món, dùng chung bảng màu với khu trình chiếu --%>
            <c:set var="teaTop"    value="#E9CBA4"/>
            <c:set var="teaBottom" value="#A9611B"/>
            <c:if test="${p.categoryName == 'Trà Trái Cây & Trà Tắc'}">
              <c:set var="teaTop" value="#F7D46B"/><c:set var="teaBottom" value="#DE9226"/>
            </c:if>
            <c:if test="${p.categoryName == 'Soda'}">
              <c:set var="teaTop" value="#8FD3E4"/><c:set var="teaBottom" value="#2F8FA9"/>
            </c:if>
            <c:if test="${p.categoryName == 'Latte'}">
              <c:set var="teaTop" value="#E4C6A2"/><c:set var="teaBottom" value="#8C5A2B"/>
            </c:if>
            <c:if test="${p.categoryName == 'Sữa Chua & Sữa Tươi'}">
              <c:set var="teaTop" value="#F6E7D6"/><c:set var="teaBottom" value="#DFB77C"/>
            </c:if>

            <%-- Hạng 1 (s.first) đứng giữa ở khổ ngang và cao hơn hẳn. Thứ tự trong DOM giữ
                 01→02→03 để trình đọc màn hình và mobile đọc đúng hạng; chỉ hoán vị bằng CSS
                 order ở khổ ≥sm để hạng 1 vào chính giữa bục. --%>
            <c:set var="isTop" value="${s.first}"/>
            <div class="${isTop ? 'sm:order-2' : (s.index == 1 ? 'sm:order-1' : 'sm:order-3')}">
              <div class="group relative bg-surface rounded-[26px] text-center transition-all duration-300
                          hover:-translate-y-1.5 hover:shadow-[0_26px_52px_-24px_rgba(7,30,7,.3)]
                          ${isTop ? 'shadow-card px-6 pt-9 pb-7' : 'shadow-soft px-5 pt-6 pb-6'}">

                <span class="absolute top-4 left-4 font-mono text-[.62rem] font-semibold tracking-[.12em] tnum
                             ${isTop ? 'text-accent' : 'text-muted'}">0${s.count}</span>

                <c:if test="${isTop}">
                  <span class="absolute top-4 right-4 font-mono text-[.54rem] font-semibold tracking-[.14em] uppercase
                               text-white bg-accent px-2.5 py-1 rounded-full">Quán chọn</span>
                </c:if>

                <%-- Ly rút gọn: phẳng, ít chi tiết hơn ly ở khu trình chiếu để hai khu không
                     bị nhìn như nhau, dù cùng ngôn ngữ hình. --%>
                <svg class="mx-auto h-auto ${isTop ? 'w-[104px]' : 'w-[82px]'}"
                     viewBox="0 0 120 168" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                  <defs>
                    <linearGradient id="hlTea${s.index}" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="0%"   stop-color="${teaTop}"/>
                      <stop offset="100%" stop-color="${teaBottom}"/>
                    </linearGradient>
                  </defs>
                  <path d="M74,40 L88,12" stroke="#A9531A" stroke-width="8" stroke-linecap="round"/>
                  <path d="M23,50 L31,146 Q32,156 42,156 L78,156 Q88,156 89,146 L97,50 Z" fill="url(#hlTea${s.index})"/>
                  <path d="M29,52 L36,148 L44,148 L37,52 Z" fill="#ffffff" opacity=".16"/>
                  <rect x="16" y="38" width="88" height="15" rx="6.5" fill="#FBF3E9"/>
                  <rect x="16" y="38" width="88" height="6"  rx="3"   fill="#ffffff" opacity=".75"/>
                </svg>

                <p class="font-mono text-[.56rem] font-medium tracking-[.14em] uppercase text-muted mt-5 mb-2">
                  <c:out value="${p.categoryName}"/>
                </p>

                <h3 class="text-ink font-extrabold tracking-[-.02em] leading-snug mb-2.5 ${isTop ? 'text-[1.15rem]' : 'text-[1rem]'}">
                  <c:out value="${p.name}"/>
                </h3>

                <p class="flex items-baseline justify-center gap-1.5 mb-5">
                  <span class="text-ink font-extrabold tnum ${isTop ? 'text-[1.6rem]' : 'text-[1.35rem]'}">
                    <fmt:formatNumber value="${p.fromPrice}" type="number" groupingUsed="true"/><span class="text-[.62em] align-super">đ</span>
                  </span>
                  <span class="font-mono text-[.58rem] tracking-[.12em] uppercase text-muted">/ Size M</span>
                </p>

                <button type="button"
                        class="btn-add-hl w-full inline-flex items-center justify-center gap-2 rounded-full font-semibold
                               transition-all duration-200 hover:-translate-y-0.5
                               ${isTop ? 'bg-accent text-white shadow-cta hover:bg-accent-deep text-[.86rem] py-3.5'
                                       : 'bg-shade text-ink hover:bg-mist text-[.82rem] py-3'}"
                        data-variant-id="${p.variants[0].variantId}">
                  <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M6.5 8h11l1 12.2a2 2 0 0 1-2 2.1H7.5a2 2 0 0 1-2-2.1L6.5 8z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>
                  </svg>
                  Thêm vào giỏ
                </button>
              </div>
            </div>
          </c:forEach>
        </div>

        <div class="text-center mt-10">
          <a href="${ctx}/san-pham" class="hs-underline inline-flex items-center gap-2 text-[.92rem] font-semibold text-ink hover:text-accent transition-colors">
            Xem toàn bộ thực đơn
            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 5 16 12 9 19"/></svg>
          </a>
        </div>

        </c:otherwise>
      </c:choose>

      <%-- Dải đánh giá — chỉ hiện khi thật sự có feedback đã duyệt (Status=RESOLVED, có
           Rating). Chưa có dữ liệu thì ẩn hẳn, không hiện khung rỗng hay số 0.0. --%>
      <c:if test="${not empty feedbackQuotes}">
        <div class="grid lg:grid-cols-[auto,1fr] gap-8 lg:gap-12 items-center bg-surface shadow-soft rounded-[26px] px-6 sm:px-9 py-8 lg:py-9 mt-14 lg:mt-16">

          <div class="text-center lg:text-left lg:pr-10">
            <p class="flex items-baseline justify-center lg:justify-start gap-1.5 mb-1.5">
              <span class="text-ink font-extrabold text-[2.6rem] leading-none tracking-[-.03em] tnum">${feedbackAvg}</span>
              <span class="font-mono text-[.7rem] text-muted">/ 5</span>
            </p>
            <div class="flex justify-center lg:justify-start gap-0.5 mb-2" aria-hidden="true">
              <c:forEach begin="1" end="5" var="i">
                <svg class="w-4 h-4 ${i <= feedbackStars ? 'text-accent' : 'text-[#DDE5D2]'}" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 2.6l2.9 5.9 6.5.9-4.7 4.6 1.1 6.5-5.8-3-5.8 3 1.1-6.5L2.6 9.4l6.5-.9L12 2.6z"/>
                </svg>
              </c:forEach>
            </div>
            <p class="font-mono text-[.62rem] tracking-[.12em] uppercase text-muted tnum">
              ${feedbackCount} đánh giá đã duyệt
            </p>
          </div>

          <div class="grid sm:grid-cols-3 gap-6">
            <c:forEach var="fb" items="${feedbackQuotes}">
              <figure class="m-0">
                <div class="flex gap-0.5 mb-2.5" aria-label="${fb.rating} trên 5 sao">
                  <c:forEach begin="1" end="5" var="i">
                    <svg class="w-3 h-3 ${i <= fb.rating ? 'text-accent' : 'text-[#DDE5D2]'}" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                      <path d="M12 2.6l2.9 5.9 6.5.9-4.7 4.6 1.1 6.5-5.8-3-5.8 3 1.1-6.5L2.6 9.4l6.5-.9L12 2.6z"/>
                    </svg>
                  </c:forEach>
                </div>
                <blockquote class="m-0 text-[.86rem] leading-relaxed text-ink-2 mb-2">
                  “<c:out value="${fb.message}"/>”
                </blockquote>
                <figcaption class="font-mono text-[.6rem] tracking-[.1em] uppercase text-muted">
                  <c:out value="${fb.name}"/>
                </figcaption>
              </figure>
            </c:forEach>
          </div>
        </div>
      </c:if>

    </div>
  </section>

  <!-- ══════════════ SECTION 3 — CÂU CHUYỆN EIGHT TEA ══════════════
       Tone kem sáng, hai khối xếp so le (Z-pattern): khối 01 chữ trái / ảnh phải,
       khối 02 đảo lại. Visual khối 02 đặt trên nền nâu đen — vừa tạo nhịp tương
       phản, vừa "bắc cầu" sang khối bảng thông số nền tối ngay bên dưới. -->
  <section id="section-3" class="relative overflow-hidden py-24 lg:py-32 bg-canvas">

    <%-- Nền toả mềm, cùng thủ pháp với hero để hai section liền mạch --%>
    <div class="absolute inset-0 pointer-events-none" aria-hidden="true"
         style="background:
           radial-gradient(560px circle at 92% 8%, var(--et-surface-muted) 0%, transparent 62%),
           radial-gradient(460px circle at 4% 82%, var(--et-surface-muted) 0%, transparent 64%);"></div>

    <div class="relative z-10 max-w-6xl mx-auto px-4 sm:px-6">

      <%-- Nhãn mở khối --%>
      <div class="flex items-center gap-4 mb-14 lg:mb-20">
        <span class="font-mono text-[.7rem] font-semibold tracking-[.2em] text-muted tnum">03</span>
        <span class="font-mono text-[.62rem] font-semibold tracking-[.16em] uppercase text-accent bg-surface shadow-soft px-4 py-2 rounded-full">
          Câu chuyện Eight Tea
        </span>
      </div>

      <!-- ── KHỐI 01 — ĐẬM VỊ TRÀ ── -->
      <div class="grid lg:grid-cols-2 gap-10 lg:gap-16 items-center">

        <div class="relative order-2 lg:order-1">
          <%-- Số chìm: nằm sau chữ, chỉ làm mốc thị giác --%>
          <span class="st-ghost absolute -top-10 -left-3 text-[7rem] lg:text-[10rem] font-bold pointer-events-none select-none z-0"
                aria-hidden="true">01</span>

          <div class="relative z-10">
            <p class="font-mono text-[.64rem] font-semibold tracking-[.18em] uppercase text-accent bg-surface shadow-soft inline-block px-4 py-2 rounded-full mb-6">
              Storytelling 01 · Nguyên bản
            </p>

            <h3 class="st-title text-dark uppercase leading-[1.02] tracking-[.03em] text-[clamp(1.9rem,4.2vw,3.1rem)] mb-5"
                style="text-wrap:balance;">
              100% Trà Lài — Đậm Vị Từ Lần Nhấp Đầu Tiên
            </h3>

            <p class="text-[.95rem] leading-relaxed text-ink-2 max-w-xl mb-9">
              Eight Tea chỉ <strong class="font-bold text-ink">CÓ</strong> một nguyên tắc duy nhất: cốt trà
              nguyên bản, tuyệt đối không si-rô công nghiệp hay hương liệu tạo mùi giả. Chúng tớ chọn những búp
              trà Ô Long nướng được thu hái thủ công tại cao nguyên Cầu Đất, ủ chuẩn nhiệt độ 92°C trong đúng
              12 phút. Kết quả là cốt trà đậm đà, chát nhẹ tinh tế và đọng lại hậu vị ngọt thanh tự nhiên.
            </p>

            <ul class="grid sm:grid-cols-3 gap-7 sm:gap-6 max-w-xl">
              <li>
                <p class="font-mono text-[.78rem] font-semibold tracking-[.1em] uppercase text-accent mb-1.5 tnum">92°C</p>
                <p class="text-[.82rem] leading-relaxed text-ink-2">Nhiệt độ chiết xuất chuẩn xác để không làm cháy lá trà.</p>
              </li>
              <li>
                <p class="font-mono text-[.78rem] font-semibold tracking-[.1em] uppercase text-accent mb-1.5">0% Chemical</p>
                <p class="text-[.82rem] leading-relaxed text-ink-2">Không chất bảo quản, không phụ gia độc hại.</p>
              </li>
              <li>
                <p class="font-mono text-[.78rem] font-semibold tracking-[.1em] uppercase text-accent mb-1.5">Fresh Brewed</p>
                <p class="text-[.82rem] leading-relaxed text-ink-2">Ủ mới theo từng mẻ nhỏ, dùng tối đa trong 4 giờ.</p>
              </li>
            </ul>
          </div>
        </div>

        <div class="order-1 lg:order-2 flex justify-center">
          <div class="st-arch shadow-card w-full max-w-[380px] aspect-[4/5] bg-shade">
            <img src="${ctx}/images/story.jpg" alt="Ly trà trái cây Eight Tea pha theo đơn, bày cùng trái cây tươi"
                 loading="lazy" decoding="async"
                 class="w-full h-full object-cover">
          </div>
        </div>
      </div>

      <!-- ── KHỐI 02 — NHANH TẬN NHÀ ── -->
      <div class="grid lg:grid-cols-2 gap-10 lg:gap-16 items-center mt-24 lg:mt-32">

        <%-- Ảnh bên trái ở khổ lớn (đảo so với khối 01), nhưng trên mobile vẫn
             đứng trước chữ để nhịp đọc mỗi khối giống nhau. --%>
        <div class="order-1 flex justify-center">
          <div class="st-arch shadow-card w-full max-w-[380px] aspect-[4/5] bg-dark grid place-items-center overflow-hidden">
            <img src="${ctx}/images/story-delivery.jpg" alt="Ly trà Eight Tea đang được giao nhanh"
                 loading="lazy" decoding="async" class="w-full h-full object-cover">
          </div>
        </div>

        <div class="relative order-2">
          <span class="st-ghost absolute -top-10 -left-3 text-[7rem] lg:text-[10rem] font-bold pointer-events-none select-none z-0"
                aria-hidden="true">02</span>

          <div class="relative z-10">
            <p class="font-mono text-[.64rem] font-semibold tracking-[.18em] uppercase text-accent bg-surface shadow-soft inline-block px-4 py-2 rounded-full mb-6">
              Storytelling 02 · Mô hình D2C
            </p>

            <h3 class="st-title text-dark uppercase leading-[1.02] tracking-[.03em] text-[clamp(1.9rem,4.2vw,3.1rem)] mb-5"
                style="text-wrap:balance;">
              Giao Hàng Trực Tiếp — Giá Chuẩn Sinh Viên, Phí App
            </h3>

            <p class="text-[.95rem] leading-relaxed text-ink-2 max-w-xl mb-9">
              Thay vì cắt chiết khấu 20% – 30% cho các ứng dụng giao đồ ăn trung gian, Eight Tea tự vận hành
              đội ngũ giao hàng D2C nội bộ. Toàn bộ chi phí tiết kiệm được, chúng tớ dành để nâng cấp chất
              lượng cốt trà và bán với mức giá cực kỳ dễ chịu (15k – 30k) cho các bạn học sinh, sinh viên
              tại khu vực Bà Rịa.
            </p>

            <ul class="grid sm:grid-cols-3 gap-7 sm:gap-6 max-w-xl">
              <li>
                <p class="font-mono text-[.78rem] font-semibold tracking-[.1em] uppercase text-accent mb-1.5 tnum">20–30 Phút</p>
                <p class="text-[.82rem] leading-relaxed text-ink-2">Tốc độ giao hàng siêu tốc trong bán kính 7–10km.</p>
              </li>
              <li>
                <p class="font-mono text-[.78rem] font-semibold tracking-[.1em] uppercase text-accent mb-1.5">Leak-Proof</p>
                <p class="text-[.82rem] leading-relaxed text-ink-2">Xài nắp ly chống tràn 100% an toàn khi di chuyển.</p>
              </li>
              <li>
                <p class="font-mono text-[.78rem] font-semibold tracking-[.1em] uppercase text-accent mb-1.5">Direct Support</p>
                <p class="text-[.82rem] leading-relaxed text-ink-2">Đặt hàng &amp; chăm sóc trực tiếp qua Messenger / Website.</p>
              </li>
            </ul>
          </div>
        </div>
      </div>

    </div>
  </section>

  <!-- ══════════════ SECTION 4 — EIGHT TEA TRÊN MẠNG XÃ HỘI ══════════════
       Ảnh chụp bài đăng & phản hồi thật từ trang Facebook của quán. Đây là bằng chứng
       xã hội (social proof) có thật, không phải ảnh minh hoạ — nên để nguyên dạng
       ảnh chụp màn hình thay vì cắt ghép lại thành testimonial giả. -->
  <section id="section-4" class="relative overflow-hidden py-24 lg:py-32 bg-shade">

    <div class="relative z-10 max-w-6xl mx-auto px-4 sm:px-6">

      <div class="flex items-center gap-4 mb-8">
        <span class="font-mono text-[.7rem] font-semibold tracking-[.2em] text-muted tnum">04</span>
        <span class="font-mono text-[.62rem] font-semibold tracking-[.16em] uppercase text-accent bg-surface shadow-soft px-4 py-2 rounded-full">
          Khách hàng nói gì
        </span>
      </div>

      <h3 class="st-title text-dark uppercase leading-[1.02] tracking-[.03em] text-[clamp(1.9rem,4.2vw,3.1rem)] mb-5 max-w-3xl"
          style="text-wrap:balance;">
        Những Ngày Đầu Tiên Của Một Quán Nhỏ
      </h3>

      <p class="text-[.95rem] leading-relaxed text-ink-2 max-w-2xl mb-14">
        Ảnh chụp trực tiếp từ trang Facebook Eight Tea — feedback thật của khách,
        những buổi pha chế đầu tiên và tấm menu mới nhất của quán.
      </p>

      <%-- Cột masonry: ảnh cao thấp khác nhau nên xếp theo cột để không bị khoảng trắng lệch.
           Toàn bộ lazy-load + khai báo sẵn width/height → không nhảy layout khi tải. --%>
      <div class="columns-1 sm:columns-2 lg:columns-3 gap-5 [column-fill:_balance]">
        <%-- fn:split thay vì list literal EL 3.0: chạy được trên mọi phiên bản JSTL --%>
        <c:forEach var="seo" items="${fn:split('2,1,3,5,4,6', ',')}">
          <a href="https://www.facebook.com/share/1BZV5Ap9xB/?mibextid=wwXIfr" target="_blank" rel="noopener"
             class="group block mb-5 break-inside-avoid rounded-[20px] overflow-hidden bg-surface shadow-soft hover:shadow-card transition no-underline">
            <img src="${ctx}/images/story/seo-${seo}.jpg"
                 alt="Bài đăng và phản hồi khách hàng trên Facebook Eight Tea"
                 loading="lazy" decoding="async" width="880" height="900"
                 class="w-full h-auto block group-hover:scale-[1.02] transition duration-500">
          </a>
        </c:forEach>
      </div>

      <div class="mt-10 flex justify-center">
        <a href="https://www.facebook.com/share/1BZV5Ap9xB/?mibextid=wwXIfr" target="_blank" rel="noopener"
           class="inline-flex items-center gap-2.5 bg-accent text-white font-bold text-[.88rem] tracking-wide uppercase px-8 py-3.5 rounded-full shadow-cta hover:brightness-110 transition no-underline">
          <i class="fa-brands fa-facebook-f text-[15px]"></i>
          Xem thêm trên Facebook
        </a>
      </div>

    </div>
  </section>

  <!-- ═══════════════ FOOTER — bỏ khung thẻ tối bo góc nổi, giữ nội dung footer ═══════════════ -->
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

          <%-- Địa chỉ + hotline: tín hiệu "quán local có thật" cho mô hình D2C.
               Để chìm (cỡ nhỏ, màu mờ) nên không tranh chấp với logo bên trái. --%>
          <div class="text-center sm:text-right">
            <p class="flex items-center justify-center sm:justify-end gap-1.5 text-[.72rem] leading-relaxed text-[rgba(255,255,255,.74)] m-0 mb-1.5">
              <%-- Trên nền tối phải dùng sắc Reseda sáng hơn; --et-primary đặt trên
                   --et-dark gần như không đọc được. --%>
              <svg class="w-3 h-3 shrink-0 text-[#6E8649]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z"/><circle cx="12" cy="10" r="3"/>
              </svg>
              123 Nguyễn Đình Chiểu
            </p>
            <p class="font-mono text-[.62rem] tracking-[.08em] text-[rgba(255,255,255,.55)] m-0">
              <a href="tel:0364523553" class="text-[rgba(255,255,255,.74)] hover:text-white transition no-underline">0938 299 752</a>
              <span class="mx-1.5 text-[rgba(255,255,255,.28)]">·</span>
              © 2026 Eight Tea
            </p>
          </div>
        </div>
      </div>
    </div>
  </footer>

</div><!-- /.hp-scope -->

    <div class="toast-stack" id="toastStack" aria-live="polite"></div>
    <script src="${ctx}/js/cart.js?v=${initParam.assetVer}"></script>
    <script>
    (function () {
      'use strict';

      var navbar = document.getElementById('navbar');
      if (navbar) {
        window.addEventListener('scroll', function () {
          navbar.classList.toggle('scrolled', window.scrollY > 40);
        });
        navbar.classList.add('scrolled');
      }

      /* ── Trình chiếu món nổi bật ─────────────────────────────────────────
         Cố tình KHÔNG tự động chạy: mỗi slide có nút "Thêm vào giỏ hàng", slide
         tự đổi ngay dưới ngón tay sẽ khiến khách bấm nhầm món. Chỉ chuyển khi
         người dùng chủ động bấm mũi tên / chấm / phím mũi tên. */
      var slides = [].slice.call(document.querySelectorAll('.hs-slide'));
      var dots   = [].slice.call(document.querySelectorAll('.hs-dot'));
      var idx = 0;

      /** dir > 0: vào từ phải (kế tiếp) · dir < 0: vào từ trái (trước) */
      function go(target, dir) {
        if (!slides.length) return;
        var next = (target + slides.length) % slides.length;
        if (next === idx) return;
        if (typeof dir !== 'number') dir = next > idx ? 1 : -1;
        idx = next;

        slides.forEach(function (s, i) {
          s.classList.remove('is-on', 'enter-l', 'enter-r');
          if (i === idx) s.classList.add('is-on', dir < 0 ? 'enter-l' : 'enter-r');
        });
        dots.forEach(function (d, i) { d.classList.toggle('is-on', i === idx); });
      }
      window.hsGo = go; // dùng cho kiểm thử tự động

      // Có 2 bộ mũi tên (nổi ở mép cho màn rộng, nằm trong hàng điều khiển cho màn hẹp)
      // nên bắt theo class thay vì id — chỉ một bộ hiển thị tại mỗi khổ màn hình.
      document.querySelectorAll('.hs-prev').forEach(function (b) {
        b.addEventListener('click', function () { go(idx - 1, -1); });
      });
      document.querySelectorAll('.hs-next').forEach(function (b) {
        b.addEventListener('click', function () { go(idx + 1, 1); });
      });
      dots.forEach(function (d) {
        d.addEventListener('click', function () {
          var t = parseInt(d.dataset.go, 10);
          go(t, t > idx ? 1 : -1);
        });
      });

      document.addEventListener('keydown', function (e) {
        if (e.target.matches('input, textarea')) return;
        if (e.key === 'ArrowLeft')  go(idx - 1, -1);
        if (e.key === 'ArrowRight') go(idx + 1,  1);
      });

      /* ── Quầng sáng bám con trỏ ──────────────────────────────────────────
         Gom toạ độ trong mousemove, chỉ ghi vào CSS var một lần mỗi khung hình
         (rAF) để không ép trình duyệt tính lại layout liên tục. */
      var hero = document.getElementById('section-1');
      var glow = document.getElementById('hsGlow');
      if (hero && glow) {
        var gx = 0, gy = 0, queued = false;
        function flushGlow() {
          queued = false;
          glow.style.setProperty('--x', gx + 'px');
          glow.style.setProperty('--y', gy + 'px');
        }
        hero.addEventListener('mousemove', function (e) {
          var r = hero.getBoundingClientRect();
          gx = e.clientX - r.left;
          gy = e.clientY - r.top;
          if (!queued) { queued = true; requestAnimationFrame(flushGlow); }
        }, { passive: true });
      }

      /* ── Gợn sóng khi bấm + thêm vào giỏ (VariantID thật của size M) ────── */
      document.querySelectorAll('.btn-add-hero').forEach(function (btn) {
        btn.addEventListener('click', function (e) {
          var r = btn.getBoundingClientRect();
          var size = Math.max(r.width, r.height);
          var ripple = document.createElement('span');
          ripple.className = 'hs-ripple';
          ripple.style.width = ripple.style.height = size + 'px';
          ripple.style.left = (e.clientX - r.left - size / 2) + 'px';
          ripple.style.top  = (e.clientY - r.top  - size / 2) + 'px';
          btn.appendChild(ripple);
          setTimeout(function () { ripple.remove(); }, 600);

          NhietDoiXanhCart.addToCart(btn.dataset.variantId, 1, btn);
        });
      });

      /* Nút thêm giỏ ở khu "Món tủ của quán" — không gắn gợn sóng như nút hero vì thẻ ở
         đây không bo overflow, vệt sóng sẽ tràn ra ngoài mép thẻ. */
      document.querySelectorAll('.btn-add-hl').forEach(function (btn) {
        btn.addEventListener('click', function () {
          NhietDoiXanhCart.addToCart(btn.dataset.variantId, 1, btn);
        });
      });
    })();
    </script>
</body>
</html>
