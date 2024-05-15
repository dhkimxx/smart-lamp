package smartLamp.smartLampspring.service;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.transaction.annotation.Transactional;
import smartLamp.smartLampspring.dto.UnitInfoDto;
import smartLamp.smartLampspring.dto.UserInfoDto;
import smartLamp.smartLampspring.Entity.Unit;
import smartLamp.smartLampspring.Entity.User;
import smartLamp.smartLampspring.repository.UnitRepository;
import smartLamp.smartLampspring.repository.UserRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

@Transactional
public class UnitService {
    private final UnitRepository unitRepository;
    private final UserRepository userRepository;

    public UnitService(UnitRepository unitRepository, UserRepository userRepository) {
        this.unitRepository = unitRepository;
        this.userRepository = userRepository;
    }

    public void create(UnitInfoDto unitInfoDto) {
        unitRepository.findByCode(unitInfoDto.getUnitCode()).ifPresent(unit -> {
            throw new DataIntegrityViolationException("unit already exists");
        });

        User storedUser = userRepository.findById(unitInfoDto.getUserId()).orElseThrow(() -> new NoSuchElementException("No user found"));

        Unit newUnit = new Unit();
        newUnit.setUnitCode(unitInfoDto.getUnitCode());
        newUnit.setUnitName(unitInfoDto.getUnitName());
        newUnit.setDistance(unitInfoDto.getDistance());
        newUnit.setTime(unitInfoDto.getTime());
        newUnit.setBrightness(unitInfoDto.getBrightness());
        newUnit.setUser(storedUser);
        unitRepository.save(newUnit);
    }

    public List<Unit> getUnitList(UserInfoDto userInfoDto) {
        User storedUser = userRepository.findById(userInfoDto.getUserId()).orElseThrow(() -> new NoSuchElementException("No user Found"));

        return storedUser.getUnitList();
    }

    public void update(UnitInfoDto unitInfoDto) {
        Unit storedUnit = unitRepository.findByCode(unitInfoDto.getUnitCode()).orElseThrow(() -> new NoSuchElementException("No unit Found"));

        storedUnit.setDistance(unitInfoDto.getDistance());
        storedUnit.setTime(unitInfoDto.getTime());
        storedUnit.setBrightness(unitInfoDto.getBrightness());
        unitRepository.save(storedUnit);
    }

    public void delete(String unitCode) {
        Unit storedUnit = unitRepository.findByCode(unitCode).orElseThrow(() -> new NoSuchElementException("No unit Found"));
        unitRepository.delete(storedUnit);
    }
}
