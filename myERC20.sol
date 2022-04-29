//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract myERC20 {

    string public name;
    string public symbol;
    address public ContractOwner;
    uint256 public maxSupply;
    uint256 public totalMinted = 0;

    //Event emitter
    event Approval(address  tokenOwner, address  spender, uint tokens);
    event Transfer(address  from, address  to, uint tokens);
    event Minted(address to, uint amount);
    event Burnt(address user, uint amount);

    //Modifier
    modifier isContractOwner {
      require(msg.sender == ContractOwner,"Not the ContractOwner");
      _;
    }
    //balance of given addr
    mapping(address => uint256) balances;

    //Amount that can be transfer from delegate address
    mapping(address => mapping (address => uint256)) allowed;
    

    using Calculation for uint256;

   constructor(uint256 _maxSupply, string memory _name, string memory _symbol) {  
	    maxSupply = _maxSupply;
        name = _name;
        symbol = _symbol;
        ContractOwner = msg.sender;
    }

    function totalSupply() public view returns (uint256) {
	return maxSupply;
    }
    
    function balanceOf(address user) public view returns (uint256) {
        return balances[user];
    }

    //Only the contract owner can mint tokens to other users
    function mint(address to, uint256 amount) public isContractOwner returns (bool) {
        require((totalMinted + amount) <= maxSupply, "Max supply count exceded");
        balances[to] = balances[to].add(amount);
        totalMinted = totalMinted.add(amount);
        emit Minted(to, amount);
        return true;
    }

    //Only the token holders can burn tokens
    function burn(uint256 amount) public returns (bool) {
        require(balances[msg.sender] >= amount, "burn amount exceeds balance");
        balances[msg.sender] = balances[msg.sender].sub(amount);
        totalMinted = totalMinted - amount;   // If the amount to be replenished
        emit Burnt(msg.sender, amount);
        return true;
    }

    //Make direct transfer of tokens between sender and receiver
    function transfer(address receiver, uint256 amount) public returns (bool) {
        require(amount <= balances[msg.sender],"Not enough tokens");
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[receiver] = balances[receiver].add(amount);
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    //it allow someone to make transfer on behalf of the token owner with predefined amount
    function approve(address spender, uint maxAllowedAmount) public returns (bool) {
        allowed[msg.sender][spender] = maxAllowedAmount;
        emit Approval(msg.sender, spender, maxAllowedAmount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint) {
        return allowed[owner][spender];
    }

    //the caller should be authorized/spender to have maxAllowedAmount != 0
    function transferFrom(address owner, address buyer, uint amount) public returns (bool) {
        require(amount <= balances[owner],"Not enough balance");    
        require(amount <= allowed[owner][msg.sender], "remaining allowed amount Limit exceeded");
    
        balances[owner] = balances[owner].sub(amount);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(amount);
        balances[buyer] = balances[buyer].add(amount);
        emit Transfer(owner, buyer, amount);
        return true;
    }
}

//Library for reusable pure function
library Calculation { 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}