package smartLamp.smartLampspring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.transaction.annotation.Transactional;
import smartLamp.smartLampspring.dto.UserInfoDto;
import smartLamp.smartLampspring.Entity.User;
import smartLamp.smartLampspring.repository.UserRepository;

import javax.security.sasl.AuthenticationException;
import java.util.NoSuchElementException;
import java.util.Objects;

@Transactional
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void logout(UserInfoDto userInfoDto) {
        User storedUser = userRepository.findById(userInfoDto.getUserId())
                .orElseThrow(() -> new NoSuchElementException("No user found"));

        storedUser.setAuthenticated(false);
        userRepository.save(storedUser);
    }

    public UserInfoDto login(UserInfoDto userInfoDto) throws AuthenticationException {
        User storedUser = userRepository.findById(userInfoDto.getUserId())
                .orElseThrow(() -> new NoSuchElementException("No user found"));

        if (!Objects.equals(storedUser.getUserPw(), userInfoDto.getUserPw())) {
            throw new AuthenticationException("Invalid password");
        }

        storedUser.setAuthenticated(true);
        userRepository.save(storedUser);
        userInfoDto.setUserName(storedUser.getUserName());
        return userInfoDto;
    }

    public void register(UserInfoDto userInfoDto) {
        userRepository.findById(userInfoDto.getUserId()).ifPresent(user -> {
            throw new DataIntegrityViolationException("userId already exists");
        });

        User newUser = new User();
        newUser.setUserId(userInfoDto.getUserId());
        newUser.setUserPw(userInfoDto.getUserPw());
        newUser.setUserName(userInfoDto.getUserName());
        newUser.setPhone(userInfoDto.getPhone());
        userRepository.save(newUser);
    }

}
