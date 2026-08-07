<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Oops! Có Lỗi Xảy Ra — Eight Tea</title>


    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=${initParam.assetVer}">
<!-- Eight Tea — display + mono (nạp sau cùng để ghi đè token) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/eighttea.css?v=${initParam.assetVer}">
</head>
<body>

<div class="error-page">
    <div class="error-card">
        <div class="error-code">
            <%= response.getStatus() %>
        </div>
        <h1>Oops! Có Lỗi Xảy Ra 😅</h1>
        <p>
            Trang bạn tìm kiếm không tồn tại hoặc đã xảy ra sự cố.
            Hãy quay về trang chủ và thử lại nhé!
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
            <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>
            Quay Về Trang Chủ
        </a>
    </div>
</div>

</body>
</html>
