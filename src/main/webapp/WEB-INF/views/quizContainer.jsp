<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>퀴즈 - DAY ${dayNum}</title>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    <link rel="stylesheet" href="/css/common.css">
    <link rel="stylesheet" href="/css/quiz-container.css">
</head>
<body>

<!-- 위험 비네트 오버레이 -->
<div id="danger-vignette"></div>

<!-- BGM / 효과음 토글 -->
<button class="sound-btn" id="bgm-btn" onclick="toggleBGM()" title="BGM 켜기/끄기">🎵</button>

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
    // ===== AUDIO ENGINE =====
    let audioCtx = null;
    let bgmScheduler = null;
    let bgmStep = 0;
    let bgmNextTime = 0;
    let bgmGainNode = null;
    let bgmActive = false;

    const NOTE = {
        C3:130.81, E3:164.81, G3:196.00,
        C5:523.25, D5:587.33, E5:659.25, G5:783.99, A5:880.00
    };

    // 8비트 스타일 루프 멜로디 (C장조, 16 스텝)
    const BGM_MELODY = [
        NOTE.C5, NOTE.E5, NOTE.G5, NOTE.A5, NOTE.G5, NOTE.E5, NOTE.D5, NOTE.E5,
        NOTE.C5, NOTE.D5, NOTE.E5, NOTE.G5, NOTE.A5, NOTE.G5, NOTE.E5, NOTE.C5
    ];
    const BGM_BASS = [
        NOTE.C3, 0, NOTE.G3, 0, NOTE.C3, 0, NOTE.E3, 0,
        NOTE.C3, 0, NOTE.G3, 0, NOTE.C3, 0, NOTE.G3, 0
    ];

    function getCtx() {
        if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        if (audioCtx.state === 'suspended') audioCtx.resume();
        return audioCtx;
    }

    function tone(freq, type, vol, start, dur, dest) {
        const ctx = getCtx();
        const osc = ctx.createOscillator();
        const g   = ctx.createGain();
        osc.type = type;
        osc.frequency.value = freq;
        g.gain.setValueAtTime(vol, start);
        g.gain.exponentialRampToValueAtTime(0.001, start + dur);
        osc.connect(g);
        g.connect(dest || ctx.destination);
        osc.start(start);
        osc.stop(start + dur + 0.02);
    }

    function scheduleBGM() {
        const ctx = getCtx();
        while (bgmNextTime < ctx.currentTime + 0.4) {
            const s = bgmStep % 16;
            tone(BGM_MELODY[s], 'triangle', 0.18, bgmNextTime, 0.20, bgmGainNode);
            if (BGM_BASS[s]) {
                tone(BGM_BASS[s], 'sine', 0.20, bgmNextTime, 0.44, bgmGainNode);
            }
            bgmNextTime += 0.25; // 8분음표 @ 120 BPM
            bgmStep++;
        }
    }

    function startBGM() {
        const ctx = getCtx();
        bgmGainNode = ctx.createGain();
        bgmGainNode.gain.value = 1;
        bgmGainNode.connect(ctx.destination);
        bgmStep = 0;
        bgmNextTime = ctx.currentTime + 0.05;
        scheduleBGM();
        bgmScheduler = setInterval(scheduleBGM, 100);
        bgmActive = true;
        document.getElementById('bgm-btn').textContent = '🔈';
    }

    function stopBGM() {
        clearInterval(bgmScheduler);
        if (bgmGainNode) {
            try { bgmGainNode.gain.setTargetAtTime(0, getCtx().currentTime, 0.1); } catch(e) {}
        }
        bgmActive = false;
        document.getElementById('bgm-btn').textContent = '🎵';
    }

    function toggleBGM() {
        bgmActive ? stopBGM() : startBGM();
    }

    // 정답 효과음: 상승 아르페지오 (취링~)
    function playCorrect() {
        const ctx = getCtx();
        [523.25, 659.25, 783.99, 1046.5].forEach((f, i) => {
            tone(f, 'sine', 0.30, ctx.currentTime + i * 0.09, 0.22, null);
        });
    }

    // 오답 효과음: 하강 버즈 (삐~)
    function playWrong() {
        const ctx = getCtx();
        const osc = ctx.createOscillator();
        const g   = ctx.createGain();
        osc.type = 'sawtooth';
        osc.frequency.setValueAtTime(260, ctx.currentTime);
        osc.frequency.exponentialRampToValueAtTime(80, ctx.currentTime + 0.4);
        g.gain.setValueAtTime(0.28, ctx.currentTime);
        g.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.4);
        osc.connect(g);
        g.connect(ctx.destination);
        osc.start();
        osc.stop(ctx.currentTime + 0.42);
    }

    // 타이머 경고음: 빙빙 (두 번 삑)
    function playTimerBeep() {
        const ctx = getCtx();
        [0, 0.18].forEach(offset => {
            tone(880, 'square', 0.15, ctx.currentTime + offset, 0.10, null);
        });
    }

    // 첫 클릭 시 AudioContext 활성화
    document.addEventListener('click', () => getCtx(), { once: true });

    // ===== QUIZ LOGIC =====
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
            playTimerBeep();

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
            playCorrect();
        } else {
            btn.classList.add('wrong');
            results.push('wrong');
            playWrong();
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
        playWrong();

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
