package com.contoso.noshnowapi.repositories;

import com.contoso.noshnowapi.models.Order;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository extends JpaRepository<Order, Long> {
}