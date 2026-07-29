(function () {
  "use strict";

  var SAMPLE_QUESTIONS = [
    { id: "ADD-001", operation: "addition", operand_a: 6, operand_b: 8, operator: "+", answer: 14, requires_regrouping: true, hint: "Cộng hàng đơn vị trước; nếu đủ 10, nhớ 1 sang hàng chục.", explanation: "6 + 8 = 14." },
    { id: "ADD-002", operation: "addition", operand_a: 11, operand_b: 7, operator: "+", answer: 18, requires_regrouping: false, hint: "Cộng hàng đơn vị trước, rồi cộng hàng chục.", explanation: "11 + 7 = 18." },
    { id: "ADD-042", operation: "addition", operand_a: 28, operand_b: 8, operator: "+", answer: 36, requires_regrouping: true, hint: "Cộng hàng đơn vị trước; nếu đủ 10, nhớ 1 sang hàng chục.", explanation: "28 + 8 = 36." },
    { id: "ADD-035", operation: "addition", operand_a: 10, operand_b: 27, operator: "+", answer: 37, requires_regrouping: false, hint: "Cộng hàng đơn vị trước, rồi cộng hàng chục.", explanation: "10 + 27 = 37." },
    { id: "ADD-069", operation: "addition", operand_a: 19, operand_b: 68, operator: "+", answer: 87, requires_regrouping: true, hint: "Cộng hàng đơn vị trước; nếu đủ 10, nhớ 1 sang hàng chục.", explanation: "19 + 68 = 87." },
    { id: "SUB-008", operation: "subtraction", operand_a: 11, operand_b: 5, operator: "-", answer: 6, requires_regrouping: true, hint: "Hàng đơn vị không trừ được thì mượn 1 chục.", explanation: "11 - 5 = 6." },
    { id: "SUB-001", operation: "subtraction", operand_a: 5, operand_b: 2, operator: "-", answer: 3, requires_regrouping: false, hint: "Trừ hàng đơn vị trước, rồi trừ hàng chục.", explanation: "5 - 2 = 3." },
    { id: "SUB-036", operation: "subtraction", operand_a: 21, operand_b: 4, operator: "-", answer: 17, requires_regrouping: true, hint: "Hàng đơn vị không trừ được thì mượn 1 chục.", explanation: "21 - 4 = 17." },
    { id: "SUB-035", operation: "subtraction", operand_a: 49, operand_b: 22, operator: "-", answer: 27, requires_regrouping: false, hint: "Trừ hàng đơn vị trước, rồi trừ hàng chục.", explanation: "49 - 22 = 27." },
    { id: "SUB-069", operation: "subtraction", operand_a: 75, operand_b: 47, answer: 28, operator: "-", requires_regrouping: true, hint: "Hàng đơn vị không trừ được thì mượn 1 chục.", explanation: "75 - 47 = 28." }
  ];

  var CORRECT_PHRASES = ["Chính xác!", "Giỏi lắm!", "Tuyệt vời!"];
  var PASS_THRESHOLD = 8;
  var TOTAL_QUESTIONS = 10;

  var app = document.getElementById("app");
  var screens = document.querySelectorAll(".screen");
  var toast = document.getElementById("toast");
  var toastTimer = null;

  function showScreen(id) {
    screens.forEach(function (s) {
      s.classList.toggle("is-active", s.id === id);
    });
    var active = document.getElementById(id);
    var heading = active.querySelector("h1, h2");
    if (heading) {
      heading.setAttribute("tabindex", "-1");
      heading.focus();
    }
  }

  function showToast(message) {
    toast.textContent = message;
    toast.hidden = false;
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () { toast.hidden = true; }, 2600);
  }

  function updateViewportClass() {
    var isTablet = window.innerWidth >= 1100;
    app.classList.toggle("is-tablet", isTablet);
  }
  updateViewportClass();
  window.addEventListener("resize", updateViewportClass);

  function shuffledFisherYates(arr) {
    var a = arr.slice();
    for (var i = a.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var tmp = a[i]; a[i] = a[j]; a[j] = tmp;
    }
    return a;
  }

  function hasTooManyConsecutiveRegroup(list) {
    var streak = 0;
    for (var i = 0; i < list.length; i++) {
      streak = list[i].requires_regrouping ? streak + 1 : 0;
      if (streak > 3) return true;
    }
    return false;
  }

  function buildQuizSet() {
    var attempt = shuffledFisherYates(SAMPLE_QUESTIONS);
    var guard = 0;
    while (hasTooManyConsecutiveRegroup(attempt) && guard < 20) {
      attempt = shuffledFisherYates(SAMPLE_QUESTIONS);
      guard++;
    }
    return attempt;
  }

  /* ================= DES-01 Menu ================= */

  var btnPlay = document.getElementById("btn-play");
  var btnSound = document.getElementById("btn-sound");
  var btnAdult = document.getElementById("btn-adult");
  var adultRing = document.getElementById("adult-ring");

  btnPlay.addEventListener("click", function () {
    startGameplay();
    showScreen("screen-gameplay");
  });

  btnSound.addEventListener("click", function () {
    var isOn = btnSound.getAttribute("aria-pressed") === "true";
    btnSound.setAttribute("aria-pressed", String(!isOn));
  });

  var holdTimer = null;
  var holdStart = 0;
  var HOLD_MS = 3000;

  function startHold() {
    holdStart = Date.now();
    tickHold();
  }
  function tickHold() {
    var elapsed = Date.now() - holdStart;
    var pct = Math.min(100, (elapsed / HOLD_MS) * 100);
    adultRing.style.setProperty("--hold-pct", pct.toFixed(1));
    if (pct >= 100) {
      cancelHold();
      showToast("Góc người lớn sẽ có trong bản dựng tiếp theo (DES-10).");
      return;
    }
    holdTimer = requestAnimationFrame(tickHold);
  }
  function cancelHold() {
    if (holdTimer) cancelAnimationFrame(holdTimer);
    holdTimer = null;
    adultRing.style.setProperty("--hold-pct", 0);
  }
  btnAdult.addEventListener("pointerdown", startHold);
  btnAdult.addEventListener("pointerup", cancelHold);
  btnAdult.addEventListener("pointerleave", cancelHold);
  btnAdult.addEventListener("pointercancel", cancelHold);

  /* ================= DES-04 Gameplay ================= */

  var ship = document.getElementById("ship");
  var currentLane = 1;
  var starCount = 0;
  var hudStarCount = document.getElementById("hud-star-count");

  function resetGameplayState() {
    currentLane = 1;
    starCount = 0;
    hudStarCount.textContent = "0";
    ship.setAttribute("data-lane", String(currentLane));
    document.querySelectorAll(".collectible").forEach(function (c) {
      c.setAttribute("data-collected", "false");
    });
  }

  function startGameplay() {
    resetGameplayState();
  }

  function setLane(lane) {
    currentLane = Math.max(0, Math.min(2, lane));
    ship.setAttribute("data-lane", String(currentLane));
  }

  document.getElementById("btn-lane-left").addEventListener("click", function () {
    setLane(currentLane - 1);
  });
  document.getElementById("btn-lane-right").addEventListener("click", function () {
    setLane(currentLane + 1);
  });
  document.getElementById("btn-jump").addEventListener("click", function () {
    ship.classList.add("is-jumping");
    setTimeout(function () { ship.classList.remove("is-jumping"); }, 420);
  });

  document.querySelectorAll(".collectible").forEach(function (c) {
    c.addEventListener("click", function () {
      if (c.getAttribute("data-collected") === "true") return;
      c.setAttribute("data-collected", "true");
      starCount++;
      hudStarCount.textContent = String(starCount);
    });
  });

  document.getElementById("btn-goto-quiz").addEventListener("click", function () {
    startQuiz();
    showScreen("screen-quiz");
  });

  document.addEventListener("keydown", function (e) {
    if (!document.getElementById("screen-gameplay").classList.contains("is-active")) return;
    if (e.key === "ArrowLeft") setLane(currentLane - 1);
    if (e.key === "ArrowRight") setLane(currentLane + 1);
    if (e.key === "ArrowUp" || e.key === " ") document.getElementById("btn-jump").click();
  });

  var pauseBackdrop = document.getElementById("pause-backdrop");
  document.getElementById("btn-pause").addEventListener("click", function () {
    pauseBackdrop.hidden = false;
  });
  document.getElementById("btn-resume").addEventListener("click", function () {
    pauseBackdrop.hidden = true;
  });
  document.getElementById("btn-restart-level").addEventListener("click", function () {
    resetGameplayState();
    pauseBackdrop.hidden = true;
  });
  document.getElementById("btn-pause-to-menu").addEventListener("click", function () {
    pauseBackdrop.hidden = true;
    showScreen("screen-menu");
  });

  /* ================= DES-06 Quiz ================= */

  var quizSet = [];
  var quizIndex = 0;
  var firstAttemptScore = 0;
  var reviewList = [];
  var currentDigits = "";
  var attemptNumber = 1;
  var awaitingContinue = false;
  var retryClearTimer = null;

  var quizProgress = document.getElementById("quiz-progress");
  var quizCount = document.getElementById("quiz-count");
  var quizEquation = document.getElementById("quiz-equation");
  var answerText = document.getElementById("answer-text");
  var answerField = document.getElementById("answer-field");
  var feedbackBand = document.getElementById("feedback-band");
  var keypad = document.getElementById("keypad");
  var btnSubmit = document.getElementById("btn-submit");

  function startQuiz() {
    quizSet = buildQuizSet();
    quizIndex = 0;
    firstAttemptScore = 0;
    reviewList = [];
    renderProgress();
    loadQuestion();
  }

  function renderProgress() {
    quizProgress.innerHTML = "";
    for (var i = 0; i < TOTAL_QUESTIONS; i++) {
      var dot = document.createElement("span");
      dot.className = "dot";
      if (i < quizIndex) dot.classList.add("is-answered");
      if (i === quizIndex) dot.classList.add("is-current");
      quizProgress.appendChild(dot);
    }
    quizCount.textContent = "Câu " + (quizIndex + 1) + "/" + TOTAL_QUESTIONS;
  }

  function loadQuestion() {
    clearTimeout(retryClearTimer);
    var q = quizSet[quizIndex];
    quizEquation.textContent = q.operand_a + " " + q.operator + " " + q.operand_b + " = ?";
    currentDigits = "";
    attemptNumber = 1;
    awaitingContinue = false;
    answerText.textContent = " ";
    answerField.classList.remove("is-correct", "is-incorrect");
    feedbackBand.className = "feedback-band";
    feedbackBand.innerHTML = "";
    setKeypadEnabled(true);
    renderProgress();
  }

  function setKeypadEnabled(enabled) {
    keypad.querySelectorAll(".key").forEach(function (k) { k.disabled = !enabled; });
  }

  function updateAnswerDisplay() {
    answerText.textContent = currentDigits.length ? currentDigits : " ";
  }

  keypad.addEventListener("click", function (e) {
    var btn = e.target.closest(".key");
    if (!btn || btn.disabled) return;
    var key = btn.getAttribute("data-key");
    if (awaitingContinue) {
      if (key === "submit") advanceAfterReveal();
      return;
    }
    if (key === "delete") {
      currentDigits = currentDigits.slice(0, -1);
      updateAnswerDisplay();
    } else if (key === "submit") {
      submitAnswer();
    } else {
      if (currentDigits.length >= 3) return;
      currentDigits += key;
      updateAnswerDisplay();
    }
  });

  function submitAnswer() {
    if (currentDigits.length === 0) return;
    clearTimeout(retryClearTimer);
    var q = quizSet[quizIndex];
    var value = parseInt(currentDigits, 10);
    var isCorrect = value === q.answer;

    if (isCorrect) {
      if (attemptNumber === 1) firstAttemptScore++;
      answerField.classList.add("is-correct");
      feedbackBand.className = "feedback-band state-correct";
      var phrase = CORRECT_PHRASES[Math.floor(Math.random() * CORRECT_PHRASES.length)];
      feedbackBand.innerHTML =
        '<div class="feedback-line"><span class="feedback-icon" aria-hidden="true">✔</span><span>' + phrase + "</span></div>";
      setKeypadEnabled(false);
      setTimeout(nextQuestion, 900);
      return;
    }

    if (attemptNumber === 1) {
      attemptNumber = 2;
      reviewList.push(q);
      answerField.classList.add("is-incorrect");
      feedbackBand.className = "feedback-band state-retry";
      feedbackBand.innerHTML =
        '<div class="feedback-line"><span class="feedback-icon" aria-hidden="true">↻</span><span>Con thử lại nhé.</span></div>';
      currentDigits = "";
      setKeypadEnabled(false);
      retryClearTimer = setTimeout(function () {
        updateAnswerDisplay();
        answerField.classList.remove("is-incorrect");
        feedbackBand.className = "feedback-band";
        feedbackBand.innerHTML = "";
        setKeypadEnabled(true);
      }, 1100);
      return;
    }

    answerField.classList.add("is-incorrect");
    feedbackBand.className = "feedback-band state-revealed";
    feedbackBand.innerHTML =
      '<div class="feedback-line"><span class="feedback-icon" aria-hidden="true">i</span><span>' +
      q.operand_a + " " + q.operator + " " + q.operand_b + " = " + q.answer +
      "</span></div>" +
      '<div class="feedback-explain">' + q.hint + "</div>";
    setKeypadEnabled(false);
    btnSubmit.disabled = false;
    btnSubmit.textContent = "Tiếp tục";
    awaitingContinue = true;
  }

  function advanceAfterReveal() {
    btnSubmit.textContent = "Trả lời";
    nextQuestion();
  }

  function nextQuestion() {
    quizIndex++;
    if (quizIndex >= TOTAL_QUESTIONS) {
      finishQuiz();
      return;
    }
    loadQuestion();
  }

  var btnSpeak = document.getElementById("btn-speak");
  btnSpeak.addEventListener("click", function () {
    var q = quizSet[quizIndex];
    var text = "Tính " + q.operand_a + (q.operator === "+" ? " cộng " : " trừ ") + q.operand_b;
    if (window.speechSynthesis && window.SpeechSynthesisUtterance) {
      try {
        var utter = new SpeechSynthesisUtterance(text);
        utter.lang = "vi-VN";
        window.speechSynthesis.cancel();
        window.speechSynthesis.speak(utter);
      } catch (err) {
        showToast("Không thể đọc câu hỏi trên trình duyệt này.");
      }
    } else {
      showToast("Không thể đọc câu hỏi trên trình duyệt này.");
    }
  });

  var quizExitBackdrop = document.getElementById("quiz-exit-backdrop");
  document.getElementById("btn-quiz-exit").addEventListener("click", function () {
    quizExitBackdrop.hidden = false;
  });
  document.getElementById("btn-quiz-exit-cancel").addEventListener("click", function () {
    quizExitBackdrop.hidden = true;
  });
  document.getElementById("btn-quiz-exit-confirm").addEventListener("click", function () {
    quizExitBackdrop.hidden = true;
    showScreen("screen-menu");
  });

  /* ================= DES-08 Result (+ retry stand-in) ================= */

  var resultContent = document.getElementById("result-content");

  function starsForScore(score) {
    if (score >= 10) return 3;
    if (score === 9) return 2;
    if (score === 8) return 1;
    return 0;
  }

  function finishQuiz() {
    var score = firstAttemptScore;
    if (score >= PASS_THRESHOLD) {
      renderPassResult(score);
    } else {
      renderRetryStandIn(score);
    }
    showScreen("screen-result-pass");
  }

  function renderPassResult(score) {
    var stars = starsForScore(score);
    var starMarkup = "";
    for (var i = 0; i < 3; i++) {
      starMarkup += '<span class="' + (i < stars ? "star-filled" : "star-empty") + '">★</span>';
    }
    var starsLabel = stars + " trên 3 sao";
    resultContent.innerHTML =
      '<h2 class="result-title" tabindex="-1">Con đã mở màn mới!</h2>' +
      '<div class="result-score">' + score + "/10</div>" +
      '<div class="result-stars" aria-label="' + starsLabel + '">' + starMarkup + "</div>" +
      '<div class="result-next">Tiếp theo: Màn 2 — Bầu trời quê em</div>' +
      '<button type="button" class="btn btn-primary" id="btn-next-level">Sang màn mới</button>';
    document.getElementById("btn-next-level").addEventListener("click", function () {
      showScreen("screen-menu");
    });
  }

  function renderRetryStandIn(score) {
    var items = reviewList.slice(0, 3).map(function (q) {
      return "<li>" + q.operand_a + " " + q.operator + " " + q.operand_b + " = " + q.answer + "</li>";
    }).join("");
    resultContent.innerHTML =
      '<h2 class="result-title" tabindex="-1">Con sắp mở được rồi!</h2>' +
      '<div class="result-score is-retry">' + score + "/10</div>" +
      '<ul class="result-review-list">' + (items || "<li>Không có câu cần xem lại.</li>") + "</ul>" +
      '<p style="color:var(--color-neutral-500); font-size: var(--size-caption); max-width: 480px;">' +
      "Màn hình đầy đủ cho DES-09 (thử lại) sẽ có ở bản dựng tiếp theo. Đây là bản rút gọn để giữ luồng thao tác." +
      "</p>" +
      '<button type="button" class="btn btn-primary" id="btn-retry-quiz">Thử lại</button>' +
      '<button type="button" class="btn btn-secondary" id="btn-retry-to-menu">Về bản đồ</button>';
    document.getElementById("btn-retry-quiz").addEventListener("click", function () {
      startQuiz();
      showScreen("screen-quiz");
    });
    document.getElementById("btn-retry-to-menu").addEventListener("click", function () {
      showScreen("screen-menu");
    });
  }
})();
