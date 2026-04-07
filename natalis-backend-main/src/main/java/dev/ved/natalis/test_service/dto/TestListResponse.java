package dev.ved.natalis.test_service.dto;
import dev.ved.natalis.test_service.enums.TestType;
import lombok.Builder;
import lombok.Data;

import java.time.Instant;


@Data
@Builder
public class TestListResponse {
    private String id;
    private String motherId;
    private String motherName;
    private String doctorName;
    private TestType testType;
    private Instant testTime;
    private String classification;
    private String trimester;
    private double gaWeeks;
}
