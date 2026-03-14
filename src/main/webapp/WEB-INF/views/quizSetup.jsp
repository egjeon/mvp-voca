<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>퀴즈 설정 - DAY ${dayNum}</title>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    <link rel="stylesheet" href="/css/common.css">
    <link rel="stylesheet" href="/css/quiz-setup.css">
</head>
<body>

<a class="back-link" href="/">← 홈으로</a>

<div class="card">
    <div class="day-badge">DAY ${dayNum}</div>
    <div class="card-title">문제 수 선택</div>
    <div class="word-count-info">총 ${totalCount}개의 단어</div>

    <div class="options-title">몇 문제 풀까요?</div>

    <div class="options-grid">
        <form class="option-form" method="post" action="/quiz/start">
            <input type="hidden" name="dayNum" value="${dayNum}"/>
            <button class="option-btn" type="submit" name="count" value="10" ${totalCount < 10 ? 'disabled' : ''}>
                <span class="label">10문제</span>
                <span class="sub">${totalCount < 10 ? '단어 부족' : '빠른 퀴즈'}</span>
            </button>
        </form>

        <form class="option-form" method="post" action="/quiz/start">
            <input type="hidden" name="dayNum" value="${dayNum}"/>
            <button class="option-btn" type="submit" name="count" value="20" ${totalCount < 20 ? 'disabled' : ''}>
                <span class="label">20문제</span>
                <span class="sub">${totalCount < 20 ? '단어 부족' : '표준 퀴즈'}</span>
            </button>
        </form>

        <form class="option-form" method="post" action="/quiz/start">
            <input type="hidden" name="dayNum" value="${dayNum}"/>
            <button class="option-btn" type="submit" name="count" value="30" ${totalCount < 30 ? 'disabled' : ''}>
                <span class="label">30문제</span>
                <span class="sub">${totalCount < 30 ? '단어 부족' : '심화 퀴즈'}</span>
            </button>
        </form>

        <form class="option-form" method="post" action="/quiz/start">
            <input type="hidden" name="dayNum" value="${dayNum}"/>
            <button class="option-btn total" type="submit" name="count" value="${totalCount}">
                <span class="label">전체 ${totalCount}문제</span>
                <span class="sub">모든 단어 완전 정복</span>
            </button>
        </form>
    </div>
</div>

</body>
</html>
