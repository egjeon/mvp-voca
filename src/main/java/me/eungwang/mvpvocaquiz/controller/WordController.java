package me.eungwang.mvpvocaquiz.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import me.eungwang.mvpvocaquiz.domain.Word;
import me.eungwang.mvpvocaquiz.repository.WordRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;

@Controller
@Slf4j
public class WordController {

    private final WordRepository wordRepository;
    private final ObjectMapper objectMapper;

    public WordController(WordRepository wordRepository, ObjectMapper objectMapper) {
        this.wordRepository = wordRepository;
        this.objectMapper = objectMapper;
    }

    // 1. 메인 홈 (Day 버튼들)
    @GetMapping("/")
    public String index(Model model) {
        List<Integer> activeDays = wordRepository.findDistinctDayNumbers();
        log.info("[GET /] 활성 DAY 목록={}", activeDays);
        model.addAttribute("activeDays", new HashSet<>(activeDays));
        return "index";
    }

    // 2. 단어 목록 보기
    @GetMapping("/day/{dayNum}")
    public String dayDetail(@PathVariable int dayNum, Model model) {
        List<Word> words = wordRepository.findByDayNumber(dayNum);
        log.info("[GET /day/{}] 단어 수={}", dayNum, words.size());
        model.addAttribute("dayNum", dayNum);
        model.addAttribute("words", words);
        return "wordList";
    }

    // 3. 퀴즈 설정 (문항 수 선택)
    @GetMapping("/quiz/setup/{dayNum}")
    public String quizSetup(@PathVariable int dayNum, Model model) {
        int total = wordRepository.findByDayNumber(dayNum).size();
        log.info("[GET /quiz/setup/{}] 총 단어 수={}", dayNum, total);
        model.addAttribute("dayNum", dayNum);
        model.addAttribute("totalCount", total);
        return "quizSetup";
    }

    // 4. 퀴즈 실행
    @PostMapping("/quiz/start")
    public String startQuiz(@RequestParam int dayNum, @RequestParam int count, Model model) {
        log.info("[POST /quiz/start] dayNum={}, 요청 문제 수={}", dayNum, count);
        List<Word> allWords = new ArrayList<>(wordRepository.findByDayNumber(dayNum));
        Collections.shuffle(allWords);
        List<Word> quizList = allWords.subList(0, Math.min(count, allWords.size()));
        log.info("[POST /quiz/start] 실제 출제 수={}, 퀴즈 단어={}", quizList.size(),
                quizList.stream().map(Word::getWord).toList());

        try {
            model.addAttribute("quizListJson", objectMapper.writeValueAsString(quizList));
            model.addAttribute("allWordsJson", objectMapper.writeValueAsString(allWords));
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        model.addAttribute("dayNum", dayNum);
        return "quizContainer";
    }
}
