// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

contract LittleMoney {
    address private owner;

    event SendFlag(address);

    constructor(){
        owner = msg.sender;
    }
    struct func{
        function() internal ptr;   // 4 bytes
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier checkPermission(address addr){
        _;
        permission(addr);
    }

    function permission(address addr)internal view{
        bool con = calcCode(addr);
        require(con,"permission");
        require(msg.sender == addr);
    }

    function calcCode(address addr)internal view returns(bool){
        uint x;
        assembly{
            x := extcodesize(addr)
        }
        if(x == 0) {
            return false;
        }
        else if(x > 12) {
            return false;
        }
        else {    // size <= 12 bytes
            assembly {
                // quits the full execution context directly, so the following two require statements were bypassed
                return(0x20,0x00)
                // Docs: Note that the EVM dialect has a built-in function called return 
                // that quits the full execution context (internal message call) 
                // and not just the current yul function.
            }
        }
    }

    function execute(address target) external checkPermission(target){
        (bool success,) = target.delegatecall(abi.encode(bytes4(keccak256("func()"))));
        require(!success,"no cover!");     // must be reverted, so can not cover owner'slot
        uint b;
        uint v;
        (b,v) = getReturnData(); // return 0x40 bytes, blockNumber + jump offset
        require(b == block.number);

        func memory set;
        set.ptr = renounce;
        assembly {
            mstore(set, add(mload(set),v))   // make v+renounce -> emit statement
        }
        set.ptr();
    }

    function renounce()public{     
        // can found according to sig:0xb15be2f5, after the msg.value check
        // or according to the set.ptr() jump in the execute function  
        require(owner != address(0));
        owner = address(0);
    }

    function getReturnData()internal pure returns(uint b,uint v){
        assembly {
            if iszero(eq(returndatasize(), 0x40)) { revert(0, 0) }
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, 0x40)
            b := and(mload(ptr), 0x00000000000000000000000000000000000000000000000000000000ffffffff)
            v := mload(add(0x20, ptr))
        }
    }

    function payforflag() public payable onlyOwner {
        require(msg.value == 1, 'I only need a little money!');
        emit SendFlag(msg.sender);   // can found according to log/caller instruction
    }


    receive()external payable{
        this;
    }
    fallback()external payable{
        revert();
    }
}
