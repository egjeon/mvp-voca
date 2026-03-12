<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>VOCA SPEED QUIZ</title>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; text-align: center; background-color: #f8f9fa; }
        .quiz-container { max-width: 500px; margin: 50px auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .timer-bar { height: 10px; background: #e0e0e0; border-radius: 5px; margin-bottom: 20px; overflow: hidden; }
        #timer-progress { height: 100%; background: #ff4757; width: 100%; transition: width 1s linear; }
        .word { font-size: 40px; font-weight: bold; margin-bottom: 30px; color: #2f3542; }
        .option-btn { display: block; width: 100%; padding: 15px; margin: 10px 0; border: 2px solid #edeff2; border-radius: 8px; background: white; cursor: pointer; font-size: 18px; transition: 0.2s; }
        .option-btn:hover { background: #f1f2f6; border-color: #ced4da; }
        .correct { background: #2ed573 !important; color: white; border-color: #2ed573; }
        .wrong { background: #ff4757 !important; color: white; border-color: #ff4757; }
    </style>
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