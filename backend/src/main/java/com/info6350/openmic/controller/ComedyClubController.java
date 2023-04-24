package com.info6350.openmic.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.info6350.openmic.repository.ComedyClubDAO;
import com.info6350.openmic.repository.UserDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/clubs")
public class ComedyClubController {

    @Autowired
    private ComedyClubDAO dao;
    static ObjectMapper mapper = new ObjectMapper();
    static String jws;

    @GetMapping("/schema")
    public ResponseEntity getSchema(@RequestHeader HttpHeaders headers) {
//        if(!validateToken(headers.get(HttpHeaders.AUTHORIZATION))) {
//            return ResponseEntity.badRequest().body("Invalid Token!");
//        } else {
        return ResponseEntity.ok(dao.getSchema());
//        }

    }

    @GetMapping("/getAll")
    public ResponseEntity getAllClubs(@RequestHeader HttpHeaders headers) {

        return ResponseEntity.ok(dao.findAll());
    }

    @PostMapping("/create")
    public ResponseEntity createClub(@RequestHeader HttpHeaders headers, @RequestBody JsonNode club) throws IOException {

//        if(!validateClub(club)){
//            ResponseEntity.badRequest().body("Invalid Club Data");
//        } else {
            return ResponseEntity.ok(dao.save(club));
//        }
//
//        return null;

    }

    @PostMapping ("/update")
    public ResponseEntity updateClub(@RequestHeader HttpHeaders headers, @RequestBody JsonNode club) throws IOException {

        return ResponseEntity.ok(dao.save(club));

    }

    @GetMapping("/get/{id}")
    public ResponseEntity getClubById(@RequestHeader HttpHeaders headers, @PathVariable String id) {

        return ResponseEntity.ok(dao.findById(id));

    }

//    public boolean validateClub(JsonNode club) {
//
//        String emailRegex = "^(.+)@(.+)$";
//        String passwordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#&()–[{}]:;',?/*~$^+=<>]).{8,20}$";
//
//        if(!club.get("id").isInt()){
//            return false;
//        } else if(!club.get("firstName").isTextual()){
//            return false;
//        } else if(!club.get("lastName").isTextual()){
//            return false;
//        } else if(!club.get("email").isTextual()){
//            Pattern pattern = Pattern.compile(emailRegex);
//            Matcher matcher = pattern.matcher((CharSequence) club.get("email"));
//            if(!matcher.matches()){
//                return false;
//            }
//        } else if(!club.get("password").isTextual()){
//            Pattern pattern = Pattern.compile(passwordRegex);
//            Matcher matcher = pattern.matcher((CharSequence) club.get("password"));
//            if(!matcher.matches()){
//                return false;
//            }
//        }
//
//        return true;
//
//    }

}
