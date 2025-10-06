package org.webdsl.servlet;

import org.webdsl.logging.Logger;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * This class will hold state information of the web application servlet 
 */
public class ServletState {
//ANSI escape codes
private static final String ANSI_RESET  = "\u001B[0m";
private static final String ANSI_RED    = "\u001B[31m";
private static final String ANSI_YELLOW = "\u001B[33m";
private static final String ANSI_GREEN  = "\u001B[32m";
private static final String ANSI_BLUE   = "\u001B[34m";
  
    private static boolean inScheduledTask = false;
    private static String runningTask = "";
    private static boolean isServletDestroying = false;

    // Track when the current task started
    private static long taskStartTime = 0L;

    // Track which tasks have executed at least once
    private static final Set<String> seenTasks = new HashSet<>();

    // Track the slowest execution time per task (in ms)
    private static final Map<String, Long> slowestExecutionMs = new HashMap<>();


    public static synchronized void servletDestroyStarted() {
        isServletDestroying = true;
    }

    // Currently only 1 recurring task runs at the time
    public static synchronized void scheduledTaskStarted(String taskName) {
        runningTask = taskName;
        inScheduledTask = true;
        taskStartTime = System.currentTimeMillis();

        // Report first-time execution of this task
        if (!seenTasks.contains(taskName)) {
            seenTasks.add(taskName);
            Logger.info("Executing: " + ANSI_BLUE + taskName + ANSI_RESET + " (logged once)");
        }
    }

    public static synchronized void scheduledTaskEnded() {
        if (inScheduledTask && taskStartTime > 0) {
            long duration = System.currentTimeMillis() - taskStartTime;

            // If duration > 1 sec, report only if slower than any previous slow run
            if (duration > 1000) {
                Long previousSlowest = slowestExecutionMs.get(runningTask);
                if (previousSlowest == null || duration > previousSlowest) {
                    slowestExecutionMs.put(runningTask, duration);
                    Logger.warn(ANSI_RED + "Slow execution (" + duration + " ms) for task: " + ANSI_RESET + ANSI_YELLOW + runningTask + ANSI_RESET);
                }
            }
        }

        inScheduledTask = false;
        runningTask = "";
        taskStartTime = 0;
    }

    public static synchronized boolean inScheduledTask() {
        return inScheduledTask;
    }

    public static synchronized String scheduledTaskName() {
        return runningTask;
    }

    public static synchronized boolean isServletDestroying() {
        return isServletDestroying;
    }
}
