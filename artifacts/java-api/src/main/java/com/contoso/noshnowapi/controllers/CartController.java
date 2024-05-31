package com.contoso.noshnowapi.controllers;

import com.contoso.noshnowapi.models.Cart;
import com.contoso.noshnowapi.apimodels.CartPostApiModel;
import com.contoso.noshnowapi.repositories.CartRepository;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/carts")
public class CartController {

    private final CartRepository cartRepository;

    public CartController(CartRepository cartRepository) {
        this.cartRepository = cartRepository;
    }

    // The request just needs a user ID in the body
    // openCart() automatically populates the cart status
    @PostMapping
    public Cart openCart(@RequestBody CartPostApiModel cartPostViewModel)
    {
        Cart cart = new Cart();
        cart.setUserId(cartPostViewModel.getUserId());
        cart.setStatus("open");
        return cartRepository.save(cart);
    }

    @PutMapping("/{id}")
    public Cart closeCart(@PathVariable Long id)
    {
        Cart currentCart = cartRepository.findById(id).orElseThrow();
        currentCart.setStatus("closed");
        return cartRepository.save(currentCart);
    }
}
