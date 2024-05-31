package com.contoso.noshnowapi.repositories;

import com.contoso.noshnowapi.models.Cart;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CartRepository extends JpaRepository<Cart, Long> {
}