package com.contoso.noshnowapi.controllers;

import com.contoso.noshnowapi.apimodels.CartItemPostApiModel;
import com.contoso.noshnowapi.models.CartItem;
import com.contoso.noshnowapi.repositories.CartItemRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/cartitems")
public class CartItemController {
    private final CartItemRepository cartItemRepository;

    public CartItemController(CartItemRepository cartItemRepository) {
        this.cartItemRepository = cartItemRepository;
    }

    @GetMapping("/carts/{id}")
    public List<CartItem> getCartItems(@PathVariable Long id)
    {
        return cartItemRepository.findCartItemsByCartId(id);
    }

    @PostMapping
    public ResponseEntity addCartItems(@RequestBody List<CartItemPostApiModel> cartItemPostApiModels)
    {
        List<CartItem> cartItems = cartItemPostApiModels
                .stream()
                .map(obj -> new CartItem(obj.getCartId(), obj.getItemId(), obj.getQty()))
                .collect(Collectors.toList());
        cartItemRepository.saveAll(cartItems);
        return new ResponseEntity(HttpStatus.NO_CONTENT);
    }
}
