['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Owned {\n', '\n', '   address public owner;\n', '   address public proposedOwner;\n', '\n', '   event OwnershipTransferInitiated(address indexed _proposedOwner);\n', '   event OwnershipTransferCompleted(address indexed _newOwner);\n', '   event OwnershipTransferCanceled();\n', '\n', '\n', '   function Owned() public\n', '   {\n', '      owner = msg.sender;\n', '   }\n', '\n', '\n', '   modifier onlyOwner() {\n', '      require(isOwner(msg.sender) == true);\n', '      _;\n', '   }\n', '\n', '\n', '   function isOwner(address _address) public view returns (bool) {\n', '      return (_address == owner);\n', '   }\n', '\n', '\n', '   function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {\n', '      require(_proposedOwner != address(0));\n', '      require(_proposedOwner != address(this));\n', '      require(_proposedOwner != owner);\n', '\n', '      proposedOwner = _proposedOwner;\n', '\n', '      OwnershipTransferInitiated(proposedOwner);\n', '\n', '      return true;\n', '   }\n', '\n', '\n', '   function cancelOwnershipTransfer() public onlyOwner returns (bool) {\n', '      if (proposedOwner == address(0)) {\n', '         return true;\n', '      }\n', '\n', '      proposedOwner = address(0);\n', '\n', '      OwnershipTransferCanceled();\n', '\n', '      return true;\n', '   }\n', '\n', '\n', '   function completeOwnershipTransfer() public returns (bool) {\n', '      require(msg.sender == proposedOwner);\n', '\n', '      owner = msg.sender;\n', '      proposedOwner = address(0);\n', '\n', '      OwnershipTransferCompleted(owner);\n', '\n', '      return true;\n', '   }\n', '}\n', '\n', '\n', '\n', 'contract OpsManaged is Owned {\n', '\n', '   address public opsAddress;\n', '\n', '   event OpsAddressUpdated(address indexed _newAddress);\n', '\n', '\n', '   function OpsManaged() public\n', '      Owned()\n', '   {\n', '   }\n', '\n', '\n', '   modifier onlyOwnerOrOps() {\n', '      require(isOwnerOrOps(msg.sender));\n', '      _;\n', '   }\n', '\n', '\n', '   function isOps(address _address) public view returns (bool) {\n', '      return (opsAddress != address(0) && _address == opsAddress);\n', '   }\n', '\n', '\n', '   function isOwnerOrOps(address _address) public view returns (bool) {\n', '      return (isOwner(_address) || isOps(_address));\n', '   }\n', '\n', '\n', '   function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool) {\n', '      require(_newOpsAddress != owner);\n', '      require(_newOpsAddress != address(this));\n', '\n', '      opsAddress = _newOpsAddress;\n', '\n', '      OpsAddressUpdated(opsAddress);\n', '\n', '      return true;\n', '   }\n', '}\n', '\n', '\n', 'library Math {\n', '\n', '   function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      uint256 r = a + b;\n', '\n', '      require(r >= a);\n', '\n', '      return r;\n', '   }\n', '\n', '\n', '   function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      require(a >= b);\n', '\n', '      return a - b;\n', '   }\n', '\n', '\n', '   function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      uint256 r = a * b;\n', '\n', '      require(a == 0 || r / a == b);\n', '\n', '      return r;\n', '   }\n', '\n', '\n', '   function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      return a / b;\n', '   }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Based on the final ERC20 specification at:\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '\n', '   event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '   event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '   function name() public view returns (string);\n', '   function symbol() public view returns (string);\n', '   function decimals() public view returns (uint8);\n', '   function totalSupply() public view returns (uint256);\n', '\n', '   function balanceOf(address _owner) public view returns (uint256 balance);\n', '   function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool success);\n', '   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '   function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', 'contract ERC20Token is ERC20Interface {\n', '\n', '   using Math for uint256;\n', '\n', '   string  private tokenName;\n', '   string  private tokenSymbol;\n', '   uint8   private tokenDecimals;\n', '   uint256 internal tokenTotalSupply;\n', '\n', '   mapping(address => uint256) internal balances;\n', '   mapping(address => mapping (address => uint256)) allowed;\n', '\n', '\n', '   function ERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {\n', '      tokenName = _name;\n', '      tokenSymbol = _symbol;\n', '      tokenDecimals = _decimals;\n', '      tokenTotalSupply = _totalSupply;\n', '\n', '      // The initial balance of tokens is assigned to the given token holder address.\n', '      balances[_initialTokenHolder] = _totalSupply;\n', '\n', '      // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.\n', '      Transfer(0x0, _initialTokenHolder, _totalSupply);\n', '   }\n', '\n', '\n', '   function name() public view returns (string) {\n', '      return tokenName;\n', '   }\n', '\n', '\n', '   function symbol() public view returns (string) {\n', '      return tokenSymbol;\n', '   }\n', '\n', '\n', '   function decimals() public view returns (uint8) {\n', '      return tokenDecimals;\n', '   }\n', '\n', '\n', '   function totalSupply() public view returns (uint256) {\n', '      return tokenTotalSupply;\n', '   }\n', '\n', '\n', '   function balanceOf(address _owner) public view returns (uint256 balance) {\n', '      return balances[_owner];\n', '   }\n', '\n', '\n', '   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '   }\n', '\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool success) {\n', '      balances[msg.sender] = balances[msg.sender].sub(_value);\n', '      balances[_to] = balances[_to].add(_value);\n', '\n', '      Transfer(msg.sender, _to, _value);\n', '\n', '      return true;\n', '   }\n', '\n', '\n', '   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '      balances[_from] = balances[_from].sub(_value);\n', '      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '      balances[_to] = balances[_to].add(_value);\n', '\n', '      Transfer(_from, _to, _value);\n', '\n', '      return true;\n', '   }\n', '\n', '\n', '   function approve(address _spender, uint256 _value) public returns (bool success) {\n', '      allowed[msg.sender][_spender] = _value;\n', '\n', '      Approval(msg.sender, _spender, _value);\n', '\n', '      return true;\n', '   }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', 'contract Finalizable is Owned {\n', '\n', '   bool public finalized;\n', '\n', '   event Finalized();\n', '\n', '\n', '   function Finalizable() public\n', '      Owned()\n', '   {\n', '      finalized = false;\n', '   }\n', '\n', '\n', '   function finalize() public onlyOwner returns (bool) {\n', '      require(!finalized);\n', '\n', '      finalized = true;\n', '\n', '      Finalized();\n', '\n', '      return true;\n', '   }\n', '}\n', '\n', '// -----------------------\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '//\n', 'contract FinalizableToken is ERC20Token, OpsManaged, Finalizable {\n', '\n', '   using Math for uint256;\n', '\n', '\n', '   // The constructor will assign the initial token supply to the owner (msg.sender).\n', '   function FinalizableToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public\n', '      ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)\n', '      OpsManaged()\n', '      Finalizable()\n', '   {\n', '   }\n', '\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool success) {\n', '      validateTransfer(msg.sender, _to);\n', '\n', '      return super.transfer(_to, _value);\n', '   }\n', '\n', '\n', '   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '      validateTransfer(msg.sender, _to);\n', '\n', '      return super.transferFrom(_from, _to, _value);\n', '   }\n', '\n', '\n', '   function validateTransfer(address _sender, address _to) private view {\n', '      require(_to != address(0));\n', '\n', '      // Once the token is finalized, everybody can transfer tokens.\n', '      if (finalized) {\n', '         return;\n', '      }\n', '\n', '      if (isOwner(_to)) {\n', '         return;\n', '      }\n', '\n', '      // Before the token is finalized, only owner and ops are allowed to initiate transfers.\n', '      // This allows them to move tokens while the sale is still ongoing for example.\n', '      require(isOwnerOrOps(_sender));\n', '   }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Token Contract Configuration\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', 'contract TokenConfig {\n', '\n', '    string  public constant TOKEN_SYMBOL      = "DUCK";\n', '    string  public constant TOKEN_NAME        = "Duckcoin";\n', '    uint8   public constant TOKEN_DECIMALS    = 18;\n', '\n', '    uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);\n', '    uint256 public constant TOKEN_TOTALSUPPLY = 2000000000000 * DECIMALSFACTOR;\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '//  - ERC20 Compatible Token\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// The  token is a standard ERC20 token with the addition of a few\n', '// concepts such as:\n', '//\n', '// 1. Finalization\n', '// Tokens can only be transfered by contributors after the contract has\n', '// been finalized.\n', '//\n', '// 2. Ops Managed Model\n', '// In addition to owner, there is a ops role which is used during the sale,\n', '// by the sale contract, in order to transfer tokens.\n', '// ----------------------------------------------------------------------------\n', 'contract Duckcoin is FinalizableToken, TokenConfig {\n', '\n', '\n', '   event TokensReclaimed(uint256 _amount);\n', '\n', '\n', '   function Duckcoin() public\n', '      FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY)\n', '   {\n', '   }\n', '\n', '\n', '   // Allows the owner to reclaim tokens that have been sent to the token address itself.\n', '   function reclaimTokens() public onlyOwner returns (bool) {\n', '\n', '      address account = address(this);\n', '      uint256 amount  = balanceOf(account);\n', '\n', '      if (amount == 0) {\n', '         return false;\n', '      }\n', '\n', '      balances[account] = balances[account].sub(amount);\n', '      balances[owner] = balances[owner].add(amount);\n', '\n', '      Transfer(account, owner, amount);\n', '\n', '      TokensReclaimed(amount);\n', '\n', '      return true;\n', '   }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Owned {\n', '\n', '   address public owner;\n', '   address public proposedOwner;\n', '\n', '   event OwnershipTransferInitiated(address indexed _proposedOwner);\n', '   event OwnershipTransferCompleted(address indexed _newOwner);\n', '   event OwnershipTransferCanceled();\n', '\n', '\n', '   function Owned() public\n', '   {\n', '      owner = msg.sender;\n', '   }\n', '\n', '\n', '   modifier onlyOwner() {\n', '      require(isOwner(msg.sender) == true);\n', '      _;\n', '   }\n', '\n', '\n', '   function isOwner(address _address) public view returns (bool) {\n', '      return (_address == owner);\n', '   }\n', '\n', '\n', '   function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {\n', '      require(_proposedOwner != address(0));\n', '      require(_proposedOwner != address(this));\n', '      require(_proposedOwner != owner);\n', '\n', '      proposedOwner = _proposedOwner;\n', '\n', '      OwnershipTransferInitiated(proposedOwner);\n', '\n', '      return true;\n', '   }\n', '\n', '\n', '   function cancelOwnershipTransfer() public onlyOwner returns (bool) {\n', '      if (proposedOwner == address(0)) {\n', '         return true;\n', '      }\n', '\n', '      proposedOwner = address(0);\n', '\n', '      OwnershipTransferCanceled();\n', '\n', '      return true;\n', '   }\n', '\n', '\n', '   function completeOwnershipTransfer() public returns (bool) {\n', '      require(msg.sender == proposedOwner);\n', '\n', '      owner = msg.sender;\n', '      proposedOwner = address(0);\n', '\n', '      OwnershipTransferCompleted(owner);\n', '\n', '      return true;\n', '   }\n', '}\n', '\n', '\n', '\n', 'contract OpsManaged is Owned {\n', '\n', '   address public opsAddress;\n', '\n', '   event OpsAddressUpdated(address indexed _newAddress);\n', '\n', '\n', '   function OpsManaged() public\n', '      Owned()\n', '   {\n', '   }\n', '\n', '\n', '   modifier onlyOwnerOrOps() {\n', '      require(isOwnerOrOps(msg.sender));\n', '      _;\n', '   }\n', '\n', '\n', '   function isOps(address _address) public view returns (bool) {\n', '      return (opsAddress != address(0) && _address == opsAddress);\n', '   }\n', '\n', '\n', '   function isOwnerOrOps(address _address) public view returns (bool) {\n', '      return (isOwner(_address) || isOps(_address));\n', '   }\n', '\n', '\n', '   function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool) {\n', '      require(_newOpsAddress != owner);\n', '      require(_newOpsAddress != address(this));\n', '\n', '      opsAddress = _newOpsAddress;\n', '\n', '      OpsAddressUpdated(opsAddress);\n', '\n', '      return true;\n', '   }\n', '}\n', '\n', '\n', 'library Math {\n', '\n', '   function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      uint256 r = a + b;\n', '\n', '      require(r >= a);\n', '\n', '      return r;\n', '   }\n', '\n', '\n', '   function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      require(a >= b);\n', '\n', '      return a - b;\n', '   }\n', '\n', '\n', '   function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      uint256 r = a * b;\n', '\n', '      require(a == 0 || r / a == b);\n', '\n', '      return r;\n', '   }\n', '\n', '\n', '   function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      return a / b;\n', '   }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Based on the final ERC20 specification at:\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '\n', '   event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '   event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '   function name() public view returns (string);\n', '   function symbol() public view returns (string);\n', '   function decimals() public view returns (uint8);\n', '   function totalSupply() public view returns (uint256);\n', '\n', '   function balanceOf(address _owner) public view returns (uint256 balance);\n', '   function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool success);\n', '   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '   function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', 'contract ERC20Token is ERC20Interface {\n', '\n', '   using Math for uint256;\n', '\n', '   string  private tokenName;\n', '   string  private tokenSymbol;\n', '   uint8   private tokenDecimals;\n', '   uint256 internal tokenTotalSupply;\n', '\n', '   mapping(address => uint256) internal balances;\n', '   mapping(address => mapping (address => uint256)) allowed;\n', '\n', '\n', '   function ERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {\n', '      tokenName = _name;\n', '      tokenSymbol = _symbol;\n', '      tokenDecimals = _decimals;\n', '      tokenTotalSupply = _totalSupply;\n', '\n', '      // The initial balance of tokens is assigned to the given token holder address.\n', '      balances[_initialTokenHolder] = _totalSupply;\n', '\n', '      // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.\n', '      Transfer(0x0, _initialTokenHolder, _totalSupply);\n', '   }\n', '\n', '\n', '   function name() public view returns (string) {\n', '      return tokenName;\n', '   }\n', '\n', '\n', '   function symbol() public view returns (string) {\n', '      return tokenSymbol;\n', '   }\n', '\n', '\n', '   function decimals() public view returns (uint8) {\n', '      return tokenDecimals;\n', '   }\n', '\n', '\n', '   function totalSupply() public view returns (uint256) {\n', '      return tokenTotalSupply;\n', '   }\n', '\n', '\n', '   function balanceOf(address _owner) public view returns (uint256 balance) {\n', '      return balances[_owner];\n', '   }\n', '\n', '\n', '   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '   }\n', '\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool success) {\n', '      balances[msg.sender] = balances[msg.sender].sub(_value);\n', '      balances[_to] = balances[_to].add(_value);\n', '\n', '      Transfer(msg.sender, _to, _value);\n', '\n', '      return true;\n', '   }\n', '\n', '\n', '   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '      balances[_from] = balances[_from].sub(_value);\n', '      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '      balances[_to] = balances[_to].add(_value);\n', '\n', '      Transfer(_from, _to, _value);\n', '\n', '      return true;\n', '   }\n', '\n', '\n', '   function approve(address _spender, uint256 _value) public returns (bool success) {\n', '      allowed[msg.sender][_spender] = _value;\n', '\n', '      Approval(msg.sender, _spender, _value);\n', '\n', '      return true;\n', '   }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', 'contract Finalizable is Owned {\n', '\n', '   bool public finalized;\n', '\n', '   event Finalized();\n', '\n', '\n', '   function Finalizable() public\n', '      Owned()\n', '   {\n', '      finalized = false;\n', '   }\n', '\n', '\n', '   function finalize() public onlyOwner returns (bool) {\n', '      require(!finalized);\n', '\n', '      finalized = true;\n', '\n', '      Finalized();\n', '\n', '      return true;\n', '   }\n', '}\n', '\n', '// -----------------------\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '//\n', 'contract FinalizableToken is ERC20Token, OpsManaged, Finalizable {\n', '\n', '   using Math for uint256;\n', '\n', '\n', '   // The constructor will assign the initial token supply to the owner (msg.sender).\n', '   function FinalizableToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public\n', '      ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)\n', '      OpsManaged()\n', '      Finalizable()\n', '   {\n', '   }\n', '\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool success) {\n', '      validateTransfer(msg.sender, _to);\n', '\n', '      return super.transfer(_to, _value);\n', '   }\n', '\n', '\n', '   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '      validateTransfer(msg.sender, _to);\n', '\n', '      return super.transferFrom(_from, _to, _value);\n', '   }\n', '\n', '\n', '   function validateTransfer(address _sender, address _to) private view {\n', '      require(_to != address(0));\n', '\n', '      // Once the token is finalized, everybody can transfer tokens.\n', '      if (finalized) {\n', '         return;\n', '      }\n', '\n', '      if (isOwner(_to)) {\n', '         return;\n', '      }\n', '\n', '      // Before the token is finalized, only owner and ops are allowed to initiate transfers.\n', '      // This allows them to move tokens while the sale is still ongoing for example.\n', '      require(isOwnerOrOps(_sender));\n', '   }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Token Contract Configuration\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', 'contract TokenConfig {\n', '\n', '    string  public constant TOKEN_SYMBOL      = "DUCK";\n', '    string  public constant TOKEN_NAME        = "Duckcoin";\n', '    uint8   public constant TOKEN_DECIMALS    = 18;\n', '\n', '    uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);\n', '    uint256 public constant TOKEN_TOTALSUPPLY = 2000000000000 * DECIMALSFACTOR;\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '//  - ERC20 Compatible Token\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// The  token is a standard ERC20 token with the addition of a few\n', '// concepts such as:\n', '//\n', '// 1. Finalization\n', '// Tokens can only be transfered by contributors after the contract has\n', '// been finalized.\n', '//\n', '// 2. Ops Managed Model\n', '// In addition to owner, there is a ops role which is used during the sale,\n', '// by the sale contract, in order to transfer tokens.\n', '// ----------------------------------------------------------------------------\n', 'contract Duckcoin is FinalizableToken, TokenConfig {\n', '\n', '\n', '   event TokensReclaimed(uint256 _amount);\n', '\n', '\n', '   function Duckcoin() public\n', '      FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY)\n', '   {\n', '   }\n', '\n', '\n', '   // Allows the owner to reclaim tokens that have been sent to the token address itself.\n', '   function reclaimTokens() public onlyOwner returns (bool) {\n', '\n', '      address account = address(this);\n', '      uint256 amount  = balanceOf(account);\n', '\n', '      if (amount == 0) {\n', '         return false;\n', '      }\n', '\n', '      balances[account] = balances[account].sub(amount);\n', '      balances[owner] = balances[owner].add(amount);\n', '\n', '      Transfer(account, owner, amount);\n', '\n', '      TokensReclaimed(amount);\n', '\n', '      return true;\n', '   }\n', '}']