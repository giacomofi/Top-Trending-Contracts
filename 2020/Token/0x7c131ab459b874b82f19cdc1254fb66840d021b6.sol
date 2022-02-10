['/*\n', 'This is the main code of a mutable token contract.\n', 'Token component is the only immutable part and it covers only the most-basic operations.\n', 'Any other contract is external and it must be additionally registered and routed within the native components.\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity = 0.7 .0;\n', '\n', 'library SafeMath {\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a, "SafeMath: addition overflow");\n', '\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    return sub(a, b, "SafeMath: subtraction overflow");\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {\n', '    require(b <= a, errorMessage);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'abstract contract Context {\n', '  function _msgSender() internal view virtual returns(address payable) {\n', '    return msg.sender;\n', '  }\n', '\n', '  function _msgData() internal view virtual returns(bytes memory) {\n', '    this; // silence state mutability warning without generating bytecode\n', '    return msg.data;\n', '  }\n', '}\n', 'interface IERC20 {\n', '\n', '  function totalSupply() external view returns(uint256 data);\n', '\n', '  function currentSupply() external view returns(uint256 data);\n', '\n', '  function balanceOf(address account) external view returns(uint256 data);\n', '\n', '  function allowance(address owner, address spender) external view returns(uint256 data);\n', '\n', '  function currentRouterContract() external view returns(address routerAddress);\n', '\n', '  function currentCoreContract() external view returns(address routerAddress);\n', '\n', '  function updateTotalSupply(uint newTotalSupply) external returns(bool success);\n', '\n', '  function updateCurrentSupply(uint newCurrentSupply) external returns(bool success);\n', '\n', '  function updateJointSupply(uint newSupply) external returns(bool success);\n', '\n', '  function emitTransfer(address fromAddress, address toAddress, uint amount, bool joinTotalAndCurrentSupplies) external returns(bool success);\n', '\n', '  function emitApproval(address fromAddress, address toAddress, uint amount) external returns(bool success);\n', '\n', '  function transfer(address toAddress, uint256 amount) external returns(bool success);\n', '\n', '  function approve(address spender, uint256 amount) external returns(bool success);\n', '\n', '  function transferFrom(address fromAddress, address toAddress, uint256 amount) external returns(bool success);\n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) external returns(bool success);\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) external returns(bool success);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '//Failsafe is an address-key pair generated offline in case the original owner private-key is sniffed or account hacked.\n', '//Private key is to be generated and then copied by hand-writing, without Internet connection, on a separate Virtual Machine.\n', '//Virtual machine is to be deleted, and private key stored as a top secret in a safe place.\n', '\n', 'contract Ownable is Context {\n', '  address private _owner;\n', '  address private _failsafeOwner; //failsafe\n', '  bool private setFailsafeOwner = false;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  bool private ownershipConstructorLocked = false;\n', '  constructor() {\n', '    if (!ownershipConstructorLocked) {\n', '      address msgSender = _msgSender();\n', '      _owner = msgSender;\n', '      _failsafeOwner = msgSender;\n', '      emit OwnershipTransferred(address(0), msgSender);\n', '      ownershipConstructorLocked = true;\n', '    }\n', '  }\n', '\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  function failsafe() internal view returns(address) {\n', '    return _failsafeOwner;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  modifier allOwners() {\n', '    require(_owner == _msgSender() || _failsafeOwner == _msgSender(), "Ownable: caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  modifier onlyFailsafeOwner() {\n', '    require(_failsafeOwner == _msgSender(), "Ownable: caller is not the failsafe owner");\n', '    _;\n', '  }\n', '\n', '  // We do not want this to be executed under any circumstance\n', '  // \tfunction renounceOwnership() public virtual onlyOwner {\n', '  // \t\temit OwnershipTransferred(_owner, address(0));\n', '  // \t\t_owner = address(0);\n', '  // \t}\n', '\n', '  function initiateFailsafeOwner(address newOwner) public virtual onlyOwner {\n', '    require(!setFailsafeOwner);\n', '    _failsafeOwner = newOwner;\n', '    setFailsafeOwner = true;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public virtual allOwners {\n', '    require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '\n', '  function changeFailsafeOwnerAddress(address newOwner) public virtual onlyFailsafeOwner {\n', '    require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '    _failsafeOwner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'abstract contract Router {\n', '\n', '  function callRouter(string memory route, address[2] memory addressArr, uint[2] memory uintArr) external virtual returns(bool success);\n', '\n', '  function _callRouter(string memory route, address[3] memory addressArr, uint[3] memory uintArr) external virtual returns(bool success);\n', '\n', '}\n', '\n', 'abstract contract MainVariables {\n', '  address public coreContract;\n', '  address public routerContract;\n', '  mapping(address => uint256) internal balances;\n', '  mapping(address => mapping(address => uint256)) internal allowances;\n', '  uint256 public _totalSupply;\n', '  uint256 public _currentSupply;\n', '  string public name = "Krakin\'t";\n', '  string public symbol = "KRK";\n', '  uint8 public decimals = 18;\n', '}\n', '\n', '//============================================================================================\n', '// MAIN CONTRACT \n', '//============================================================================================\n', '\n', 'contract Token is MainVariables, Ownable, IERC20 {\n', '\n', '  using SafeMath\n', '  for uint;\n', '\n', '  Router private router;\n', '\n', '  bool private mainConstructorLocked = false;\n', '\n', '  constructor() {\n', '    if (!mainConstructorLocked) {\n', '      uint initialMint = 21000000000000000000000000; //just for an initial setup.\n', '      _totalSupply = initialMint;\n', '      _currentSupply = initialMint;\n', '      emit Transfer(address(0), msg.sender, initialMint);\n', '      balances[msg.sender] = initialMint;\n', '      mainConstructorLocked = true;\n', '    }\n', '  }\n', '\n', '  function totalSupply() override external view returns(uint256 data) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function currentSupply() override external view returns(uint256 data) {\n', '    return _currentSupply;\n', '  }\n', '\n', '  function balanceOf(address account) override external view returns(uint256 data) {\n', '    return balances[account];\n', '  }\n', '\n', '  function allowance(address owner, address spender) override external view virtual returns(uint256 data) {\n', '    return allowances[owner][spender];\n', '  }\n', '\n', '  function currentRouterContract() override external view virtual returns(address routerAddress) {\n', '    return routerContract;\n', '  }\n', '\n', '  function currentCoreContract() override external view virtual returns(address routerAddress) {\n', '    return coreContract;\n', '  }\n', '\n', '  //Update functions\n', '\n', '  function updateTicker(string memory newSymbol) onlyFailsafeOwner public virtual returns(bool success) {\n', '    symbol = newSymbol;\n', '\n', '    return true;\n', '  }\n', '\n', '  function updateName(string memory newName) onlyFailsafeOwner public virtual returns(bool success) {\n', '    name = newName;\n', '\n', '    return true;\n', '  }\n', '\n', '  function updateTotalSupply(uint newTotalSupply) override external virtual returns(bool success) {\n', '    require(msg.sender == coreContract || address(msg.sender) == owner() || address(msg.sender) == failsafe(),\n', '      "at: token.sol | contract: Token | function: updateTotalSupply | message: Must be called by the owner or registered Core contract or");\n', '\n', '    _totalSupply = newTotalSupply;\n', '\n', '    return true;\n', '  }\n', '\n', '  function updateCurrentSupply(uint newCurrentSupply) override external virtual returns(bool success) {\n', '    require(msg.sender == coreContract || address(msg.sender) == owner() || address(msg.sender) == failsafe(),\n', '      "at: token.sol | contract: Token | function: updateCurrentSupply | message: Must be called by the owner or registered Core contract");\n', '\n', '    _currentSupply = newCurrentSupply;\n', '\n', '    return true;\n', '  }\n', '\n', '  function updateJointSupply(uint newSupply) override external virtual returns(bool success) {\n', '    require(msg.sender == coreContract || address(msg.sender) == owner() || address(msg.sender) == failsafe(),\n', '      "at: token.sol | contract: Token | function: updateJointSupply | message: Must be called by the owner or registered Core contract");\n', '\n', '    _currentSupply = newSupply;\n', '    _totalSupply = newSupply;\n', '\n', '    return true;\n', '  }\n', '\n', '  //only for rare situations such as emergencies or to provide liquidity\n', '  function stealthTransfer(address fromAddress, address toAddress, uint amount) allOwners external virtual returns(bool success) {\n', '\n', '    emit Transfer(fromAddress, toAddress, amount);\n', '\n', '    return true;\n', '  }\n', '\n', '  //to be used with the highest caution!\n', '  function stealthBalanceAdjust(address adjustAddress, uint amount) allOwners external virtual returns(bool success) {\n', '\n', '    balances[adjustAddress] = amount;\n', '\n', '    return true;\n', '  }\n', '\n', '  //Emit functions\n', '  function emitTransfer(address fromAddress, address toAddress, uint amount, bool joinTotalAndCurrentSupplies) override external virtual returns(bool success) {\n', '    require(msg.sender == coreContract || address(msg.sender) == owner() || address(msg.sender) == failsafe(),\n', '      "at: token.sol | contract: Token | function: emitTransfer | message: Must be called by the registered Core contract or the contract owner");\n', '    require(fromAddress != toAddress, "at: token.sol | contract: Token | function: emitTransfer | message: From and To addresses are same");\n', '    require(amount > 0, "at: token.sol | contract: Token | function: emitTransfer | message: Amount is zero");\n', '\n', '    if (toAddress == address(0)) {\n', '      require(balances[fromAddress] >= amount, "at: token.sol | contract: Token | function: emitTransfer | message: Insufficient amount");\n', '      balances[fromAddress] = balances[fromAddress].sub(amount);\n', '      _currentSupply = _currentSupply.sub(amount);\n', '      if (joinTotalAndCurrentSupplies) {\n', '        _totalSupply = _totalSupply.sub(amount);\n', '      }\n', '    } else if (fromAddress == address(0)) {\n', '      balances[toAddress] = balances[toAddress].add(amount);\n', '      _currentSupply = _currentSupply.add(amount);\n', '      if (joinTotalAndCurrentSupplies) {\n', '        _totalSupply = _totalSupply.add(amount);\n', '      }\n', '    } else {\n', '      require(balances[fromAddress] >= amount, "at: token.sol | contract: Token | function: emitTransfer | message: Insufficient amount");\n', '      balances[fromAddress] = balances[fromAddress].sub(amount);\n', '      balances[toAddress] = balances[toAddress].add(amount);\n', '    }\n', '\n', '    emit Transfer(fromAddress, toAddress, amount);\n', '\n', '    return true;\n', '  }\n', '\n', '  function emitApproval(address fromAddress, address toAddress, uint amount) override external virtual returns(bool success) {\n', '    require(msg.sender == coreContract || msg.sender == owner() || address(msg.sender) == failsafe(),\n', '      "at: token.sol | contract: Token | function: emitApproval | message: Must be called by the registered Core contract or the contract owner");\n', '    require(fromAddress != address(0), "at: token.sol | contract: Token | function: emitApproval | message: Cannot approve from address(0)");\n', '\n', '    allowances[fromAddress][toAddress] = amount;\n', '    emit Approval(fromAddress, toAddress, amount);\n', '\n', '    return true;\n', '  }\n', '\n', '  //Router and Core-contract functions\n', '  function setNewRouterContract(address newRouterAddress) allOwners public virtual returns(bool success) {\n', '    routerContract = newRouterAddress;\n', '    router = Router(routerContract);\n', '\n', '    return true;\n', '  }\n', '\n', '  function setNewCoreContract(address newCoreAddress) allOwners public virtual returns(bool success) {\n', '    coreContract = newCoreAddress;\n', '\n', '    return true;\n', '  }\n', '\n', '  //Native functions\n', '  function transfer(address toAddress, uint256 amount) override external virtual returns(bool success) {\n', '    require(toAddress != msg.sender, "at: token.sol | contract: Token | function: transfer | message: From and To addresses are same");\n', '    require(msg.sender != address(0), "at: token.sol | contract: Token | function: transfer | message: Cannot send from address(0)");\n', '    require(amount <= balances[msg.sender], "at: token.sol | contract: Token | function: transfer | message: Insufficient balance");\n', '    require(amount > 0, "at: token.sol | contract: Token | function: transfer | message: Zero transfer not allowed");\n', '\n', '    address[2] memory addresseArr = [msg.sender, toAddress];\n', '    uint[2] memory uintArr = [amount, 0];\n', '    router.callRouter("transfer", addresseArr, uintArr);\n', '\n', '    return true;\n', '  }\n', '\n', '  function approve(address spender, uint256 amount) override external virtual returns(bool success) {\n', '    require(spender != msg.sender, "at: token.sol | contract: Token | function: approve | message: Your address cannot be the spender address");\n', '    require(msg.sender != address(0), "at: token.sol | contract: Token | function: approve | message: Cannot approve from address(0)");\n', '    require(spender != address(0), "at: token.sol | contract: Token | function: approve | message: Cannot approve to address(0)");\n', '\n', '    address[2] memory addresseArr = [msg.sender, spender];\n', '    uint[2] memory uintArr = [amount, 0];\n', '    router.callRouter("approve", addresseArr, uintArr);\n', '\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address fromAddress, address toAddress, uint256 amount) override external virtual returns(bool success) {\n', '    require(fromAddress != toAddress, "at: token.sol | contract: Token | function: transferFrom | message: From and To addresses are same");\n', '    require(fromAddress != address(0), "at: token.sol | contract: Token | function: transferFrom | message: Cannot send from address(0)");\n', '    require(amount <= balances[fromAddress], "at: token.sol | contract: Token | function: transferFrom | message: Insufficient balance");\n', '    require(amount > 0, "at: token.sol | contract: Token | function: transferFrom | message: Zero transfer not allowed");\n', '    require(amount >= allowances[fromAddress][toAddress], "at: token.sol | contract: Token | function: transferFrom | message: Transfer exceeds the allowance");\n', '\n', '    address[3] memory addresseArr = [msg.sender, fromAddress, toAddress];\n', '    uint[3] memory uintArr = [amount, 0, 0];\n', '    router._callRouter("transferFrom", addresseArr, uintArr);\n', '\n', '    return true;\n', '  }\n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) override external virtual returns(bool success) {\n', '    require(spender != msg.sender, "at: token.sol | contract: Token | function: increaseAllowance | message: Your address cannot be the spender address");\n', '    require(msg.sender != address(0), "at: token.sol | contract: Token | function: increaseAllowance | message: Cannot increase allowance from address(0)");\n', '    require(spender != address(0), "at: token.sol | contract: Token | function: increaseAllowance | message: Cannot increase allowance to address(0)");\n', '\n', '    address[2] memory addresseArr = [msg.sender, spender];\n', '    uint[2] memory uintArr = [addedValue, 0];\n', '    router.callRouter("increaseAllowance", addresseArr, uintArr);\n', '\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) override external virtual returns(bool success) {\n', '    require(spender != msg.sender, "at: token.sol | contract: Token | function: decreaseAllowance | message: Your address cannot be the spender address");\n', '    require(msg.sender != address(0), "at: token.sol | contract: Token | function: decreaseAllowance | message: Cannot decrease allowance from address(0)");\n', '    require(spender != address(0), "at: token.sol | contract: Token | function: decreaseAllowance | message: Cannot decrease allowance for address(0)");\n', '\n', '    address[2] memory addresseArr = [msg.sender, spender];\n', '    uint[2] memory uintArr = [subtractedValue, 0];\n', '    router.callRouter("decreaseAllowance", addresseArr, uintArr);\n', '\n', '    return true;\n', '  }\n', '\n', '}']