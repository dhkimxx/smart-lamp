package smartLamp.smartLampspring.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import smartLamp.smartLampspring.dto.UserInfoDto;
import smartLamp.smartLampspring.service.UserService;

import javax.security.sasl.AuthenticationException;
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;

    private UserController(UserService userService) {
        this.userService = userService;
    }

    // 사용자 정보 등록 API
    @PostMapping
    public ResponseEntity<Void> createUser(@RequestBody UserInfoDto userInfoDto) {
        try {
            userService.register(userInfoDto);
            return ResponseEntity.status(HttpStatus.CREATED).build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
    }

    // 사용자 인증 API
    @PostMapping("/authenticate")
    public ResponseEntity<UserInfoDto> loginUser(@RequestBody UserInfoDto userInfoDto) {
        try {
            UserInfoDto userInfo = userService.login(userInfoDto);
            return ResponseEntity.ok(userInfo);
        } catch (AuthenticationException | NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }

    // 사용자 로그아웃 API
    @PatchMapping("/authenticate")
    public ResponseEntity<Void> logoutUser(@RequestBody UserInfoDto userInfoDto) {
        try {
            userService.logout(userInfoDto);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

    }
}