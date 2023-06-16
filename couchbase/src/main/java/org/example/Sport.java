package org.example;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.couchbase.core.mapping.Document;

@Document
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Sport {
    @Id
    private String id;
    private String sportName;
    private String sportProficiency;
    //index: CREATE INDEX idx_sportName ON `my-bucket`(DISTINCT ARRAY sport.sportName FOR sport IN sports END)
}
