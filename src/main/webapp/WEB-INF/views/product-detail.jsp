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
    <title><c:out value="${not empty product ? product.name : 'Không tìm thấy món'}"/> — Eight Tea</title>
    <meta name="description" content="<c:out value="${not empty product.description ? product.description : 'Eight Tea — pha theo đơn, giao 20–30 phút tại TP. Bà Rịa.'}"/>">
    <meta name="csrf-token" content="${sessionScope._csrf}">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="${ctx}/css/style.css?v=${initParam.assetVer}">
    <link rel="stylesheet" href="${ctx}/css/product.css?v=${initParam.assetVer}">
    <%-- Nạp SAU cùng: design system Eight Tea ghi đè da cũ (kèm @import font) --%>
    <link rel="stylesheet" href="${ctx}/css/eighttea.css?v=${initParam.assetVer}">

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
    // preflight:false — BẮT BUỘC, giống các trang còn lại. Bật preflight sẽ reset sạch
    // style.css/product.css/eighttea.css và làm vỡ navbar dùng chung.
    tailwind.config = {
      corePlugins: { preflight: false },
      theme: { extend: {
        colors: {
          canvas:'#FAF6F0', surface:'#FFFFFF', accent:'#D2691E', 'accent-deep':'#A9531A',
          dark:'#120E0C', 'dark-2':'#1C1614', ink:'#2B2625', 'ink-2':'#6B615C',
          muted:'#9C918B', mist:'#EFE7DC'
        },
        fontFamily: {
          sans:['Plus Jakarta Sans','system-ui','sans-serif'],
          mono:['IBM Plex Mono','ui-monospace','monospace']
        },
        boxShadow: {
          soft:'0 1px 2px rgba(43,38,37,.04), 0 4px 14px rgba(43,38,37,.04)',
          card:'0 2px 4px rgba(43,38,37,.03), 0 14px 34px -12px rgba(43,38,37,.14)',
          float:'0 6px 12px rgba(43,38,37,.04), 0 34px 68px -24px rgba(43,38,37,.26)',
          cta:'0 10px 24px -8px rgba(210,105,30,.55)'
        }
      }}
    }
    </script>

    <style>
      html { scroll-behavior: smooth; }

      /* Navbar đặc ngay khung hình đầu — trang này không có hero tối nhưng vẫn giữ
         cùng hành vi với các trang khác để thanh điều hướng không "nhấp nháy" khi chuyển trang. */
      body.pd-body #navbar {
        background:#FAF6F0 !important; backdrop-filter:none !important; -webkit-backdrop-filter:none !important;
        padding:13px 0 !important;
        box-shadow:0 1px 0 rgba(43,38,37,.07), 0 16px 32px -22px rgba(43,38,37,.22);
      }

      /* Ràng buộc borderless của design system — giới hạn trong khu nội dung để không đụng navbar chung */
      .pd *, .pd *::before, .pd *::after { border: 0 !important; }
      .pd .tnum { font-variant-numeric: tabular-nums; }
      .pd a:focus-visible, .pd button:focus-visible, .pd input:focus-visible, .pd textarea:focus-visible {
        box-shadow:0 0 0 3px rgba(210,105,30,.45); outline:none;
      }

      /* Khung vòm — cùng ngôn ngữ hình với khu kể chuyện ở trang chủ */
      .pd .pd-arch { border-radius: 999px 999px 32px 32px; overflow: hidden; }

      /* Pill lựa chọn (Size / Đường / Đá): input thật bị ẩn để vẫn dùng được bàn phím
         và trình đọc màn hình, phần nhìn do span đảm nhiệm. */
      .pd .pd-opt { position:relative; display:inline-flex; }
      .pd .pd-opt input { position:absolute; inset:0; opacity:0; width:100%; height:100%; margin:0; cursor:pointer; }
      .pd .pd-opt span {
        display:inline-flex; align-items:center; gap:7px; background:#FAF6F0; color:#6B615C;
        font-size:.85rem; font-weight:500; padding:11px 18px; border-radius:999px;
        transition: background-color .2s ease, color .2s ease, box-shadow .2s ease;
      }
      .pd .pd-opt:hover span { background:#EFE7DC; }
      .pd .pd-opt input:checked ~ span {
        background:#D2691E; color:#fff; box-shadow:0 10px 24px -8px rgba(210,105,30,.55);
      }
      .pd .pd-opt input:focus-visible ~ span { box-shadow:0 0 0 3px rgba(210,105,30,.45); }

      /* Hàng topping */
      .pd .pd-top { position:relative; display:block; cursor:pointer; }
      .pd .pd-top input { position:absolute; opacity:0; width:1px; height:1px; }
      .pd .pd-top-wrap {
        display:flex; align-items:center; gap:12px; background:#FAF6F0;
        border-radius:16px; padding:12px 15px; transition:background-color .2s ease;
      }
      .pd .pd-top:hover .pd-top-wrap { background:#EFE7DC; }
      .pd .pd-top-box {
        flex:none; width:20px; height:20px; border-radius:7px; background:#fff;
        box-shadow:0 1px 2px rgba(43,38,37,.05);
        display:grid; place-items:center; color:#fff; transition:background-color .2s ease;
      }
      .pd .pd-top-tick { width:12px; height:12px; opacity:0; transition:opacity .2s ease; }
      .pd .pd-top input:checked ~ .pd-top-wrap .pd-top-box { background:#D2691E; }
      .pd .pd-top input:checked ~ .pd-top-wrap .pd-top-tick { opacity:1; }

      /* Ly xem trước: đổi kích thước mềm khi chọn size, các lớp đá/trân châu hiện dần */
      .pd #pdCupWrap { transition: transform .45s cubic-bezier(.22,1,.36,1); }
      .pd .pd-layer { transition: opacity .35s ease; }

      /* Ô ghi chú — eighttea.css đặt background !important cho textarea nên khai báo lại tường minh */
      .pd #pdNote {
        background:#FAF6F0 !important; border-radius:16px !important;
        padding:12px 15px !important; font-size:.88rem; resize:none;
      }

      @media (prefers-reduced-motion: reduce) {
        html { scroll-behavior:auto; }
        .pd *, .pd #pdCupWrap { transition-duration:.01ms !important; animation-duration:.01ms !important; }
      }
    </style>
</head>

<body class="pd-body bg-canvas font-sans text-ink-2">

    <c:set var="cartCount" value="${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}" />
    <%@ include file="/WEB-INF/views/common/customer-header.jsp" %>

<div class="pd">

<c:choose>
  <%-- ══════════ KHÔNG TÌM THẤY MÓN ══════════ --%>
  <c:when test="${empty product}">
    <section class="pt-32 pb-24">
      <div class="max-w-xl mx-auto px-4 sm:px-6">
        <div class="bg-surface rounded-[26px] shadow-card p-12 text-center">
          <svg class="w-11 h-11 text-muted mx-auto mb-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
            <path d="M6 3h12l-1.3 15.6a2 2 0 0 1-2 1.9H9.3a2 2 0 0 1-2-1.9L6 3z"/><line x1="6.6" y1="9" x2="17.4" y2="9"/>
          </svg>
          <h1 class="text-ink font-extrabold text-[1.3rem] tracking-[-.02em] mb-2">
            <c:out value="${not empty errorMessage ? errorMessage : 'Món này không còn trên thực đơn.'}"/>
          </h1>
          <p class="text-sm text-ink-2 mb-7">Có thể món đã ngừng bán hoặc đường dẫn không còn đúng.</p>
          <a href="${ctx}/san-pham"
             class="inline-flex items-center gap-2.5 bg-accent text-white font-semibold text-[.9rem] px-7 py-3.5 rounded-full shadow-cta hover:bg-accent-deep hover:-translate-y-0.5 transition no-underline">
            Xem toàn bộ thực đơn
          </a>
        </div>
      </div>
    </section>
  </c:when>

  <%-- ══════════ TRANG CHI TIẾT ══════════ --%>
  <c:otherwise>

  <%-- Bảng màu nước theo nhóm món — dùng chung với khu trình chiếu & "món tủ" ở trang chủ --%>
  <c:set var="teaTop"    value="#E9CBA4"/>
  <c:set var="teaBottom" value="#A9611B"/>
  <c:set var="hasFoam"   value="${true}"/>
  <c:if test="${product.categoryName == 'Trà Trái Cây & Trà Tắc'}">
    <c:set var="teaTop" value="#F7D46B"/><c:set var="teaBottom" value="#DE9226"/><c:set var="hasFoam" value="${false}"/>
  </c:if>
  <c:if test="${product.categoryName == 'Soda'}">
    <c:set var="teaTop" value="#8FD3E4"/><c:set var="teaBottom" value="#2F8FA9"/><c:set var="hasFoam" value="${false}"/>
  </c:if>
  <c:if test="${product.categoryName == 'Latte'}">
    <c:set var="teaTop" value="#E4C6A2"/><c:set var="teaBottom" value="#8C5A2B"/>
  </c:if>
  <c:if test="${product.categoryName == 'Sữa Chua & Sữa Tươi'}">
    <c:set var="teaTop" value="#F6E7D6"/><c:set var="teaBottom" value="#DFB77C"/>
  </c:if>

  <section class="pt-28 sm:pt-32 pb-16">
    <div class="max-w-6xl mx-auto px-4 sm:px-6">

      <%-- Đường dẫn phân cấp: cho khách biết đang đứng ở đâu và lùi lại được từng bậc --%>
      <nav aria-label="Đường dẫn" class="flex flex-wrap items-center gap-2 font-mono text-[.62rem] tracking-[.1em] uppercase text-muted mb-9">
        <a href="${ctx}/" class="hover:text-accent transition no-underline text-muted">Trang chủ</a>
        <span aria-hidden="true">/</span>
        <a href="${ctx}/san-pham" class="hover:text-accent transition no-underline text-muted">Thực đơn</a>
        <c:if test="${not empty product.categoryName}">
          <span aria-hidden="true">/</span>
          <a href="${ctx}/san-pham?danhmuc=${product.categoryId}" class="hover:text-accent transition no-underline text-muted">
            <c:out value="${product.categoryName}"/>
          </a>
        </c:if>
        <span aria-hidden="true">/</span>
        <span class="text-ink" aria-current="page"><c:out value="${product.name}"/></span>
      </nav>

      <div class="grid lg:grid-cols-2 gap-10 lg:gap-16 items-start">

        <!-- ══ CỘT TRÁI: ly xem trước, đổi theo lựa chọn ══ -->
        <div class="lg:sticky lg:top-24">
          <div class="pd-arch bg-shade shadow-card relative grid place-items-center py-10"
               style="background:linear-gradient(170deg,#FFFFFF 0%,#EFEAE2 100%);">

            <span class="absolute top-5 left-5 font-mono text-[.55rem] font-semibold tracking-[.12em] uppercase text-accent bg-white/90 px-3 py-1.5 rounded-full">
              Xem trước
            </span>

            <div id="pdCupWrap" class="w-[210px] sm:w-[248px]">
              <svg viewBox="0 0 300 470" fill="none" xmlns="http://www.w3.org/2000/svg"
                   role="img" aria-label="Hình minh hoạ ly ${fn:escapeXml(product.name)}">
                <defs>
                  <linearGradient id="pdTea" x1="0" y1="0" x2="0" y2="1">
                    <stop id="pdTeaTop"    offset="0%"   stop-color="${teaTop}"/>
                    <stop id="pdTeaBottom" offset="100%" stop-color="${teaBottom}"/>
                  </linearGradient>
                  <linearGradient id="pdGlass" x1="0" y1="0" x2="1" y2="0">
                    <stop offset="0%"   stop-color="#ffffff" stop-opacity=".32"/>
                    <stop offset="45%"  stop-color="#ffffff" stop-opacity=".05"/>
                    <stop offset="100%" stop-color="#ffffff" stop-opacity=".20"/>
                  </linearGradient>
                  <clipPath id="pdClip">
                    <path d="M67,146 L100,372 Q102,384 113,384 L187,384 Q198,384 200,372 L233,146 Z"/>
                  </clipPath>
                </defs>

                <%-- Khói: chỉ hiện khi chọn "Nóng / Ít đá" --%>
                <g id="pdSteam" class="pd-layer" opacity="0">
                  <path d="M120,96 C108,78 132,68 120,48" stroke="#C9BCAF" stroke-width="5" stroke-linecap="round"/>
                  <path d="M152,92 C140,72 164,62 152,40" stroke="#C9BCAF" stroke-width="5" stroke-linecap="round"/>
                  <path d="M184,96 C172,78 196,68 184,48" stroke="#C9BCAF" stroke-width="5" stroke-linecap="round"/>
                </g>

                <%-- Ống hút --%>
                <path d="M178,112 L216,24" stroke="#A9531A" stroke-width="18" stroke-linecap="round"/>
                <path d="M178,112 L216,24" stroke="#E8A33D" stroke-width="9"  stroke-linecap="round"/>

                <g clip-path="url(#pdClip)">
                  <c:if test="${hasFoam}">
                    <rect x="50" y="138" width="200" height="70" fill="#F8EBDA"/>
                    <path d="M50,204 C86,190 112,220 148,206 C184,191 214,218 250,204 L250,240 L50,240 Z" fill="#F0D8B6"/>
                  </c:if>
                  <rect id="pdLiquid" x="50" y="${hasFoam ? 234 : 138}" width="200" height="240" fill="url(#pdTea)"/>

                  <%-- Đá: số viên hiện theo mức đá đã chọn --%>
                  <g id="pdIce" class="pd-layer" fill="#ffffff" opacity=".34">
                    <rect class="pd-ice-cube" x="106" y="250" width="34" height="34" rx="7" transform="rotate(-14 123 267)"/>
                    <rect class="pd-ice-cube" x="152" y="288" width="30" height="30" rx="6" transform="rotate(11 167 303)"/>
                    <rect class="pd-ice-cube" x="112" y="318" width="28" height="28" rx="6" transform="rotate(22 126 332)"/>
                    <rect class="pd-ice-cube" x="160" y="240" width="26" height="26" rx="6" transform="rotate(-8 173 253)"/>
                  </g>

                  <%-- Trân châu: hiện khi tick topping có chữ "trân châu" --%>
                  <g id="pdBoba" class="pd-layer" opacity="0">
                    <g fill="#241610">
                      <circle cx="124" cy="358" r="11"/><circle cx="152" cy="351" r="11"/><circle cx="180" cy="358" r="11"/>
                      <circle cx="115" cy="375" r="11"/><circle cx="144" cy="373" r="11"/><circle cx="173" cy="375" r="11"/>
                    </g>
                    <g fill="#5A4030" opacity=".85">
                      <circle cx="120" cy="354" r="3"/><circle cx="148" cy="347" r="3"/><circle cx="176" cy="354" r="3"/>
                    </g>
                  </g>

                  <path d="M78,140 L106,384 L122,384 L94,140 Z" fill="#ffffff" opacity=".11"/>
                </g>

                <path d="M62,140 L96,376 Q98,390 112,390 L188,390 Q202,390 204,376 L238,140 Z" fill="url(#pdGlass)"/>
                <path d="M58,124 Q150,78 242,124 Z" fill="#EFE3D4"/>
                <rect x="50" y="120" width="200" height="26" rx="9" fill="#FBF3E9"/>
                <rect x="50" y="120" width="200" height="9"  rx="4.5" fill="#ffffff" opacity=".7"/>

                <%-- Nhãn dung tích dán trên ly, đổi theo size --%>
                <text id="pdCupLabel" x="150" y="432" text-anchor="middle"
                      font-family="'IBM Plex Mono', ui-monospace, monospace"
                      font-size="19" font-weight="600" letter-spacing="3" fill="#9C918B">700ML</text>
              </svg>
            </div>
          </div>

          <p class="flex items-center justify-center gap-2 text-[.76rem] text-muted mt-4">
            <svg class="w-3.5 h-3.5 shrink-0 text-accent" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="9"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
            Hình minh hoạ đổi theo lựa chọn của bạn, không phải ảnh chụp thật.
          </p>
        </div>

        <!-- ══ CỘT PHẢI: thông tin & tuỳ chọn ══ -->
        <div>
          <div class="flex flex-wrap items-center gap-2.5 mb-4">
            <c:if test="${not empty product.categoryName}">
              <span class="font-mono text-[.6rem] font-semibold tracking-[.16em] uppercase text-accent bg-surface shadow-soft px-3.5 py-1.5 rounded-full">
                <c:out value="${product.categoryName}"/>
              </span>
            </c:if>
            <c:choose>
              <c:when test="${not empty product.variants}">
                <span class="inline-flex items-center gap-1.5 font-mono text-[.6rem] font-semibold tracking-[.12em] uppercase text-[#2F7A4F] bg-[#E7F3EC] px-3.5 py-1.5 rounded-full">
                  <span class="w-1.5 h-1.5 rounded-full bg-[#2F7A4F]"></span> Đang bán
                </span>
              </c:when>
              <c:otherwise>
                <span class="font-mono text-[.6rem] font-semibold tracking-[.12em] uppercase text-[#9A5B2A] bg-[#F7EADC] px-3.5 py-1.5 rounded-full">Tạm hết</span>
              </c:otherwise>
            </c:choose>
          </div>

          <h1 class="text-ink font-extrabold tracking-[-.03em] leading-[1.1] text-[clamp(1.7rem,4vw,2.5rem)] mb-3.5">
            <c:out value="${product.name}"/>
          </h1>

          <p class="text-[.95rem] leading-relaxed text-ink-2 mb-7">
            <c:out value="${not empty product.description ? product.description : 'Pha theo đơn — bạn chọn size, mức đường và mức đá, quầy làm đúng theo đó.'}"/>
          </p>

          <c:choose>
          <c:when test="${not empty product.variants}">

            <%-- Danh sách topping đẩy sang JS: mỗi topping là sản phẩm thật có VariantID riêng --%>
            <script type="application/json" id="pdToppingData">[<c:forEach var="t" items="${toppings}" varStatus="ts">{"variantId":${t.variants[0].variantId},"name":"${fn:escapeXml(t.name)}","price":${t.variants[0].price}}<c:if test="${!ts.last}">,</c:if></c:forEach>]</script>

            <!-- SIZE -->
            <div class="mb-6">
              <span class="block font-mono text-[.58rem] font-semibold tracking-[.16em] uppercase text-muted mb-3">Size</span>
              <div class="flex flex-wrap gap-2.5" id="pdSizeGroup">
                <c:forEach var="v" items="${product.variants}" varStatus="vs">
                  <label class="pd-opt">
                    <input type="radio" name="pdSize" value="${v.variantId}"
                           data-price="${v.price}" data-size="${fn:escapeXml(v.size)}"
                           ${vs.first ? 'checked' : ''}>
                    <span>
                      <c:out value="${v.sizeLabel}"/>
                      <span class="font-mono text-[.72rem] opacity-80 tnum"><fmt:formatNumber value="${v.price}" type="number" groupingUsed="true"/>đ</span>
                    </span>
                  </label>
                </c:forEach>
              </div>
            </div>

            <!-- MỨC ĐƯỜNG -->
            <div class="mb-6">
              <span class="block font-mono text-[.58rem] font-semibold tracking-[.16em] uppercase text-muted mb-3">Mức đường</span>
              <div class="flex flex-wrap gap-2.5">
                <c:forEach var="s" items="0%,30%,70%,100%">
                  <label class="pd-opt">
                    <input type="radio" name="pdSugar" value="${s}" ${s == '70%' ? 'checked' : ''}>
                    <span>${s}</span>
                  </label>
                </c:forEach>
              </div>
            </div>

            <!-- MỨC ĐÁ -->
            <div class="mb-6">
              <span class="block font-mono text-[.58rem] font-semibold tracking-[.16em] uppercase text-muted mb-3">Mức đá</span>
              <div class="flex flex-wrap gap-2.5">
                <label class="pd-opt">
                  <input type="radio" name="pdIce" value="Nóng / Ít đá" data-ice="0">
                  <span>Nóng / Ít đá</span>
                </label>
                <label class="pd-opt">
                  <input type="radio" name="pdIce" value="50% đá" data-ice="2" checked>
                  <span>50% đá</span>
                </label>
                <label class="pd-opt">
                  <input type="radio" name="pdIce" value="100% đá" data-ice="4">
                  <span>100% đá</span>
                </label>
              </div>
            </div>

            <!-- TOPPING -->
            <c:if test="${not empty toppings}">
            <div class="mb-6">
              <span class="block font-mono text-[.58rem] font-semibold tracking-[.16em] uppercase text-muted mb-3">Topping thêm</span>
              <div class="grid sm:grid-cols-2 gap-2.5">
                <c:forEach var="t" items="${toppings}">
                  <label class="pd-top">
                    <input type="checkbox" class="pd-top-input"
                           data-variant-id="${t.variants[0].variantId}"
                           data-name="${fn:escapeXml(t.name)}"
                           data-price="${t.variants[0].price}">
                    <span class="pd-top-wrap">
                      <span class="pd-top-box">
                        <svg class="pd-top-tick" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.4" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                      </span>
                      <span class="flex-1 text-[.85rem] text-ink"><c:out value="${t.name}"/></span>
                      <span class="font-mono text-[.7rem] text-muted tnum">+<fmt:formatNumber value="${t.variants[0].price}" type="number" groupingUsed="true"/>đ</span>
                    </span>
                  </label>
                </c:forEach>
              </div>
            </div>
            </c:if>

            <!-- GHI CHÚ -->
            <div class="mb-7">
              <label for="pdNote" class="block font-mono text-[.58rem] font-semibold tracking-[.16em] uppercase text-muted mb-3">Ghi chú riêng</label>
              <textarea id="pdNote" rows="2" maxlength="200"
                        placeholder="Ví dụ: ít đường hơn bình thường, không lấy ống hút..."
                        class="w-full text-ink placeholder:text-muted"></textarea>
              <p class="text-[.72rem] text-muted mt-2 mb-0">
                Mức đường, mức đá và ghi chú sẽ được quầy xác nhận lại khi lên đơn.
              </p>
            </div>

            <!-- SỐ LƯỢNG + TẠM TÍNH -->
            <div class="bg-surface shadow-soft rounded-[22px] p-5 mb-4">
              <div class="flex flex-wrap items-center justify-between gap-4">
                <div class="flex items-center gap-1 bg-canvas rounded-full p-1">
                  <button type="button" id="pdQtyMinus" aria-label="Giảm số lượng"
                          class="w-9 h-9 rounded-full grid place-items-center text-ink hover:bg-mist transition text-lg leading-none">−</button>
                  <input type="text" id="pdQty" value="1" inputmode="numeric" aria-label="Số lượng"
                         class="w-11 text-center bg-transparent font-bold text-ink tnum"
                         style="background:transparent !important;padding:0 !important;box-shadow:none !important;">
                  <button type="button" id="pdQtyPlus" aria-label="Tăng số lượng"
                          class="w-9 h-9 rounded-full grid place-items-center text-ink hover:bg-mist transition text-lg leading-none">+</button>
                </div>
                <div class="text-right">
                  <span class="block font-mono text-[.56rem] tracking-[.14em] uppercase text-muted mb-0.5">Tạm tính</span>
                  <span id="pdTotal" class="block text-ink font-extrabold text-[1.7rem] leading-none tracking-[-.02em] tnum">—</span>
                </div>
              </div>
            </div>

            <button type="button" id="pdAddBtn"
                    class="w-full inline-flex items-center justify-center gap-2.5 bg-accent text-white font-semibold text-[.95rem]
                           px-7 py-4 rounded-full shadow-cta hover:bg-accent-deep hover:-translate-y-0.5 active:translate-y-0 transition">
              <svg class="w-[18px] h-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M6.5 8h11l1 12.2a2 2 0 0 1-2 2.1H7.5a2 2 0 0 1-2-2.1L6.5 8z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>
              </svg>
              Thêm vào giỏ
            </button>

            <div class="flex flex-wrap items-center gap-x-7 gap-y-2 mt-6 font-mono text-[.6rem] tracking-[.1em] uppercase text-muted">
              <span>Mã món · <span class="tnum">#${product.productId}</span></span>
              <a href="${ctx}/cart" class="text-muted hover:text-accent transition no-underline">Xem giỏ hàng →</a>
            </div>
          </c:when>

          <c:otherwise>
            <div class="bg-surface shadow-soft rounded-[22px] p-6">
              <p class="text-ink font-semibold mb-1.5">Món này đang tạm hết</p>
              <p class="text-sm text-ink-2 mb-5">Chưa có size nào mở bán. Bạn xem món khác trong cùng nhóm nhé.</p>
              <a href="${ctx}/san-pham?danhmuc=${product.categoryId}"
                 class="inline-flex items-center gap-2 bg-accent text-white font-semibold text-[.88rem] px-6 py-3 rounded-full shadow-cta hover:bg-accent-deep transition no-underline">
                Xem nhóm <c:out value="${product.categoryName}"/>
              </a>
            </div>
          </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </section>

  <!-- ══════════ BẢNG THÔNG SỐ ══════════ -->
  <section class="pb-4">
    <div class="max-w-6xl mx-auto px-4 sm:px-6">
      <div class="bg-surface shadow-soft rounded-[26px] overflow-hidden">
        <div class="px-6 sm:px-8 py-5" style="box-shadow:0 1px 0 rgba(43,38,37,.06);">
          <h2 class="font-mono text-[.62rem] font-semibold tracking-[.18em] uppercase text-accent m-0">Thông số</h2>
        </div>
        <dl class="m-0 px-6 sm:px-8 py-2">
          <c:if test="${not empty product.categoryName}">
            <div class="flex flex-wrap gap-x-6 gap-y-1 py-3.5" style="box-shadow:0 1px 0 rgba(43,38,37,.05);">
              <dt class="w-40 shrink-0 text-[.84rem] text-muted m-0">Nhóm món</dt>
              <dd class="flex-1 text-[.88rem] text-ink m-0"><c:out value="${product.categoryName}"/></dd>
            </div>
          </c:if>
          <c:if test="${not empty product.variants}">
            <div class="flex flex-wrap gap-x-6 gap-y-1 py-3.5" style="box-shadow:0 1px 0 rgba(43,38,37,.05);">
              <dt class="w-40 shrink-0 text-[.84rem] text-muted m-0">Dung tích</dt>
              <dd class="flex-1 text-[.88rem] text-ink m-0">
                <c:forEach var="v" items="${product.variants}" varStatus="vs"><c:out value="${v.sizeLabel}"/><c:if test="${!vs.last}"> · </c:if></c:forEach>
              </dd>
            </div>
          </c:if>
          <c:if test="${fn:containsIgnoreCase(product.categoryName,'trà')}">
            <div class="flex flex-wrap gap-x-6 gap-y-1 py-3.5" style="box-shadow:0 1px 0 rgba(43,38,37,.05);">
              <dt class="w-40 shrink-0 text-[.84rem] text-muted m-0">Nhiệt độ ủ trà</dt>
              <dd class="flex-1 text-[.88rem] text-ink m-0 tnum">92–95°C · ủ mẻ nhỏ, dùng tối đa 4 giờ</dd>
            </div>
          </c:if>
          <div class="flex flex-wrap gap-x-6 gap-y-1 py-3.5" style="box-shadow:0 1px 0 rgba(43,38,37,.05);">
            <dt class="w-40 shrink-0 text-[.84rem] text-muted m-0">Bao bì</dt>
            <dd class="flex-1 text-[.88rem] text-ink m-0">Ly PP an toàn thực phẩm, ép màng kín trước khi giao</dd>
          </div>
          <div class="flex flex-wrap gap-x-6 gap-y-1 py-3.5">
            <dt class="w-40 shrink-0 text-[.84rem] text-muted m-0">Pha chế</dt>
            <dd class="flex-1 text-[.88rem] text-ink m-0">Pha sau khi nhận đơn · giao 20–30 phút tại TP. Bà Rịa</dd>
          </div>
        </dl>
      </div>
    </div>
  </section>

  <!-- ══════════ MÓN KHÁC ══════════ -->
  <c:if test="${not empty otherProducts}">
  <section class="py-16 lg:py-20">
    <div class="max-w-6xl mx-auto px-4 sm:px-6">
      <div class="flex flex-wrap items-end justify-between gap-4 mb-8">
        <div>
          <span class="block font-mono text-[.62rem] font-semibold tracking-[.16em] uppercase text-accent mb-2">Gợi ý thêm</span>
          <h2 class="text-ink font-extrabold tracking-[-.03em] text-[clamp(1.4rem,3vw,1.9rem)] m-0">
            Món khác bạn có thể thích
          </h2>
        </div>
        <a href="${ctx}/san-pham" class="text-[.88rem] font-semibold text-ink hover:text-accent transition no-underline">
          Xem tất cả →
        </a>
      </div>

      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-5">
        <c:forEach var="p" items="${otherProducts}">
          <%-- Dùng lại đúng fragment thẻ sản phẩm của khu thực đơn để hai nơi không lệch nhau --%>
          <%@ include file="/WEB-INF/views/common/_product-card.jspf" %>
        </c:forEach>
      </div>
    </div>
  </section>
  </c:if>

  <!-- ══════════ CAM KẾT ══════════ -->
  <section class="pb-20">
    <div class="max-w-6xl mx-auto px-4 sm:px-6">
      <div class="grid sm:grid-cols-3 gap-4 lg:gap-5">
        <div class="bg-surface shadow-soft rounded-[20px] px-6 py-5 flex items-center gap-4">
          <span class="w-10 h-10 rounded-xl bg-accent/10 grid place-items-center text-accent shrink-0">
            <svg class="w-[18px] h-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="9"/><polyline points="12 7 12 12 16 14"/>
            </svg>
          </span>
          <span>
            <span class="block text-[.88rem] font-bold text-ink">Giao 20–30 phút</span>
            <span class="block text-[.76rem] text-muted">Bán kính 7–10km tại TP. Bà Rịa</span>
          </span>
        </div>
        <div class="bg-surface shadow-soft rounded-[20px] px-6 py-5 flex items-center gap-4">
          <span class="w-10 h-10 rounded-xl bg-accent/10 grid place-items-center text-accent shrink-0">
            <svg class="w-[18px] h-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M21 7.5l-9-4.5-9 4.5 9 4.5 9-4.5z"/><path d="M3 7.5v9l9 4.5 9-4.5v-9"/><polyline points="8.8 11.8 10.6 13.6 15 9.2"/>
            </svg>
          </span>
          <span>
            <span class="block text-[.88rem] font-bold text-ink">Ép màng kín</span>
            <span class="block text-[.76rem] text-muted">Không tràn khi di chuyển</span>
          </span>
        </div>
        <div class="bg-surface shadow-soft rounded-[20px] px-6 py-5 flex items-center gap-4">
          <span class="w-10 h-10 rounded-xl bg-accent/10 grid place-items-center text-accent shrink-0">
            <svg class="w-[18px] h-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M12 3a2 2 0 0 0-2 2v9.3a4 4 0 1 0 4 0V5a2 2 0 0 0-2-2z"/><line x1="12" y1="9" x2="12" y2="14.5"/>
            </svg>
          </span>
          <span>
            <span class="block text-[.88rem] font-bold text-ink">Pha theo đơn</span>
            <span class="block text-[.76rem] text-muted">Không pha sẵn để tủ</span>
          </span>
        </div>
      </div>
    </div>
  </section>

  <%-- Thanh chốt đơn dính đáy màn hình trên mobile: cột phải rất dài, nếu không có thanh
       này khách phải cuộn ngược lên mới bấm được "Thêm vào giỏ". --%>
  <c:if test="${not empty product.variants}">
  <div class="lg:hidden fixed bottom-0 left-0 right-0 z-40 bg-surface px-4 py-3 flex items-center gap-4"
       style="box-shadow:0 -1px 0 rgba(43,38,37,.07), 0 -18px 36px -24px rgba(43,38,37,.3);">
    <div class="flex-1 min-w-0">
      <span class="block font-mono text-[.54rem] tracking-[.14em] uppercase text-muted">Tạm tính</span>
      <span id="pdTotalMobile" class="block text-ink font-extrabold text-[1.15rem] leading-tight tnum">—</span>
    </div>
    <button type="button" id="pdAddBtnMobile"
            class="shrink-0 inline-flex items-center gap-2 bg-accent text-white font-semibold text-[.88rem] px-6 py-3.5 rounded-full shadow-cta hover:bg-accent-deep transition">
      <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M6.5 8h11l1 12.2a2 2 0 0 1-2 2.1H7.5a2 2 0 0 1-2-2.1L6.5 8z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>
      </svg>
      Thêm vào giỏ
    </button>
  </div>
  <div class="lg:hidden h-20" aria-hidden="true"></div>
  </c:if>

  </c:otherwise>
</c:choose>

</div><!-- /.pd -->

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

      /* Bấm thẻ "món khác" → sang trang chi tiết của món đó (thẻ dùng chung với khu thực đơn) */
      document.querySelectorAll('.product-card').forEach(function (card) {
        card.addEventListener('click', function () {
          if (card.dataset.detailUrl) window.location.href = card.dataset.detailUrl;
        });
      });

      var addBtn = document.getElementById('pdAddBtn');
      if (!addBtn) return;   // món tạm hết: không có khu tuỳ chọn

      var qtyInput = document.getElementById('pdQty');
      var totalOut = document.getElementById('pdTotal');
      var totalOutMobile = document.getElementById('pdTotalMobile');
      var addBtnMobile = document.getElementById('pdAddBtnMobile');
      var cupWrap = document.getElementById('pdCupWrap');
      var cupLabel = document.getElementById('pdCupLabel');
      var iceCubes = Array.prototype.slice.call(document.querySelectorAll('.pd-ice-cube'));
      var iceGroup = document.getElementById('pdIce');
      var steam = document.getElementById('pdSteam');
      var boba = document.getElementById('pdBoba');
      var teaTopStop = document.getElementById('pdTeaTop');
      var teaBottomStop = document.getElementById('pdTeaBottom');

      var BASE_TOP = '${teaTop}';
      var BASE_BOTTOM = '${teaBottom}';

      function clampQty(v) {
        v = parseInt(v, 10);
        if (isNaN(v)) v = 1;
        return Math.min(99, Math.max(1, v));
      }
      function formatVnd(n) { return new Intl.NumberFormat('vi-VN').format(n) + 'đ'; }

      function checkedInput(name) { return document.querySelector('input[name="' + name + '"]:checked'); }

      function checkedToppings() {
        return Array.prototype.slice.call(document.querySelectorAll('.pd-top-input:checked'));
      }

      /* Pha màu về phía trắng (t>0) — dùng để nước nhạt dần khi giảm đường. */
      function lighten(hex, t) {
        var n = parseInt(hex.slice(1), 16);
        var r = (n >> 16) & 255, g = (n >> 8) & 255, b = n & 255;
        r = Math.round(r + (255 - r) * t);
        g = Math.round(g + (255 - g) * t);
        b = Math.round(b + (255 - b) * t);
        return 'rgb(' + r + ',' + g + ',' + b + ')';
      }

      /* Ly phản chiếu lựa chọn: size đổi kích thước, đường đổi độ đậm của nước,
         đá hiện số viên tương ứng (chọn "Nóng" thì hiện khói thay cho đá),
         topping có "trân châu" thì hiện lớp trân châu dưới đáy. */
      function paintCup() {
        var size = checkedInput('pdSize');
        var isLarge = size && (size.dataset.size || '').toUpperCase() === 'L';
        if (cupWrap) cupWrap.style.transform = isLarge ? 'scale(1.08)' : 'scale(1)';
        if (cupLabel) cupLabel.textContent = isLarge ? '900ML' : '700ML';

        var sugarEl = checkedInput('pdSugar');
        var sugar = sugarEl ? parseInt(sugarEl.value, 10) : 70;
        // 100% đường -> đúng màu gốc; 0% -> nhạt nhất (pha 45% về trắng)
        var t = (100 - sugar) / 100 * 0.45;
        if (teaTopStop) teaTopStop.setAttribute('stop-color', lighten(BASE_TOP, t));
        if (teaBottomStop) teaBottomStop.setAttribute('stop-color', lighten(BASE_BOTTOM, t));

        var iceEl = checkedInput('pdIce');
        var iceCount = iceEl ? parseInt(iceEl.dataset.ice, 10) : 2;
        if (iceGroup) iceGroup.setAttribute('opacity', iceCount > 0 ? '.34' : '0');
        iceCubes.forEach(function (cube, i) { cube.style.opacity = i < iceCount ? '1' : '0'; });
        if (steam) steam.setAttribute('opacity', iceCount === 0 ? '1' : '0');

        var hasBoba = checkedToppings().some(function (t2) {
          return (t2.dataset.name || '').toLowerCase().indexOf('trân châu') !== -1
              || (t2.dataset.name || '').toLowerCase().indexOf('tran chau') !== -1;
        });
        if (boba) boba.setAttribute('opacity', hasBoba ? '1' : '0');
      }

      function unitPrice() {
        var size = checkedInput('pdSize');
        var total = size ? parseFloat(size.dataset.price) : 0;
        checkedToppings().forEach(function (t) { total += parseFloat(t.dataset.price || '0'); });
        return total;
      }

      function refresh() {
        var qty = clampQty(qtyInput.value);
        var str = formatVnd(unitPrice() * qty);
        if (totalOut) totalOut.textContent = str;
        if (totalOutMobile) totalOutMobile.textContent = str;
        paintCup();
      }

      document.getElementById('pdQtyMinus').addEventListener('click', function () {
        qtyInput.value = Math.max(1, clampQty(qtyInput.value) - 1); refresh();
      });
      document.getElementById('pdQtyPlus').addEventListener('click', function () {
        qtyInput.value = Math.min(99, clampQty(qtyInput.value) + 1); refresh();
      });
      qtyInput.addEventListener('change', function () { qtyInput.value = clampQty(qtyInput.value); refresh(); });

      document.querySelectorAll('input[name="pdSize"], input[name="pdSugar"], input[name="pdIce"], .pd-top-input')
        .forEach(function (el) { el.addEventListener('change', refresh); });

      /* Thêm vào giỏ: size đã chọn + từng topping được tick. Mỗi topping vốn là một sản phẩm
         thật riêng trong DB nên được thêm thành dòng giỏ hàng riêng, nhân đúng theo số ly.
         Đường/đá/ghi chú chưa có cột lưu riêng theo dòng giỏ hàng — quầy xác nhận lại khi
         lên đơn (đã ghi rõ ngay dưới ô ghi chú). */
      function submitAdd(btn) {
        var size = checkedInput('pdSize');
        if (!size) return;
        var qty = clampQty(qtyInput.value);
        NhietDoiXanhCart.addToCart(size.value, qty, btn);
        checkedToppings().forEach(function (t) {
          NhietDoiXanhCart.addToCart(t.dataset.variantId, qty, null);
        });
      }

      addBtn.addEventListener('click', function () { submitAdd(addBtn); });
      if (addBtnMobile) addBtnMobile.addEventListener('click', function () { submitAdd(addBtnMobile); });

      refresh();
    })();
    </script>

</body>
</html>
