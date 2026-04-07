package dev.ved.natalis.mother_service.entity;

import dev.ved.natalis.mother_service.enums.BloodGroup;
import dev.ved.natalis.mother_service.enums.MaritalStatus;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.time.LocalDate;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "mothers")
@CompoundIndex(def = "{'organizationId': 1, 'doctorId': 1}")
@CompoundIndex(def = "{'organizationId': 1, 'isActive': 1}")
public class Mother {

    @Id
    private String id;   // Mongo _id

    /* =========================
       RELATIONSHIPS
       ========================= */

    @Indexed
    private String userId;          // From User service (optional for now)

    @Indexed
    private String organizationId;  // Hospital / Clinic

    @Indexed
    private String doctorId;        // Primary doctor

    /* =========================
       BASIC PROFILE
       ========================= */

    private String name;

    private Integer age;

    private MaritalStatus maritalStatus;

    private BloodGroup bloodGroup;

    /* =========================
       PREGNANCY DETAILS
       ========================= */

    private LocalDate lmp;   // Last Menstrual Period

    private LocalDate edd;   // Expected Delivery Date (derived)

    private Integer gravida; // Number of pregnancies

    private Integer para;    // Number of births

    private Boolean highRisk = false;

    /* =========================
       EXTENSIBLE MEDICAL DATA
       ========================= */

    private Map<String, Object> additionalMedicalInfo;
    // e.g. thyroid, diabetes, hypertension

    /* =========================
       SYSTEM FIELDS
       ========================= */

    private Boolean isActive = true;

    private Instant createdAt;
}
