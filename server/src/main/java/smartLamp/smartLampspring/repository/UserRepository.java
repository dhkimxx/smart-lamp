package smartLamp.smartLampspring.repository;

import smartLamp.smartLampspring.Entity.User;

import java.util.List;
import java.util.Optional;

public interface UserRepository {
    User save(User user);

    void delete(User user);

    Optional<User> findById(String userId);

    List<User> findAll();
}
