package dev.ved.natalis.test_service.dto;

import dev.ved.natalis.test_service.enums.TestType;
import lombok.*;

import java.time.Instant;
import java.util.Map;


@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TestResponse {

    private String id;

    private String motherId;
    private String motherName;
    private String doctorId;
    private String doctorName;
    private String organizationId;

    private TestType testType;
    private Instant testTime;

    private Double hcMm;
    private Double gaWeeks;
    private String classification;
    private String percentileBand;
    private String edd;
    private String trimester;
    private String weeksRemaining;

    private String annotatedImageBase64;

    private Map<String, Object> additionalResults;

}
