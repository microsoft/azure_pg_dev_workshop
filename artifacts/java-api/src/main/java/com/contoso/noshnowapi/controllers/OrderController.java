package com.contoso.noshnowapi.controllers;

import com.contoso.noshnowapi.apimodels.OrderPostApiModel;
import com.contoso.noshnowapi.models.Order;
import com.contoso.noshnowapi.repositories.OrderRepository;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;

@RestController
@RequestMapping("/api/v1/orders")
public class OrderController {
    private final OrderRepository orderRepository;

    public OrderController(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    @PostMapping
    public Order createOrder(@RequestBody OrderPostApiModel orderPostApiModel)
    {
        Order order = new Order();

        order.setUserId(orderPostApiModel.getUserId());
        order.setCartId(orderPostApiModel.getCartId());
        order.setName(orderPostApiModel.getName());
        order.setAddress(orderPostApiModel.getAddress());
        order.setSpecialInstructions(orderPostApiModel.getSpecialInstructions());
        order.setCooktime(orderPostApiModel.getCooktime());
        order.setCreatedAt(Instant.now());
        order.setUpdatedAt(Instant.now());

        return orderRepository.save(order);
    }
}
