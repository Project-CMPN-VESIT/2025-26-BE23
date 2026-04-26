package dev.ved.natalis.doctor_service.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "doctors")
@CompoundIndex(def = "{'organizationId': 1, 'userId': 1}", unique = true)
public class Doctor {

    @Id
    private String id;

    @Indexed(unique = true)
    private String userId;   // Reference to User (Auth)

    private String name;

    private String specialization;

    private String qualification;

    private Integer experienceYears;

    @Indexed
    private String organizationId;

    private String organizationName;

    private Boolean isActive = true;

    private Instant createdAt;
}

