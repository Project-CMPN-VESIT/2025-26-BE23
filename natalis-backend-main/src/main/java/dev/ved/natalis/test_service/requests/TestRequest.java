package dev.ved.natalis.test_service.requests;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.Map;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TestRequest {

    /* =========================
       AI OUTPUT PARAMETERS
       ========================= */

    @NotNull(message = "HC value is required")
    private Double hcMm;

    private Double gaWeeks;

    @NotBlank(message = "Classification is required")
    private String classification;

    private String percentileBand;

    private String edd;

    private String trimester;

    private String weeksRemaining;

    /* =========================
       IMAGE OUTPUT
       ========================= */

    @NotBlank(message = "Annotated image is required")
    private String annotatedImageBase64;

    /* =========================
       EXTENSIBLE RESULTS
       ========================= */

    private Map<String, Object> additionalResults;
}
