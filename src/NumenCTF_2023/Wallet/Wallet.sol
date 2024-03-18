// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
import "./IERC20.sol";

contract NC is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    address public admin;

    constructor() {
        _mint(msg.sender, 100 * 10**18);
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public override view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public override view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        _spendAllowance(from, msg.sender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 fromBalance = _balances[from];
        require(
            fromBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[from] = fromBalance - amount;
        _balances[to] += amount;
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply += amount;
        _balances[account] += amount;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        if (tx.origin == admin) {
            require(msg.sender.code.length > 0);
            _allowances[spender][tx.origin] = amount;
            return;
        }
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
}

struct Holder {
    address user;
    string name;
    bool approve;
    bytes reason;
}
struct Signature {
    uint8 v;
    bytes32[2] rs;
}
struct SignedByowner {
    Holder holder;
    Signature signature;
}

contract Wallet {
    address[] public owners;
    address immutable public token;
    Verifier immutable public verifier;
    mapping(address => uint256) public contribution;
    address[] public contributors;

    constructor() {
        token = address(new NC());
        verifier = new Verifier();
        initWallet();
    }

    function initWallet() private {
        owners.push(address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));
        owners.push(address(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2));
        owners.push(address(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db));
        owners.push(address(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB));
        owners.push(address(0x617F2E2fD72FD9D5503197092aC168c91465E7f2));
    }

    function deposit(uint256 _amount) public {
        require(_amount > 0, "Deposit value of 0 is not allowed");
        IERC20(token).transferFrom(msg.sender, address(this), _amount);
        if(contribution[msg.sender] == 0){
            contributors.push(msg.sender);
        }
        contribution[msg.sender] += _amount;

    }

    function transferWithSign(address _to, uint256 _amount, SignedByowner[] calldata signs) external {
        require(address(0) != _to, "Please fill in the correct address");
        require(_amount > 0, "amount must be greater than 0");
        uint256 len = signs.length;
        require(len > (owners.length / 2), "Not enough signatures");
        Holder memory holder;
        uint256 numOfApprove;
        for(uint i; i < len; i++){
            holder = signs[i].holder;
            if(holder.approve){
                //Prevent zero address
                require(checkSinger(holder.user), "Signer is not wallet owner");
                verifier.verify(_to, _amount, signs[i]);
            }else{
                continue;
            }
            numOfApprove++;
        }
        require(numOfApprove > owners.length / 2, "not enough confirmation");
        IERC20(token).approve(_to, _amount);
        IERC20(token).transfer(_to, _amount);
    }

    function checkSinger(address _addr) public view returns(bool res){  // the same signature could be used multiple times
        for(uint i; i < owners.length; i++){      
            if(owners[i] == _addr){
                res = true;
            }
        }
    }

    function isSolved() public view returns(bool){
        return IERC20(token).balanceOf(address(this)) == 0;
    }
    
}

contract Verifier{

    function verify(address _to, uint256 _amount, SignedByowner calldata scoupon) public pure {
        Holder memory holder = scoupon.holder;
        Signature memory sig = scoupon.signature;
        bytes memory serialized = abi.encode(
            _to,
            _amount,
            holder.approve,
            holder.reason
        );
        // console2.logBytes(msg.data);
        // 0x6452dc9d
        // address,uint256,((address,string,bool,bytes),(uint8,bytes32[2]))
        // 000000000000000000000000d41bc63873be128dabaf5207847b7f3368455a54 address _to
        // 0000000000000000000000000000000000000000000000056bc75e2d63100000 uint256 _amount
        // 0000000000000000000000000000000000000000000000000000000000000060 offset to scoupon
        // 0000000000000000000000000000000000000000000000000000000000000080 offset to holder
        // 0000000000000000000000000000000000000000000000000000000000000001 signature.v
        // 3100000000000000000000000000000000000000000000000000000000000000 signature.rs[0]
        // 3200000000000000000000000000000000000000000000000000000000000000 signature.rs[1]
        // 0000000000000000000000000000000000000000000000000000000000000000 holder.user
        // 0000000000000000000000000000000000000000000000000000000000000080 offset to name
        // 0000000000000000000000000000000000000000000000000000000000000001 bool approve
        // 00000000000000000000000000000000000000000000000000000000000000c0 offset to reason
        // 0000000000000000000000000000000000000000000000000000000000000006 len name
        // 61747461636b0000000000000000000000000000000000000000000000000000 bytes name
        // 0000000000000000000000000000000000000000000000000000000000000001 len reason
        // 3000000000000000000000000000000000000000000000000000000000000000 bytes reason        
        // https://arbiscan.io/solcbuginfo?a=AbiReencodingHeadOverflowWithStaticArrayCleanup
        // https://soliditylang.org/blog/2022/08/08/calldata-tuple-reencoding-head-overflow-bug/
        // bug fixed until v0.8.16

        require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", serialized)), sig.v, sig.rs[0], sig.rs[1]) == holder.user, "Invalid signature");
    }
}