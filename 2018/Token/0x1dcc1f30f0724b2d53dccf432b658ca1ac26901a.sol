['pragma solidity 0.4.24;\n', '\n', '/*\n', '    Copyright 2018, Vicent Nos & Mireia Puig\n', '\n', '    This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '    This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '    You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '*/\n', '\n', '\n', '/**\n', ' * @title OpenZeppelin SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', ' library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title OpenZeppelin Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '//////////////////////////////////////////////////////////////\n', '//                                                          //\n', '//          Zironex, Open End Crypto Fund ERC20             //\n', '//                                                          //\n', '//////////////////////////////////////////////////////////////\n', '\n', 'contract ZironexERC20 is Ownable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) public balances;\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  /* Public variables for the ERC20 token */\n', '  string public constant standard = "ERC20 Zironex";\n', '  uint8 public constant decimals = 18; // hardcoded to be a constant\n', '  uint256 public totalSupply = 10000000000000000000000000;\n', '  string public name = "Ziron";\n', '  string public symbol = "ZNX";\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '        allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /* Approve and then communicate the approved contract in a single tx */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '    tokenRecipient spender = tokenRecipient(_spender);\n', '\n', '    if (approve(_spender, _value)) {\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '        return true;\n', '    }\n', '  }\n', '}\n', '\n', '\n', 'interface tokenRecipient {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;\n', '}\n', '\n', '\n', 'contract Zironex is ZironexERC20 {\n', '\n', '  // Constant to simplify conversion of token amounts into integer form\n', '    uint256 public tokenUnit = uint256(10)**decimals;\n', '\n', '  //Declare logging events\n', '    event LogDeposit(address sender, uint amount);\n', '\n', '  /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor(\n', '      address contractOwner\n', '\n', '        ) public {\n', '        owner = contractOwner; // set owner address\n', '        balances[contractOwner] = balances[contractOwner].add(totalSupply); // set owner balance\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', '/*\n', '    Copyright 2018, Vicent Nos & Mireia Puig\n', '\n', '    This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '    This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '    You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '*/\n', '\n', '\n', '/**\n', ' * @title OpenZeppelin SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', ' library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title OpenZeppelin Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '//////////////////////////////////////////////////////////////\n', '//                                                          //\n', '//          Zironex, Open End Crypto Fund ERC20             //\n', '//                                                          //\n', '//////////////////////////////////////////////////////////////\n', '\n', 'contract ZironexERC20 is Ownable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) public balances;\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  /* Public variables for the ERC20 token */\n', '  string public constant standard = "ERC20 Zironex";\n', '  uint8 public constant decimals = 18; // hardcoded to be a constant\n', '  uint256 public totalSupply = 10000000000000000000000000;\n', '  string public name = "Ziron";\n', '  string public symbol = "ZNX";\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '        allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /* Approve and then communicate the approved contract in a single tx */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '    tokenRecipient spender = tokenRecipient(_spender);\n', '\n', '    if (approve(_spender, _value)) {\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '        return true;\n', '    }\n', '  }\n', '}\n', '\n', '\n', 'interface tokenRecipient {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;\n', '}\n', '\n', '\n', 'contract Zironex is ZironexERC20 {\n', '\n', '  // Constant to simplify conversion of token amounts into integer form\n', '    uint256 public tokenUnit = uint256(10)**decimals;\n', '\n', '  //Declare logging events\n', '    event LogDeposit(address sender, uint amount);\n', '\n', '  /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor(\n', '      address contractOwner\n', '\n', '        ) public {\n', '        owner = contractOwner; // set owner address\n', '        balances[contractOwner] = balances[contractOwner].add(totalSupply); // set owner balance\n', '    }\n', '}']
