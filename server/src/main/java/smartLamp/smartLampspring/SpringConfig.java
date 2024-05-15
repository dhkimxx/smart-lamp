package smartLamp.smartLampspring;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import smartLamp.smartLampspring.repository.JpaUnitRepository;
import smartLamp.smartLampspring.repository.JpaUserRepository;
import smartLamp.smartLampspring.repository.UnitRepository;
import smartLamp.smartLampspring.repository.UserRepository;
import smartLamp.smartLampspring.service.UnitService;
import smartLamp.smartLampspring.service.UserService;

import javax.persistence.EntityManager;
import javax.sql.DataSource;

@Configuration
public class SpringConfig {
    private final DataSource dataSource;
    public final EntityManager em;

    public SpringConfig(DataSource dataSource, EntityManager em) {
        this.dataSource = dataSource;
        this.em = em;
    }

    @Bean
    public UserService userService(){
        return new UserService(userRepository());
    }

    @Bean
    public UserRepository userRepository(){
        return new JpaUserRepository(em);
    }

    @Bean
    public UnitService unitService(){
        return new UnitService(unitRepository(), userRepository());
    }

    @Bean
    public UnitRepository unitRepository(){
        return new JpaUnitRepository(em);
    }
}
