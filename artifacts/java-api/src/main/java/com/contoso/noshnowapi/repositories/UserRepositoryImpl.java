package com.contoso.noshnowapi.repositories;

import com.contoso.noshnowapi.models.User;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

@Repository
public class UserRepositoryImpl implements UserRepositoryCustom {
    @PersistenceContext
    EntityManager entityManager;

    @Override
    public User getRandomUser() {
        Query query = entityManager.createNativeQuery("SELECT * FROM Users ORDER BY RAND() LIMIT 1;", User.class);
        return (User)query.getSingleResult();
    }
}
