package me.eungwang.mvpvocaquiz.repository;

import me.eungwang.mvpvocaquiz.domain.Word;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WordRepository extends JpaRepository<Word, Long> {
    List<Word> findByDayNumberBetween(int start, int end);
    List<Word> findByDayNumber(int dayNumber);

    @Query("SELECT DISTINCT w.dayNumber FROM Word w ORDER BY w.dayNumber")
    List<Integer> findDistinctDayNumbers();
}