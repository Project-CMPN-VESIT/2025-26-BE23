package dev.ved.natalis.visit_service.entity;

import lombok.*;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Vitals {

    private String bloodPressure;   // e.g. 120/80
    private Double weight;          // kg
    private Double height;          // cm
    private Integer fetalHeartRate; // bpm
    private Double temperature;     // optional
}
