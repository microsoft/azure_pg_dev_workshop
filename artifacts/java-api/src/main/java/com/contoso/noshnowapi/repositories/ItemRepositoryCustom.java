package com.contoso.noshnowapi.repositories;

import com.contoso.noshnowapi.models.Item;

import java.util.List;

public interface ItemRepositoryCustom {
    List<Item> findByCategoryUrl(String categoryName);
}
