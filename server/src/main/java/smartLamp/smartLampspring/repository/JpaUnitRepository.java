package smartLamp.smartLampspring.repository;

import smartLamp.smartLampspring.Entity.Unit;

import javax.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

public class JpaUnitRepository implements UnitRepository{

    private final EntityManager em;

    public JpaUnitRepository(EntityManager em){
        this.em = em;
    }
    @Override
    public Unit save(Unit unit) {
        em.persist(unit);
        return unit;
    }

    @Override
    public void delete(Unit unit) {
        em.remove(unit);
    }

    @Override
    public Optional<Unit> findByCode(String unitCode) {
        Unit unit = em.find(Unit.class, unitCode);
        return Optional.ofNullable(unit);
    }

    @Override
    public List<Unit> findAll() {
        return em.createQuery("select m from unit m", Unit.class).getResultList();
    }
}
