package dev.ved.natalis.user_service.service;
import dev.ved.natalis.exception.BadRequestException;
import dev.ved.natalis.exception.ResourceNotFoundException;
import dev.ved.natalis.exception.UnauthorizedException;
import dev.ved.natalis.user_service.entity.User;
import dev.ved.natalis.user_service.enums.Role;
import dev.ved.natalis.user_service.repository.UserRepository;
import dev.ved.natalis.user_service.requests.LoginRequest;
import dev.ved.natalis.user_service.requests.RegisterRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;



    public User registerUser(RegisterRequest request) {

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("Email already registered");
        }

        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(request.getRole()); // IMPORTANT
        user.setIsActive(true);
        user.setCreatedAt(Instant.now());

        return userRepository.save(user);
    }

    public User authenticate(LoginRequest loginRequest) {

        User user = userRepository
                .findByEmailAndIsActiveTrue(loginRequest.getEmail())
                .orElseThrow(() -> new UnauthorizedException("Invalid credentials"));

        if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
            throw new UnauthorizedException("Invalid credentials");
        }

        return user;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(String userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }


    public void deactivateUser(String userId) {
        userRepository.findById(userId).ifPresent(user -> {
            user.setIsActive(false);
            userRepository.save(user);
        });
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public User save(User user) {
        return userRepository.save(user);
    }
}
