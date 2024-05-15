package smartLamp.smartLampspring.repository;

import smartLamp.smartLampspring.Entity.Unit;

import java.util.List;
import java.util.Optional;

public interface UnitRepository {
    Unit save(Unit unit);

    void delete(Unit unit);

    Optional<Unit> findByCode(String unitCode);

    List<Unit> findAll();
}
