package dev.ved.natalis.user_service.controller;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import dev.ved.natalis.configuration.JwtService;
import dev.ved.natalis.exception.UnauthorizedException;
import dev.ved.natalis.refresh_token_service.entity.RefreshToken;
import dev.ved.natalis.refresh_token_service.repository.RefreshTokenRepository;
import dev.ved.natalis.user_service.dto.UserResponse;
import dev.ved.natalis.user_service.entity.User;
import dev.ved.natalis.user_service.enums.Role;
import dev.ved.natalis.user_service.repository.UserRepository;
import dev.ved.natalis.user_service.requests.GoogleLoginRequest;
import dev.ved.natalis.user_service.requests.LoginRequest;
import dev.ved.natalis.user_service.requests.RegisterRequest;
import dev.ved.natalis.user_service.service.AuthService;
import dev.ved.natalis.user_service.service.GoogleTokenService;
import dev.ved.natalis.user_service.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final AuthService authService;
    private final GoogleTokenService googleTokenService;

    @PostMapping("/register")
    public ResponseEntity<?> register(
            @Valid @RequestBody RegisterRequest request
    ) {

        User user = userService.registerUser(request);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(
                        Map.of(
                                "user", UserResponse.builder()
                                        .id(user.getId())
                                        .email(user.getEmail())
                                        .role(user.getRole())
                                        .build(),
                                "message", "User registered successfully"
                        )
                );
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {

        User user = userService.authenticate(request);

        Map<String, Object> tokens = authService.login(user);

        return ResponseEntity.ok(
                Map.of(
                        "user", UserResponse.builder()
                                .id(user.getId())
                                .email(user.getEmail())
                                .role(user.getRole())
                                .build(),
                        "token", tokens.get("token"),
                        "refreshToken", tokens.get("refreshToken")
                )
        );
    }

    @PostMapping("/google")
    public ResponseEntity<?> googleLogin(
            @RequestBody GoogleLoginRequest request
    ) throws Exception {


        GoogleIdToken.Payload payload =
                googleTokenService.verify(request.getIdToken());

        String email = payload.getEmail();


        User user = userService.findByEmail(email)
                .orElseThrow(() -> {
                    return new UnauthorizedException("No registration found for the email address");
                });


        if (user.getProvider() == null) {
            user.setProvider("GOOGLE");
            userService.save(user);
        }

        // 4️⃣ Generate access + refresh tokens using existing logic
        Map<String, Object> tokens = authService.login(user);

        return ResponseEntity.ok(
                Map.of(
                        "user", UserResponse.builder()
                                .id(user.getId())
                                .email(user.getEmail())
                                .role(user.getRole())
                                .build(),
                        "token", tokens.get("token"),
                        "refreshToken", tokens.get("refreshToken")
                )
        );
    }

    @PostMapping("/refresh")
    public ResponseEntity<?> refresh(@RequestBody Map<String, String> body) {

        String newAccessToken = authService.refresh(body.get("refreshToken"));

        return ResponseEntity.ok(
                Map.of("accessToken", newAccessToken)
        );
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(@RequestBody Map<String, String> body) {

        authService.logout(body.get("refreshToken"));

        return ResponseEntity.ok(
                Map.of("message", "Logged out successfully")
        );
    }

    @PostMapping("/logout-all")
    public ResponseEntity<?> logoutAll(@RequestBody Map<String, String> body) {

        authService.logoutAll(body.get("userId"));

        return ResponseEntity.ok(
                Map.of("message", "Logged out from all devices")
        );
    }
}
