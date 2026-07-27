<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- scope="request" BẮT BUỘC: <jsp:include> tạo PageContext riêng cho mỗi file được
     include, nên <c:set> mặc định (phạm vi "page") KHÔNG truyền được qua include —
     kể cả include lồng 2 lớp (dashboard.jsp include header.jsp, header.jsp include
     sidebar.jsp) lẫn ngược lại (biến set trong header.jsp không thấy được ở
     dashboard.jsp sau khi include xong). Đã kiểm chứng lỗi này bằng test thật trên
     server: để scope mặc định, ${ctx} luôn rỗng bên ngoài chính header.jsp. Phạm vi
     "request" dùng chung HttpServletRequest nên mọi include (2 chiều, mọi độ sâu)
     đều thấy được. --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<c:set var="uri" value="${requestScope['jakarta.servlet.forward.servlet_path']}" scope="request"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="${pageContext.request.contextPath}">
    <title>Eight Tea · Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <%-- Cùng bộ chữ với khu khách hàng: Plus Jakarta Sans cho thân, IBM Plex Mono cho
         nhãn/số liệu — giữ admin và storefront đọc như một thương hiệu. --%>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ═══════════════════════════════════════════════════════════════════
           EIGHT TEA · ADMIN — hệ thiết kế
           Khung trắng bo tròn nổi trên nền kem, nav dạng pill, thẻ số liệu bento.
           Đúng bảng màu của khu khách hàng (eighttea.css) chứ không phải da xanh lá cũ.

           LƯU Ý QUAN TRỌNG: các biến --admin-* GIỮ NGUYÊN TÊN như bản cũ, chỉ đổi giá
           trị. Mỗi trang admin có một khối <style> riêng tham chiếu các biến này, nên
           đổi tên biến sẽ làm 9 trang mất màu cùng lúc; đổi giá trị thì tất cả tự
           khoác da mới mà không phải sửa từng trang.
           ═══════════════════════════════════════════════════════════════════ */
        :root{
            /* Nền & bề mặt */
            --admin-bg:#F2EBE1;          /* nền trang (kem đậm hơn khung) */
            --admin-surface:#FFFFFF;     /* khung/thẻ */
            --admin-soft:#FAF6F0;        /* nền lõm nhẹ trong thẻ */
            --admin-mist:#EFE7DC;

            /* Caramel — màu điểm nhấn duy nhất */
            --admin-primary:#D2691E;
            --admin-primary-hover:#A9531A;
            --admin-primary-soft:#F7EADC;
            --admin-gold:#E08B45;

            /* Mực */
            --admin-text:#2B2625;
            --admin-text-2:#6B615C;
            --admin-text-light:#9C918B;
            --admin-border:#EFE7DC;

            /* Dải tối (giữ để trang nào cần vẫn dùng được) */
            --admin-dark:#120E0C;
            --admin-dark-2:#1C1614;

            --admin-red:#C2543F;
            --admin-green:#2F7A4F;

            /* Màu trạng thái đơn — chuyển sang tông ấm cho hợp bảng màu mới */
            --status-pending:#D2691E;--status-confirmed:#3E6BB8;--status-shipping:#7A5AF8;
            --status-done:#2F7A4F;--status-cancelled:#C2543F;

            /* Bí danh cho font: --fd (display) & --fb (body) đều là Plus Jakarta Sans,
               giữ tên cũ vì các trang con còn tham chiếu. --fm dành cho số liệu/nhãn. */
            --fd:'Plus Jakarta Sans',system-ui,sans-serif;
            --fb:'Plus Jakarta Sans',system-ui,sans-serif;
            --fm:'IBM Plex Mono',ui-monospace,monospace;

            --r-lg:26px;--r-md:18px;--r-sm:12px;
            --sh-soft:0 1px 2px rgba(43,38,37,.04), 0 4px 14px rgba(43,38,37,.04);
            --sh-card:0 2px 4px rgba(43,38,37,.03), 0 14px 34px -12px rgba(43,38,37,.14);
            --sh-cta:0 10px 24px -8px rgba(210,105,30,.5);
            --ease:cubic-bezier(.22,1,.36,1);
        }
        *{margin:0;padding:0;box-sizing:border-box;font-family:var(--fb)}
        body{background:var(--admin-bg);color:var(--admin-text-2);-webkit-font-smoothing:antialiased;font-size:14.5px}
        a{text-decoration:none}
        .tnum{font-variant-numeric:tabular-nums}
        ::-webkit-scrollbar{width:9px;height:9px}
        ::-webkit-scrollbar-thumb{background:#DCD2C6;border-radius:9px}
        ::-webkit-scrollbar-track{background:transparent}

        /* ── Khung ứng dụng: nền kem chừa lề, khung trắng bo tròn nổi lên ─────────
           KHÔNG dùng overflow:hidden ở đây: nếu để, mọi trang có bảng dài (đơn hàng,
           sản phẩm...) sẽ bị CẮT MẤT phần cuối khi nội dung cao hơn 1 màn hình, vì
           .shell chỉ có min-height chứ không co giãn theo nội dung thật. Bỏ overflow
           để trang dài tự đẩy chiều cao .shell ra, cuộn ở cấp document như bình thường;
           bo góc vẫn hiển thị đúng vì border-radius không phụ thuộc overflow. */
        .app-frame{padding:14px;min-height:100vh}
        .shell{
            background:var(--admin-surface);border-radius:var(--r-lg);
            box-shadow:var(--sh-card);min-height:calc(100vh - 28px);
            display:flex;
        }

        /* ═══════════════════════════════════════════════════════════════════
           SIDEBAR — markup thật nằm ở sidebar.jsp (tách riêng, xem file đó).
           Nền nâu đen ủ trà (--admin-dark) — cùng token đang dùng cho dải tối
           bên khách hàng (hero, footer), không phải màu bịa mới. Vẫn sticky +
           min-height riêng (không stretch theo .shell): panel tối luôn cao gần
           hết màn hình (đúng cảm giác "thanh sidebar" bạn muốn), nhưng KHÔNG
           dùng flex đẩy "Đăng xuất" tuột xuống tận đáy — footer nằm ngay sau
           menu, khoảng trống (nếu có) rơi xuống DƯỚI footer, không còn kẹp giữa
           menu và footer như bản stretch cũ (nhìn giống lỗi trôi ra ngoài).
           border-radius riêng ở 2 góc trái để khớp góc bo của .shell — bắt buộc
           phải khai báo tường minh vì .shell không còn overflow:hidden (bỏ để
           trang dài không bị cắt mất nội dung), nên con không tự động bị "gọt"
           theo góc bo của cha nữa.
           Mục đang chọn "khoét" sáng đúng màu nền TRANG (--admin-bg) — tạo hiệu
           ứng đèn rọi rõ ràng trên nền tối, dễ nhận biết hơn hẳn nav pill cũ.
           Vạch caramel + đổi màu icon là lớp bảo hiểm thứ hai. */
        .side-nav{
            width:236px;flex:none;align-self:flex-start;position:sticky;top:14px;
            display:flex;flex-direction:column;padding:22px 14px 16px;
            min-height:calc(100vh - 28px);max-height:calc(100vh - 28px);
            background:var(--admin-dark);border-radius:var(--r-lg) 0 0 var(--r-lg);
            color:rgba(255,255,255,.72);
        }
        .brand{display:flex;align-items:center;gap:11px;flex:none;padding:0 10px;margin-bottom:26px}
        .brand-mark{
            width:38px;height:38px;border-radius:12px;background:var(--admin-primary);
            display:grid;place-items:center;flex:none;box-shadow:var(--sh-cta);
        }
        .brand-mark svg{width:19px;height:19px;fill:#fff}
        .brand-txt{font-weight:800;font-size:15.5px;letter-spacing:-.02em;color:#F5EFE7;line-height:1.15}
        .brand-txt small{display:block;font-family:var(--fm);font-size:9.5px;font-weight:500;letter-spacing:.16em;text-transform:uppercase;color:rgba(255,255,255,.4)}

        .side-scroll{flex:none;overflow-y:auto;max-height:100%}
        .side-group{margin-bottom:6px}
        .side-group-label{
            padding:14px 14px 8px;font-family:var(--fm);font-size:10px;font-weight:500;
            letter-spacing:.14em;text-transform:uppercase;color:rgba(255,255,255,.35);
        }
        .side-menu{list-style:none;display:flex;flex-direction:column;gap:2px}
        .side-link{
            position:relative;display:flex;align-items:center;gap:12px;
            padding:11px 14px 11px 17px;border-radius:13px;
            font-size:13.8px;font-weight:600;color:rgba(255,255,255,.72);
            transition:background .2s var(--ease),color .2s var(--ease);
        }
        .side-link i{width:16px;flex:none;text-align:center;font-size:14.5px;color:rgba(255,255,255,.4);transition:color .2s var(--ease)}
        .side-link:hover{background:rgba(255,255,255,.08);color:#fff}
        .side-link.active{background:var(--admin-bg);color:var(--admin-primary-hover);font-weight:700}
        .side-link.active i{color:var(--admin-primary)}
        .side-link.active::before{
            content:'';position:absolute;left:2px;top:9px;bottom:9px;width:3.5px;
            border-radius:4px;background:var(--admin-primary);
        }

        /* margin-top:auto đẩy footer xuống đáy hộp tối (đã cao sẵn nhờ min-height ở
           .side-nav) — khác bản trắng lúc trước ở chỗ: giờ khoảng trống đó không
           còn là "vùng trắng trống bất thường" nữa, mà là NỀN TỐI LIỀN MỘT KHỐI,
           nên nhìn như một thanh sidebar đặc, không giống lỗi trôi ra ngoài như
           bản cũ (khi đó khoảng trống cùng màu trắng với nội dung bên cạnh nên
           trông tách rời, lạc lõng). */
        .side-foot{flex:none;margin-top:auto;padding-top:12px;border-top:1px solid rgba(255,255,255,.1)}
        .side-foot .side-link{color:rgba(255,255,255,.72)}
        .side-foot form{margin:0}
        .side-foot button.side-link{width:100%;border:none;background:none;cursor:pointer;font-family:var(--fb);text-align:left}
        .side-foot button.side-link:hover{background:rgba(217,83,79,.16);color:#FF9B93}
        .side-foot button.side-link:hover i{color:#FF9B93}

        /* ── Cột nội dung: topbar rút gọn (mobile toggle + người dùng) + main ──── */
        .content-col{flex:1;display:flex;flex-direction:column;min-width:0}
        .topbar{display:flex;align-items:center;gap:14px;padding:16px 24px 0}
        .top-right{display:flex;align-items:center;gap:9px;flex:none;margin-left:auto}
        .ic-btn{
            width:40px;height:40px;border-radius:13px;background:var(--admin-soft);border:none;
            display:grid;place-items:center;color:var(--admin-text-2);font-size:15px;
            cursor:pointer;transition:background .2s var(--ease),color .2s var(--ease);
        }
        .ic-btn:hover{background:var(--admin-mist);color:var(--admin-text)}
        .admin-user{display:flex;align-items:center;gap:10px;padding:5px 6px 5px 13px;background:var(--admin-soft);border-radius:999px}
        .admin-user .u-name{font-weight:700;font-size:13px;line-height:1.2;color:var(--admin-text)}
        .admin-user .u-role{font-family:var(--fm);font-size:10px;font-weight:500;letter-spacing:.1em;text-transform:uppercase;color:var(--admin-text-light)}
        .admin-user .u-avatar{
            width:36px;height:36px;border-radius:50%;display:grid;place-items:center;
            background:var(--admin-primary);color:#fff;font-weight:800;font-size:14.5px;
            text-transform:uppercase;flex:none;
        }

        /* ── Vùng nội dung ─────────────────────────────────────────────────────── */
        .main-content{flex:1;padding:6px 26px 34px;min-width:0}

        /* Tiêu đề trang cỡ lớn — nhịp mở đầu giống bảng điều khiển trong ảnh mẫu */
        .page-head{display:flex;align-items:flex-end;justify-content:space-between;gap:18px;flex-wrap:wrap;margin:14px 0 24px}
        .page-head h1{font-size:clamp(1.5rem,2.6vw,2rem);font-weight:800;letter-spacing:-.03em;color:var(--admin-text);line-height:1.15}
        .page-head p{font-size:13.5px;color:var(--admin-text-light);margin-top:5px}
        .page-head-actions{display:flex;align-items:center;gap:9px;flex-wrap:wrap}

        /* ── Thẻ ───────────────────────────────────────────────────────────────── */
        .card{background:var(--admin-surface);border-radius:var(--r-md);padding:22px;box-shadow:var(--sh-soft);margin-bottom:18px}
        .card h3{font-size:15.5px;font-weight:800;letter-spacing:-.02em;color:var(--admin-text);margin-bottom:3px}

        /* Thẻ đặt trên nền trắng của shell cần nền kem để tách lớp (không dùng viền) */
        .main-content > .card,
        .card{background:var(--admin-soft)}

        /* ── Nút ───────────────────────────────────────────────────────────────── */
        .btn{
            padding:11px 20px;border-radius:999px;font-weight:700;font-size:13.5px;cursor:pointer;
            border:none;transition:background .2s var(--ease),transform .2s var(--ease);
            display:inline-flex;align-items:center;gap:8px;font-family:var(--fb);
        }
        .btn-primary{background:var(--admin-primary);color:#fff;box-shadow:var(--sh-cta)}
        .btn-primary:hover{background:var(--admin-primary-hover);transform:translateY(-1px)}
        .btn-danger{background:var(--admin-red);color:#fff}
        .btn-danger:hover{transform:translateY(-1px)}
        .btn-outline{background:var(--admin-surface);color:var(--admin-text);box-shadow:var(--sh-soft)}
        .btn-outline:hover{background:var(--admin-mist);transform:translateY(-1px)}

        /* ── Bảng ──────────────────────────────────────────────────────────────── */
        .table-responsive{overflow-x:auto}
        .admin-table{width:100%;border-collapse:collapse}
        .admin-table th,.admin-table td{padding:14px 16px;text-align:left}
        .admin-table th{
            font-family:var(--fm);color:var(--admin-text-light);font-weight:500;font-size:10.5px;
            text-transform:uppercase;letter-spacing:.14em;white-space:nowrap;
        }
        .admin-table thead tr{background:var(--admin-surface)}
        .admin-table thead th:first-child{border-radius:12px 0 0 12px}
        .admin-table thead th:last-child{border-radius:0 12px 12px 0}
        .admin-table td{font-size:13.8px;font-weight:500;color:var(--admin-text-2);box-shadow:inset 0 -1px 0 rgba(43,38,37,.05)}
        .admin-table tbody tr{transition:background .15s var(--ease)}
        .admin-table tbody tr:hover{background:var(--admin-surface)}
        .admin-table tbody tr:last-child td{box-shadow:none}

        /* ── Tab điều hướng phụ (đơn hàng, nhân viên...) ────────────────────────── */
        .admin-tabs{display:flex;flex-wrap:wrap;gap:4px;background:var(--admin-surface);padding:5px;border-radius:999px;margin-bottom:20px;box-shadow:var(--sh-soft)}
        .admin-tab{
            display:inline-flex;align-items:center;gap:8px;padding:10px 16px;border-radius:999px;
            font-size:13.5px;font-weight:600;color:var(--admin-text-2);
            transition:background .18s var(--ease),color .18s var(--ease);
        }
        .admin-tab:hover{background:var(--admin-soft);color:var(--admin-text)}
        .admin-tab.active{background:var(--admin-primary);color:#fff;font-weight:700;box-shadow:var(--sh-cta)}
        .admin-tab-count{
            min-width:21px;padding:2px 7px;border-radius:999px;background:var(--admin-soft);
            color:var(--admin-text-light);font-family:var(--fm);font-size:11px;font-weight:600;text-align:center;
        }
        .admin-tab.active .admin-tab-count{background:rgba(255,255,255,.24);color:#fff}

        /* ── Nhãn trạng thái: chấm màu + chữ, đúng kiểu bảng trong ảnh mẫu ──────── */
        .badge{
            padding:5px 12px 5px 10px;border-radius:999px;font-size:11.5px;font-weight:700;
            display:inline-flex;align-items:center;gap:7px;white-space:nowrap;
        }
        .badge::before{content:'';width:6px;height:6px;border-radius:50%;background:currentColor;flex:none}
        .badge-PENDING{background:#F7EADC;color:#A9531A}
        .badge-CONFIRMED{background:#E9EFFA;color:#3E6BB8}
        .badge-SHIPPING{background:#EEEAFD;color:#6B4AE0}
        .badge-DONE{background:#E7F3EC;color:#2F7A4F}
        .badge-AWAITING_CONFIRM{background:#E2F2F1;color:#0F8F87}
        .badge-CANCELLED{background:#F9E9E6;color:#C2543F}
        .badge-PENDING_CANCEL{background:#F9E9E6;color:#B9432E}
        .badge-NEW{background:#F7EADC;color:#A9531A}
        .badge-SEEN{background:#E9EFFA;color:#3E6BB8}
        .badge-RESOLVED{background:#E7F3EC;color:#2F7A4F}
        .badge-UNPAID{background:#F0EDEA;color:#6B615C}
        .badge-PAID{background:#E7F3EC;color:#2F7A4F}
        .badge-FAILED{background:#F9E9E6;color:#C2543F}
        .badge-REFUND_PENDING{background:#F7EADC;color:#A9531A}

        /* ── Biểu mẫu — nền lõm thay cho viền, đồng bộ khu khách hàng ───────────── */
        .form-group{margin-bottom:18px}
        .form-group label{display:block;margin-bottom:7px;font-weight:600;font-size:13px;color:var(--admin-text)}
        .form-control{
            width:100%;padding:12px 16px;border:none;border-radius:14px;background:var(--admin-surface);
            font-size:14px;color:var(--admin-text);font-family:var(--fb);
            box-shadow:var(--sh-soft);transition:box-shadow .2s var(--ease);
        }
        .form-control:focus{outline:none;box-shadow:0 0 0 3px rgba(210,105,30,.3)}

        /* ── Ràng buộc "không viền" của design system ──────────────────────────
           Phân tầng bằng nền + bóng, không dùng đường kẻ. Buộc phải có !important:
           mỗi trang admin có khối <style> riêng được nạp SAU khối này, nên các khai
           báo `border:1px solid var(--admin-border)` còn sót từ da cũ sẽ thắng nếu
           chỉ ghi đè bằng specificity thường. */
        .main-content input,.main-content select,.main-content textarea{
            border:none !important;border-radius:12px;font-family:var(--fb);color:var(--admin-text);
        }
        .main-content input:not([type=checkbox]):not([type=radio]),
        .main-content select,.main-content textarea{
            background:var(--admin-surface);box-shadow:var(--sh-soft);
        }
        .main-content input:focus,.main-content select:focus,.main-content textarea:focus{
            outline:none;box-shadow:0 0 0 3px rgba(210,105,30,.3);
        }
        /* Khối/thẻ trong trang con: bỏ viền, giữ nền + bo góc sẵn có của chúng */
        .main-content .card,.main-content [class*="-zone"],.main-content [class*="-ticket"],
        .main-content [class*="-row"],.main-content [class*="-modal"],.main-content [class*="-map"]{
            border:none !important;
        }

        a:focus-visible,button:focus-visible,input:focus-visible,select:focus-visible,textarea:focus-visible{
            outline:3px solid rgba(210,105,30,.45);outline-offset:2px;
        }

        .mobile-only{display:none}

        /* ── Mobile: sidebar biến thành drawer trượt từ trái, có lớp phủ ────────── */
        @media(max-width:900px){
            .app-frame{padding:8px}
            .shell{border-radius:20px;min-height:calc(100vh - 16px);position:relative}
            .mobile-only{display:grid}
            .topbar{padding:14px 16px 0}
            .admin-user .u-meta{display:none}

            .side-nav{
                position:fixed;top:0;left:0;bottom:0;z-index:200;width:260px;
                background:var(--admin-dark);box-shadow:var(--sh-card);border-radius:0;
                min-height:0;max-height:none;
                transform:translateX(-100%);transition:transform .28s var(--ease);
                padding-top:18px;
            }
            .side-nav.open{transform:none}
            .side-backdrop{
                display:none;position:fixed;inset:0;background:rgba(18,14,12,.35);
                z-index:190;
            }
            .side-backdrop.open{display:block}
            .main-content{padding:4px 14px 30px}
        }
        @media(prefers-reduced-motion:reduce){
            *{transition-duration:.01ms !important;animation-duration:.01ms !important}
        }
    </style>
</head>
<body>
<div class="app-frame">
  <div class="shell">

    <div class="side-backdrop" id="sideBackdrop"></div>

    <jsp:include page="/WEB-INF/views/admin/layout/sidebar.jsp" />

    <div class="content-col">
      <header class="topbar">
        <button type="button" class="ic-btn mobile-only" id="sideToggle" aria-label="Mở menu">
          <i class="fa-solid fa-bars"></i>
        </button>

        <div class="top-right">
          <div class="admin-user">
            <div class="u-meta">
              <div class="u-name"><c:out value="${requestScope.adminUser.fullName}"/></div>
              <div class="u-role"><c:out value="${fn:toLowerCase(requestScope.adminUser.role)}"/></div>
            </div>
            <div class="u-avatar" aria-hidden="true"><c:out value="${not empty requestScope.adminUser.fullName ? fn:substring(requestScope.adminUser.fullName, 0, 1) : 'A'}"/></div>
          </div>
        </div>
      </header>

      <main class="main-content">
