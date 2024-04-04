// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract AlienSpaceship {

    struct struct_482 {
        bytes32 role;
        uint256 time;
        bool enableWormholes;
    }

    mapping (address => struct_482) public roles;
    bool public wormholesEnabled;
    bool public missionAborted;
    uint256 public numArea51Visits;
    uint256 public x;
    uint256 public y;
    uint256 public z;
    uint256 public payloadMass;


    function CAPTAIN() public pure returns (bytes32) {
        return 0x3a1665efe60dbe93a7cdcf728baddc0d7ebafe407d444d0de3ed20e1e52a6a0d;
    }

    function ENGINEER() public pure returns (bytes32) { 
        return 0x56a2da3687a5982774df44639b06a410da311ff14844c2f7ff0cab50d681571c;
    }

    function PHYSICIST() public pure returns (bytes32) {
        return 0xb5b6b705a01c9fbc2f5b52325436afd32f5988596d999716ad1711063539b564;
    }

    function BLOCKCHAIN_SECURITY_RESEARCHER() public pure returns (bytes32) {
        return 0x720a004d39b816addddcfa184666132ae9e307670a4e534d64e0af23c84ee0e1;
    }

    function distance(uint256 _z, uint256 _y, uint256 _x) internal pure returns(uint256){
        return _z + _y + _x;
    } 

    constructor() {
        payloadMass = 5_000 *10**18;
        x = 1_000_000 *10**18;
        y = 2_000_000 *10**18;
        z = 3_000_000 *10**18;
    }

    function dumpPayload(uint256 payload) public payable {   // 0x4e85c36e
        require(roles[msg.sender].role == ENGINEER(), "Invalid role");
        require(payload <= payloadMass, "Cannot dump more than what exists");
        require(payloadMass - payload > 500 *10**18, "Need to keep some food around");
        payloadMass = payloadMass - payload;
    }

    function jumpThroughWormhole(uint256 _x, uint256 _y, uint256 _z) public payable returns (string memory) {  // 0x183aa328
        require(roles[msg.sender].role == CAPTAIN(), "Invalid role");
        if(wormholesEnabled) {
            if (payloadMass < 1_000 *10**18) {
                uint256 dist = distance(_z, _y, _x);
                if (dist > 100_000 *10**18) {
                    x = _x;
                    y = _y;
                    z = _z;
                    payloadMass = payloadMass << 1;
                    return "You've almost solved the level!";
                } else {
                    return "Cannot get closer than 100km or the enemy will detect us!";
                }
            } else {
                return "Must weigh less than 1,000kg to jump through wormhole";
            }
        } else {
            return "Wormholes are disabled";
        }
    }

    function visitArea51(address password) public payable {  // 0x6f445300
        require(roles[msg.sender].role == CAPTAIN(), "Invalid role");
        require(uint160(uint256(uint160(password)) + uint256(uint160(msg.sender))) == 51);
        numArea51Visits += 1;
        x = 51_000_000 *10**18;
        y = 51_000_000 *10**18;
        z = 51_000_000 *10**18;
    }

    function applyForPromotion(bytes32 addr) public payable { // 0x8c0ff94b
        require(addr == CAPTAIN() || addr == ENGINEER() || addr == PHYSICIST() || addr == BLOCKCHAIN_SECURITY_RESEARCHER(), "Invalid role");
        require(roles[msg.sender].role == PHYSICIST() && addr == CAPTAIN(), "Promotion not available");
        require(roles[msg.sender].time + 12 <= block.timestamp, "You must hold a position for at least 12 seconds before being eligible for promotion");
        require(roles[msg.sender].enableWormholes);
        roles[msg.sender].role = CAPTAIN();
        roles[msg.sender].time = block.timestamp;
    } 

    function applyForJob(bytes32 targetRole) public payable {   // 0xa15184c7
        require(targetRole == CAPTAIN() || targetRole == ENGINEER() || targetRole == PHYSICIST() || targetRole == BLOCKCHAIN_SECURITY_RESEARCHER(), "Invalid role");
        require(roles[msg.sender].role == 0, "Use the applyForPromotion function to get promoted");
        if (targetRole != ENGINEER()) {
            if (targetRole != PHYSICIST() || roles[address(this)].role != ENGINEER()) {
                require(targetRole == BLOCKCHAIN_SECURITY_RESEARCHER(), "Role is not hiring");
                revert("There is no blockchain security researcher position on the spaceship but we've heard that OpenZeppelin is hiring :)");        
            } else {
                roles[msg.sender].role = PHYSICIST();
                roles[msg.sender].time = block.timestamp;
            }
        } else {
            roles[msg.sender].role = ENGINEER();
            roles[msg.sender].time = block.timestamp;
        }
    }

    function quitJob() public payable {
        require(roles[msg.sender].role != 0, "Cannot quit if you don't have a job");
        roles[msg.sender].role = 0;
        roles[msg.sender].time = 0;
        roles[msg.sender].enableWormholes = false;
    }

    function enableWormholes() public payable { // 0xe42c7669
        require(roles[msg.sender].role == PHYSICIST(), "Invalid role");
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        address account = msg.sender;
        assembly {
            codehash := extcodehash(account)
        }
        require(codehash == accountHash); // EOA, constructor
        wormholesEnabled = true;
        roles[msg.sender].enableWormholes = true;
    }

    function runExperiment(bytes memory data) public payable{ //0xea93bc96
        require(roles[msg.sender].role == ENGINEER());
        (bool success, ) = address(this).call(data);
        require(success, "Experiment failed!");
    }
    
    function abortMission() public payable {  // 0x7235a6d5
        require(roles[msg.sender].role == CAPTAIN(), "Invalid role");
        uint256 dist = distance(z, y, x);
        require(dist < 1_000_000 *10**18, "Must be within 1000km to abort mission");
        require(payloadMass < 1_000 *10**18, "Must be weigh less than 1000kg to abort mission");
        require(numArea51Visits > 0, "Must visit Area 51 and scare the humans before aborting mission");
        
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        address account = msg.sender;
        assembly {
        codehash := extcodehash(account)
        }
        require(codehash != accountHash); // isContract

        missionAborted = true;
    }
}