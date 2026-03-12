<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>퀴즈 - DAY ${dayNum}</title>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', 'Apple SD Gothic Neo', 'Malgun Gothic', sans-serif;
            background: linear-gradient(135deg, #0f0e17 0%, #1a1040 50%, #0d1b2a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #e2e8f0;
            padding: 20px;
        }

        .quiz-wrapper {
            width: 100%;
            max-width: 520px;
        }

        /* ===== QUIZ SCREEN ===== */
        #quiz-screen { animation: fadeIn 0.3s ease; }

        .quiz-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .day-label {
            font-size: 12px;
            letter-spacing: 3px;
            color: #64748b;
            text-transform: uppercase;
        }

        .question-counter {
            font-size: 13px;
            color: #94a3b8;
            font-weight: 600;
        }

        /* Progress dots */
        .progress-dots {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
            justify-content: center;
            margin-bottom: 20px;
        }

        .dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #1e293b;
            transition: background 0.3s;
        }
        .dot.correct { background: #10b981; }
        .dot.wrong   { background: #ef4444; }
        .dot.current { background: #7c3aed; box-shadow: 0 0 6px #7c3aed; }

        /* Timer */
        .timer-container { margin-bottom: 8px; }

        .timer-bar-bg {
            height: 6px;
            background: #1e293b;
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 6px;
        }

        #timer-bar {
            height: 100%;
            width: 100%;
            background: linear-gradient(90deg, #10b981, #34d399);
            border-radius: 3px;
            transition: width 1s linear, background 1s linear;
        }

        .timer-text {
            text-align: right;
            font-size: 13px;
            color: #64748b;
        }

        #timer-num {
            font-weight: 700;
            color: #94a3b8;
        }

        /* Word card */
        .word-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px;
            padding: 32px 24px;
            text-align: center;
            margin-bottom: 16px;
        }

        #word-text {
            font-size: 38px;
            font-weight: 800;
            letter-spacing: 1px;
            color: #f1f5f9;
            margin-bottom: 6px;
        }

        #pos-text {
            font-size: 14px;
            color: #7c3aed;
            font-style: italic;
        }

        /* Options */
        #options-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .option-btn {
            padding: 16px 12px;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.04);
            color: #cbd5e1;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s ease;
            text-align: center;
            word-break: keep-all;
            line-height: 1.4;
        }

        .option-btn:hover:not(:disabled) {
            background: rgba(124, 58, 237, 0.15);
            border-color: rgba(124, 58, 237, 0.4);
            color: #e2e8f0;
        }

        .option-btn:disabled { cursor: not-allowed; }

        .option-btn.correct {
            background: rgba(16, 185, 129, 0.2) !important;
            border-color: #10b981 !important;
            color: #6ee7b7 !important;
        }

        .option-btn.wrong {
            background: rgba(239, 68, 68, 0.2) !important;
            border-color: #ef4444 !important;
            color: #fca5a5 !important;
        }

        /* ===== RESULT SCREEN ===== */
        #result-screen {
            display: none;
            text-align: center;
            animation: fadeIn 0.5s ease;
        }

        .result-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 20px;
            padding: 48px 32px;
        }

        .result-emoji {
            font-size: 64px;
            margin-bottom: 12px;
            display: block;
        }

        .result-grade {
            font-size: 36px;
            font-weight: 900;
            letter-spacing: 2px;
            margin-bottom: 24px;
        }

        .grade-perfect   { color: #fbbf24; }
        .grade-excellent { color: #34d399; }
        .grade-great     { color: #60a5fa; }
        .grade-try       { color: #f97316; }
        .grade-study     { color: #f87171; }

        .result-percent {
            font-size: 64px;
            font-weight: 800;
            background: linear-gradient(90deg, #a78bfa, #60a5fa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .result-score {
            font-size: 16px;
            color: #64748b;
            margin-bottom: 36px;
        }

        .result-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .btn-action {
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            border: none;
            transition: all 0.2s;
        }

        .btn-home {
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.1);
            color: #94a3b8;
        }
        .btn-home:hover { background: rgba(255,255,255,0.1); color: #e2e8f0; }

        .btn-retry {
            background: linear-gradient(135deg, #7c3aed, #4f46e5);
            color: #fff;
            box-shadow: 0 4px 15px rgba(124, 58, 237, 0.4);
        }
        .btn-retry:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(124, 58, 237, 0.6); }

        .hidden { display: none !important; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            15%       { transform: translateX(-6px) rotate(-0.5deg); }
            30%       { transform: translateX(6px) rotate(0.5deg); }
            45%       { transform: translateX(-5px); }
            60%       { transform: translateX(5px); }
            75%       { transform: translateX(-3px); }
            90%       { transform: translateX(3px); }
        }

        @keyframes danger-pulse {
            0%, 100% { transform: scale(1); box-shadow: 0 0 0 rgba(239,68,68,0); }
            50%       { transform: scale(1.012); box-shadow: 0 0 28px rgba(239,68,68,0.35); }
        }

        @keyframes vignette-pulse {
            0%, 100% { opacity: 0.5; }
            50%       { opacity: 1; }
        }

        /* 위험 상태 오버레이 */
        #danger-vignette {
            pointer-events: none;
            position: fixed;
            inset: 0;
            background: radial-gradient(ellipse at center, transparent 40%, rgba(200,0,0,0.55) 100%);
            opacity: 0;
            transition: opacity 0.4s ease;
            z-index: 999;
        }

        body.danger-low  #danger-vignette { opacity: 0.45; animation: vignette-pulse 1s ease-in-out infinite; }
        body.danger-high #danger-vignette { opacity: 0.8;  animation: vignette-pulse 0.5s ease-in-out infinite; }

        body.danger-low  { background: linear-gradient(135deg, #1a0a0a 0%, #2a0d1a 50%, #1a0808 100%); }
        body.danger-high { background: linear-gradient(135deg, #2a0000 0%, #3d0a0a 50%, #1f0000 100%); }

        .word-card.danger-low  { animation: danger-pulse 1s ease-in-out infinite; border-color: rgba(239,68,68,0.3); }
        .word-card.danger-high { animation: danger-pulse 0.5s ease-in-out infinite; border-color: rgba(239,68,68,0.7); }

        .quiz-wrapper.shake { animation: shake 0.4s ease-in-out; }
    </style>
</head>
<body>

<!-- 위험 비네트 오버레이 -->
<div id="danger-vignette"></div>

<!-- JSON 데이터 -->
<script id="quiz-data" type="application/json">${quizListJson}</script>
<script id="all-words-data" type="application/json">${allWordsJson}</script>

<div class="quiz-wrapper">

    <!-- 퀴즈 화면 -->
    <div id="quiz-screen">
        <div class="quiz-header">
            <span class="day-label">DAY ${dayNum}</span>
            <span class="question-counter" id="question-counter">1 / ?</span>
        </div>

        <div class="progress-dots" id="progress-dots"></div>

        <div class="timer-container">
            <div class="timer-bar-bg">
                <div id="timer-bar"></div>
            </div>
            <div class="timer-text">⏱ <span id="timer-num">10</span>초</div>
        </div>

        <div class="word-card">
            <div id="word-text"></div>
            <div id="pos-text"></div>
        </div>

        <div id="options-container"></div>
    </div>

    <!-- 결과 화면 -->
    <div id="result-screen">
        <div class="result-card">
            <span class="result-emoji" id="result-emoji"></span>
            <div class="result-grade" id="result-grade"></div>
            <div class="result-percent" id="result-percent"></div>
            <div class="result-score" id="result-score"></div>
            <div class="result-actions">
                <a class="btn-action btn-home" href="/">홈으로</a>
                <a class="btn-action btn-retry" href="/quiz/setup/${dayNum}">다시 풀기</a>
            </div>
        </div>
    </div>

</div>

<script>
    const quizWords = JSON.parse(document.getElementById('quiz-data').textContent);
    const allWords  = JSON.parse(document.getElementById('all-words-data').textContent);

    let currentIdx = 0;
    let score = 0;
    let answered = false;
    let timerInterval = null;
    let timeLeft = 10;
    const results = []; // 'correct' | 'wrong' per question

    // ===== 도우미 함수 =====

    function shuffle(arr) {
        return arr.slice().sort(() => Math.random() - 0.5);
    }

    function getOptions(currentWord) {
        const pool = allWords.filter(w => w.meaning !== currentWord.meaning);
        const wrong = shuffle(pool).slice(0, 3);
        return shuffle([...wrong, currentWord]);
    }

    // ===== 타이머 =====

    function startTimer() {
        timeLeft = 10;
        clearInterval(timerInterval);

        // transition 끊고 즉시 100%로 리셋 → 이전 위치에서 차오르는 현상 방지
        const bar = document.getElementById('timer-bar');
        bar.style.transition = 'none';
        bar.style.width = '100%';
        bar.style.background = 'linear-gradient(90deg, #10b981, #34d399)';
        bar.offsetWidth; // reflow 강제 실행
        bar.style.transition = 'width 1s linear, background 1s linear';

        document.getElementById('timer-num').textContent = timeLeft;

        timerInterval = setInterval(() => {
            timeLeft--;
            updateTimerUI();
            if (timeLeft <= 0) {
                clearInterval(timerInterval);
                handleTimeout();
            }
        }, 1000);
    }

    function updateTimerUI() {
        const pct = (timeLeft / 10) * 100;
        const bar = document.getElementById('timer-bar');
        bar.style.width = pct + '%';
        document.getElementById('timer-num').textContent = timeLeft;

        const body      = document.body;
        const wordCard  = document.querySelector('.word-card');
        const wrapper   = document.querySelector('.quiz-wrapper');

        if (timeLeft > 6) {
            bar.style.background = 'linear-gradient(90deg, #10b981, #34d399)';
            body.classList.remove('danger-low', 'danger-high');
            wordCard.classList.remove('danger-low', 'danger-high');

        } else if (timeLeft > 3) {
            bar.style.background = 'linear-gradient(90deg, #f59e0b, #fbbf24)';
            body.classList.remove('danger-low', 'danger-high');
            wordCard.classList.remove('danger-low', 'danger-high');

        } else {
            bar.style.background = 'linear-gradient(90deg, #ef4444, #f87171)';

            if (timeLeft <= 2) {
                body.classList.remove('danger-low');
                body.classList.add('danger-high');
                wordCard.classList.remove('danger-low');
                wordCard.classList.add('danger-high');
            } else {
                body.classList.remove('danger-high');
                body.classList.add('danger-low');
                wordCard.classList.remove('danger-high');
                wordCard.classList.add('danger-low');
            }

            // 매 초 화면 흔들기
            wrapper.classList.remove('shake');
            wrapper.offsetWidth; // reflow
            wrapper.classList.add('shake');
            wrapper.addEventListener('animationend', () => wrapper.classList.remove('shake'), { once: true });
        }
    }

    function clearDangerEffects() {
        document.body.classList.remove('danger-low', 'danger-high');
        const wordCard = document.querySelector('.word-card');
        if (wordCard) wordCard.classList.remove('danger-low', 'danger-high');
    }

    // ===== 렌더링 =====

    function renderQuestion(idx) {
        const word = quizWords[idx];
        answered = false;

        // 카운터
        document.getElementById('question-counter').textContent = (idx + 1) + ' / ' + quizWords.length;

        // 점 업데이트
        const dots = document.querySelectorAll('.dot');
        dots.forEach((d, i) => {
            d.className = 'dot';
            if (i < idx) d.classList.add(results[i]);
            else if (i === idx) d.classList.add('current');
        });

        // 단어
        document.getElementById('word-text').textContent = word.word;
        document.getElementById('pos-text').textContent = word.partOfSpeech || '';

        // 보기
        const options = getOptions(word);
        const container = document.getElementById('options-container');
        container.innerHTML = '';
        options.forEach(opt => {
            const btn = document.createElement('button');
            btn.className = 'option-btn';
            btn.textContent = opt.meaning;
            btn.addEventListener('click', () => selectAnswer(btn, opt.meaning, word.meaning));
            container.appendChild(btn);
        });

        // 애니메이션
        document.querySelector('.word-card').style.animation = 'none';
        requestAnimationFrame(() => {
            document.querySelector('.word-card').style.animation = 'fadeIn 0.3s ease';
        });

        startTimer();
    }

    function renderProgressDots() {
        const container = document.getElementById('progress-dots');
        container.innerHTML = '';
        quizWords.forEach((_, i) => {
            const dot = document.createElement('div');
            dot.className = 'dot';
            container.appendChild(dot);
        });
    }

    // ===== 정답 처리 =====

    function selectAnswer(btn, selected, correct) {
        if (answered) return;
        answered = true;
        clearInterval(timerInterval);

        const buttons = document.querySelectorAll('.option-btn');
        buttons.forEach(b => b.disabled = true);

        clearDangerEffects();

        if (selected === correct) {
            btn.classList.add('correct');
            results.push('correct');
            score++;
        } else {
            btn.classList.add('wrong');
            results.push('wrong');
            buttons.forEach(b => {
                if (b.textContent === correct) b.classList.add('correct');
            });
        }

        setTimeout(nextQuestion, 900);
    }

    function handleTimeout() {
        if (answered) return;
        answered = true;
        clearDangerEffects();
        results.push('wrong');

        const correct = quizWords[currentIdx].meaning;
        document.querySelectorAll('.option-btn').forEach(b => {
            b.disabled = true;
            if (b.textContent === correct) b.classList.add('correct');
        });

        setTimeout(nextQuestion, 1000);
    }

    function nextQuestion() {
        currentIdx++;
        if (currentIdx < quizWords.length) {
            renderQuestion(currentIdx);
        } else {
            showResult();
        }
    }

    // ===== 결과 화면 =====

    function showResult() {
        document.getElementById('quiz-screen').style.display = 'none';
        const resultScreen = document.getElementById('result-screen');
        resultScreen.style.display = 'block';

        const percent = Math.round((score / quizWords.length) * 100);

        let emoji, grade, gradeClass;
        if (percent === 100) {
            emoji = '🎉'; grade = 'PERFECT!';     gradeClass = 'grade-perfect';
        } else if (percent >= 80) {
            emoji = '👏'; grade = 'EXCELLENT!';   gradeClass = 'grade-excellent';
        } else if (percent >= 60) {
            emoji = '😊'; grade = 'GREAT JOB!';   gradeClass = 'grade-great';
        } else if (percent >= 40) {
            emoji = '😅'; grade = 'TRY AGAIN!';   gradeClass = 'grade-try';
        } else {
            emoji = '📚'; grade = 'KEEP STUDYING!'; gradeClass = 'grade-study';
        }

        document.getElementById('result-emoji').textContent = emoji;
        const gradeEl = document.getElementById('result-grade');
        gradeEl.textContent = grade;
        gradeEl.className = 'result-grade ' + gradeClass;
        document.getElementById('result-percent').textContent = percent + '%';
        document.getElementById('result-score').textContent = score + ' / ' + quizWords.length + ' 정답';
    }

    // ===== 시작 =====
    renderProgressDots();
    renderQuestion(0);
</script>

</body>
</html>
