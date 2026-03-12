<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>퀴즈 설정 - DAY ${dayNum}</title>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', 'Apple SD Gothic Neo', 'Malgun Gothic', sans-serif;
            background: linear-gradient(135deg, #0f0e17 0%, #1a1040 50%, #0d1b2a 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #e2e8f0;
            padding: 20px;
        }

        .back-link {
            position: fixed;
            top: 20px;
            left: 20px;
            color: #64748b;
            text-decoration: none;
            font-size: 13px;
            letter-spacing: 1px;
            transition: color 0.2s;
        }
        .back-link:hover { color: #a78bfa; }

        .card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 20px;
            padding: 44px 40px;
            max-width: 480px;
            width: 100%;
            text-align: center;
            backdrop-filter: blur(10px);
        }

        .day-badge {
            display: inline-block;
            background: linear-gradient(135deg, #7c3aed, #4f46e5);
            color: #fff;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 3px;
            padding: 6px 18px;
            border-radius: 20px;
            margin-bottom: 16px;
        }

        .card-title {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 6px;
            background: linear-gradient(90deg, #a78bfa, #60a5fa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .word-count-info {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 32px;
        }

        .options-title {
            font-size: 11px;
            letter-spacing: 3px;
            color: #475569;
            text-transform: uppercase;
            margin-bottom: 16px;
        }

        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .option-form { display: contents; }

        .option-btn {
            padding: 20px 12px;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.04);
            color: #e2e8f0;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            width: 100%;
        }

        .option-btn:hover:not(:disabled) {
            background: linear-gradient(135deg, #7c3aed55, #4f46e555);
            border-color: #7c3aed;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(124, 58, 237, 0.3);
        }

        .option-btn:disabled {
            opacity: 0.25;
            cursor: not-allowed;
        }

        .option-btn .label { display: block; font-size: 18px; font-weight: 700; }
        .option-btn .sub { display: block; font-size: 11px; color: #64748b; margin-top: 4px; }

        .option-btn.total {
            grid-column: span 2;
            background: linear-gradient(135deg, rgba(124,58,237,0.15), rgba(79,70,229,0.15));
            border-color: rgba(124,58,237,0.3);
        }

        .option-btn.total:hover:not(:disabled) {
            background: linear-gradient(135deg, #7c3aed, #4f46e5);
            border-color: #7c3aed;
        }
    </style>
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
