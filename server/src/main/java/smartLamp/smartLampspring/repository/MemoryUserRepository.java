package smartLamp.smartLampspring.repository;

import smartLamp.smartLampspring.Entity.User;

import java.util.*;

public class MemoryUserRepository implements UserRepository {
    private static Map<String, User> store = new HashMap<>();


    @Override
    public User save(User user) {
        store.put(user.getUserId(), user);
        return user;
    }

    @Override
    public void delete(User user) {
        store.remove(user.getUserId());
    }

    @Override
    public Optional<User> findById(String userId) {
        return Optional.ofNullable(store.get(userId));
    }

    @Override
    public List<User> findAll() {
        return new ArrayList<>(store.values());
    }
}
