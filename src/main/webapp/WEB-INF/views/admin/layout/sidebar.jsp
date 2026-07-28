<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Sidebar quản trị — tách riêng khỏi header.jsp để cô lập hoàn toàn khỏi CSS của từng
     trang con. Mỗi trang admin (feedback/list.jsp, orders/list.jsp...) có 1 khối <style>
     riêng nạp SAU header.jsp; tách sidebar ra file này không đổi thứ tự nạp CSS, nhưng
     giữ markup của sidebar ở một chỗ duy nhất, dễ soát lỗi độc lập với nội dung trang.
     Biến "ctx" và "uri" đã được header.jsp c:set trước khi include file này. --%>
<aside class="side-nav" id="sideNav">
  <a href="${ctx}/admin" class="brand">
    <span class="brand-mark">
      <svg viewBox="0 0 24 24"><path d="M17 8C8 10 5.9 16.17 3.82 21.34l1.89.66.95-2.3c.48.17.98.3 1.34.3C19 20 22 3 22 3c-1 2-8 2.25-13 3.25S2 11.5 2 13.5s1.75 3.75 1.75 3.75C7 8 17 8 17 8z"/></svg>
    </span>
    <span class="brand-txt">Eight Tea<small>Quản trị</small></span>
  </a>

  <nav class="side-scroll" aria-label="Điều hướng chính">
    <div class="side-group">
      <div class="side-group-label">Tổng quan</div>
      <ul class="side-menu">
        <li><a href="${ctx}/admin" class="side-link ${uri.endsWith('/admin') or uri.contains('dashboard') ? 'active' : ''}"><i class="fa-solid fa-chart-pie"></i> Tổng quan</a></li>
      </ul>
    </div>
    <div class="side-group">
      <div class="side-group-label">Vận hành</div>
      <ul class="side-menu">
        <li><a href="${ctx}/admin/don-hang" class="side-link ${uri.contains('/don-hang') ? 'active' : ''}"><i class="fa-solid fa-cart-shopping"></i> Đơn hàng</a></li>
        <li><a href="${ctx}/admin/san-pham" class="side-link ${uri.contains('/san-pham') ? 'active' : ''}"><i class="fa-solid fa-box"></i> Sản phẩm</a></li>
        <li><a href="${ctx}/admin/phan-hoi" class="side-link ${uri.contains('/phan-hoi') ? 'active' : ''}"><i class="fa-solid fa-comment-dots"></i> Phản hồi</a></li>
      </ul>
    </div>
    <div class="side-group">
      <div class="side-group-label">Hệ thống</div>
      <ul class="side-menu">
        <li><a href="${ctx}/admin/nhan-vien" class="side-link ${uri.contains('/nhan-vien') ? 'active' : ''}"><i class="fa-solid fa-users-gear"></i> Nhân viên</a></li>
        <li><a href="${ctx}/admin/nhat-ky" class="side-link ${uri.contains('/nhat-ky') ? 'active' : ''}"><i class="fa-solid fa-clock-rotate-left"></i> Nhật ký</a></li>
      </ul>
    </div>
  </nav>

  <div class="side-foot">
    <a href="${ctx}/" class="side-link"><i class="fa-solid fa-store"></i> Xem cửa hàng</a>
    <form method="post" action="${ctx}/admin/logout">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <button type="submit" class="side-link"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</button>
    </form>
  </div>
</aside>
