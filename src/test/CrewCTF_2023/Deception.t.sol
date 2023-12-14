// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/CrewCTF_2023/Deception/Setup.sol";

contract Exploiter is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Setup setup;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        setup = new Setup();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", setup.isSolved());
        
        vm.stopPrank();

    }

    function solve() public {
        Deception d = setup.TARGET();
        // will revert
        // d.solve("secret");

        // console2.logBytes(address(setup.TARGET()).code);
        // 0x608060405234801561001057600080fd5b50600436106100575760003560e01c8063224b610b1461005c57806376fe1e921461007a578063799320bb1461008f5780637f60b20a146100b3578063a6f9dae1146100c6575b600080fd5b6100646100d9565b6040516100719190610415565b60405180910390f35b61008d6100883660046104eb565b6101fe565b005b6000546100a390600160a01b900460ff1681565b6040519015158152602001610071565b6100646100c1366004610528565b610296565b61008d6100d4366004610578565b61037d565b6000546060906001600160a01b031633146101335760405162461bcd60e51b81526020600482015260156024820152744f6e6c79206f776e65722063616e2061636365737360581b60448201526064015b60405180910390fd5b600060025460045460015461014891906106a4565b61015291906106c6565b905080604c036101ed576101a2601e6020836003548561017291906106da565b61017c91906106f1565b60405160200161018e91815260200190565b604051602081830303815290604052610296565b6101c7601e6020600354600354626162636101bd9190610705565b61017c9190610718565b6040516020016101d892919061072b565b60405160208183030381529060405291505090565b6040805160208101839052016101d8565b8060405160200161020f919061075a565b604051602081830303815290604052805190602001207fdb91bc5e087269e83dad667aa9d10c334acd7c63657ca8a58346bb89b931934860001b146102805760405162461bcd60e51b81526020600482015260076024820152661a5b9d985b1a5960ca1b604482015260640161012a565b506000805460ff60a01b1916600160a01b179055565b606060006102a48585610718565b6102af906001610705565b67ffffffffffffffff8111156102c7576102c7610448565b6040519080825280601f01601f1916602001820160405280156102f1576020820181803683370190505b50905060005b6103018686610718565b8111610374578360016103148884610705565b61031e9190610718565b8151811061032e5761032e610776565b602001015160f81c60f81b82828151811061034b5761034b610776565b60200101906001600160f81b031916908160001a9053508061036c8161078c565b9150506102f7565b50949350505050565b6000546001600160a01b031633146103cf5760405162461bcd60e51b81526020600482015260156024820152744f6e6c79206f776e65722063616e2061636365737360581b604482015260640161012a565b600080546001600160a01b0319166001600160a01b0392909216919091179055565b60005b8381101561040c5781810151838201526020016103f4565b50506000910152565b60208152600082518060208401526104348160408501602087016103f1565b601f01601f19169190910160400192915050565b634e487b7160e01b600052604160045260246000fd5b600082601f83011261046f57600080fd5b813567ffffffffffffffff8082111561048a5761048a610448565b604051601f8301601f19908116603f011681019082821181831017156104b2576104b2610448565b816040528381528660208588010111156104cb57600080fd5b836020870160208301376000602085830101528094505050505092915050565b6000602082840312156104fd57600080fd5b813567ffffffffffffffff81111561051457600080fd5b6105208482850161045e565b949350505050565b60008060006060848603121561053d57600080fd5b8335925060208401359150604084013567ffffffffffffffff81111561056257600080fd5b61056e8682870161045e565b9150509250925092565b60006020828403121561058a57600080fd5b81356001600160a01b03811681146105a157600080fd5b9392505050565b634e487b7160e01b600052601160045260246000fd5b600181815b808511156105f95781600019048211156105df576105df6105a8565b808516156105ec57918102915b93841c93908002906105c3565b509250929050565b6000826106105750600161069e565b8161061d5750600061069e565b8160018114610633576002811461063d57610659565b600191505061069e565b60ff84111561064e5761064e6105a8565b50506001821b61069e565b5060208310610133831016604e8410600b841016171561067c575081810a61069e565b61068683836105be565b806000190482111561069a5761069a6105a8565b0290505b92915050565b60006105a18383610601565b634e487b7160e01b600052601260045260246000fd5b6000826106d5576106d56106b0565b500690565b808202811582820484141761069e5761069e6105a8565b600082610700576107006106b0565b500490565b8082018082111561069e5761069e6105a8565b8181038181111561069e5761069e6105a8565b6000835161073d8184602088016103f1565b8351908301906107518183602088016103f1565b01949350505050565b6000825161076c8184602087016103f1565b9190910192915050565b634e487b7160e01b600052603260045260246000fd5b60006001820161079e5761079e6105a8565b506001019056fea264697066735822122015a536c3425da7ac868f8dc2f76bb01a95476ec6536474055fddd99ce31c25b464736f6c63430008140033
    
    
        address owner = address(uint160(uint256(vm.load(address(d), 0))));
        vm.startPrank(owner, owner);
        string memory password = d.password();
        // cast call deceptionAddress "password()(string)" -r RPC_URL --from owner
        // xyzabc
        d.solve(password);
    }

}


