package me.eungwang.mvpvocaquiz.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import me.eungwang.mvpvocaquiz.domain.Word;
import me.eungwang.mvpvocaquiz.service.QuizService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
public class QuizController {

    private final QuizService quizService;

    // 주소 예시: http://localhost:8080/api/quiz?start=1&end=2&count=3
    @GetMapping("/api/quiz")
    public List<Word> getQuiz(
            @RequestParam(defaultValue = "1") int start,
            @RequestParam(defaultValue = "60") int end,
            @RequestParam(defaultValue = "10") int count) {

        log.info("[GET /api/quiz] start={}, end={}, count={}", start, end, count);

        List<Word> result = quizService.getRandomQuiz(start, end, count);

        log.info("[GET /api/quiz] 응답 단어 수={}, words={}", result.size(),
                result.stream().map(Word::getWord).toList());

        return result;
    }
}