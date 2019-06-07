package org.webdsl.security;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;

public class AttemptsTracker {
  private static int maxAttempts = 10;
  private static long expiresIn = 10;
  private static TimeUnit expiresUnit = TimeUnit.MINUTES;
  
  private static LoadingCache<String, AttemptCounter> attempts = CacheBuilder.newBuilder()
      .maximumSize(100000)
      .expireAfterWrite(expiresIn, expiresUnit)
      .build(
          new CacheLoader<String, AttemptCounter>() {
            public AttemptCounter load(String key) {
              return new AttemptCounter();
            }
          });  
  
  /*
   * Check if limit has been reached, otherwise increase number of attempts done.
   * Example WebDSL usage:
   * var mayLogin := AttemptLimiter.attempt( "login", remoteAddress() );    
   * validate( mayLogin, "Maximum number of login attempts reached, please try again in 10 minutes");
   * if(mayLogin){
   *   ...do login...
   * }
   */
  public static boolean attempt( String type, String actorID ) {
    AttemptCounter a;
    String key = type + "__" + actorID;
    try {
      a = attempts.get(key);
    } catch (ExecutionException e) {
      return true;
    }
    
    if( a == null ) {
      return true;
    } else {
      a.attempts++;
    }
    
    return a == null || a.attempts <= maxAttempts;
  }
  
  //Only use with care! Resetting the attempts after a successful (login) attempt is a bad idea. Someone can just login to a known user account to reset the counter repeatedly.
  public static void reset( String actorID ) {
    attempts.invalidate( actorID );
  }
  
}

class AttemptCounter{
  int attempts = 0;
}
