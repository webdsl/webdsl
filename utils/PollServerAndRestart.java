import java.io.BufferedReader;
import java.io.Closeable;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PollServerAndRestart {
    
    public static void main(String[] args){
        System.out.println(getDateTime()+" started");
        String cmd     = readArgOrElse(args,0,"./restarttomcat.sh");
        System.out.println(getDateTime()+" 1 cmd = "+cmd);
        String url     = readArgOrElse(args,1,"http://webdsl.org/home");
        System.out.println(getDateTime()+" 2 url = "+url);
        String content = readArgOrElse(args,2,"More information about bugs fixed");
        System.out.println(getDateTime()+" 3 content = "+content);
        int restartWaitTime = Integer.parseInt(readArgOrElse(args,3,"60"));
        System.out.println(getDateTime()+" 4 restartWaitTime = "+restartWaitTime+" seconds");

        int fails = 0;
        while(true){
            if(findContents(url,content)){
                System.out.println(getDateTime()+" ok");
                fails=0;
            }
            else{
                System.out.println(getDateTime()+" fail");
                fails++;
            }
            if(fails > 0){
                fails = 0;
                runCommand(cmd);
                wait(restartWaitTime);
            }
            wait(10); 
        }
    }
    
    public static void wait(int seconds){
        try { Thread.sleep(seconds * 1000); } catch (Exception e) { e.printStackTrace();	}
    }
    
    public static String readArgOrElse(String[] args, int argnum, String def){
        if(args.length > argnum){ 
            return args[argnum]; 
        } 
        else{ 
            return def;
        }
    }
    
    public static void runCommand(String cmd){
        Runtime run = Runtime.getRuntime();
        Process proc = null;
        try {
            proc = run.exec(cmd);
        } catch (Exception e) {
            e.printStackTrace();
        }
        /* necessary stuff to avoid 'too many open files' error */
        if(proc != null){
            try{
                proc.waitFor();
            }
            catch(InterruptedException e){
                e.printStackTrace();
            }
            close(proc.getInputStream());
            close(proc.getErrorStream());
            close(proc.getOutputStream());
            proc.destroy();
        }
    }
    
    private static void close(Closeable c) {
        if (c != null) {
            try {
              c.close();
            } catch (IOException e) {
              e.printStackTrace();
            }
        }
    }
    
    public static boolean findContents(String url, String check){
        try {
            URL url1 = new URL(url);
            HttpURLConnection huc = (HttpURLConnection) url1.openConnection();
            HttpURLConnection.setFollowRedirects(false);
                    huc.setReadTimeout(10 * 1000);
            huc.setConnectTimeout(10 * 1000);
            huc.setRequestMethod("GET");
            huc.connect();
            BufferedReader br = new BufferedReader(new InputStreamReader(huc.getInputStream()));
            String buffer = "";
            while (buffer != null) {
                if(buffer.contains(check)){
                    return true;
                }
                buffer = br.readLine();
            }
            huc.disconnect();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return false;		
    }
    
    private static String getDateTime() {
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        Date date = new Date();
        return dateFormat.format(date);
    }
    
}

