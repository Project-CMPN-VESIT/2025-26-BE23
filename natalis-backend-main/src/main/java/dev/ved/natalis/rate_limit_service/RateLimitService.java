package dev.ved.natalis.rate_limit_service;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class RateLimitService {

    private final Map<String, Bucket> cache = new ConcurrentHashMap<>();

    private Bucket createNewBucket() {

        Bandwidth limit = Bandwidth.builder()
                .capacity(5) // 5 requests
                .refillIntervally(5, Duration.ofMinutes(1)) // per 1 minute
                .build();

        return Bucket.builder()
                .addLimit(limit)
                .build();
    }

    public Bucket resolveBucket(String key) {
        return cache.computeIfAbsent(key, k -> createNewBucket());
    }
}