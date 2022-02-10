['/*\n', 'Copyright 2018 Fileora\n', 'Licensed under the Apache License, Version 2.0 (the "License");\n', 'you may not use this file except in compliance with the License.\n', 'You may obtain a copy of the License at\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', 'Unless required by applicable law or agreed to in writing, software\n', 'distributed under the License is distributed on an "AS IS" BASIS,\n', 'WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', 'See the License for the specific language governing permissions and\n', 'limitations under the License.\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) internal balances;\n', '\n', '  uint256 internal totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', '/*\n', 'Copyright 2018 Binod Nirvan\n', '\n', 'Licensed under the Apache License, Version 2.0 (the "License");\n', 'you may not use this file except in compliance with the License.\n', 'You may obtain a copy of the License at\n', '\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', '\n', 'Unless required by applicable law or agreed to in writing, software\n', 'distributed under the License is distributed on an "AS IS" BASIS,\n', 'WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', 'See the License for the specific language governing permissions and\n', 'limitations under the License.\n', ' */\n', '\n', '\n', '\n', '/*\n', 'Copyright 2018 Binod Nirvan\n', '\n', 'Licensed under the Apache License, Version 2.0 (the "License");\n', 'you may not use this file except in compliance with the License.\n', 'You may obtain a copy of the License at\n', '\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', '\n', 'Unless required by applicable law or agreed to in writing, software\n', 'distributed under the License is distributed on an "AS IS" BASIS,\n', 'WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', 'See the License for the specific language governing permissions and\n', 'limitations under the License.\n', ' */\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '\n', '///@title This contract enables to create multiple contract administrators.\n', 'contract CustomAdmin is Ownable {\n', '  ///@notice List of administrators.\n', '  mapping(address => bool) public admins;\n', '\n', '  event AdminAdded(address indexed _address);\n', '  event AdminRemoved(address indexed _address);\n', '\n', '  ///@notice Validates if the sender is actually an administrator.\n', '  modifier onlyAdmin() {\n', '    require(isAdmin(msg.sender), "Access is denied.");\n', '    _;\n', '  }\n', '\n', '  ///@notice Adds the specified address to the list of administrators.\n', '  ///@param _address The address to add to the administrator list.\n', '  function addAdmin(address _address) external onlyAdmin returns(bool) {\n', '    require(_address != address(0), "Invalid address.");\n', '    require(!admins[_address], "This address is already an administrator.");\n', '\n', '    require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");\n', '\n', '    admins[_address] = true;\n', '\n', '    emit AdminAdded(_address);\n', '    return true;\n', '  }\n', '\n', '  ///@notice Adds multiple addresses to the administrator list.\n', '  ///@param _accounts The wallet addresses to add to the administrator list.\n', '  function addManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {\n', '    for(uint8 i = 0; i < _accounts.length; i++) {\n', '      address account = _accounts[i];\n', '\n', '      ///Zero address cannot be an admin.\n', '      ///The owner is already an admin and cannot be assigned.\n', '      ///The address cannot be an existing admin.\n', '      if(account != address(0) && !admins[account] && account != owner) {\n', '        admins[account] = true;\n', '\n', '        emit AdminAdded(_accounts[i]);\n', '      }\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  ///@notice Removes the specified address from the list of administrators.\n', '  ///@param _address The address to remove from the administrator list.\n', '  function removeAdmin(address _address) external onlyAdmin returns(bool) {\n', '    require(_address != address(0), "Invalid address.");\n', '    require(admins[_address], "This address isn\'t an administrator.");\n', '\n', '    //The owner cannot be removed as admin.\n', '    require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");\n', '\n', '    admins[_address] = false;\n', '    emit AdminRemoved(_address);\n', '    return true;\n', '  }\n', '\n', '  ///@notice Removes multiple addresses to the administrator list.\n', '  ///@param _accounts The wallet addresses to add to the administrator list.\n', '  function removeManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {\n', '    for(uint8 i = 0; i < _accounts.length; i++) {\n', '      address account = _accounts[i];\n', '\n', '      ///Zero address can neither be added or removed from this list.\n', '      ///The owner is the super admin and cannot be removed.\n', '      ///The address must be an existing admin in order for it to be removed.\n', '      if(account != address(0) && admins[account] && account != owner) {\n', '        admins[account] = false;\n', '\n', '        emit AdminRemoved(_accounts[i]);\n', '      }\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  ///@notice Checks if an address is an administrator.\n', '  function isAdmin(address _address) public view returns(bool) {\n', '    if(_address == owner) {\n', '      return true;\n', '    }\n', '\n', '    return admins[_address];\n', '  }\n', '}\n', '\n', '\n', '\n', '///@title This contract enables you to create pausable mechanism to stop in case of emergency.\n', 'contract CustomPausable is CustomAdmin {\n', '  event Paused();\n', '  event Unpaused();\n', '\n', '  bool public paused = false;\n', '\n', '  ///@notice Verifies whether the contract is not paused.\n', '  modifier whenNotPaused() {\n', '    require(!paused, "Sorry but the contract isn\'t paused.");\n', '    _;\n', '  }\n', '\n', '  ///@notice Verifies whether the contract is paused.\n', '  modifier whenPaused() {\n', '    require(paused, "Sorry but the contract is paused.");\n', '    _;\n', '  }\n', '\n', '  ///@notice Pauses the contract.\n', '  function pause() external onlyAdmin whenNotPaused {\n', '    paused = true;\n', '    emit Paused();\n', '  }\n', '\n', '  ///@notice Unpauses the contract and returns to normal state.\n', '  function unpause() external onlyAdmin whenPaused {\n', '    paused = false;\n', '    emit Unpaused();\n', '  }\n', '}\n', '/*\n', 'Copyright 2018 Binod Nirvan\n', 'Licensed under the Apache License, Version 2.0 (the "License");\n', 'you may not use this file except in compliance with the License.\n', 'You may obtain a copy of the License at\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', 'Unless required by applicable law or agreed to in writing, software\n', 'distributed under the License is distributed on an "AS IS" BASIS,\n', 'WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', 'See the License for the specific language governing permissions and\n', 'limitations under the License.\n', '*/\n', '\n', '\n', '\n', '\n', '\n', '\n', '///@title Transfer State Contract\n', '///@author Binod Nirvan\n', '///@notice Enables the admins to maintain the transfer state.\n', '///Transfer state when disabled disallows everyone but admins to transfer tokens.\n', 'contract TransferState is CustomPausable {\n', '  bool public released = false;\n', '\n', '  event TokenReleased(bool _state);\n', '\n', '  ///@notice Checks if the supplied address is able to perform transfers.\n', '  ///@param _from The address to check against if the transfer is allowed.\n', '  modifier canTransfer(address _from) {\n', '    if(paused || !released) {\n', '      if(!isAdmin(_from)) {\n', '        revert("Operation not allowed. The transfer state is restricted.");\n', '      }\n', '    }\n', '\n', '    _;\n', '  }\n', '\n', '  ///@notice This function enables token transfers for everyone.\n', '  ///Can only be enabled after the end of the ICO.\n', '  function enableTransfers() external onlyAdmin whenNotPaused returns(bool) {\n', '    require(!released, "Invalid operation. The transfer state is no more restricted.");\n', '\n', '    released = true;\n', '\n', '    emit TokenReleased(released);\n', '    return true;\n', '  }\n', '\n', '  ///@notice This function disables token transfers for everyone.\n', '  function disableTransfers() external onlyAdmin whenNotPaused returns(bool) {\n', '    require(released, "Invalid operation. The transfer state is already restricted.");\n', '\n', '    released = false;\n', '\n', '    emit TokenReleased(released);\n', '    return true;\n', '  }\n', '}\n', '/*\n', 'Copyright 2018 Binod Nirvan\n', 'Licensed under the Apache License, Version 2.0 (the "License");\n', 'you may not use this file except in compliance with the License.\n', 'You may obtain a copy of the License at\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', 'Unless required by applicable law or agreed to in writing, software\n', 'distributed under the License is distributed on an "AS IS" BASIS,\n', 'WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', 'See the License for the specific language governing permissions and\n', 'limitations under the License.\n', '*/\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '///@title Bulk Transfer Contract\n', '///@author Binod Nirvan\n', '///@notice This contract provides features for admins to perform bulk transfers.\n', 'contract BulkTransfer is StandardToken, CustomAdmin {\n', '  event BulkTransferPerformed(address[] _destinations, uint256[] _amounts);\n', '\n', '  ///@notice Allows only the admins and/or whitelisted applications to perform bulk transfer operation.\n', '  ///@param _destinations The destination wallet addresses to send funds to.\n', '  ///@param _amounts The respective amount of fund to send to the specified addresses. \n', '  function bulkTransfer(address[] _destinations, uint256[] _amounts) public onlyAdmin returns(bool) {\n', '    require(_destinations.length == _amounts.length, "Invalid operation.");\n', '\n', '    //Saving gas by determining if the sender has enough balance\n', '    //to post this transaction.\n', '    uint256 requiredBalance = sumOf(_amounts);\n', '    require(balances[msg.sender] >= requiredBalance, "You don\'t have sufficient funds to transfer amount that large.");\n', '    \n', '    for (uint256 i = 0; i < _destinations.length; i++) {\n', '      transfer(_destinations[i], _amounts[i]);\n', '    }\n', '\n', '    emit BulkTransferPerformed(_destinations, _amounts);\n', '    return true;\n', '  }\n', '  \n', '  ///@notice Returns the sum of supplied values.\n', '  ///@param _values The collection of values to create the sum from.  \n', '  function sumOf(uint256[] _values) private pure returns(uint256) {\n', '    uint256 total = 0;\n', '\n', '    for (uint256 i = 0; i < _values.length; i++) {\n', '      total = total.add(_values[i]);\n', '    }\n', '\n', '    return total;\n', '  }\n', '}\n', '/*\n', 'Copyright 2018 Binod Nirvan\n', 'Licensed under the Apache License, Version 2.0 (the "License");\n', 'you may not use this file except in compliance with the License.\n', 'You may obtain a copy of the License at\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', 'Unless required by applicable law or agreed to in writing, software\n', 'distributed under the License is distributed on an "AS IS" BASIS,\n', 'WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', 'See the License for the specific language governing permissions and\n', 'limitations under the License.\n', '*/\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(\n', '    ERC20Basic _token,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transfer(_to, _value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 _token,\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transferFrom(_from, _to, _value));\n', '  }\n', '\n', '  function safeApprove(\n', '    ERC20 _token,\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.approve(_spender, _value));\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '///@title Reclaimable Contract\n', '///@author Binod Nirvan\n', '///@notice Reclaimable contract enables the administrators \n', '///to reclaim accidentally sent Ethers and ERC20 token(s)\n', '///to this contract.\n', 'contract Reclaimable is CustomAdmin {\n', '  using SafeERC20 for ERC20;\n', '\n', '  ///@notice Transfers all Ether held by the contract to the owner.\n', '  function reclaimEther() external onlyAdmin {\n', '    msg.sender.transfer(address(this).balance);\n', '  }\n', '\n', '  ///@notice Transfers all ERC20 tokens held by the contract to the owner.\n', '  ///@param _token The amount of token to reclaim.\n', '  function reclaimToken(address _token) external onlyAdmin {\n', '    ERC20 erc20 = ERC20(_token);\n', '    uint256 balance = erc20.balanceOf(this);\n', '    erc20.safeTransfer(msg.sender, balance);\n', '  }\n', '}\n', '\n', '\n', '///@title Fileora Internal Token\n', '///@author Binod Nirvan\n', '///@notice Fileora Internal Token\n', 'contract FileoraInternalToken is StandardToken, TransferState, BulkTransfer, Reclaimable, BurnableToken {\n', '  //solhint-disable\n', '  uint8 public constant decimals = 18;\n', '  string public constant name = "Fileora Internal Token";\n', '  string public constant symbol = "FIT";\n', '  //solhint-enable\n', '\n', '  uint256 public constant MAX_SUPPLY = 249392500 * 1 ether;\n', '  uint256 public constant INITIAL_SUPPLY = 100000 * 1 ether;\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  constructor() public {\n', '    mintTokens(msg.sender, INITIAL_SUPPLY);\n', '  }\n', '\n', '  ///@notice Transfers the specified value of FET tokens to the destination address. \n', '  //Transfers can only happen when the transfer state is enabled. \n', '  //Transfer state can only be enabled after the end of the crowdsale.\n', '  ///@param _to The destination wallet address to transfer funds to.\n', '  ///@param _value The amount of tokens to send to the destination address.\n', '  function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns(bool) {\n', '    require(_to != address(0), "Invalid address.");\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  ///@notice Transfers tokens from a specified wallet address.\n', '  ///@dev This function is overridden to leverage transfer state feature.\n', '  ///@param _from The address to transfer funds from.\n', '  ///@param _to The address to transfer funds to.\n', '  ///@param _value The amount of tokens to transfer.\n', '  function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns(bool) {\n', '    require(_to != address(0), "Invalid address.");\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  ///@notice Approves a wallet address to spend on behalf of the sender.\n', '  ///@dev This function is overridden to leverage transfer state feature.\n', '  ///@param _spender The address which is approved to spend on behalf of the sender.\n', '  ///@param _value The amount of tokens approve to spend. \n', '  function approve(address _spender, uint256 _value) public canTransfer(msg.sender) returns(bool) {\n', '    require(_spender != address(0), "Invalid address.");\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  ///@notice Increases the approval of the spender.\n', '  ///@dev This function is overridden to leverage transfer state feature.\n', '  ///@param _spender The address which is approved to spend on behalf of the sender.\n', '  ///@param _addedValue The added amount of tokens approved to spend.\n', '  function increaseApproval(address _spender, uint256 _addedValue) public canTransfer(msg.sender) returns(bool) {\n', '    require(_spender != address(0), "Invalid address.");\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  ///@notice Decreases the approval of the spender.\n', '  ///@dev This function is overridden to leverage transfer state feature.\n', '  ///@param _spender The address of the spender to decrease the allocation from.\n', '  ///@param _subtractedValue The amount of tokens to subtract from the approved allocation.\n', '  function decreaseApproval(address _spender, uint256 _subtractedValue) public canTransfer(msg.sender) returns(bool) {\n', '    require(_spender != address(0), "Invalid address.");\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '\n', '  ///@notice Burns the coins held by the sender.\n', '  ///@param _value The amount of coins to burn.\n', '  ///@dev This function is overridden to leverage Pausable feature.\n', '  function burn(uint256 _value) public whenNotPaused {\n', '    super.burn(_value);\n', '  }\n', '\n', '  ///@notice Mints the supplied value of the tokens to the destination address.\n', '  //Minting cannot be performed any further once the maximum supply is reached.\n', '  //This function cannot be used by anyone except for this contract.\n', '  ///@param _to The address which will receive the minted tokens.\n', '  ///@param _value The amount of tokens to mint.\n', '  function mintTokens(address _to, uint _value) public onlyAdmin returns(bool) {\n', '    require(_to != address(0), "Invalid address.");\n', '    require(totalSupply_.add(_value) <= MAX_SUPPLY, "Sorry but the total supply can\'t exceed the maximum supply.");\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    totalSupply_ = totalSupply_.add(_value);\n', '\n', '    emit Transfer(address(0), _to, _value);\n', '    emit Mint(_to, _value);\n', '\n', '    return true;\n', '  }\n', '}']