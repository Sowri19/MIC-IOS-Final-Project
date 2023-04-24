package com.info6350.openmic.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.RedisConnectionFailureException;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.repository.configuration.EnableRedisRepositories;
import org.springframework.data.redis.serializer.GenericToStringSerializer;
import org.springframework.data.redis.serializer.JdkSerializationRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
@EnableRedisRepositories
public class RedisConfig {

//    @Bean
//    JedisConnectionFactory jedisConnectionFactory() {
//
//        JedisConnectionFactory jedisConnectionFactory = null;
//
//        try {
//            RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration("localhost",
//                    6379);
//            jedisConnectionFactory = new JedisConnectionFactory(redisStandaloneConfiguration);
//            jedisConnectionFactory.getPoolConfig().setMaxTotal(50);
//            jedisConnectionFactory.getPoolConfig().setMaxIdle(50);
//        } catch (RedisConnectionFailureException e) {
//            e.getMessage();
//        }
//
//        return jedisConnectionFactory;
//    }


//    @Bean
//    public RedisTemplate<String, Object> redisTemplate() {
//        final RedisTemplate<String, Object> template = new RedisTemplate<String, Object>();
//        template.setConnectionFactory(jedisConnectionFactory());
//        template.setValueSerializer(new GenericToStringSerializer<Object>(Object.class));
//        template.setEnableTransactionSupport(true);
//        return template;
//    }

        @Bean
    public JedisConnectionFactory connectionFactory() {
        RedisStandaloneConfiguration configuration = new RedisStandaloneConfiguration();
        configuration.setHostName("redis-19248.c245.us-east-1-3.ec2.cloud.redislabs.com");
        configuration.setPort(19248);
        configuration.setPassword("5fmLrKqUgJjVg90mlbVbsmIMhkFssGOj");
        return new JedisConnectionFactory(configuration);
    }

    @Bean
    public RedisTemplate<String, Object> redisTemplate() {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory());
        template.setKeySerializer(new StringRedisSerializer());
        template.setHashKeySerializer(new JdkSerializationRedisSerializer());
        template.setEnableTransactionSupport(true);
        template.afterPropertiesSet();
        return template;
    }

}
