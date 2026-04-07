package dev.ved.natalis.visit_service.requests;

import dev.ved.natalis.visit_service.entity.Vitals;
import dev.ved.natalis.visit_service.enums.Trimester;
import dev.ved.natalis.visit_service.enums.VisitType;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class VisitRequest {

    /* =========================
       RELATIONSHIPS
       ========================= */

    @NotBlank(message = "Mother ID is required")
    private String motherId;

    @NotBlank(message = "Doctor ID is required")
    private String doctorId;

    /* =========================
       VISIT DETAILS
       ========================= */

    private VisitType visitType;   // ROUTINE_ANC, FOLLOW_UP, etc.

    private String reasonForVisit;

    private String notes;

    /* =========================
       VITALS
       ========================= */

    private Vitals vitals;

    /* =========================
       PREGNANCY SNAPSHOT
       ========================= */

    private Integer gestationalAgeWeeks;

    private Trimester trimester;

    private Boolean highRiskAtVisit;

    /* =========================
       EXTENSIBLE NOTES
       ========================= */

    private Map<String, Object> additionalNotes;
}
