package vn.iotstar.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class JpaListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		try {
			// Khởi động JPA khi Tomcat Server start
			// Hibernate sẽ tự động quét các Entity và tạo/cập nhật bảng trong Database
			JPAConfig.getEntityManager().close();
			System.out.println("=== [Hibernate] Auto-created/updated tables on Server Startup successfully! ===");
		} catch (Throwable t) {
			System.err.println("=== [Hibernate] Database connection warning on Server Startup: " + t.getMessage() + " ===");
		}
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		try {
			JPAConfig.close();
		} catch (Throwable ignored) {}
	}
}
