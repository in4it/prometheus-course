package io.in4it.monitoring.springboot;

import org.slf4j.Logger;

import io.micrometer.core.annotation.Timed;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Metrics;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@RestController
public class ApplicationController {

    private static final Logger log = org.slf4j.LoggerFactory.getLogger(ApplicationController.class);
    private Counter runCounter = Metrics.counter("runCounter");
    private Random random = new Random();

    @GetMapping("/api/demo")
    @Timed
    // creates a Timer time series named http_server_requests which by default contains dimensions for the HTTP status of the response, HTTP method, exception type if the request fails, and the pre-variable substitution parameterized endpoint URI.
    public String apiUse() throws InterruptedException {
        runCounter.increment();
        log.info("Hello world app accessed on /api/demo");
        return "Hello world";
    }
    
    @GetMapping("/api/delayed/demo")
    @Timed
    public String apiCountedUse() throws InterruptedException {
        int delay = (int) Math.sqrt(random.nextInt(400*200));
        log.info("/api/delayed/demo called, waiting for: {}", delay);
        Thread.sleep(delay);
        return "Done waiting, waited: " + delay + " ms";
    }

}
