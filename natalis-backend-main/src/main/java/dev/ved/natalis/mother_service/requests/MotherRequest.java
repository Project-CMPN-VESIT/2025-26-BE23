package dev.ved.natalis.mother_service.requests;

import dev.ved.natalis.mother_service.enums.BloodGroup;
import dev.ved.natalis.mother_service.enums.MaritalStatus;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.time.LocalDate;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MotherRequest {

    /* =========================
       BASIC PROFILE
       ========================= */

    @NotBlank(message = "Mother name is required")
    private String name;

    @NotNull(message = "Age is required")
    @Min(value = 10, message = "Age must be valid")
    private Integer age;

    @NotNull(message = "Marital status is required")
    private MaritalStatus maritalStatus;

    @NotNull(message = "Blood group is required")
    private BloodGroup bloodGroup;

    /* =========================
       PREGNANCY DETAILS
       ========================= */

    @NotNull(message = "LMP is required")
    private LocalDate lmp;

    @Min(value = 0, message = "Gravida cannot be negative")
    private Integer gravida;

    @Min(value = 0, message = "Para cannot be negative")
    private Integer para;

    private Boolean highRisk;

    /* =========================
       ADDITIONAL MEDICAL INFO
       ========================= */

    private Map<String, Object> additionalMedicalInfo;
}
