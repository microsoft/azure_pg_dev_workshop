package com.contoso.noshnowapi.controllers;

import com.contoso.noshnowapi.models.Category;
import com.contoso.noshnowapi.repositories.CategoryRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/v1/categories")
public class CategoryController {
    private final CategoryRepository categoryRepository;

    public CategoryController(CategoryRepository categoryRepository)
    {
        this.categoryRepository = categoryRepository;
    }

    @GetMapping
    public List<Category> getCategories()
    {
        return this.categoryRepository.findByOrderByNameAsc();
    }
}
