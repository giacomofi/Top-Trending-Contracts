['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol\n', '\n', '/**\n', ' * @title Contracts that should not own Ether\n', ' * @author Remco Bloemen <remco@2π.com>\n', ' * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up\n', ' * in the contract, it will allow the owner to reclaim this ether.\n', ' * @notice Ether can still be sent to this contract by:\n', ' * calling functions labeled `payable`\n', ' * `selfdestruct(contract_address)`\n', ' * mining directly to the contract address\n', ' */\n', 'contract HasNoEther is Ownable {\n', '\n', '  /**\n', '  * @dev Constructor that rejects incoming Ether\n', '  * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we\n', '  * leave out payable, then Solidity will allow inheriting contracts to implement a payable\n', '  * constructor. By doing it this way we prevent a payable constructor from working. Alternatively\n', '  * we could use assembly to access msg.value.\n', '  */\n', '  constructor() public payable {\n', '    require(msg.value == 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Disallows direct send by settings a default function without the `payable` flag.\n', '   */\n', '  function() external {\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer all Ether held by the contract to the owner.\n', '   */\n', '  function reclaimEther() external onlyOwner {\n', '    owner.transfer(address(this).balance);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts/pixie/PixieTokenAirdropper.sol\n', '\n', 'contract PixieTokenAirdropper is Ownable, HasNoEther {\n', '\n', '  // The token which is already deployed to the network\n', '  ERC20Basic public token;\n', '\n', '  event AirDroppedTokens(uint256 addressCount);\n', '  event AirDrop(address indexed receiver, uint256 total);\n', '\n', '  // After this contract is deployed, we will grant access to this contract\n', '  // by calling methods on the token since we are using the same owner\n', '  // and granting the distribution of tokens to this contract\n', '  constructor(address _token) public payable {\n', '    require(_token != address(0), "Must be a non-zero address");\n', '\n', '    token = ERC20Basic(_token);\n', '  }\n', '\n', '  function transfer(address[] _address, uint256[] _values) onlyOwner public {\n', '    require(_address.length == _values.length, "Address array and values array must be same length");\n', '\n', '    for (uint i = 0; i < _address.length; i += 1) {\n', '      _transfer(_address[i], _values[i]);\n', '    }\n', '\n', '    emit AirDroppedTokens(_address.length);\n', '  }\n', '\n', '  function transferSingle(address _address, uint256 _value) onlyOwner public {\n', '    _transfer(_address, _value);\n', '\n', '    emit AirDroppedTokens(1);\n', '  }\n', '\n', '  function _transfer(address _address, uint256 _value) internal {\n', '    require(_address != address(0), "Address invalid");\n', '    require(_value > 0, "Value invalid");\n', '\n', '    token.transfer(_address, _value);\n', '\n', '    emit AirDrop(_address, _value);\n', '  }\n', '\n', '  function remainingBalance() public view returns (uint256) {\n', '    return token.balanceOf(address(this));\n', '  }\n', '\n', '  // after we distribute the bonus tokens, we will send them back to the coin itself\n', '  function ownerRecoverTokens(address _beneficiary) external onlyOwner {\n', '    require(_beneficiary != address(0));\n', '    require(_beneficiary != address(token));\n', '\n', '    uint256 _tokensRemaining = token.balanceOf(address(this));\n', '    if (_tokensRemaining > 0) {\n', '      token.transfer(_beneficiary, _tokensRemaining);\n', '    }\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol\n', '\n', '/**\n', ' * @title Contracts that should not own Ether\n', ' * @author Remco Bloemen <remco@2π.com>\n', ' * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up\n', ' * in the contract, it will allow the owner to reclaim this ether.\n', ' * @notice Ether can still be sent to this contract by:\n', ' * calling functions labeled `payable`\n', ' * `selfdestruct(contract_address)`\n', ' * mining directly to the contract address\n', ' */\n', 'contract HasNoEther is Ownable {\n', '\n', '  /**\n', '  * @dev Constructor that rejects incoming Ether\n', '  * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we\n', '  * leave out payable, then Solidity will allow inheriting contracts to implement a payable\n', '  * constructor. By doing it this way we prevent a payable constructor from working. Alternatively\n', '  * we could use assembly to access msg.value.\n', '  */\n', '  constructor() public payable {\n', '    require(msg.value == 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Disallows direct send by settings a default function without the `payable` flag.\n', '   */\n', '  function() external {\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer all Ether held by the contract to the owner.\n', '   */\n', '  function reclaimEther() external onlyOwner {\n', '    owner.transfer(address(this).balance);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts/pixie/PixieTokenAirdropper.sol\n', '\n', 'contract PixieTokenAirdropper is Ownable, HasNoEther {\n', '\n', '  // The token which is already deployed to the network\n', '  ERC20Basic public token;\n', '\n', '  event AirDroppedTokens(uint256 addressCount);\n', '  event AirDrop(address indexed receiver, uint256 total);\n', '\n', '  // After this contract is deployed, we will grant access to this contract\n', '  // by calling methods on the token since we are using the same owner\n', '  // and granting the distribution of tokens to this contract\n', '  constructor(address _token) public payable {\n', '    require(_token != address(0), "Must be a non-zero address");\n', '\n', '    token = ERC20Basic(_token);\n', '  }\n', '\n', '  function transfer(address[] _address, uint256[] _values) onlyOwner public {\n', '    require(_address.length == _values.length, "Address array and values array must be same length");\n', '\n', '    for (uint i = 0; i < _address.length; i += 1) {\n', '      _transfer(_address[i], _values[i]);\n', '    }\n', '\n', '    emit AirDroppedTokens(_address.length);\n', '  }\n', '\n', '  function transferSingle(address _address, uint256 _value) onlyOwner public {\n', '    _transfer(_address, _value);\n', '\n', '    emit AirDroppedTokens(1);\n', '  }\n', '\n', '  function _transfer(address _address, uint256 _value) internal {\n', '    require(_address != address(0), "Address invalid");\n', '    require(_value > 0, "Value invalid");\n', '\n', '    token.transfer(_address, _value);\n', '\n', '    emit AirDrop(_address, _value);\n', '  }\n', '\n', '  function remainingBalance() public view returns (uint256) {\n', '    return token.balanceOf(address(this));\n', '  }\n', '\n', '  // after we distribute the bonus tokens, we will send them back to the coin itself\n', '  function ownerRecoverTokens(address _beneficiary) external onlyOwner {\n', '    require(_beneficiary != address(0));\n', '    require(_beneficiary != address(token));\n', '\n', '    uint256 _tokensRemaining = token.balanceOf(address(this));\n', '    if (_tokensRemaining > 0) {\n', '      token.transfer(_beneficiary, _tokensRemaining);\n', '    }\n', '  }\n', '\n', '}']
