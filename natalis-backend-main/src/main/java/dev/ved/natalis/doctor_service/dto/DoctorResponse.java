package dev.ved.natalis.doctor_service.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DoctorResponse {

    private String id;
    private String name;
    private String specialization;
    private String qualification;
    private Integer experienceYears;
    private String organizationName;
    private String organizationId;
}
