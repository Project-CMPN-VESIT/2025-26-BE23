package dev.ved.natalis.visit_service.entity;


import dev.ved.natalis.visit_service.enums.Trimester;
import dev.ved.natalis.visit_service.enums.VisitType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;


import java.time.Instant;
import java.util.Date;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "visits")
@CompoundIndex(def = "{'organizationId': 1, 'motherId': 1, 'visitDateTime': -1}")
@CompoundIndex(def = "{'organizationId': 1, 'doctorId': 1, 'visitDateTime': -1}")
public class Visit {

    @Id
    private String id;

    /* =========================
       RELATIONSHIPS
       ========================= */

    @Indexed
    private String organizationId;

    @Indexed
    private String motherId;

    @Indexed
    private String doctorId;

    /* =========================
       VISIT METADATA
       ========================= */

    private Instant visitDateTime;

    private VisitType visitType;   // ROUTINE_ANC, FOLLOW_UP, EMERGENCY, etc.

    private String reasonForVisit;

    private String notes;           // Doctor notes

    /* =========================
       VITALS (EMBEDDED)
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

    /* =========================
       SYSTEM FIELDS
       ========================= */

    private Boolean isActive = true;

    private Instant createdAt;

    private Instant updatedAt;
}
