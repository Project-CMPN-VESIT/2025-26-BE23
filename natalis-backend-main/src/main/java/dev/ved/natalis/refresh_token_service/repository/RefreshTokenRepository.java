package dev.ved.natalis.refresh_token_service.repository;

import dev.ved.natalis.refresh_token_service.entity.RefreshToken;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface RefreshTokenRepository
        extends MongoRepository<RefreshToken, String> {

    Optional<RefreshToken> findByToken(String token);

    List<RefreshToken> findByUserId(String userId);

    void deleteByToken(String token);

    void deleteByUserId(String userId);
}
