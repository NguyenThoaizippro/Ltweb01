package vn.iotstar.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.PersistenceContext;

@PersistenceContext
public class JPAConfig {
	private static volatile EntityManagerFactory factory;

	public static EntityManagerFactory getEntityManagerFactory() {
		if (factory == null || !factory.isOpen()) {
			synchronized (JPAConfig.class) {
				if (factory == null || !factory.isOpen()) {
					factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql");
				}
			}
		}
		return factory;
	}

	public static EntityManager getEntityManager() {
		return getEntityManagerFactory().createEntityManager();
	}

	public static void close() {
		if (factory != null && factory.isOpen()) {
			factory.close();
		}
	}
}
