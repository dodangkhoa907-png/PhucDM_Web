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

    <%-- Trước đây nhúng Tailwind Play CDN (script ngoài 407KB, JIT-compile ngay trên trình
         duyệt mỗi lần tải trang — chặn render, phụ thuộc mạng tới CDN ngoài). Giờ dùng bản
         build sẵn (npm run build:css, xem tailwind.config.js ở gốc repo) — cùng nội dung
         theme/preflight:false, chỉ khác là CSS tĩnh, không tốn JS/CPU phía client. --%>
    <link rel="stylesheet" href="${ctx}/css/tailwind-built.css?v=${initParam.assetVer}">

    <style>
      html { scroll-behavior: smooth; }

      /* Navbar đặc ngay khung hình đầu — trang này không có hero tối nhưng vẫn giữ
         cùng hành vi với các trang khác để thanh điều hướng không "nhấp nháy" khi chuyển trang. */
      body.pd-body #navbar {
        background:var(--et-canvas) !important; backdrop-filter:none !important; -webkit-backdrop-filter:none !important;
        padding:13px 0 !important;
        box-shadow:0 1px 0 rgba(var(--et-dark-rgb),.07), 0 16px 32px -22px rgba(var(--et-dark-rgb),.22);
      }

      /* Ràng buộc borderless của design system — giới hạn trong khu nội dung để không đụng navbar chung */
      .pd *, .pd *::before, .pd *::after { border: 0 !important; }
      .pd .tnum { font-variant-numeric: tabular-nums; }
      .pd .pd-mono { font-family:'IBM Plex Mono', ui-monospace, monospace; }
      .pd a:focus-visible, .pd button:focus-visible, .pd input:focus-visible, .pd textarea:focus-visible {
        box-shadow:0 0 0 3px rgba(var(--et-primary-rgb),.45); outline:none;
      }
      /* Input thật của radio/checkbox bị ẩn bằng opacity (không phải display:none) nên vẫn
         nhận được focus bàn phím — quầng focus được chuyển sang phần nhìn kế bên. */
      .pd .pd-size input:focus-visible ~ .pd-size-box,
      .pd .pd-chip input:focus-visible ~ .pd-chip-box,
      .pd .pd-top input:focus-visible ~ .pd-top-wrap { box-shadow:0 0 0 3px rgba(var(--et-primary-rgb),.45); }

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
        background:linear-gradient(170deg,#FFFFFF 0%,var(--et-surface-muted) 100%);
        box-shadow:0 2px 4px rgba(var(--et-dark-rgb),.03), 0 14px 34px -12px rgba(var(--et-dark-rgb),.14);
      }
      .pd-cup { width:min(260px, 62vw); }
      @media (min-width:1024px) { .pd-cup { width:280px; } }
      @media (min-width:1440px) { .pd-cup { width:300px; } }
      .pd #pdCupWrap { transition: transform .45s cubic-bezier(.22,1,.36,1); }
      .pd-cup-img {
        display:block; width:100%; height:auto; aspect-ratio:600/770;
        object-fit:cover; border-radius:20px;
      }
      .pd-cup-fallback {
        display:block; width:100%; aspect-ratio:600/770; border-radius:20px;
        background:linear-gradient(178deg,var(--et-accent-muted),var(--et-primary-hover));
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
        box-shadow:0 2px 4px rgba(var(--et-dark-rgb),.03), 0 14px 34px -12px rgba(var(--et-dark-rgb),.14);
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
      .pd-step-title { font-size:.85rem; font-weight:700; color:var(--et-text); letter-spacing:-.01em; }

      /* Size — một hàng: chữ cái size bên trái, giá bên phải. Trạng thái chọn
         thể hiện bằng nền xanh thương hiệu, không cần dấu tick lớn. */
      .pd-sizes { display:grid; gap:10px; grid-template-columns:repeat(auto-fit,minmax(104px,1fr)); }
      .pd-size { position:relative; display:block; cursor:pointer; }
      .pd-size input { position:absolute; inset:0; width:100%; height:100%; opacity:0; margin:0; cursor:pointer; }
      .pd-size-box {
        display:flex; align-items:center; justify-content:space-between; gap:10px;
        background:var(--et-surface-muted); border-radius:16px; padding:0 14px; min-height:48px;
        transition:background-color .2s ease, box-shadow .2s ease, transform .2s ease;
      }
      .pd-size:hover .pd-size-box { background:var(--et-border); transform:translateY(-1px); }
      .pd-size-name  { font-size:.86rem; font-weight:700; color:var(--et-text); line-height:1.2; }
      .pd-size-price { font-family:'IBM Plex Mono', ui-monospace, monospace; font-size:.8rem;
                       font-weight:600; color:var(--et-text-secondary); white-space:nowrap; }
      .pd-size input:checked ~ .pd-size-box {
        background:var(--et-primary); box-shadow:0 10px 24px -10px rgba(var(--et-primary-rgb),.6);
      }
      .pd-size input:checked ~ .pd-size-box .pd-size-name { color:#FFFFFF; }
      .pd-size input:checked ~ .pd-size-box .pd-size-price { color:rgba(255,255,255,.88); }

      /* Đường / Đá — chip cao 44px, chỉ rộng bằng nội dung */
      .pd-chips { display:flex; flex-wrap:wrap; gap:8px; }
      .pd-chip { position:relative; display:inline-flex; }
      .pd-chip input { position:absolute; inset:0; width:100%; height:100%; opacity:0; margin:0; cursor:pointer; }
      .pd-chip-box {
        display:inline-flex; align-items:center; gap:7px; min-height:44px; padding:0 17px;
        border-radius:999px; background:var(--et-surface-muted); color:var(--et-text); font-size:.84rem; font-weight:600;
        transition:background-color .2s ease, color .2s ease, box-shadow .2s ease;
      }
      .pd-chip:hover .pd-chip-box { background:var(--et-border); }
      .pd-chip input:checked ~ .pd-chip-box {
        background:var(--et-primary); color:#FFFFFF; box-shadow:0 10px 24px -10px rgba(var(--et-primary-rgb),.6);
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
        display:flex; align-items:center; gap:8px; background:var(--et-surface-muted); min-height:46px;
        border-radius:14px; padding:0 12px;
        transition:background-color .2s ease, box-shadow .2s ease;
      }
      /* Hover phải khác hẳn nền nghỉ, nên dùng sắc xanh rất nhạt chứ không phải
         --et-surface-muted (giờ đã là nền nghỉ) — nếu không sẽ mất hoàn toàn phản hồi hover. */
      .pd .pd-top:hover .pd-top-wrap { background:rgba(var(--et-primary-rgb),.08); }
      /* Tên không xuống dòng trên desktop: cắt bằng ellipsis, tên đầy đủ ở tooltip */
      .pd-top-name {
        flex:1 1 auto; min-width:0; font-size:.84rem; color:var(--et-text); line-height:1.25;
        white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
      }
      .pd-top-price { flex:none; font-size:.72rem; color:var(--et-text-muted); white-space:nowrap; }
      /* Chấm nhỏ thay cho ô checkbox trắng lớn */
      .pd-top-dot {
        flex:none; width:8px; height:8px; border-radius:999px;
        background:rgba(var(--et-dark-rgb),.18); transition:background-color .2s ease;
      }
      /* Đã chọn: sắc xanh rõ hơn hẳn nền chưa chọn. Không dùng --et-primary-soft ở đây vì
         nó (#E9EEE1) gần như trùng với --et-canvas (#F4F6EF) của trạng thái chưa chọn —
         nhìn ra không biết đã chọn hay chưa. Vẫn là nền nhạt nên chữ đen giữ tương phản,
         và chấm tròn đổi sang xanh đậm nên trạng thái không chỉ được báo bằng màu nền. */
      .pd .pd-top input:checked ~ .pd-top-wrap {
        background:rgba(var(--et-primary-rgb),.16); box-shadow:0 6px 16px -10px rgba(var(--et-primary-rgb),.55);
      }
      .pd .pd-top input:checked ~ .pd-top-wrap .pd-top-dot { background:var(--et-primary); }
      <%-- Trên nền xanh nhạt, --et-text-secondary (#66705E) chỉ đạt ~4.1:1 với cỡ chữ .72rem
           → chưa đủ 4.5:1. Dùng --et-text cho dòng giá khi đã chọn. --%>
      .pd .pd-top input:checked ~ .pd-top-wrap .pd-top-price { color:var(--et-text); }
      .pd-top-more {
        margin-top:8px; min-height:40px; padding:0 16px; border-radius:999px; background:var(--et-surface-muted);
        color:var(--et-text); font-size:.78rem; font-weight:600; cursor:pointer;
        display:inline-flex; align-items:center; gap:7px; transition:background-color .2s ease;
      }
      .pd-top-more:hover { background:var(--et-border); }

      /* Ô ghi chú — cao gần bằng khối topping bên cạnh, bộ đếm ký tự nằm góc dưới.
         eighttea.css đặt background !important cho textarea nên khai báo lại tường minh. */
      .pd-a-note { display:flex; flex-direction:column; min-width:0; }
      .pd-note-wrap { position:relative; display:flex; flex:1 1 auto; min-height:0; }
      .pd #pdNote {
        flex:1 1 auto; width:100%;
        background:var(--et-surface-muted) !important; border-radius:16px !important;
        padding:11px 13px 24px !important; font-size:.85rem; line-height:1.45; resize:none;
        min-height:100px; overflow-y:auto;
      }
      @media (min-width:1200px) { .pd #pdNote { min-height:106px; } }
      .pd #pdNote:focus { background:#FFFFFF !important; box-shadow:0 0 0 3px rgba(var(--et-primary-rgb),.35) !important; }
      /* Bộ đếm ký tự chỉ xuất hiện khi focus hoặc đã nhập nội dung */
      .pd-note-count {
        position:absolute; right:12px; bottom:7px; font-size:.7rem; color:var(--et-text-muted);
        pointer-events:none; opacity:0; transition:opacity .18s ease;
      }
      .pd-note-wrap:focus-within .pd-note-count,
      .pd-note-count.is-on { opacity:1; }

      /* Số lượng */
      .pd-qty { display:inline-flex; align-items:center; gap:2px; background:var(--et-surface-muted); border-radius:999px; padding:4px; }
      .pd-qty button {
        width:40px; height:40px; border-radius:999px; background:transparent; color:var(--et-text);
        font-size:1.15rem; line-height:1; display:grid; place-items:center; cursor:pointer;
        transition:background-color .2s ease, opacity .2s ease;
      }
      .pd-qty button:hover:not(:disabled) { background:#FFFFFF; }
      .pd-qty button:disabled { opacity:.35; cursor:not-allowed; }
      .pd #pdQty {
        width:46px; text-align:center; font-weight:700; font-size:.95rem; color:var(--et-text);
        background:transparent !important; box-shadow:none !important; padding:0 !important;
      }

      /* ── HÀNG 3: SỐ LƯỢNG · TẠM TÍNH · CTA ───────────────────────────── */
      .pd-purchase { display:grid; gap:12px; min-width:0; }
      @media (min-width:768px) {
        .pd-purchase { grid-template-columns:auto minmax(0,1fr); align-items:center; gap:16px; }
      }
      .pd-buy {
        background:var(--et-canvas); border-radius:20px; padding:12px 16px;
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
        font-size:1.35rem; font-weight:600; letter-spacing:-.02em; color:var(--et-text); line-height:1.15;
      }
      .pd-buy-sum {
        display:block; margin-top:2px; font-size:.72rem; line-height:1.35; color:var(--et-text-secondary);
      }
      .pd-cta {
        flex:1 1 100%; min-height:54px; padding:0 24px; border-radius:999px;
        display:inline-flex; align-items:center; justify-content:center; gap:9px;
        background:var(--et-primary); color:#FFFFFF; font-size:.94rem; font-weight:700; cursor:pointer;
        box-shadow:0 10px 24px -8px rgba(var(--et-primary-rgb),.55);
        transition:background-color .2s ease, transform .2s ease, opacity .2s ease;
      }
      .pd-cta:hover:not(:disabled) { background:var(--et-primary-hover); transform:translateY(-1px); }
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
          box-shadow:0 -1px 0 rgba(var(--et-dark-rgb),.06), 0 -18px 40px -24px rgba(var(--et-dark-rgb),.35);
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
                <%-- Trạng thái "không dùng được" → màu trung tính xám-xanh nhạt, KHÔNG dùng
                     xanh thương hiệu (sẽ bị đọc nhầm thành "đang bán") và cũng không giữ
                     sắc cam cũ vốn là màu nhấn thương hiệu. --%>
                <span class="font-mono text-[.6rem] font-semibold tracking-[.12em] uppercase text-muted bg-[#E9EEE1] px-3.5 py-1.5 rounded-full">Tạm hết</span>
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

        <!-- ══ CỘT TRÁI: ảnh sản phẩm ══ -->
        <div class="pd-visual">
          <div class="pd-cup-card">

            <div id="pdCupWrap" class="pd-cup">
              <c:choose>
                <c:when test="${not empty product.imageUrl}">
                  <img src="${ctx}${product.imageUrl}" alt="${fn:escapeXml(product.name)}"
                       width="600" height="770" decoding="async" fetchpriority="high"
                       class="pd-cup-img">
                </c:when>
                <c:otherwise>
                  <%-- Chưa có ảnh: ly vẽ bằng CSS, cùng kiểu với thẻ sản phẩm ở khu danh sách --%>
                  <span class="pd-cup-fallback" role="img" aria-label="${fn:escapeXml(product.name)}"></span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
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
                    <fmt:formatNumber var="topFullPrice" value="${t.variants[0].price}" type="number" groupingUsed="true"/>
                    <fmt:formatNumber var="topShortPrice" value="${t.variants[0].price / 1000}" type="number" maxFractionDigits="0"/>
                    <label class="pd-top" title="${fn:escapeXml(t.name)} · +${topFullPrice}đ"
                           ${ts.index ge 4 ? 'data-extra="1"' : ''}>
                      <input type="checkbox" class="pd-top-input"
                             data-variant-id="${t.variants[0].variantId}"
                             data-name="${fn:escapeXml(t.name)}"
                             data-price="${t.variants[0].price}">
                      <span class="pd-top-wrap">
                        <span class="pd-top-name"><c:out value="${t.name}"/></span>
                        <span class="pd-top-price pd-mono tnum">+${topShortPrice}k</span>
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
        <div class="px-6 sm:px-8 py-5" style="box-shadow:0 1px 0 rgba(var(--et-dark-rgb),.06);">
          <h2 class="font-mono text-[.62rem] font-semibold tracking-[.18em] uppercase text-accent m-0">Thông số</h2>
        </div>
        <dl class="m-0 px-6 sm:px-8 py-2">
          <c:if test="${not empty product.categoryName}">
            <div class="flex flex-wrap gap-x-6 gap-y-1 py-3.5" style="box-shadow:0 1px 0 rgba(var(--et-dark-rgb),.05);">
              <dt class="w-40 shrink-0 text-[.84rem] text-muted m-0">Nhóm món</dt>
              <dd class="flex-1 text-[.88rem] text-ink m-0"><c:out value="${product.categoryName}"/></dd>
            </div>
          </c:if>
          <c:if test="${not empty product.variants}">
            <div class="flex flex-wrap gap-x-6 gap-y-1 py-3.5" style="box-shadow:0 1px 0 rgba(var(--et-dark-rgb),.05);">
              <dt class="w-40 shrink-0 text-[.84rem] text-muted m-0">Dung tích</dt>
              <dd class="flex-1 text-[.88rem] text-ink m-0">
                <c:forEach var="v" items="${product.variants}" varStatus="vs"><c:out value="${v.sizeLabel}"/><c:if test="${!vs.last}"> · </c:if></c:forEach>
              </dd>
            </div>
          </c:if>
          <c:if test="${fn:containsIgnoreCase(product.categoryName,'trà')}">
            <div class="flex flex-wrap gap-x-6 gap-y-1 py-3.5" style="box-shadow:0 1px 0 rgba(var(--et-dark-rgb),.05);">
              <dt class="w-40 shrink-0 text-[.84rem] text-muted m-0">Nhiệt độ ủ trà</dt>
              <dd class="flex-1 text-[.88rem] text-ink m-0 tnum">92–95°C · ủ mẻ nhỏ, dùng tối đa 4 giờ</dd>
            </div>
          </c:if>
          <div class="flex flex-wrap gap-x-6 gap-y-1 py-3.5" style="box-shadow:0 1px 0 rgba(var(--et-dark-rgb),.05);">
            <dt class="w-40 shrink-0 text-[.84rem] text-muted m-0">Bao bì</dt>
            <dd class="flex-1 text-[.88rem] text-ink m-0">
              <%-- Latte có lớp bọt/topping trên mặt (khoai môn, matcha...) — ép màng dễ làm xô lớp
                   mặt khi xé màng, nên dùng giấy chống tràn + nắp + băng keo thay vì ép màng kín. --%>
              <c:choose>
                <c:when test="${product.categoryName == 'Latte'}">Ly PP an toàn thực phẩm, dùng giấy chống tràn, đậy nắp và dán băng keo chắc chắn trước khi giao (không ép màng)</c:when>
                <c:otherwise>Ly PP an toàn thực phẩm, ép màng kín trước khi giao</c:otherwise>
              </c:choose>
            </dd>
          </div>
          <div class="flex flex-wrap gap-x-6 gap-y-1 py-3.5">
            <dt class="w-40 shrink-0 text-[.84rem] text-muted m-0">Pha chế</dt>
            <dd class="flex-1 text-[.88rem] text-ink m-0">
              <c:choose>
                <c:when test="${product.categoryName == 'Latte'}">Pha sau khi nhận đơn · giao 10–15 phút tại TP. Bà Rịa</c:when>
                <c:otherwise>Pha sau khi nhận đơn · giao 20–30 phút tại TP. Bà Rịa</c:otherwise>
              </c:choose>
            </dd>
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
            <c:choose>
              <c:when test="${product.categoryName == 'Latte'}">
                <span class="block text-[.88rem] font-bold text-ink">Giao 10–15 phút</span>
              </c:when>
              <c:otherwise>
                <span class="block text-[.88rem] font-bold text-ink">Giao 20–30 phút</span>
              </c:otherwise>
            </c:choose>
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
            <c:choose>
              <c:when test="${product.categoryName == 'Latte'}">
                <span class="block text-[.88rem] font-bold text-ink">Nắp + băng keo</span>
                <span class="block text-[.76rem] text-muted">Giấy chống tràn, không ép màng</span>
              </c:when>
              <c:otherwise>
                <span class="block text-[.88rem] font-bold text-ink">Ép màng kín</span>
                <span class="block text-[.76rem] text-muted">Không tràn khi di chuyển</span>
              </c:otherwise>
            </c:choose>
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

      /* Ảnh hơi phóng to khi chọn size L, cho cảm giác ly lớn hơn. */
      function paintCup() {
        var size = checkedInput('pdSize');
        var isLarge = size && (size.dataset.size || '').toUpperCase() === 'L';
        if (cupWrap) cupWrap.style.transform = isLarge ? 'scale(1.08)' : 'scale(1)';
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

        // Đọc tuỳ chỉnh đồ uống — gửi kèm đơn hàng chính, topping không có đường/đá/ghi chú.
        var sugarEl = checkedInput('pdSugar');
        var iceEl   = checkedInput('pdIce');
        var noteVal = noteInput ? noteInput.value.trim() : '';
        var customization = {
          sugar: sugarEl ? sugarEl.value : '',
          ice:   iceEl   ? iceEl.value   : '',
          note:  noteVal
        };

        var jobs = [NhietDoiXanhCart.addToCart(size.value, qty, null, customization)];
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
