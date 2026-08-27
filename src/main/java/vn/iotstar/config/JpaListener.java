package vn.iotstar.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class JpaListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		try {
			// Khởi động JPA ngay khi Tomcat Server start
			// Hibernate sẽ tự động quét các Entity (Category, Video) và tạo bảng trong SQL Server
			JPAConfig.getEntityManager().close();
			System.out.println("=== [Hibernate] Auto-created/updated tables on Server Startup successfully! ===");
		} catch (Exception e) {
			System.err.println("=== [Hibernate] Error initializing database on Server Startup ===");
			e.printStackTrace();
		}
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
	}
}
