package vn.iotstar.util;

import java.io.File;

public class Constant {
    public static final String DIR = System.getProperty("os.name") != null && System.getProperty("os.name").toLowerCase().contains("win")
            ? "D:\\upload"
            : System.getProperty("user.home") + File.separator + "upload";
    public static final String SESSION_USERNAME = "username";
    public static final String COOKIE_REMEMBER = "username";
}

