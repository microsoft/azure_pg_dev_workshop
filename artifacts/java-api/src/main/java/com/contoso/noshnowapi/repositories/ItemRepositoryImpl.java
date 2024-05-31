package com.contoso.noshnowapi.repositories;

import com.contoso.noshnowapi.models.Item;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.List;

public class ItemRepositoryImpl implements ItemRepositoryCustom {
    @PersistenceContext
    EntityManager entityManager;

    @Override
    public List<Item> findByCategoryUrl(String categoryName) {
        Query query = entityManager.createNativeQuery
                (
            "SELECT " +
                        "i.id, " +
                        "i.category_id, " +
                        "i.name, " +
                        "i.img, " +
                        "i.price, " +
                        "i.cooktime, " +
                        "i.desc " +
                    "FROM items i " +
                    "JOIN categories c " +
                    "ON i.category_id = c.id " +
                    "WHERE c.url = :url " +
                    "ORDER BY i.name ASC",
                    Item.class
                );
        query.setParameter("url", categoryName);
        return query.getResultList();
    }
}
