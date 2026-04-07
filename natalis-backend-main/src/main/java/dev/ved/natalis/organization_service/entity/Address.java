package dev.ved.natalis.organization_service.entity;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Address {

    private String line1;
    private String line2;
    private String city;
    private String state;
    private String country;
    private String pincode;
}
