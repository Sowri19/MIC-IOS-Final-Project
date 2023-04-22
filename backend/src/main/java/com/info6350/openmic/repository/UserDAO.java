package com.info6350.openmic.repository;

import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;
import redis.clients.jedis.Jedis;

import java.io.IOException;
import java.util.List;

@Repository
public class UserDAO {

    private static final Object HASH_KEY = "Users";

    @Autowired
    @Qualifier("redisTemplate")
    private RedisTemplate template;

    public JsonNode save(JsonNode payload) throws IOException {

        //template.get

        if (payload.get("$schema") != null) {
            template.opsForHash().put("Schema", payload.get("type"), payload);
        } else {
            template.opsForHash().put(HASH_KEY, payload.get("id").toString(), payload);
//            template.convertAndSend("http://localhost:9393/publish", payload);



//            RestTemplate restTemplate = new RestTemplate();
//            restTemplate.postForObject("http://localhost:9393/publish", payload, String.class);

//            RestTemplate restTemplate = new RestTemplate();
//            restTemplate.postForObject("http://localhost:8080/producer", payload, String.class);
        }


        return payload;
    }

    public List<JsonNode> findAll() {
        return template.opsForHash().values(HASH_KEY);
    }

    public JsonNode findById(String id) {
        List<JsonNode> users = template.opsForHash().values(HASH_KEY);
        for (JsonNode u : users) {
            if (u.get("id").asText().equals(id)) {
                return u;
            }
        }
        return null;
    }

    public String deleteRate(String id) {


        template.opsForHash().delete(HASH_KEY, id);
        return "user removed!";
    }

    public String getSchema() {
        return template.opsForHash().values("Schema").toString();
    }

    public void update(JsonNode ratePatched, String id) {
        template.opsForHash().put(HASH_KEY, id, ratePatched);
    }

}
