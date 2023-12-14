// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract SampleEditor {

    enum Align { None, Bars, BarsAndBeats }

    struct Settings {
        Align align;
        bool flexOn;
    }

    struct Region {
        Settings settings;
        bytes data;
    }

    uint256 public project_tempo = 60;   // slot 0
    uint256 public region_tempo = 60;   // slot 1

    mapping(string => Region[]) public tracks;   // slot 2

    error OvO();    // I'm watching you
    error QaQ();

    constructor() {
        // Settings memory ff = Settings({align: Align.None, flexOn: true});
        Settings memory ff = Settings({align: Align.None, flexOn: false});
        Region[] storage r = tracks["Rhythmic"];   // region_slot (string.2)
        r.push(Region({settings: ff, data: bytes("part1")}));  // region[0] keecak(region_slot)
        r.push(Region({settings: ff, data: bytes("part2")}));
        r.push(Region({settings: ff, data: bytes("part3")}));
        // fill 2 slot  
        // ... flexOn Align
        // bytes  
    }

    function setTempo(uint256 _tempo) external {
        if (_tempo > 233) revert OvO();
        project_tempo = _tempo;  // the biggest of tempo is 233, so the biggest of log2(tempo) is 7
    }

    function adjust() external {  // call this func to change tempo
        if (!tracks["Rhythmic"][2].settings.flexOn)
            revert QaQ();
        region_tempo = project_tempo;
    }

    function updateSettings(uint256 p, uint256 v) external {
        if (p <= 39) revert OvO();
        assembly {
            sstore(p, v)
        }
    }
}