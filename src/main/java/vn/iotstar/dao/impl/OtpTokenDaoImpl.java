package vn.iotstar.dao.impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JPAConfig;
import vn.iotstar.dao.OtpTokenDao;
import vn.iotstar.entity.OtpToken;

import java.util.List;

public class OtpTokenDaoImpl implements OtpTokenDao {

    @Override
    public void save(OtpToken token) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(token);
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public OtpToken findLatest(String email, String purpose) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<OtpToken> query = em.createNamedQuery("OtpToken.findLatest", OtpToken.class);
            query.setParameter("email", email);
            query.setParameter("purpose", purpose);
            query.setMaxResults(1);
            List<OtpToken> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            OtpToken token = em.find(OtpToken.class, id);
            if (token != null) {
                em.remove(token);
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
    public void incrementAttempts(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            OtpToken token = em.find(OtpToken.class, id);
            if (token != null) {
                token.setAttempts(token.getAttempts() + 1);
                em.merge(token);
            }
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
