package com.eighttea.util;

import java.text.Normalizer;
import java.util.regex.Pattern;

/** Tạo slug URL-friendly từ chuỗi tiếng Việt có dấu (Categories/Products không lưu cột Slug riêng). */
public final class Slugs {

    private static final Pattern DIACRITICS = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
    private static final Pattern NON_ALNUM = Pattern.compile("[^a-z0-9]+");

    private Slugs() { }

    public static String of(String input) {
        if (input == null || input.isBlank()) return "";
        String lower = stripDiacritics(input.trim()).toLowerCase();
        String slug = NON_ALNUM.matcher(lower).replaceAll("-");
        return slug.replaceAll("^-+|-+$", "");
    }

    /**
     * Bỏ dấu tiếng Việt (NFD + xoá dấu kết hợp, "đ/Đ" xử lý riêng vì không tách dấu qua
     * NFD). Dùng cho tìm kiếm không phân biệt dấu — ví dụ gõ "tra" vẫn khớp "Trà" — vì cột
     * ProductName trong SQL Server đang ở collation accent-sensitive (LIKE không tự bỏ
     * dấu), nên phải chuẩn hoá ở tầng Java trước khi so khớp.
     */
    public static String stripDiacritics(String input) {
        if (input == null) return "";
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        String noDiacritics = DIACRITICS.matcher(normalized).replaceAll("");
        return noDiacritics.replace('đ', 'd').replace('Đ', 'D');
    }
}
