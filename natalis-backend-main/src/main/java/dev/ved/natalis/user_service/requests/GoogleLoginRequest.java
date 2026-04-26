package dev.ved.natalis.user_service.requests;

import lombok.Data;

@Data
public class GoogleLoginRequest {
    private String idToken;
}