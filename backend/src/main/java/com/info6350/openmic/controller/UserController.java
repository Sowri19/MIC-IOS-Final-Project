package com.info6350.openmic.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.info6350.openmic.repository.UserDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserDAO dao;
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
    public ResponseEntity getAllUsers(@RequestHeader HttpHeaders headers) {

        return ResponseEntity.ok(dao.findAll());
    }

    @PostMapping("/create")
    public ResponseEntity createUser(@RequestBody String user) throws IOException {

//        if(!validateUser(user)){
//            ResponseEntity.badRequest().body("Invalid User Data");
//        } else {
        JsonNode u = mapper.readTree(user);
            return ResponseEntity.ok(dao.save(u));
//        }

//        return null;

    }

    @PostMapping ("/update")
    public ResponseEntity updateUser(@RequestHeader HttpHeaders headers, @RequestBody JsonNode user) throws IOException {

        List<JsonNode> users = dao.findAll();

        JsonNode updatedUser = null;

        for(JsonNode u: users) {
            if (u.get("id").asText().equals(user.get("id").asText())) {
                if(!u.get("isComedian").isNull()){
                    ObjectNode nodes = mapper.readValue(u.traverse(), ObjectNode.class);
//                nodes.put("picture", user.get("picture"));
                    nodes.put("genre", user.get("genre"));
                    nodes.put("bio", user.get("bio"));
                    updatedUser = nodes;
                    break;
                } else {
                    ObjectNode nodes = mapper.readValue(u.traverse(), ObjectNode.class);
//                nodes.put("picture", user.get("picture"));
                    nodes.put("poc", user.get("poc"));
                    nodes.put("location", user.get("location"));
                    updatedUser = nodes;
                    break;
                }

            }
        }


        if (updatedUser == null) {
            // handle user not found error
            return ResponseEntity.notFound().build();
        }

        dao.save(updatedUser);

        return ResponseEntity.ok(updatedUser);

    }

    @GetMapping("/get/{id}")
    public ResponseEntity getUserById(@RequestHeader HttpHeaders headers, @PathVariable String id) {

        return ResponseEntity.ok(dao.findById(id));

    }

    public boolean validateUser(JsonNode user) {

        String emailRegex = "^(.+)@(.+)$";
        String passwordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#&()–[{}]:;',?/*~$^+=<>]).{8,20}$";

        if(!user.get("id").isInt()){
            return false;
        } else if(!user.get("firstName").isTextual()){
            return false;
        } else if(!user.get("lastName").isTextual()){
            return false;
        } else if(!user.get("email").isTextual()){
            Pattern pattern = Pattern.compile(emailRegex);
            Matcher matcher = pattern.matcher((CharSequence) user.get("email"));
            if(!matcher.matches()){
                return false;
            }
        } else if(!user.get("password").isTextual()){
            Pattern pattern = Pattern.compile(passwordRegex);
            Matcher matcher = pattern.matcher((CharSequence) user.get("password"));
            if(!matcher.matches()){
                return false;
            }
        }

        return true;

    }


}
