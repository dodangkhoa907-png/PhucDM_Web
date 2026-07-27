<%@ page pageEncoding="UTF-8" %>
      </main>
    </div><!-- /.content-col -->
  </div><!-- /.shell -->
</div><!-- /.app-frame -->

<script>
(function () {
  /* Lời chào theo giờ — phải lấy giờ TRÌNH DUYỆT (giờ của người đang xem), không phải
     giờ server vì server có thể ở múi giờ khác. HTML render sẵn "Xin chào" làm mặc
     định nên nếu JS không chạy thì vẫn đọc được chứ không trống. */
  var el = document.getElementById('greetWord');
  if (el) {
    var h = new Date().getHours();
    el.textContent = h < 11 ? 'Chào buổi sáng' : h < 14 ? 'Chào buổi trưa'
                    : h < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';
  }

  /* Sidebar dạng drawer trên màn hẹp: bấm nút bars mở, bấm lớp phủ hoặc Esc để đóng. */
  var toggle = document.getElementById('sideToggle');
  var nav = document.getElementById('sideNav');
  var backdrop = document.getElementById('sideBackdrop');
  if (!toggle || !nav || !backdrop) return;

  function open() { nav.classList.add('open'); backdrop.classList.add('open'); }
  function close() { nav.classList.remove('open'); backdrop.classList.remove('open'); }

  toggle.addEventListener('click', function (e) { e.stopPropagation(); open(); });
  backdrop.addEventListener('click', close);
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') close(); });
  nav.querySelectorAll('a, button[type="submit"]').forEach(function (el2) {
    el2.addEventListener('click', close);
  });
})();
</script>
</body>
</html>
