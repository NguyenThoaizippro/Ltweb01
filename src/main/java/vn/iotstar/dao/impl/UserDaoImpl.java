package vn.iotstar.dao.impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JPAConfig;
import vn.iotstar.dao.UserDao;
import vn.iotstar.entity.User;

import java.util.List;

public class UserDaoImpl implements UserDao {

	@Override
	public User findById(int id) {
		EntityManager em = JPAConfig.getEntityManager();
		try {
			return em.find(User.class, id);
		} finally {
			em.close();
		}
	}

	@Override
	public User get(String username) {
		EntityManager em = JPAConfig.getEntityManager();
		try {
			TypedQuery<User> query = em.createNamedQuery("User.findByUsername", User.class);
			query.setParameter("username", username);
			query.setMaxResults(1);
			List<User> list = query.getResultList();
			return list.isEmpty() ? null : list.get(0);
		} finally {
			em.close();
		}
	}

	@Override
	public User getByEmail(String email) {
		EntityManager em = JPAConfig.getEntityManager();
		try {
			TypedQuery<User> query = em.createNamedQuery("User.findByEmail", User.class);
			query.setParameter("email", email);
			query.setMaxResults(1);
			List<User> list = query.getResultList();
			return list.isEmpty() ? null : list.get(0);
		} finally {
			em.close();
		}
	}

	@Override
	public void insert(User user) {
		EntityManager em = JPAConfig.getEntityManager();
		EntityTransaction trans = em.getTransaction();
		try {
			trans.begin();
			em.persist(user);
			trans.commit();
		} catch (Exception e) {
			if (trans.isActive()) trans.rollback();
			throw e;
		} finally {
			em.close();
		}
	}

	@Override
	public void update(User user) {
		EntityManager em = JPAConfig.getEntityManager();
		EntityTransaction trans = em.getTransaction();
		try {
			trans.begin();
			em.merge(user);
			trans.commit();
		} catch (Exception e) {
			if (trans.isActive()) trans.rollback();
			throw e;
		} finally {
			em.close();
		}
	}

	@Override
	public void updateActiveByEmail(String email, int isActive) {
		EntityManager em = JPAConfig.getEntityManager();
		EntityTransaction trans = em.getTransaction();
		try {
			trans.begin();
			TypedQuery<User> query = em.createNamedQuery("User.findByEmail", User.class);
			query.setParameter("email", email);
			query.setMaxResults(1);
			List<User> list = query.getResultList();
			if (!list.isEmpty()) {
				User u = list.get(0);
				u.setIsActive(isActive);
				em.merge(u);
			}
			trans.commit();
		} catch (Exception e) {
			if (trans.isActive()) trans.rollback();
			throw e;
		} finally {
			em.close();
		}
	}

	@Override
	public void updatePassword(User user) {
		update(user);
	}
}
