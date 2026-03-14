<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>VOCA SPEED QUIZ</title>
    <link rel="stylesheet" href="/css/quiz.css">
</head>
<body>
<div class="quiz-container">
    <div class="timer-bar"><div id="timer-progress"></div></div>
    <div id="timer-text">남은 시간: <span id="seconds">10</span>초</div>

    <div class="word">${word.word}</div>

    <c:forEach var="opt" items="${options}">
        <button class="option-btn" onclick="checkAnswer(this, '${opt.meaning}', '${word.meaning}')">
                ${opt.meaning}
        </button>
    </c:forEach>
</div>

<script>
    let timeLeft = 10;
    const timerBar = document.getElementById('timer-progress');
    const timerText = document.getElementById('seconds');

    // 1. 타이머 작동
    const countdown = setInterval(() => {
        timeLeft--;
        timerText.innerText = timeLeft;
        timerBar.style.width = (timeLeft * 10) + "%";

        if(timeLeft <= 0) {
            clearInterval(countdown);
            alert("시간 초과! 정답은 [ ${word.meaning} ] 입니다.");
            location.reload();
        }
    }, 1000);

    // 2. 정답 체크
    function checkAnswer(btn, selected, correct) {
        clearInterval(countdown); // 클릭하는 순간 타이머 정지

        if (selected === correct) {
            btn.classList.add('correct');
            setTimeout(() => { alert("정답입니다! 🎉"); location.reload(); }, 500);
        } else {
            btn.classList.add('wrong');
            alert("틀렸습니다! 😭 정답은: " + correct);
            location.reload();
        }
    }
</script>
</body>
</html>