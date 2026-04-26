package dev.ved.natalis.test_service.entity;

import dev.ved.natalis.test_service.enums.TestType;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;


import java.time.Instant;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "tests")
@CompoundIndex(def = "{'organizationId': 1, 'motherId': 1}")
@CompoundIndex(def = "{'organizationId': 1, 'doctorId': 1}")
@CompoundIndex(
        name = "org_created_idx",
        def = "{'organizationId': 1, 'createdAt': 1}"
)
//@CompoundIndex(def = "{'organizationId': 1, 'visitId': 1, 'testTime': -1}")
public class Test {

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
    private String motherName;

    @Indexed
    private String doctorName;

    @Indexed
    private String doctorId;

//    @Indexed
//    private String visitId;


    /* =========================
       TEST METADATA
       ========================= */

    private TestType testType;   // AI_ANALYSIS for now

    private Instant testTime;

    /* =========================
       AI OUTPUT PARAMETERS
       ========================= */

    private Double hcMm;               // Head circumference (mm)

    private Double gaWeeks;            // Gestational age (weeks)

    private String classification;     // Normal / Abnormal / etc.

    private String percentileBand;     // e.g. 10–90

    private String edd;                // predicted EDD (string from model)

    private String trimester;

    private String weeksRemaining;

    /* =========================
       IMAGE OUTPUT
       ========================= */

    private String annotatedImageBase64; // TEMP (later → object storage)

    /* =========================
       EXTENSIBILITY
       ========================= */

    private Map<String, Object> additionalResults;

    /* =========================
       SYSTEM FIELDS
       ========================= */

    private Boolean isActive = true;

    private Instant createdAt;
}
