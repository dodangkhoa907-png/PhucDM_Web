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
      .pd .pd-mono { font-family:'IBM Plex Mono', ui-monospace, monospace; }
      .pd a:focus-visible, .pd button:focus-visible, .pd input:focus-visible, .pd textarea:focus-visible {
        box-shadow:0 0 0 3px rgba(210,105,30,.45); outline:none;
      }
      /* Input thật của radio/checkbox bị ẩn bằng opacity (không phải display:none) nên vẫn
         nhận được focus bàn phím — quầng focus được chuyển sang phần nhìn kế bên. */
      .pd .pd-size input:focus-visible ~ .pd-size-box,
      .pd .pd-chip input:focus-visible ~ .pd-chip-box,
      .pd .pd-top input:focus-visible ~ .pd-top-wrap { box-shadow:0 0 0 3px rgba(210,105,30,.45); }

      /* ── BỐ CỤC 2 CỘT ────────────────────────────────────────────────────
         Thứ tự DOM (đầu trang → cuối): thông tin món → ly minh hoạ → khối cấu hình.
         Mobile giữ nguyên thứ tự đó; desktop dùng grid-template-areas để đẩy ly
         sang cột trái và ghép thông tin + cấu hình thành một mạch dọc ở cột phải. */
      .pd-shell { display:grid; gap:20px; }
      @media (min-width:1024px) {
        .pd-shell {
          grid-template-columns: minmax(0,37fr) minmax(0,63fr);
          grid-template-areas: "visual head" "visual config";
          column-gap:40px; row-gap:16px;
        }
        .pd-visual { grid-area:visual; position:sticky; top:96px; align-self:start; }
        .pd-head   { grid-area:head; }
        .pd-config { grid-area:config; }
      }
      @media (min-width:1280px) { .pd-shell { column-gap:48px; } }
      /* Mô tả món gói gọn 2 dòng để phần đầu không đẩy khối cấu hình xuống dưới màn hình */
      @media (min-width:1024px) {
        .pd-desc { display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }
      }

      /* ── CỘT TRÁI ────────────────────────────────────────────────────── */
      .pd-cup-card {
        border-radius:28px; padding:18px 16px 20px; display:grid; place-items:center;
        background:linear-gradient(170deg,#FFFFFF 0%,#EFEAE2 100%);
        box-shadow:0 2px 4px rgba(43,38,37,.03), 0 14px 34px -12px rgba(43,38,37,.14);
      }
      .pd-cup { width:min(188px, 50vw); }
      @media (min-width:1024px) { .pd-cup { width:200px; } }
      @media (min-width:1440px) { .pd-cup { width:214px; } }
      .pd #pdCupWrap { transition: transform .45s cubic-bezier(.22,1,.36,1); }
      .pd .pd-layer { transition: opacity .35s ease; }
      .pd-hint {
        display:flex; align-items:flex-start; justify-content:center; gap:6px;
        margin-top:6px; font-size:.7rem; line-height:1.4; color:#9C918B;
      }

      /* ── KHỐI CẤU HÌNH ───────────────────────────────────────────────
         Desktop ≥1200px xếp thành đúng 3 hàng ngang:
           hàng 1  size | đường | đá
           hàng 2  topping | ghi chú
           hàng 3  số lượng | tạm tính | thêm vào giỏ
         Bố cục thật bằng Grid — không zoom, không scale, không cắt nội dung. */
      .pd-card {
        background:#FFFFFF; border-radius:26px; padding:22px;
        display:grid; gap:20px; align-content:start;
        box-shadow:0 2px 4px rgba(43,38,37,.03), 0 14px 34px -12px rgba(43,38,37,.14);
      }
      @media (min-width:640px) { .pd-card { padding:24px 26px; } }
      @media (min-width:768px) and (max-width:1199.98px) {
        .pd-card {
          grid-template-columns:repeat(2,minmax(0,1fr));
          grid-template-areas:"size size" "sugar ice" "top note" "buy buy";
        }
        .pd-a-size{grid-area:size} .pd-a-sugar{grid-area:sugar} .pd-a-ice{grid-area:ice}
        .pd-a-top{grid-area:top} .pd-a-note{grid-area:note} .pd-a-buy{grid-area:buy}
      }
      @media (min-width:1200px) {
        .pd-card {
          grid-template-columns:1.2fr 1fr 1fr; gap:20px 22px;
          grid-template-areas:"size sugar ice" "top top note" "buy buy buy";
        }
        .pd-a-size{grid-area:size} .pd-a-sugar{grid-area:sugar} .pd-a-ice{grid-area:ice}
        .pd-a-top{grid-area:top} .pd-a-note{grid-area:note} .pd-a-buy{grid-area:buy}
      }
      .pd-step { min-width:0; }
      /* Tiêu đề nhóm: một dòng ngắn, không mô tả phụ, không letter-spacing lớn */
      .pd-step-head { display:flex; align-items:baseline; margin-bottom:8px; }
      .pd-step-title { font-size:.85rem; font-weight:700; color:#120E0C; letter-spacing:-.01em; }

      /* Size — một hàng: chữ cái size bên trái, giá bên phải. Trạng thái chọn
         thể hiện bằng nền cam, không cần dấu tick lớn. */
      .pd-sizes { display:grid; gap:10px; grid-template-columns:repeat(auto-fit,minmax(104px,1fr)); }
      .pd-size { position:relative; display:block; cursor:pointer; }
      .pd-size input { position:absolute; inset:0; width:100%; height:100%; opacity:0; margin:0; cursor:pointer; }
      .pd-size-box {
        display:flex; align-items:center; justify-content:space-between; gap:10px;
        background:#EFEAE2; border-radius:16px; padding:0 14px; min-height:48px;
        transition:background-color .2s ease, box-shadow .2s ease, transform .2s ease;
      }
      .pd-size:hover .pd-size-box { background:#E7DFD4; transform:translateY(-1px); }
      .pd-size-name  { font-size:.86rem; font-weight:700; color:#120E0C; line-height:1.2; }
      .pd-size-price { font-family:'IBM Plex Mono', ui-monospace, monospace; font-size:.8rem;
                       font-weight:600; color:#6B615C; white-space:nowrap; }
      .pd-size input:checked ~ .pd-size-box {
        background:#D2691E; box-shadow:0 10px 24px -10px rgba(210,105,30,.6);
      }
      .pd-size input:checked ~ .pd-size-box .pd-size-name { color:#FFFFFF; }
      .pd-size input:checked ~ .pd-size-box .pd-size-price { color:rgba(255,255,255,.88); }

      /* Đường / Đá — chip cao 44px, chỉ rộng bằng nội dung */
      .pd-chips { display:flex; flex-wrap:wrap; gap:8px; }
      .pd-chip { position:relative; display:inline-flex; }
      .pd-chip input { position:absolute; inset:0; width:100%; height:100%; opacity:0; margin:0; cursor:pointer; }
      .pd-chip-box {
        display:inline-flex; align-items:center; gap:7px; min-height:44px; padding:0 17px;
        border-radius:999px; background:#EFEAE2; color:#3C3532; font-size:.84rem; font-weight:600;
        transition:background-color .2s ease, color .2s ease, box-shadow .2s ease;
      }
      .pd-chip:hover .pd-chip-box { background:#E7DFD4; }
      .pd-chip input:checked ~ .pd-chip-box {
        background:#D2691E; color:#FFFFFF; box-shadow:0 10px 24px -10px rgba(210,105,30,.6);
      }
      /* Đường 4 lựa chọn / đá 3 lựa chọn chia đều một hàng, cao bằng nhau */
      .pd-chips-4, .pd-chips-3 { display:grid; gap:8px; }
      .pd-chips-4 { grid-template-columns:repeat(4,minmax(0,1fr)); }
      .pd-chips-3 { grid-template-columns:repeat(3,minmax(0,1fr)); }
      .pd-chips-4 .pd-chip, .pd-chips-3 .pd-chip { display:block; }
      .pd-chips-4 .pd-chip-box, .pd-chips-3 .pd-chip-box {
        display:flex; width:100%; justify-content:center; text-align:center;
        gap:5px; padding:0 8px; font-size:.8rem; line-height:1.2;
      }
      .pd-chips-3 .pd-chip-box { font-size:.8rem; padding:0 6px; }

      /* Topping — luôn 2 cột, checkbox thật vẫn nằm trong DOM */
      .pd-tops { display:grid; gap:9px; grid-template-columns:repeat(2,minmax(0,1fr)); }
      @media (max-width:419.98px) { .pd-tops { grid-template-columns:minmax(0,1fr); } }
      .pd .pd-top { position:relative; display:block; cursor:pointer; }
      .pd .pd-top[hidden] { display:none !important; }
      .pd .pd-top input { position:absolute; opacity:0; width:1px; height:1px; }
      .pd .pd-top-wrap {
        display:flex; align-items:center; gap:8px; background:#FAF6F0; min-height:46px;
        border-radius:14px; padding:0 12px;
        transition:background-color .2s ease, box-shadow .2s ease;
      }
      .pd .pd-top:hover .pd-top-wrap { background:#EFEAE2; }
      /* Tên không xuống dòng trên desktop: cắt bằng ellipsis, tên đầy đủ ở tooltip */
      .pd-top-name {
        flex:1 1 auto; min-width:0; font-size:.84rem; color:#120E0C; line-height:1.25;
        white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
      }
      .pd-top-price { flex:none; font-size:.72rem; color:#9C918B; white-space:nowrap; }
      /* Chấm nhỏ thay cho ô checkbox trắng lớn */
      .pd-top-dot {
        flex:none; width:8px; height:8px; border-radius:999px;
        background:rgba(18,14,12,.14); transition:background-color .2s ease;
      }
      .pd .pd-top input:checked ~ .pd-top-wrap {
        background:#F7EADC; box-shadow:0 6px 16px -10px rgba(210,105,30,.55);
      }
      .pd .pd-top input:checked ~ .pd-top-wrap .pd-top-dot { background:#D2691E; }
      .pd .pd-top input:checked ~ .pd-top-wrap .pd-top-price { color:#6B615C; }
      .pd-top-more {
        margin-top:8px; min-height:40px; padding:0 16px; border-radius:999px; background:#EFEAE2;
        color:#120E0C; font-size:.78rem; font-weight:600; cursor:pointer;
        display:inline-flex; align-items:center; gap:7px; transition:background-color .2s ease;
      }
      .pd-top-more:hover { background:#E7DFD4; }

      /* Ô ghi chú — cao gần bằng khối topping bên cạnh, bộ đếm ký tự nằm góc dưới.
         eighttea.css đặt background !important cho textarea nên khai báo lại tường minh. */
      .pd-a-note { display:flex; flex-direction:column; min-width:0; }
      .pd-note-wrap { position:relative; display:flex; flex:1 1 auto; min-height:0; }
      .pd #pdNote {
        flex:1 1 auto; width:100%;
        background:#EFEAE2 !important; border-radius:16px !important;
        padding:11px 13px 24px !important; font-size:.85rem; line-height:1.45; resize:none;
        min-height:100px; overflow-y:auto;
      }
      @media (min-width:1200px) { .pd #pdNote { min-height:106px; } }
      .pd #pdNote:focus { background:#FFFFFF !important; box-shadow:0 0 0 3px rgba(210,105,30,.35) !important; }
      /* Bộ đếm ký tự chỉ xuất hiện khi focus hoặc đã nhập nội dung */
      .pd-note-count {
        position:absolute; right:12px; bottom:7px; font-size:.7rem; color:#9C918B;
        pointer-events:none; opacity:0; transition:opacity .18s ease;
      }
      .pd-note-wrap:focus-within .pd-note-count,
      .pd-note-count.is-on { opacity:1; }

      /* Số lượng */
      .pd-qty { display:inline-flex; align-items:center; gap:2px; background:#EFEAE2; border-radius:999px; padding:4px; }
      .pd-qty button {
        width:40px; height:40px; border-radius:999px; background:transparent; color:#120E0C;
        font-size:1.15rem; line-height:1; display:grid; place-items:center; cursor:pointer;
        transition:background-color .2s ease, opacity .2s ease;
      }
      .pd-qty button:hover:not(:disabled) { background:#FFFFFF; }
      .pd-qty button:disabled { opacity:.35; cursor:not-allowed; }
      .pd #pdQty {
        width:46px; text-align:center; font-weight:700; font-size:.95rem; color:#120E0C;
        background:transparent !important; box-shadow:none !important; padding:0 !important;
      }

      /* ── HÀNG 3: SỐ LƯỢNG · TẠM TÍNH · CTA ───────────────────────────── */
      .pd-purchase { display:grid; gap:12px; min-width:0; }
      @media (min-width:768px) {
        .pd-purchase { grid-template-columns:auto minmax(0,1fr); align-items:center; gap:16px; }
      }
      .pd-buy {
        background:#FAF6F0; border-radius:20px; padding:12px 16px;
        display:flex; flex-wrap:wrap; align-items:center; gap:10px 14px;
      }
      @media (min-width:768px) {
        .pd-buy {
          display:grid; grid-template-columns:minmax(150px,.8fr) minmax(220px,1.4fr);
          align-items:center; gap:16px;
        }
      }
      .pd-buy-info { flex:1 1 auto; min-width:0; }
      .pd-buy-total {
        display:block; font-family:'IBM Plex Mono', ui-monospace, monospace;
        font-size:1.35rem; font-weight:600; letter-spacing:-.02em; color:#120E0C; line-height:1.15;
      }
      .pd-buy-sum {
        display:block; margin-top:2px; font-size:.72rem; line-height:1.35; color:#6B615C;
      }
      .pd-cta {
        flex:1 1 100%; min-height:54px; padding:0 24px; border-radius:999px;
        display:inline-flex; align-items:center; justify-content:center; gap:9px;
        background:#D2691E; color:#FFFFFF; font-size:.94rem; font-weight:700; cursor:pointer;
        box-shadow:0 10px 24px -8px rgba(210,105,30,.55);
        transition:background-color .2s ease, transform .2s ease, opacity .2s ease;
      }
      .pd-cta:hover:not(:disabled) { background:#A9531A; transform:translateY(-1px); }
      .pd-cta:active:not(:disabled) { transform:translateY(0); }
      .pd-cta:disabled { opacity:.62; cursor:progress; transform:none; box-shadow:none; }
      @media (min-width:768px) { .pd-cta { flex:none; width:100%; } }
      #pdBuySpacer { display:none; }

      /* Dưới 768px khối tóm tắt tự rời khỏi thẻ cấu hình và dính đáy màn hình.
         Vẫn là MỘT nút duy nhất trong DOM — không nhân bản CTA nên không có
         listener trùng và tổng tiền luôn khớp; desktop không có CTA sticky thứ hai. */
      @media (max-width:767.98px) {
        .pd-buy {
          position:fixed; left:0; right:0; bottom:0; z-index:40; margin:0;
          border-radius:20px 20px 0 0; background:#FFFFFF; flex-wrap:nowrap;
          padding:11px 16px calc(11px + env(safe-area-inset-bottom));
          box-shadow:0 -1px 0 rgba(43,38,37,.06), 0 -18px 40px -24px rgba(43,38,37,.35);
        }
        .pd-buy-sum { display:none; }
        .pd-buy-total { font-size:1.2rem; }
        .pd-cta { flex:0 0 auto; min-height:48px; padding:0 20px; font-size:.88rem; }
        #pdBuySpacer { display:block; height:104px; }
        /* Vùng chạm tối thiểu 44px trên thiết bị cảm ứng */
        .pd-size-box { min-height:52px; }
        .pd .pd-top-wrap { min-height:48px; }
        .pd-qty button { width:44px; height:44px; }
        .pd #pdQty { width:52px; }
        .pd-top-more { min-height:44px; }
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

  <section class="pt-24 sm:pt-28 pb-14">
    <div class="max-w-[1320px] mx-auto px-4 sm:px-6 lg:px-8">

      <%-- Đường dẫn phân cấp: cho khách biết đang đứng ở đâu và lùi lại được từng bậc --%>
      <nav aria-label="Đường dẫn" class="flex flex-wrap items-center gap-2 text-[.75rem] text-muted mb-5">
        <a href="${ctx}/" class="hover:text-accent transition no-underline text-muted">Trang chủ</a>
        <c:if test="${not empty product.categoryName}">
          <span aria-hidden="true">/</span>
          <a href="${ctx}/san-pham?danhmuc=${product.categoryId}" class="hover:text-accent transition no-underline text-muted">
            <c:out value="${product.categoryName}"/>
          </a>
        </c:if>
        <span aria-hidden="true">/</span>
        <span class="text-ink" aria-current="page"><c:out value="${product.name}"/></span>
      </nav>

      <%-- Khoảng giá hiển thị cạnh tên món — tính từ chính danh sách variant, không hardcode. --%>
      <c:set var="pdMinPrice" value=""/>
      <c:set var="pdMaxPrice" value=""/>
      <c:forEach var="v" items="${product.variants}">
        <c:if test="${empty pdMinPrice or v.price lt pdMinPrice}"><c:set var="pdMinPrice" value="${v.price}"/></c:if>
        <c:if test="${empty pdMaxPrice or v.price gt pdMaxPrice}"><c:set var="pdMaxPrice" value="${v.price}"/></c:if>
      </c:forEach>

      <%-- Thứ tự DOM = thứ tự đọc trên mobile: thông tin món → ly minh hoạ → cấu hình.
           Desktop kéo ly sang cột trái bằng grid-template-areas (xem .pd-shell). --%>
      <div class="pd-shell">

        <!-- ══ THÔNG TIN MÓN ══ -->
        <div class="pd-head">
          <div class="flex flex-wrap items-center gap-2.5 mb-2.5">
            <c:if test="${not empty product.categoryName}">
              <span class="font-mono text-[.6rem] font-semibold tracking-[.16em] uppercase text-accent bg-surface shadow-soft px-3.5 py-1.5 rounded-full">
                <c:out value="${product.categoryName}"/>
              </span>
            </c:if>
            <c:choose>
              <c:when test="${not empty product.variants}">
                <span class="inline-flex items-center gap-1.5 font-mono text-[.6rem] font-semibold tracking-[.12em] uppercase text-[#2F7A4F] bg-[#E7F3EC] px-3.5 py-1.5 rounded-full">
                  <span class="w-1.5 h-1.5 rounded-full bg-[#2F7A4F]" aria-hidden="true"></span> Đang bán
                </span>
              </c:when>
              <c:otherwise>
                <span class="font-mono text-[.6rem] font-semibold tracking-[.12em] uppercase text-[#9A5B2A] bg-[#F7EADC] px-3.5 py-1.5 rounded-full">Tạm hết</span>
              </c:otherwise>
            </c:choose>
          </div>

          <h1 class="text-ink font-extrabold tracking-[-.03em] leading-[1.12] text-[clamp(1.5rem,3vw,2rem)] mb-1.5">
            <c:out value="${product.name}"/>
          </h1>

          <p class="pd-desc text-[.9rem] leading-[1.5] text-ink-2 m-0">
            <c:out value="${not empty product.description ? product.description : 'Pha theo đơn — bạn chọn size, mức đường và mức đá, quầy làm đúng theo đó.'}"/>
          </p>

          <c:if test="${not empty pdMinPrice}">
            <p class="flex flex-wrap items-baseline gap-2 mt-2 mb-0">
              <span class="pd-mono text-[.7rem] font-semibold tracking-[.12em] uppercase text-muted">
                ${pdMinPrice == pdMaxPrice ? 'Giá' : 'Giá từ'}
              </span>
              <span class="pd-mono text-[1.05rem] font-semibold text-ink tnum">
                <fmt:formatNumber value="${pdMinPrice}" type="number" groupingUsed="true"/>đ<c:if test="${pdMinPrice != pdMaxPrice}"> – <fmt:formatNumber value="${pdMaxPrice}" type="number" groupingUsed="true"/>đ</c:if>
              </span>
            </p>
          </c:if>
        </div>

        <!-- ══ CỘT TRÁI: ly xem trước, đổi theo lựa chọn ══ -->
        <div class="pd-visual">
          <div class="pd-cup-card">

            <div id="pdCupWrap" class="pd-cup">
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

          <%-- Ba chỉ số rút gọn của lựa chọn hiện tại — không lặp lại cả form ở cột trái --%>
          <c:if test="${not empty product.variants}">
          </c:if>

          <p class="pd-hint">
            <svg class="w-3.5 h-3.5 shrink-0 mt-[2px] text-accent" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <circle cx="12" cy="12" r="9"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
            <span>Hình minh hoạ thay đổi theo lựa chọn, không phải ảnh chụp thật.</span>
          </p>
        </div>

        <!-- ══ CỘT PHẢI: khối cấu hình ══ -->
        <div class="pd-config">

          <c:choose>
          <c:when test="${not empty product.variants}">

            <%-- MỘT thẻ cấu hình duy nhất, xếp thành 3 hàng ngang trên desktop:
                 (1) Size | Đường | Đá  (2) Topping | Ghi chú  (3) Số lượng | Tạm tính | CTA.
                 Bố cục thật bằng CSS Grid — không zoom/scale/overflow ẩn nội dung. --%>
            <div class="pd-card">

              <!-- ── SIZE ── -->
              <section class="pd-step pd-a-size" role="group" aria-labelledby="pdSizeTitle">
                <div class="pd-step-head">
                  <span class="pd-step-title" id="pdSizeTitle">Size</span>
                </div>
                <div class="pd-sizes">
                  <c:forEach var="v" items="${product.variants}" varStatus="vs">
                    <%-- Nhãn hiển thị rút gọn còn chữ cái size; value gửi backend vẫn là variantId. --%>
                    <label class="pd-size" title="${fn:escapeXml(v.sizeLabel)} · ${fn:toUpperCase(v.size) == 'L' ? '900ml' : '700ml'}">
                      <input type="radio" name="pdSize" value="${v.variantId}"
                             data-price="${v.price}" data-size="${fn:escapeXml(v.size)}"
                             data-volume="${fn:toUpperCase(v.size) == 'L' ? '900ML' : '700ML'}"
                             data-label="${fn:escapeXml(fn:toUpperCase(v.size))}"
                             aria-label="${fn:escapeXml(v.sizeLabel)}"
                             ${vs.first ? 'checked' : ''}>
                      <span class="pd-size-box">
                        <span class="pd-size-name">${fn:toUpperCase(v.size)}</span>
                        <span class="pd-size-price tnum"><fmt:formatNumber value="${v.price}" type="number" groupingUsed="true"/>đ</span>
                      </span>
                    </label>
                  </c:forEach>
                </div>
              </section>

              <!-- ── ĐƯỜNG ── -->
              <section class="pd-step pd-a-sugar" role="group" aria-labelledby="pdSugarTitle">
                <div class="pd-step-head">
                  <span class="pd-step-title" id="pdSugarTitle">Đường</span>
                </div>
                <div class="pd-chips pd-chips-4">
                  <c:forEach var="s" items="0%,30%,70%,100%">
                    <label class="pd-chip">
                      <input type="radio" name="pdSugar" value="${s}"
                             aria-label="${s} đường" ${s == '70%' ? 'checked' : ''}>
                      <span class="pd-chip-box">${s}</span>
                    </label>
                  </c:forEach>
                </div>
              </section>

              <!-- ── ĐÁ ──
                   Nhãn hiển thị rút gọn (Nóng / 50% / 100%) nhưng value giữ nguyên như cũ. -->
              <section class="pd-step pd-a-ice" role="group" aria-labelledby="pdIceTitle">
                <div class="pd-step-head">
                  <span class="pd-step-title" id="pdIceTitle">Đá</span>
                </div>
                <div class="pd-chips pd-chips-3">
                  <label class="pd-chip">
                    <input type="radio" name="pdIce" value="Nóng / Ít đá" data-ice="0" data-short="Nóng"
                           aria-label="Nóng hoặc ít đá">
                    <span class="pd-chip-box">Nóng</span>
                  </label>
                  <label class="pd-chip">
                    <input type="radio" name="pdIce" value="50% đá" data-ice="2" data-short="50%"
                           aria-label="50% đá" checked>
                    <span class="pd-chip-box">50%</span>
                  </label>
                  <label class="pd-chip">
                    <input type="radio" name="pdIce" value="100% đá" data-ice="4" data-short="100%"
                           aria-label="100% đá">
                    <span class="pd-chip-box">100%</span>
                  </label>
                </div>
              </section>

              <!-- ── TOPPING ── -->
              <c:if test="${not empty toppings}">
              <section class="pd-step pd-a-top" aria-labelledby="pdTopTitle">
                <div class="pd-step-head">
                  <span class="pd-step-title" id="pdTopTitle">Topping</span>
                </div>
                <div class="pd-tops" id="pdTopGrid">
                  <c:forEach var="t" items="${toppings}" varStatus="ts">
                    <%-- Từ topping thứ 5 trở đi ẩn sau nút "Xem thêm" — checkbox thật vẫn nằm
                         trong DOM nên trạng thái tick không bao giờ bị mất.
                         Giá hiển thị rút gọn dạng "+7k"; giá thật vẫn do backend tính. --%>
                    <label class="pd-top" title="${fn:escapeXml(t.name)} · +<fmt:formatNumber value="${t.variants[0].price}" type="number" groupingUsed="true"/>đ"
                           ${ts.index ge 4 ? 'data-extra="1"' : ''}>
                      <input type="checkbox" class="pd-top-input"
                             data-variant-id="${t.variants[0].variantId}"
                             data-name="${fn:escapeXml(t.name)}"
                             data-price="${t.variants[0].price}">
                      <span class="pd-top-wrap">
                        <span class="pd-top-name"><c:out value="${t.name}"/></span>
                        <span class="pd-top-price pd-mono tnum">+<fmt:formatNumber value="${t.variants[0].price / 1000}" type="number" maxFractionDigits="0"/>k</span>
                        <span class="pd-top-dot" aria-hidden="true"></span>
                      </span>
                    </label>
                  </c:forEach>
                </div>
                <c:if test="${fn:length(toppings) gt 4}">
                  <button type="button" class="pd-top-more" id="pdTopMore" aria-expanded="false" aria-controls="pdTopGrid">
                    <span id="pdTopMoreText">Xem thêm ${fn:length(toppings) - 4} topping</span>
                  </button>
                </c:if>
              </section>
              </c:if>

              <!-- ── GHI CHÚ ── -->
              <section class="pd-step pd-a-note">
                <div class="pd-step-head">
                  <label class="pd-step-title" for="pdNote">Ghi chú</label>
                </div>
                <div class="pd-note-wrap">
                  <textarea id="pdNote" rows="3" maxlength="200"
                            placeholder="Ví dụ: không lấy ống hút…"
                            class="w-full text-ink placeholder:text-muted"></textarea>
                  <%-- Bộ đếm chỉ hiện khi focus hoặc đã có nội dung (JS bật .is-on). --%>
                  <span class="pd-note-count pd-mono tnum" id="pdNoteCount">0/200</span>
                </div>
              </section>

              <%-- HÀNG 3: số lượng · tạm tính · CTA nằm cùng một hàng ngang trên desktop.
                   Dưới 768px riêng khối .pd-buy chuyển thành thanh dính đáy màn hình (CSS
                   thuần) nên vẫn chỉ có duy nhất MỘT nút "Thêm vào giỏ" trong DOM. --%>
              <div class="pd-purchase pd-a-buy">
                <%-- Không còn tiêu đề "Số lượng" riêng: nhãn nằm gọn trong aria-label. --%>
                <div class="pd-qty" role="group" aria-label="Số lượng, tối đa 99 ly mỗi lần thêm">
                  <button type="button" id="pdQtyMinus" aria-label="Giảm số lượng">−</button>
                  <input type="text" id="pdQty" value="1" inputmode="numeric" autocomplete="off" aria-label="Số lượng">
                  <button type="button" id="pdQtyPlus" aria-label="Tăng số lượng">+</button>
                </div>

                <div class="pd-buy">
                  <div class="pd-buy-info">
                    <span id="pdTotal" class="pd-buy-total tnum" aria-live="polite">—</span>
                    <span id="pdSummaryLine" class="pd-buy-sum"></span>
                  </div>
                  <button type="button" id="pdAddBtn" class="pd-cta">
                    <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                      <path d="M6.5 8h11l1 12.2a2 2 0 0 1-2 2.1H7.5a2 2 0 0 1-2-2.1L6.5 8z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>
                    </svg>
                    <span id="pdAddBtnText">Thêm vào giỏ hàng</span>
                  </button>
                </div>
              </div>
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
    <div class="max-w-[1200px] mx-auto px-4 sm:px-6">
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
    <div class="max-w-[1200px] mx-auto px-4 sm:px-6">
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
    <div class="max-w-[1200px] mx-auto px-4 sm:px-6">
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

  <%-- Dưới 1024px khối .pd-buy trong thẻ cấu hình được CSS chuyển thành thanh dính đáy
       màn hình. Chỉ cần chừa chỗ trống cuối trang để thanh đó không che nội dung —
       KHÔNG dựng thêm nút "Thêm vào giỏ" thứ hai (tránh trùng ID, trùng listener và
       lệch tổng tiền). --%>
  <c:if test="${not empty product.variants}">
    <div id="pdBuySpacer" aria-hidden="true"></div>
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
      var qtyMinus = document.getElementById('pdQtyMinus');
      var qtyPlus = document.getElementById('pdQtyPlus');
      var totalOut = document.getElementById('pdTotal');
      var sumLine = document.getElementById('pdSummaryLine');
      var addBtnText = document.getElementById('pdAddBtnText');
      var noteInput = document.getElementById('pdNote');
      var noteCount = document.getElementById('pdNoteCount');
      var topMore = document.getElementById('pdTopMore');
      var topMoreText = document.getElementById('pdTopMoreText');
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
        // Dung tích do JSP truyền qua data-volume, không hardcode trong JS
        if (cupLabel && size && size.dataset.volume) cupLabel.textContent = size.dataset.volume;

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

      /* Tóm tắt lựa chọn hiện tại — chỉ hiển thị MỘT lần, ngay cạnh tổng tiền. */
      function summaryParts() {
        var parts = [];
        var size = checkedInput('pdSize');
        if (size) parts.push(size.dataset.label || size.dataset.size || '');
        var sugar = checkedInput('pdSugar');
        if (sugar) parts.push('Đường ' + sugar.value);
        var ice = checkedInput('pdIce');
        if (ice) {
          var iceShort = ice.dataset.short || ice.value;
          parts.push(iceShort === 'Nóng' ? 'Nóng' : 'Đá ' + iceShort);
        }
        return parts;
      }

      function refresh() {
        var qty = clampQty(qtyInput.value);
        if (totalOut) totalOut.textContent = formatVnd(unitPrice() * qty);

        var parts = summaryParts();
        if (sumLine) {
          var line = parts.slice();
          var topCount = checkedToppings().length;
          if (topCount > 0) line.push(topCount + ' topping');
          if (qty > 1) line.push(qty + ' ly');
          sumLine.textContent = line.join(' · ');
        }

        if (qtyMinus) qtyMinus.disabled = qty <= 1;
        if (qtyPlus) qtyPlus.disabled = qty >= 99;

        paintCup();
      }

      qtyMinus.addEventListener('click', function () {
        qtyInput.value = Math.max(1, clampQty(qtyInput.value) - 1); refresh();
      });
      qtyPlus.addEventListener('click', function () {
        qtyInput.value = Math.min(99, clampQty(qtyInput.value) + 1); refresh();
      });
      /* Gõ tay: chỉ nhận chữ số, chốt về 1..99 khi rời ô (không chặn lúc đang xoá để gõ lại) */
      qtyInput.addEventListener('input', function () {
        var digits = qtyInput.value.replace(/[^0-9]/g, '');
        if (digits !== qtyInput.value) qtyInput.value = digits;
        if (digits !== '') refresh();
      });
      qtyInput.addEventListener('change', function () { qtyInput.value = clampQty(qtyInput.value); refresh(); });
      qtyInput.addEventListener('blur', function () { qtyInput.value = clampQty(qtyInput.value); refresh(); });

      document.querySelectorAll('input[name="pdSize"], input[name="pdSugar"], input[name="pdIce"], .pd-top-input')
        .forEach(function (el) { el.addEventListener('change', refresh); });

      /* Ghi chú: đếm ký tự theo đúng maxlength của ô, chỉ hiện khi đã có nội dung
         (CSS lo phần hiện khi focus) để vùng mua hàng bớt chữ thừa. */
      if (noteInput) {
        var noteMax = parseInt(noteInput.getAttribute('maxlength'), 10) || 0;
        var syncNoteCount = function () {
          if (!noteCount || !noteMax) return;
          noteCount.textContent = noteInput.value.length + '/' + noteMax;
          noteCount.classList.toggle('is-on', noteInput.value.length > 0);
        };
        noteInput.addEventListener('input', syncNoteCount);
        syncNoteCount();
      }

      /* Danh sách topping dài: chỉ mở rộng/thu gọn phần dư, checkbox thật luôn nằm trong DOM.
         Topping đã tick thì không bị thu lại để tổng tiền không bao giờ chứa món khuất mắt. */
      if (topMore) {
        var extras = Array.prototype.slice.call(document.querySelectorAll('.pd-top[data-extra="1"]'));
        var expanded = false;
        var applyExtras = function () {
          extras.forEach(function (el) {
            var input = el.querySelector('.pd-top-input');
            el.hidden = !expanded && !(input && input.checked);
          });
          var stillHidden = extras.filter(function (el) { return el.hidden; }).length;
          // Thu gọn xong mà không còn gì để mở (đã tick hết) thì nút mất luôn ý nghĩa
          topMore.hidden = !expanded && stillHidden === 0;
          topMore.setAttribute('aria-expanded', expanded ? 'true' : 'false');
          if (topMoreText) {
            topMoreText.textContent = expanded ? 'Thu gọn' : 'Xem thêm ' + stillHidden + ' topping';
          }
        };
        topMore.addEventListener('click', function () { expanded = !expanded; applyExtras(); });
        extras.forEach(function (el) {
          var input = el.querySelector('.pd-top-input');
          if (input) input.addEventListener('change', applyExtras);
        });
        applyExtras();
      }

      /* Thêm vào giỏ: size đã chọn + từng topping được tick. Mỗi topping vốn là một sản phẩm
         thật riêng trong DB nên được thêm thành dòng giỏ hàng riêng, nhân đúng theo số ly.
         Đường/đá/ghi chú chưa có cột lưu riêng theo dòng giỏ hàng — quầy xác nhận lại khi
         lên đơn (đã ghi rõ ngay dưới ô ghi chú).
         Giá gửi lên server chỉ có variantId + quantity: backend tự đọc giá từ DB, tổng tiền
         hiển thị ở đây thuần tuý là preview. */
      var isAdding = false;

      function setBusy(busy) {
        isAdding = busy;
        addBtn.disabled = busy;
        if (addBtnText) addBtnText.textContent = busy ? 'Đang thêm…' : 'Thêm vào giỏ hàng';
      }

      function submitAdd() {
        if (isAdding) return;                       // chặn double click
        var size = checkedInput('pdSize');
        if (!size) return;
        var qty = clampQty(qtyInput.value);
        setBusy(true);

        var jobs = [NhietDoiXanhCart.addToCart(size.value, qty, null)];
        checkedToppings().forEach(function (t) {
          jobs.push(NhietDoiXanhCart.addToCart(t.dataset.variantId, qty, null));
        });

        Promise.all(jobs.map(function (p) {
          return Promise.resolve(p).catch(function () { /* toast đã báo lỗi ở cart.js */ });
        })).then(function () { setBusy(false); });
      }

      addBtn.addEventListener('click', submitAdd);

      refresh();
    })();
    </script>

</body>
</html>
