package dev.ved.natalis.visit_service.dto;

import dev.ved.natalis.visit_service.entity.Vitals;
import dev.ved.natalis.visit_service.enums.Trimester;
import dev.ved.natalis.visit_service.enums.VisitType;
import lombok.*;

import java.time.Instant;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class VisitResponse {

    private String id;

    private String organizationId;
    private String motherId;
    private String doctorId;

    private Instant visitDateTime;
    private VisitType visitType;

    private String reasonForVisit;
    private String notes;

    private Vitals vitals;

    private Integer gestationalAgeWeeks;
    private Trimester trimester;
    private Boolean highRiskAtVisit;
}

