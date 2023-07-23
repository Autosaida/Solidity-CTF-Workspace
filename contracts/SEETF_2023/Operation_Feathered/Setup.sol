// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./Pigeon.sol";

/*
In the dystopian digital landscape of the near future, a cunning mastermind has kickstarted his plan for ultimate dominance by creating an army of robotic pigeons. These pigeons, six in the beginning, are given a sinister mission: to spy on the public, their focus being on individuals amassing significant Ethereum (ETH) holdings.

Each pigeon has been tasked with documenting the ETH each person owns, planning for a future operation to swoop in and siphon off these digital assets. The robotic pigeons, however, are not just spies, but also consumers. They are provided with ETH by their creator to cover their operational expenses, making the network of spy birds self-sustaining and increasingly dangerous.

The army operates on a merit-based system, where the pigeon agents earn points for their successful missions. These points pave their path towards promotion, allowing them to ascend the ranks of the robotic army. But, the journey up isn't free. They must return the earned ETH back to their master for their promotion.

Despite the regimented system, the robotic pigeons have a choice. They can choose to desert the army at any point, taking with them the ETH they've earned. Will they remain loyal, or will they break free?
*/


contract SetupPigeonSEETF23 {
    PigeonSEETF23 public immutable pigeon;

    constructor() payable {
        pigeon = new PigeonSEETF23();

        // Junior Pigeons
        pigeon.assignPigeon("Numbuh", "6", address(0x006), 0);
        pigeon.assignPigeon{value: 5e18}("Numbuh", "5", address(0x005), 0);

        pigeon.assignPigeon("Numbuh", "4", address(0x004), 1);
        pigeon.assignPigeon{value: 10e18}("Numbuh", "3", address(0x003), 1);

        pigeon.assignPigeon("Numbuh", "2", address(0x002), 2);
        pigeon.assignPigeon{value: 15e18}("Numbuh", "1", address(0x001), 2);
    }

    receive() external payable {}

    function isSolved() external view returns (bool) {
        // players ha 5 eth initially
        return address(msg.sender).balance >= 34 ether && address(pigeon).balance == 0 ether;
    }
}
