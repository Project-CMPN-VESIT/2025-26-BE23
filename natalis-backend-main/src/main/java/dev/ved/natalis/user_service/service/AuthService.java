package dev.ved.natalis.user_service.service;

import dev.ved.natalis.configuration.JwtService;
import dev.ved.natalis.exception.UnauthorizedException;
import dev.ved.natalis.refresh_token_service.entity.RefreshToken;
import dev.ved.natalis.refresh_token_service.repository.RefreshTokenRepository;
import dev.ved.natalis.user_service.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final JwtService jwtService;
    private final RefreshTokenRepository refreshTokenRepository;
    private final UserService userService;

    public Map<String, Object> login(User user) {

        String accessToken = jwtService.generateToken(user);
        String refreshTokenValue = jwtService.generateRefreshToken(user);

//        RefreshToken refreshToken = RefreshToken.builder()
//                .userId(user.getId())
//                .token(refreshTokenValue)
//                .expiryDate(Instant.now().plus(7, ChronoUnit.DAYS))
//                .createdAt(Instant.now())
//                .build();

//        refreshTokenRepository.save(refreshToken);

        return Map.of(
                "token", accessToken,
                "refreshToken", refreshTokenValue
        );
    }

    public String refresh(String refreshTokenValue) {

        RefreshToken storedToken = refreshTokenRepository
                .findByToken(refreshTokenValue)
                .orElseThrow(() ->
                        new UnauthorizedException("Invalid refresh token"));

        if (storedToken.getExpiryDate().isBefore(Instant.now())) {
            refreshTokenRepository.deleteByToken(refreshTokenValue);
            throw new UnauthorizedException("Refresh token expired");
        }

        User user = userService.getUserById(storedToken.getUserId());

        return jwtService.generateToken(user);
    }

    public void logout(String refreshToken) {
        refreshTokenRepository.deleteByToken(refreshToken);
    }

    public void logoutAll(String userId) {
        refreshTokenRepository.deleteByUserId(userId);
    }
}
