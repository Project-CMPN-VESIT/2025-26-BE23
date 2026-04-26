package dev.ved.natalis.mother_service.dto;

import dev.ved.natalis.mother_service.enums.BloodGroup;
import dev.ved.natalis.mother_service.enums.MaritalStatus;
import lombok.*;

import java.time.LocalDate;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MotherResponse {

    private String id;
    private String name;
    private Integer age;
    private MaritalStatus maritalStatus;
    private BloodGroup bloodGroup;

    private LocalDate lmp;
    private LocalDate edd;

    private Integer gravida;
    private Integer para;
    private Boolean highRisk;

    private String doctorId;
    private String organizationId;
}
