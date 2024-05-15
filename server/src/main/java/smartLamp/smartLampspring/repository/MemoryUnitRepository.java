package smartLamp.smartLampspring.repository;

import smartLamp.smartLampspring.Entity.Unit;

import java.util.*;

public class MemoryUnitRepository implements UnitRepository {

    private static Map<String, Unit> store = new HashMap<>();

    @Override
    public Unit save(Unit unit) {
        store.put(unit.getUnitCode(), unit);
        return unit;
    }

    @Override
    public void delete(Unit unit) {
        store.remove(unit.getUnitCode());
    }

    @Override
    public Optional<Unit> findByCode(String unitCode) {
        return Optional.ofNullable(store.get(unitCode));
    }

    @Override
    public List<Unit> findAll() {
        return new ArrayList<>(store.values());
    }
}
