<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="vi_VN"/>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
/* ═══ Lưới bento: hàng trên 3 khối, hàng dưới cột phụ + bảng ═══════════════ */
.dash{display:grid;grid-template-columns:repeat(12,1fr);gap:16px;align-items:start}
.g-hero{grid-column:span 3}
.g-stats{grid-column:span 4}
.g-chart{grid-column:span 5}
.g-side{grid-column:span 3}
.g-table{grid-column:span 9}
@media(max-width:1240px){
  .g-hero{grid-column:span 5}.g-stats{grid-column:span 7}
  .g-chart{grid-column:span 12}.g-side{grid-column:span 5}.g-table{grid-column:span 7}
}
@media(max-width:900px){
  .g-hero,.g-stats,.g-chart,.g-side,.g-table{grid-column:span 12}
}

.blk{background:var(--admin-soft);border-radius:var(--r-md);padding:20px}
.blk-h{font-size:14.5px;font-weight:800;letter-spacing:-.02em;color:var(--admin-text)}
.blk-sub{font-family:var(--fm);font-size:10px;font-weight:500;letter-spacing:.14em;text-transform:uppercase;color:var(--admin-text-light);margin-top:4px}

/* Nhãn nhỏ dạng datasheet — dùng lại ngôn ngữ chữ của khu khách hàng */
.stat-lbl{font-family:var(--fm);font-size:10px;font-weight:500;letter-spacing:.15em;text-transform:uppercase;color:var(--admin-text-light)}
.stat-num{font-size:1.85rem;font-weight:800;letter-spacing:-.035em;color:var(--admin-text);line-height:1.05;margin-top:9px}
.stat-foot{font-size:12px;color:var(--admin-text-light);margin-top:6px}

/* Chip biến động */
.delta{display:inline-flex;align-items:center;gap:5px;font-family:var(--fm);font-size:11px;font-weight:600;padding:4px 10px;border-radius:999px}
.delta.up{background:#E7F3EC;color:#2F7A4F}
.delta.down{background:#F9E9E6;color:#C2543F}
.delta.flat{background:var(--admin-mist);color:var(--admin-text-light)}

/* ── Khối doanh thu (hero) ─────────────────────────────────────────────── */
.hero-card{background:var(--admin-soft);border-radius:var(--r-md);padding:22px;display:flex;flex-direction:column;gap:2px}
.hero-num{font-size:clamp(1.7rem,3vw,2.15rem);font-weight:800;letter-spacing:-.04em;color:var(--admin-text);line-height:1.02;margin:12px 0 4px}
.hero-num sup{font-size:.44em;font-weight:700;margin-left:2px;vertical-align:super}
.hero-actions{display:flex;gap:8px;margin-top:18px;flex-wrap:wrap}
.hero-actions .btn{padding:10px 17px;font-size:12.5px}

/* ── 4 ô số liệu (1 ô caramel làm điểm nhấn duy nhất) ──────────────────── */
.stat-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;height:100%}
.stat-box{background:var(--admin-soft);border-radius:var(--r-md);padding:18px;display:flex;flex-direction:column}
.stat-box.accent{background:var(--admin-primary);box-shadow:var(--sh-cta)}
.stat-box.accent .stat-lbl{color:rgba(255,255,255,.72)}
.stat-box.accent .stat-num{color:#fff}
.stat-box.accent .stat-foot{color:rgba(255,255,255,.75)}
.stat-ic{width:34px;height:34px;border-radius:11px;display:grid;place-items:center;font-size:14px;background:var(--admin-surface);color:var(--admin-primary);margin-bottom:14px}
.stat-box.accent .stat-ic{background:rgba(255,255,255,.2);color:#fff}

/* Thanh tiến độ tỷ lệ thành công */
.bar-track{height:6px;border-radius:999px;background:var(--admin-mist);margin-top:12px;overflow:hidden}
.bar-fill{height:100%;border-radius:999px;background:var(--admin-primary)}

/* ── Biểu đồ cột doanh thu theo ngày ───────────────────────────────────── */
.chart-head{display:flex;align-items:flex-start;justify-content:space-between;gap:14px;flex-wrap:wrap;margin-bottom:22px}
.legend{display:flex;align-items:center;gap:14px;font-family:var(--fm);font-size:10px;letter-spacing:.1em;text-transform:uppercase;color:var(--admin-text-light)}
.legend i{width:9px;height:9px;border-radius:3px;display:inline-block;margin-right:6px;vertical-align:middle}
.bars{display:flex;align-items:flex-end;justify-content:space-between;gap:8px;height:196px}
.bar-col{flex:1;display:flex;flex-direction:column;align-items:center;justify-content:flex-end;height:100%;gap:9px;min-width:0}
.bar-amt{font-family:var(--fm);font-size:10px;font-weight:600;color:var(--admin-text-2);opacity:0;transition:opacity .18s var(--ease);white-space:nowrap}
.bar-col:hover .bar-amt,.bar-col:focus-within .bar-amt{opacity:1}
.bar-shape{width:100%;max-width:30px;border-radius:9px;background:var(--admin-primary-soft);min-height:5px;transition:height .55s var(--ease),background-color .2s var(--ease)}
.bar-col:hover .bar-shape{background:var(--admin-gold)}
.bar-col.today .bar-shape{background:var(--admin-primary)}
.bar-lbl{font-family:var(--fm);font-size:10.5px;font-weight:500;color:var(--admin-text-light);letter-spacing:.06em}
.bar-col.today .bar-lbl{color:var(--admin-primary);font-weight:600}

/* ── Vòng cơ cấu doanh thu ─────────────────────────────────────────────── */
.donut-wrap{display:flex;flex-direction:column;align-items:center;gap:16px;margin-top:16px}
.donut{width:132px;height:132px;border-radius:50%;position:relative;display:grid;place-items:center;background:var(--admin-mist)}
.donut::after{content:'';position:absolute;inset:19px;background:var(--admin-soft);border-radius:50%}
.donut-c{position:relative;z-index:1;text-align:center}
.donut-c b{display:block;font-size:19px;font-weight:800;color:var(--admin-text);letter-spacing:-.02em}
.donut-c span{font-family:var(--fm);font-size:9px;letter-spacing:.14em;text-transform:uppercase;color:var(--admin-text-light)}
.legend-list{width:100%;display:flex;flex-direction:column;gap:9px;list-style:none}
.legend-list li{display:flex;align-items:center;gap:9px;font-size:12.5px;font-weight:500;color:var(--admin-text-2)}
.legend-list .dot{width:9px;height:9px;border-radius:3px;flex:none}
.legend-list .pct{margin-left:auto;font-family:var(--fm);font-size:11px;font-weight:600;color:var(--admin-text)}

/* ── Top sản phẩm ──────────────────────────────────────────────────────── */
.top-list{display:flex;flex-direction:column;gap:13px;margin-top:16px}
.top-item{display:flex;align-items:center;gap:12px}
.top-rank{width:27px;height:27px;border-radius:9px;display:grid;place-items:center;font-family:var(--fm);font-weight:600;font-size:11.5px;flex:none;background:var(--admin-mist);color:var(--admin-text-2)}
.top-item:first-child .top-rank{background:var(--admin-primary);color:#fff}
.top-info b{display:block;font-size:13.2px;font-weight:700;color:var(--admin-text);line-height:1.3}
.top-info span{font-family:var(--fm);font-size:10.5px;color:var(--admin-text-light);letter-spacing:.06em}

/* ── Rỗng ──────────────────────────────────────────────────────────────── */
.empty{text-align:center;padding:38px 16px;color:var(--admin-text-light)}
.empty i{font-size:30px;opacity:.28;margin-bottom:11px;display:block}
.empty p{font-size:13px}
</style>

<div class="page-head">
  <div>
    <h1><span id="greetWord">Xin chào</span>, <c:out value="${requestScope.adminUser.fullName}"/></h1>
    <p>Theo dõi đơn hàng, doanh thu và những gì cần xử lý ngay hôm nay.</p>
  </div>
  <div class="page-head-actions">
    <a href="${ctx}/admin/don-hang" class="btn btn-outline"><i class="fa-solid fa-list-check"></i> Tất cả đơn</a>
    <a href="${ctx}/admin/san-pham" class="btn btn-primary"><i class="fa-solid fa-box"></i> Quản lý món</a>
  </div>
</div>

<div class="dash">

  <!-- ══ Doanh thu tuần này ══ -->
  <div class="g-hero hero-card">
    <span class="stat-lbl">Doanh thu tuần này</span>
    <div class="hero-num tnum">
      <fmt:formatNumber value="${revenueThisWeek}" type="number" groupingUsed="true"/><sup>đ</sup>
    </div>
    <div>
      <c:choose>
        <c:when test="${revenueChangePct == null}"><span class="delta flat">Tuần đầu tiên</span></c:when>
        <c:when test="${revenueChangePct >= 0}"><span class="delta up"><i class="fa-solid fa-arrow-up"></i> ${revenueChangePct}%</span></c:when>
        <c:otherwise><span class="delta down"><i class="fa-solid fa-arrow-down"></i> ${-revenueChangePct}%</span></c:otherwise>
      </c:choose>
      <span class="stat-foot" style="margin-left:7px">so với tuần trước</span>
    </div>
    <div class="hero-actions">
      <a href="${ctx}/admin/don-hang" class="btn btn-primary"><i class="fa-solid fa-arrow-right-long"></i> Xem đơn hàng</a>
    </div>
  </div>

  <!-- ══ 4 ô số liệu · ô caramel là việc cần làm ngay ══ -->
  <div class="g-stats">
    <div class="stat-grid">

      <%-- Ô nhấn duy nhất của trang. Cố ý KHÔNG dành cho doanh thu: người mở admin
           buổi sáng cần biết "còn bao nhiêu đơn đang chờ mình" trước tiên, đó mới là
           con số đòi hành động. Doanh thu quan trọng nhưng không cần thao tác ngay. --%>
      <div class="stat-box accent">
        <span class="stat-ic"><i class="fa-solid fa-hourglass-half"></i></span>
        <span class="stat-lbl">Đang xử lý</span>
        <span class="stat-num tnum">${processingNow}</span>
        <span class="stat-foot">đơn cần xử lý ngay</span>
      </div>

      <div class="stat-box">
        <span class="stat-ic"><i class="fa-solid fa-cart-shopping"></i></span>
        <span class="stat-lbl">Đơn mới / tuần</span>
        <span class="stat-num tnum">${newOrdersThisWeek}</span>
        <span class="stat-foot">
          <c:choose>
            <c:when test="${newOrdersChangePct == null}">chưa có kỳ trước</c:when>
            <c:when test="${newOrdersChangePct >= 0}">tăng ${newOrdersChangePct}% so tuần trước</c:when>
            <c:otherwise>giảm ${-newOrdersChangePct}% so tuần trước</c:otherwise>
          </c:choose>
        </span>
      </div>

      <div class="stat-box">
        <span class="stat-ic"><i class="fa-solid fa-circle-check"></i></span>
        <span class="stat-lbl">Tỷ lệ thành công</span>
        <span class="stat-num tnum">${successRate}%</span>
        <div class="bar-track"><div class="bar-fill" style="width:${successRate}%"></div></div>
      </div>

      <div class="stat-box">
        <span class="stat-ic"><i class="fa-solid fa-layer-group"></i></span>
        <span class="stat-lbl">Nhóm có doanh thu</span>
        <span class="stat-num tnum">${fn:length(categorySlices)}</span>
        <span class="stat-foot">nhóm món đang bán ra</span>
      </div>

    </div>
  </div>

  <!-- ══ Doanh thu theo ngày ══ -->
  <div class="g-chart blk">
    <div class="chart-head">
      <div>
        <div class="blk-h">Doanh thu theo ngày</div>
        <div class="blk-sub">Tuần này · Thứ 2 → Chủ nhật</div>
      </div>
      <div class="legend">
        <span><i style="background:var(--admin-primary)"></i>Hôm nay</span>
        <span><i style="background:var(--admin-primary-soft)"></i>Ngày khác</span>
      </div>
    </div>
    <c:choose>
      <c:when test="${not empty revenueByDay}">
        <div class="bars">
          <c:forEach var="entry" items="${revenueByDay}">
            <c:set var="pct" value="${maxDayRevenue > 0 ? (entry.value * 100) / maxDayRevenue : 0}"/>
            <div class="bar-col ${entry.key == todayLabel ? 'today' : ''}" tabindex="0">
              <span class="bar-amt"><fmt:formatNumber value="${entry.value}" type="number" groupingUsed="true"/>đ</span>
              <div class="bar-shape" style="height:${pct < 3 ? 3 : pct}%"></div>
              <span class="bar-lbl">${entry.key}</span>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <div class="empty"><i class="fa-regular fa-chart-bar"></i><p>Chưa có doanh thu trong tuần này.</p></div>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- ══ Cột phụ: cơ cấu + top món ══ -->
  <div class="g-side">
    <div class="blk" style="margin-bottom:16px">
      <div class="blk-h">Cơ cấu doanh thu</div>
      <div class="blk-sub">Theo nhóm sản phẩm</div>
      <c:choose>
        <c:when test="${not empty categorySlices}">
          <div class="donut-wrap">
            <div class="donut" id="revenueDonut">
              <div class="donut-c"><b>${fn:length(categorySlices)}</b><span>Nhóm</span></div>
            </div>
            <ul class="legend-list">
              <c:forEach var="s" items="${categorySlices}" varStatus="st">
                <li>
                  <span class="dot" data-slice-color="${st.index}"></span>
                  <c:out value="${s.name}"/>
                  <span class="pct" data-slice-pct="${s.percent}">${s.percent}%</span>
                </li>
              </c:forEach>
            </ul>
          </div>
        </c:when>
        <c:otherwise>
          <div class="empty"><i class="fa-regular fa-chart-pie"></i><p>Chưa có doanh thu để thống kê.</p></div>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="blk">
      <div class="blk-h">Món bán chạy</div>
      <div class="blk-sub">Theo số ly đã bán</div>
      <c:choose>
        <c:when test="${not empty topProducts}">
          <div class="top-list">
            <c:forEach var="p" items="${topProducts}" varStatus="st">
              <div class="top-item">
                <span class="top-rank">${st.index + 1}</span>
                <span class="top-info">
                  <b><c:out value="${p.name}"/></b>
                  <span>${p.quantity} ly</span>
                </span>
              </div>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="empty"><i class="fa-regular fa-lemon"></i><p>Chưa bán được món nào.</p></div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <!-- ══ Đơn hàng gần đây ══ -->
  <div class="g-table blk">
    <div class="chart-head" style="margin-bottom:16px">
      <div>
        <div class="blk-h">Đơn hàng gần đây</div>
        <div class="blk-sub">Cập nhật theo thời gian đặt</div>
      </div>
      <a href="${ctx}/admin/don-hang" class="btn btn-outline" style="padding:9px 16px;font-size:12.5px">
        Xem tất cả <i class="fa-solid fa-arrow-right-long"></i>
      </a>
    </div>
    <c:choose>
      <c:when test="${not empty recentOrders}">
        <div class="table-responsive">
          <table class="admin-table">
            <thead>
              <tr><th>Mã đơn</th><th>Khách hàng</th><th>Tổng tiền</th><th>Trạng thái</th><th>Ngày đặt</th></tr>
            </thead>
            <tbody>
              <c:forEach var="o" items="${recentOrders}">
                <tr>
                  <td><span class="tnum" style="font-family:var(--fm);font-size:12.5px;color:var(--admin-text)">#${o.orderId}</span></td>
                  <td style="font-weight:600;color:var(--admin-text)"><c:out value="${o.customerName}"/></td>
                  <td class="tnum" style="font-weight:700;color:var(--admin-text)"><fmt:formatNumber value="${o.finalAmount}" type="number" groupingUsed="true"/>đ</td>
                  <td><span class="badge badge-${o.orderStatus}"><c:out value="${o.orderStatusLabel}"/></span></td>
                  <td class="tnum" style="font-family:var(--fm);font-size:12px"><fmt:formatDate value="${o.createdAt}" pattern="HH:mm dd/MM/yyyy"/></td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:when>
      <c:otherwise>
        <div class="empty"><i class="fa-regular fa-folder-open"></i><p>Chưa có đơn hàng nào.</p></div>
      </c:otherwise>
    </c:choose>
  </div>

</div>

<script>
(function () {
  var donut = document.getElementById('revenueDonut');
  if (!donut) return;
  /* Dải màu ấm cùng họ caramel — thay bảng màu xanh lá của bản cũ. */
  var colors = ['#D2691E', '#E08B45', '#8C5A2B', '#DFB77C', '#A9531A'];
  var stops = [], cum = 0;
  document.querySelectorAll('[data-slice-color]').forEach(function (dot, i) {
    var pctEl = dot.closest('li').querySelector('[data-slice-pct]');
    var pct = parseFloat(pctEl.getAttribute('data-slice-pct')) || 0;
    var color = colors[i % colors.length];
    dot.style.background = color;
    stops.push(color + ' ' + cum + '% ' + (cum + pct) + '%');
    cum += pct;
  });
  if (stops.length) donut.style.background = 'conic-gradient(' + stops.join(',') + ')';
})();
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
