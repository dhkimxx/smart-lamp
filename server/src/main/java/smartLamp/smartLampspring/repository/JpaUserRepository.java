package smartLamp.smartLampspring.repository;

import smartLamp.smartLampspring.Entity.User;

import javax.persistence.EntityManager;
import java.util.List;
import java.util.Optional;


public class JpaUserRepository implements UserRepository{

    private final EntityManager em;

    public JpaUserRepository(EntityManager em){
        this.em = em;
    }

    @Override
    public User save(User user) {
        em.persist(user);
        return user;
    }

    @Override
    public void delete(User user) {
        em.remove(user);
    }

    @Override
    public Optional<User> findById(String user_id) {
        User user = em.find(User.class, user_id);
        return Optional.ofNullable(user);
    }

    @Override
    public List<User> findAll() {
        return em.createQuery("select m from user m", User.class).getResultList();
    }
}
