package com.info6350.openmic.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.info6350.openmic.repository.ComediansDAO;
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
@RequestMapping("/events")
public class EventsController {

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
    public ResponseEntity getAllEvents(@RequestHeader HttpHeaders headers) {

        return ResponseEntity.ok(dao.findAll());
    }

    @PostMapping("/create")
    public ResponseEntity createEvent(@RequestHeader HttpHeaders headers, @RequestBody JsonNode event) throws IOException {

//        if(!validateClub(club)){
//            ResponseEntity.badRequest().body("Invalid Club Data");
//        } else {
        return ResponseEntity.ok(dao.save(event));
//        }
//
//        return null;

    }

    @PostMapping ("/update")
    public ResponseEntity updateEvent(@RequestHeader HttpHeaders headers, @RequestBody JsonNode event) throws IOException {

        return ResponseEntity.ok(dao.save(event));

    }

    @GetMapping("/get/{id}")
    public ResponseEntity getEventById(@RequestHeader HttpHeaders headers, @PathVariable String id) {

        return ResponseEntity.ok(dao.findById(id));

    }

}
