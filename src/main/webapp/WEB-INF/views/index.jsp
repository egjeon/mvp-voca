<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MVP VOCA QUIZ</title>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', 'Apple SD Gothic Neo', 'Malgun Gothic', sans-serif;
            background: linear-gradient(135deg, #0f0e17 0%, #1a1040 50%, #0d1b2a 100%);
            min-height: 100vh;
            color: #e2e8f0;
        }

        .header {
            text-align: center;
            padding: 48px 20px 32px;
        }

        .logo {
            display: inline-block;
            font-size: 42px;
            font-weight: 800;
            letter-spacing: 4px;
            background: linear-gradient(90deg, #a78bfa, #60a5fa, #34d399);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .subtitle {
            font-size: 14px;
            letter-spacing: 6px;
            color: #64748b;
            text-transform: uppercase;
        }

        .divider {
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, #7c3aed, #3b82f6);
            margin: 16px auto;
            border-radius: 2px;
        }

        .section-title {
            text-align: center;
            font-size: 13px;
            letter-spacing: 3px;
            color: #475569;
            text-transform: uppercase;
            margin-bottom: 24px;
        }

        .grid-container {
            max-width: 860px;
            margin: 0 auto;
            padding: 0 20px 60px;
        }

        .days-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 10px;
        }

        @media (max-width: 600px) {
            .days-grid { grid-template-columns: repeat(4, 1fr); }
            .logo { font-size: 30px; }
        }
        @media (max-width: 400px) {
            .days-grid { grid-template-columns: repeat(3, 1fr); }
        }

        .day-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 12px 6px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 1px;
            text-decoration: none;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
        }

        .day-num-label {
            font-size: 9px;
            letter-spacing: 1px;
            opacity: 0.7;
            margin-bottom: 2px;
        }

        .day-num-val {
            font-size: 16px;
            font-weight: 700;
        }

        .day-btn.active {
            background: linear-gradient(135deg, #7c3aed, #4f46e5);
            color: #fff;
            box-shadow: 0 4px 15px rgba(124, 58, 237, 0.35);
        }

        .day-btn.active:hover {
            transform: translateY(-3px) scale(1.04);
            box-shadow: 0 8px 24px rgba(124, 58, 237, 0.55);
        }

        .day-btn.locked {
            background: #1e1e30;
            color: #374151;
            cursor: not-allowed;
            border: 1px solid #2d2d45;
        }

        .lock-icon {
            font-size: 10px;
            margin-top: 2px;
            opacity: 0.4;
        }

        .footer {
            text-align: center;
            padding: 20px;
            color: #334155;
            font-size: 12px;
            letter-spacing: 1px;
        }
    </style>
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
