package smartLamp.smartLampspring.sms;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Balance;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import smartLamp.smartLampspring.Entity.Unit;
import smartLamp.smartLampspring.Entity.User;
import smartLamp.smartLampspring.dto.UnitInfoDto;
import smartLamp.smartLampspring.repository.UnitRepository;
import smartLamp.smartLampspring.repository.UserRepository;

import java.util.NoSuchElementException;
import java.util.Optional;

@RestController
@PropertySource("classpath:properties/env.properties")
public class sendSms {
    private final Environment environment;
    final DefaultMessageService messageService;

    private final UserRepository userRepository;
    private final UnitRepository unitRepository;

    public sendSms(UserRepository userRepository, UnitRepository unitRepository, Environment environment) {
        this.userRepository = userRepository;
        this.unitRepository = unitRepository;
        this.environment = environment;
        String apiKey = environment.getProperty("apiKey");
        String apiSecretKey = environment.getProperty("apiSecretKey");
        this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecretKey, "https://api.coolsms.co.kr");

    }

    @PostMapping("/send-test")
    public Message send(@RequestBody UnitInfoDto unitInfoDto) {
        try {
            Unit storedUnit = unitRepository.findByCode(unitInfoDto.getUnitCode())
                    .orElseThrow(() -> new NoSuchElementException("No unit Found"));
            User user = storedUnit.getUser();

            Message message = new Message();
            message.setFrom(environment.getProperty("sendFrom"));
            message.setTo(user.getPhone());
            message.setText("[SmartLampService]\n\n" + '`' + storedUnit.getUnitName() + '`' +  "에서 낙상사고가 예상됩니다.");
            return message;

        } catch (NoSuchElementException e) {
            throw new RuntimeException(e);
        }
    }
    @PostMapping("/send-one")
    public SingleMessageSentResponse sendOne(@RequestBody UnitInfoDto unitInfoDto) {
        try {
            Unit storedUnit = unitRepository.findByCode(unitInfoDto.getUnitCode())
                    .orElseThrow(() -> new NoSuchElementException("No unit Found"));
            User user = storedUnit.getUser();

            Message message = new Message();
            message.setFrom(environment.getProperty("sendFrom"));
            message.setTo(user.getPhone());
            message.setText("[SmartLampService]\n\n" + '`' + storedUnit.getUnitName() + '`' +  "에서 낙상사고가 예상됩니다.");
            SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
            return response;

        } catch (NoSuchElementException e) {
            throw new RuntimeException(e);
        }
    }

    @GetMapping("/get-balance")
    public Balance getBalance() {
        Balance balance = this.messageService.getBalance();
        return balance;
    }
}
