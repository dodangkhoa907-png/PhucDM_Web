/**
 * Build-time thay cho <script src="https://cdn.tailwindcss.com"> (Play CDN) từng nhúng
 * trực tiếp trong home.jsp / product-list.jsp / product-detail.jsp — 3 trang đó tự biên
 * dịch Tailwind ngay trên trình duyệt mỗi lần tải trang (407KB JS + JIT compile phía
 * client, chặn render, phụ thuộc CDN ngoài). Giờ chạy 1 lần lúc dev (`npm run build:css`),
 * commit thẳng CSS đã build vào src/main/webapp/css/tailwind-built.css như mọi file CSS
 * tĩnh khác — Maven đóng WAR không cần biết gì về Node/Tailwind CLI.
 *
 * Nội dung theme.extend là HỢP (union) của 3 khối tailwind.config từng khai báo riêng lẻ
 * trong 3 trang trên (đã đối chiếu — gần như giống hệt nhau, chỉ khác vài token). Riêng
 * boxShadow.cta có 2 giá trị hơi khác nhau giữa home.jsp và product-list/detail — chọn 1
 * giá trị dùng chung (khác biệt cực nhỏ, không nhận ra bằng mắt thường).
 */
module.exports = {
  corePlugins: { preflight: false },
  content: [
    './src/main/webapp/WEB-INF/views/home.jsp',
    './src/main/webapp/WEB-INF/views/product-list.jsp',
    './src/main/webapp/WEB-INF/views/product-detail.jsp',
    './src/main/webapp/WEB-INF/views/common/customer-header.jsp',
    './src/main/webapp/WEB-INF/views/common/_product-card.jspf',
  ],
  theme: {
    extend: {
      colors: {
        canvas: '#F4F6EF', surface: '#FFFFFF', shade: '#E9EEE1', mist: '#DDE5D2',
        accent: '#477023', 'accent-deep': '#2D531A',
        dark: '#071E07', 'dark-2': '#0D330E', ink: '#071E07', 'ink-2': '#66705E', muted: '#8A9382',
      },
      fontFamily: {
        sans: ['Plus Jakarta Sans', 'system-ui', 'sans-serif'],
        mono: ['IBM Plex Mono', 'ui-monospace', 'monospace'],
      },
      boxShadow: {
        soft: '0 1px 2px rgba(7,30,7,.04), 0 4px 14px rgba(7,30,7,.04)',
        card: '0 2px 4px rgba(7,30,7,.03), 0 14px 34px -12px rgba(7,30,7,.14)',
        float: '0 6px 12px rgba(7,30,7,.04), 0 34px 68px -24px rgba(7,30,7,.26)',
        cta: '0 10px 24px -8px rgba(71,112,35,.55)',
      },
    },
  },
  plugins: [],
};
