package smartLamp.smartLampspring.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import smartLamp.smartLampspring.dto.UnitInfoDto;
import smartLamp.smartLampspring.dto.UserInfoDto;
import smartLamp.smartLampspring.Entity.Unit;
import smartLamp.smartLampspring.service.UnitService;

import java.util.List;
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/api/unit")
public class UnitController {

    private final UnitService unitService;

    @Autowired
    public UnitController(UnitService unitService) {
        this.unitService = unitService;
    }

    // 디바이스 정보 등록 API
    @PostMapping
    public ResponseEntity<Void> createUnit(@RequestBody UnitInfoDto unitInfoDto) {
        try {
            unitService.create(unitInfoDto);
            return ResponseEntity.status(HttpStatus.CREATED).build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
    }

    // 디바이스 정보 반환 API
    @PostMapping("/unitList")
    public ResponseEntity<List<Unit>> getUnitList(@RequestBody UserInfoDto userInfoDto) {
        return ResponseEntity.ok(unitService.getUnitList(userInfoDto));
    }


    // 디바이스 정보 수정
    @PatchMapping
    public ResponseEntity<Void> updateUnit(@RequestBody UnitInfoDto unitInfoDto) {
        try {
            unitService.update(unitInfoDto);
            return ResponseEntity.status(HttpStatus.CREATED).build();
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
    }

    // 디바이스 삭제 API
    @DeleteMapping
    public ResponseEntity<Void> deleteUnit(@RequestBody UnitInfoDto unitInfoDto) {
        try {
            unitService.delete(unitInfoDto.getUnitCode());
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

}
