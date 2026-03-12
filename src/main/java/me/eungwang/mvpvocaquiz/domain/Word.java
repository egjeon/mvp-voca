package me.eungwang.mvpvocaquiz.domain;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Table(name="WORD")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Word {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private int dayNumber; // MVP 교재의 DAY

    @Column(nullable = false)
    private String word; // 영단어

    private String partOfSpeech; // 품사

    @Column(nullable = false)
    private String meaning; // 뜻

    private String synonyms; // 동의어 (쉼표로 구분)
    private String antonyms; // 반의어 (쉼표로 구분)
}