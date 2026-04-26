package dev.ved.natalis.rate_limit_service;

import io.github.bucket4j.Bucket;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class RateLimitFilter extends OncePerRequestFilter {

    private final RateLimitService rateLimitService;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {

        String path = request.getRequestURI();

        // Only limit auth endpoints
        if (path.startsWith("/api/auth/login") ||
                path.startsWith("/api/auth/google") ||
                path.startsWith("/api/auth/refresh")) {

            String ip = request.getRemoteAddr();

            Bucket bucket = rateLimitService.resolveBucket(ip);

            if (!bucket.tryConsume(1)) {

                response.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
                response.setContentType("application/json");
                response.getWriter().write(
                        "{\"error\": \"Too many requests. Try again later.\"}"
                );
                return;
            }
        }

        filterChain.doFilter(request, response);
    }
}