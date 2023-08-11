// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract ConfidentialQuill {
    string public firstUser = "ALICE";
    uint public alice_age = 24;
		bytes32 private ALICE_PRIVATE_KEY = hex"494b5e35a96cc412e378a765ecd50c479aaa60e631d4febf924bae25897dabf0"; //Super Secret Key
    bytes32 public ALICE_DATA = "QWxpY2UK";
    bytes32 private aliceHash = hash(ALICE_PRIVATE_KEY, ALICE_DATA);

    string public secondUser = "BOB";
    uint public bob_age = 21;
    bytes32 private BOB_PRIVATE_KEY = hex"9027c0d0f5f1e82ae19f40e71639cc9bd5b9ec607bf2cf4e0600af9cd3b2b58c"; // Super Secret Key
    bytes32 public BOB_DATA = "Qm9iCg";
    bytes32 private bobHash = hash(BOB_PRIVATE_KEY, BOB_DATA);
		
		constructor() {}

    function hash(bytes32 key1, bytes32 key2) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(key1, key2));
    }

    function checkthehash(bytes32 _hash) public view returns(bool){
        require (_hash == hash(aliceHash, bobHash));
        return true;
    }
}