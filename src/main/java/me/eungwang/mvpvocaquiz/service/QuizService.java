package me.eungwang.mvpvocaquiz.service;

import lombok.RequiredArgsConstructor;
import me.eungwang.mvpvocaquiz.domain.Word;
import me.eungwang.mvpvocaquiz.repository.WordRepository;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuizService {

    private final WordRepository wordRepository;

    public List<Word> getRandomQuiz(int startDay, int endDay, int count) {
        // 1. 범위에 맞는 단어 가져오기
        List<Word> words = wordRepository.findByDayNumberBetween(startDay, endDay);

        // 2. 리스트 무작위로 섞기 (Collections 활용!)
        Collections.shuffle(words);

        // 3. 요청한 개수만큼 잘라서 반환
        return words.stream()
                .limit(count)
                .collect(Collectors.toList());
    }
}