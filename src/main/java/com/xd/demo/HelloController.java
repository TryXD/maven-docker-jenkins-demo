package com.xd.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
public class HelloController {

    private Logger logger = LoggerFactory.getLogger(HelloController.class);

    @GetMapping("/")
    public String hello() {

        System.out.println("***System.out.println***");
        logger.info("date:{}", new Date());
        return "hello spring-boot-web-docker " + new Date();
    }

    @GetMapping("/helloWorld")
    public String helloWorld() {
        logger.info("~~helloWorld~~");
        return "helloWorld";
    }

}
