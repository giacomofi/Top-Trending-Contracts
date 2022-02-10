['pragma solidity ^0.4.20;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '  event OwnershipTransferred (address indexed _from, address indexed _to);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public{\n', '    owner = msg.sender;\n', '    OwnershipTransferred(address(0), owner);\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '    OwnershipTransferred(owner,newOwner);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Token\n', ' * @dev API interface for interacting with the Token contract \n', ' */\n', 'interface Token {\n', '  function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '  function balanceOf(address _owner) constant external returns (uint256 balance);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool); \n', '}\n', '\n', '/**\n', ' * @title AirDropAFTKSeven Ver 1.0\n', ' * @dev This contract can be used for Airdrop or token redumption for AFTK Token\n', ' *\n', ' */\n', 'contract AirDropAFTKSeven is Ownable {\n', '\n', '  Token token;\n', '  mapping(address => uint256) public redeemBalanceOf; \n', '  event BalanceSet(address indexed beneficiary, uint256 value);\n', '  event Redeemed(address indexed beneficiary, uint256 value);\n', '  event BalanceCleared(address indexed beneficiary, uint256 value);\n', '  event TokenSendStart(address indexed beneficiary, uint256 value);\n', '  event TransferredToken(address indexed to, uint256 value);\n', '  event FailedTransfer(address indexed to, uint256 value);\n', '\n', '  function AirDropAFTKSeven() public {\n', '      address _tokenAddr = 0x7fa2f70bd4c4120fdd539ebd55c04118ba336b9e;\n', '      token = Token(_tokenAddr);\n', '  }\n', '\n', ' /**\n', '  * @dev Send approved tokens to one address\n', '  * @param dests -> address where you want to send tokens\n', '  * @param quantity -> number of tokens to send\n', '  */\n', ' function sendTokensToOne(address dests, uint256 quantity)  public payable onlyOwner returns (uint) {\n', '    \n', '\tTokenSendStart(dests,quantity * 10**18);\n', '\ttoken.approve(dests, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests ,quantity * 10**18));\n', '    return token.balanceOf(dests);\n', '\t\n', '  }\n', '\n', ' /**\n', '  * @dev Send approved tokens to seven addresses\n', '  * @param dests1 -> address where you want to send tokens\n', '  * @param dests2 -> address where you want to send tokens\n', '  * @param dests3 -> address where you want to send tokens\n', '  * @param dests4 -> address where you want to send tokens\n', '  * @param dests5 -> address where you want to send tokens\n', '  * @param dests6 -> address where you want to send tokens\n', '  * @param dests7 -> address where you want to send tokens\n', '  * @param quantity -> number of tokens to send\n', '  */\n', ' function sendTokensTo7(address dests1, address dests2, address dests3, address dests4, address dests5, \n', ' address dests6, address dests7,  uint256 quantity)  public payable onlyOwner returns (uint) {\n', '    \n', '\tTokenSendStart(dests1,quantity * 10**18);\n', '\ttoken.approve(dests1, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests1 ,quantity * 10**18));\n', '\t\n', '\tTokenSendStart(dests2,quantity * 10**18);\n', '\ttoken.approve(dests2, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests2 ,quantity * 10**18));\n', '\t\n', '\tTokenSendStart(dests3,quantity * 10**18);\n', '\ttoken.approve(dests3, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests3 ,quantity * 10**18));\n', '\t\n', '\tTokenSendStart(dests4,quantity * 10**18);\n', '\ttoken.approve(dests4, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests4 ,quantity * 10**18));\n', '\t\n', '\tTokenSendStart(dests5,quantity * 10**18);\n', '\ttoken.approve(dests5, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests5 ,quantity * 10**18));\n', '\t\n', '\tTokenSendStart(dests6,quantity * 10**18);\n', '\ttoken.approve(dests6, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests6 ,quantity * 10**18));\n', '    \n', '\tTokenSendStart(dests7,quantity * 10**18);\n', '\ttoken.approve(dests7, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests7 ,quantity * 10**18));\n', '\t\n', '\treturn token.balanceOf(dests7);\n', '  }\n', '  \n', ' /**\n', '  * @dev admin can destroy this contract\n', '  */\n', '  function destroy() onlyOwner public { uint256 tokensAvailable = token.balanceOf(this); require (tokensAvailable > 0); token.transfer(owner, tokensAvailable);  selfdestruct(owner);  } \n', '}']
['pragma solidity ^0.4.20;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '  event OwnershipTransferred (address indexed _from, address indexed _to);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public{\n', '    owner = msg.sender;\n', '    OwnershipTransferred(address(0), owner);\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '    OwnershipTransferred(owner,newOwner);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Token\n', ' * @dev API interface for interacting with the Token contract \n', ' */\n', 'interface Token {\n', '  function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '  function balanceOf(address _owner) constant external returns (uint256 balance);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool); \n', '}\n', '\n', '/**\n', ' * @title AirDropAFTKSeven Ver 1.0\n', ' * @dev This contract can be used for Airdrop or token redumption for AFTK Token\n', ' *\n', ' */\n', 'contract AirDropAFTKSeven is Ownable {\n', '\n', '  Token token;\n', '  mapping(address => uint256) public redeemBalanceOf; \n', '  event BalanceSet(address indexed beneficiary, uint256 value);\n', '  event Redeemed(address indexed beneficiary, uint256 value);\n', '  event BalanceCleared(address indexed beneficiary, uint256 value);\n', '  event TokenSendStart(address indexed beneficiary, uint256 value);\n', '  event TransferredToken(address indexed to, uint256 value);\n', '  event FailedTransfer(address indexed to, uint256 value);\n', '\n', '  function AirDropAFTKSeven() public {\n', '      address _tokenAddr = 0x7fa2f70bd4c4120fdd539ebd55c04118ba336b9e;\n', '      token = Token(_tokenAddr);\n', '  }\n', '\n', ' /**\n', '  * @dev Send approved tokens to one address\n', '  * @param dests -> address where you want to send tokens\n', '  * @param quantity -> number of tokens to send\n', '  */\n', ' function sendTokensToOne(address dests, uint256 quantity)  public payable onlyOwner returns (uint) {\n', '    \n', '\tTokenSendStart(dests,quantity * 10**18);\n', '\ttoken.approve(dests, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests ,quantity * 10**18));\n', '    return token.balanceOf(dests);\n', '\t\n', '  }\n', '\n', ' /**\n', '  * @dev Send approved tokens to seven addresses\n', '  * @param dests1 -> address where you want to send tokens\n', '  * @param dests2 -> address where you want to send tokens\n', '  * @param dests3 -> address where you want to send tokens\n', '  * @param dests4 -> address where you want to send tokens\n', '  * @param dests5 -> address where you want to send tokens\n', '  * @param dests6 -> address where you want to send tokens\n', '  * @param dests7 -> address where you want to send tokens\n', '  * @param quantity -> number of tokens to send\n', '  */\n', ' function sendTokensTo7(address dests1, address dests2, address dests3, address dests4, address dests5, \n', ' address dests6, address dests7,  uint256 quantity)  public payable onlyOwner returns (uint) {\n', '    \n', '\tTokenSendStart(dests1,quantity * 10**18);\n', '\ttoken.approve(dests1, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests1 ,quantity * 10**18));\n', '\t\n', '\tTokenSendStart(dests2,quantity * 10**18);\n', '\ttoken.approve(dests2, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests2 ,quantity * 10**18));\n', '\t\n', '\tTokenSendStart(dests3,quantity * 10**18);\n', '\ttoken.approve(dests3, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests3 ,quantity * 10**18));\n', '\t\n', '\tTokenSendStart(dests4,quantity * 10**18);\n', '\ttoken.approve(dests4, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests4 ,quantity * 10**18));\n', '\t\n', '\tTokenSendStart(dests5,quantity * 10**18);\n', '\ttoken.approve(dests5, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests5 ,quantity * 10**18));\n', '\t\n', '\tTokenSendStart(dests6,quantity * 10**18);\n', '\ttoken.approve(dests6, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests6 ,quantity * 10**18));\n', '    \n', '\tTokenSendStart(dests7,quantity * 10**18);\n', '\ttoken.approve(dests7, quantity * 10**18);\n', '\trequire(token.transferFrom(owner , dests7 ,quantity * 10**18));\n', '\t\n', '\treturn token.balanceOf(dests7);\n', '  }\n', '  \n', ' /**\n', '  * @dev admin can destroy this contract\n', '  */\n', '  function destroy() onlyOwner public { uint256 tokensAvailable = token.balanceOf(this); require (tokensAvailable > 0); token.transfer(owner, tokensAvailable);  selfdestruct(owner);  } \n', '}']