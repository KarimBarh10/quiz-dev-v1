package com.example.quiz_dev.controller;

import com.example.quiz_dev.model.Question;
import com.example.quiz_dev.service.QuestionService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Collections;
import java.util.List;

@Controller
public class QuizController {

    private final QuestionService questionService;

    public QuizController(QuestionService questionService) {
        this.questionService = questionService;
    }

    @GetMapping("/quiz")
    public String showQuiz(Model model) {
        // Get all questions
        List<Question> questions = questionService.getAllQuestions();

        // Shuffle questions randomly
        Collections.shuffle(questions);

        // Optionally: Limit to N questions
        // questions = questions.stream().limit(10).toList();

        model.addAttribute("questions", questions);
        return "quiz";
    }
}
