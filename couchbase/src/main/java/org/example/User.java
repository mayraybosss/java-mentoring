package org.example;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.couchbase.core.mapping.Document;

import java.util.Date;
import java.util.List;

@Document
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    private String id;
    private String email;
    private String fullName;
    private Date birthDate;
    private String gender;
    private List<Sport> sports;

    // index creation
    // CREATE INDEX idx_email ON `my-bucket`(email);
}
