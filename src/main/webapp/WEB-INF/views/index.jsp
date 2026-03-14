<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MVP VOCA QUIZ</title>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    <link rel="stylesheet" href="/css/common.css">
    <link rel="stylesheet" href="/css/index.css">
</head>
<body>

<div class="header">
    <div class="logo">MVP VOCA</div>
    <div class="divider"></div>
    <div class="subtitle">Vocabulary Quiz</div>
</div>

<div class="grid-container">
    <div class="section-title">DAY 선택</div>
    <div class="days-grid">
        <c:forEach begin="1" end="60" var="dayNum">
            <c:choose>
                <c:when test="${activeDays.contains(dayNum)}">
                    <a class="day-btn active" href="/quiz/setup/${dayNum}">
                        <span class="day-num-label">DAY</span>
                        <span class="day-num-val">${dayNum}</span>
                    </a>
                </c:when>
                <c:otherwise>
                    <div class="day-btn locked">
                        <span class="day-num-label">DAY</span>
                        <span class="day-num-val">${dayNum}</span>
                        <span class="lock-icon">🔒</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
</div>

<div class="footer">MVP VOCA QUIZ &nbsp;·&nbsp; 단어를 정복하라</div>

</body>
</html>
