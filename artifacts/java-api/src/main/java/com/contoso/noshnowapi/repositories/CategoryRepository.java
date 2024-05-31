package com.contoso.noshnowapi.repositories;

import com.contoso.noshnowapi.models.Category;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    public List<Category> findByOrderByNameAsc();
}