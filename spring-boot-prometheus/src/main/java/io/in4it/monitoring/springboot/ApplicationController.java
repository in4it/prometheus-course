package io.in4it.monitoring.springboot;

import org.slf4j.Logger;

import io.micrometer.core.annotation.Timed;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Metrics;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class ApplicationController {

    private static final Logger log = org.slf4j.LoggerFactory.getLogger(ApplicationController.class);
    private Counter runCounter = Metrics.counter("runCounter");

    @Timed
    @GetMapping("/api/demo")
    public String apiUse() throws InterruptedException {
        runCounter.increment();
        log.info("Hello world app accessed on /api/demo");
        return "Hello world";
    }

}
