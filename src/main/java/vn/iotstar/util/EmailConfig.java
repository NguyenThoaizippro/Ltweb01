package vn.iotstar.util;
public class EmailConfig {
  public static String getApiKey(){
    String v=System.getenv("BREVO_API_KEY");
    if(v!=null && !v.isBlank()) return v;
    try{
      var p=new java.util.Properties();
      var is=EmailConfig.class.getResourceAsStream("/brevo.properties");
      if(is!=null){ p.load(is); String k=p.getProperty("brevo.api.key"); if(k!=null && !k.isBlank() && !k.contains("xxx")) return k; }
    }catch(Exception e){}
    // Fallback: read from local untracked file D:\upload\brevo.key if exists (dev only)
    try{ String k=java.nio.file.Files.readString(java.nio.file.Path.of("D:/upload/brevo.key")).trim(); if(!k.isBlank()) return k; }catch(Exception e){}
    return null; // caller must handle null -> mock log
  }
  public static String getFromEmail(){ return "thoain.n2006@gmail.com"; }
  public static String getFromName(){ return "TOIDIBANHANG"; }
  public static String getSmtpHost(){ return "smtp-relay.brevo.com"; }
  public static int getSmtpPort(){ return 587; }
}
