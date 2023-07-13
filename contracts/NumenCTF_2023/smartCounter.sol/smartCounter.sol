pragma solidity ^0.8.13;

contract Deployer {
    constructor(bytes memory code) { assembly { return (add(code, 0x20), mload(code)) } }
}
contract SmartCounter{
    address public owner;
    address public target;
    bool flag=false;
    constructor(address owner_){
        owner=owner_;
    }
    function create(bytes memory code) public{ // call it firstly to generate target, runtime code size < 24 bytes
        require(code.length<=24);
        target=address(new Deployer(code));
    }

    function A_delegateccall(bytes memory data) public{
        (bool success, bytes memory returnData)=target.delegatecall(data);  // delegatecall to change owner
        require(owner==msg.sender);
        flag=true;
    }
    function isSolved() public view returns(bool){
        return flag;
    }
}