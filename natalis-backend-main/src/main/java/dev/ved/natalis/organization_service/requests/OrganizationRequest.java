package dev.ved.natalis.organization_service.requests;
import dev.ved.natalis.organization_service.entity.Address;
import dev.ved.natalis.organization_service.enums.OrganizationType;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;



@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrganizationRequest {

    @NotBlank(message = "Organization name is required")
    private String name;

    @NotNull(message = "Organization type is required")
    private OrganizationType type;

    @Valid
    @NotNull(message = "Address is required")
    private Address address;
}
