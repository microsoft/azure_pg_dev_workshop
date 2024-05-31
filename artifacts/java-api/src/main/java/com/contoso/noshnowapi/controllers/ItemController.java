package com.contoso.noshnowapi.controllers;

import com.contoso.noshnowapi.apimodels.ItemsGetApiModel;
import com.contoso.noshnowapi.models.Item;
import com.contoso.noshnowapi.repositories.ItemRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/items")
public class ItemController {
    private final ItemRepository itemRepository;

    public ItemController(ItemRepository itemRepository)
    {
        this.itemRepository = itemRepository;
    }

    @GetMapping
    public List<Item> getItems(@RequestBody ItemsGetApiModel itemsGetApiModel)
    {
        return itemRepository.findByIdIn(itemsGetApiModel.getItemKeys());
    }

    @GetMapping("/categories/{categoryUrl}")
    public List<Item> getItemsByCategory(@PathVariable String categoryUrl)
    {
        return itemRepository.findByCategoryUrl(categoryUrl);
    }

    @GetMapping("/{id}")
    public Item getItem(@PathVariable Long id)
    {
        return itemRepository.findById(id).orElseThrow();
    }
}
