package dev.ved.natalis.user_service.repository;

import dev.ved.natalis.user_service.entity.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String> {

    Optional<User> findByEmailAndIsActiveTrue(String email);

    boolean existsByEmail(String email);

    Optional<User> findByEmail(String email);
}
