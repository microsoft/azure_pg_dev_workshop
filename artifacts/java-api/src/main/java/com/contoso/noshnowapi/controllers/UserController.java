package com.contoso.noshnowapi.controllers;

import com.contoso.noshnowapi.models.User;
import com.contoso.noshnowapi.repositories.UserRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/users")
public class UserController {
    private final UserRepository userRepository;

    public UserController(UserRepository userRepository)
    {
        this.userRepository = userRepository;
    }

    @GetMapping
    public List<User> getUsers()
    {
        return this.userRepository.findAll();
    }

    @GetMapping("/randomUser")
    public User getRandomUser()
    {
        return this.userRepository.getRandomUser();
    }

    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id)
    {
        return this.userRepository.findById(id).orElseThrow();
    }
}
