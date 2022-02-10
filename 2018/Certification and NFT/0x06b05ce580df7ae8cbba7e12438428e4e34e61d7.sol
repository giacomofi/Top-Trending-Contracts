['pragma solidity ^0.4.18;\n', '\n', '/*\n', '    Copyright 2017-2018 Phillip A. Elsasser\n', '\n', '    Licensed under the Apache License, Version 2.0 (the "License");\n', '    you may not use this file except in compliance with the License.\n', '    You may obtain a copy of the License at\n', '\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', '\n', '    Unless required by applicable law or agreed to in writing, software\n', '    distributed under the License is distributed on an "AS IS" BASIS,\n', '    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '    See the License for the specific language governing permissions and\n', '    limitations under the License.\n', '*/\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract UpgradeableTarget {\n', '    function upgradeFrom(address from, uint256 value) external; // note: implementation should require(from == oldToken)\n', '}\n', '\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    Burn(burner, _value);\n', '    Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/// @title Upgradeable Token\n', '/// @notice allows for us to update some of the needed functionality in our tokens post deployment. Inspiration taken\n', '/// from Golems migrate functionality.\n', '/// @author Phil Elsasser <phil@marketprotocol.io>\n', 'contract UpgradeableToken is Ownable, BurnableToken, StandardToken {\n', '\n', '    address public upgradeableTarget;       // contract address handling upgrade\n', '    uint256 public totalUpgraded;           // total token amount already upgraded\n', '\n', '    event Upgraded(address indexed from, address indexed to, uint256 value);\n', '\n', '    /*\n', '    // EXTERNAL METHODS - TOKEN UPGRADE SUPPORT\n', '    */\n', '\n', '    /// @notice Update token to the new upgraded token\n', '    /// @param value The amount of token to be migrated to upgraded token\n', '    function upgrade(uint256 value) external {\n', '        require(upgradeableTarget != address(0));\n', '\n', '        burn(value);                    // burn tokens as we migrate them.\n', '        totalUpgraded = totalUpgraded.add(value);\n', '\n', '        UpgradeableTarget(upgradeableTarget).upgradeFrom(msg.sender, value);\n', '        Upgraded(msg.sender, upgradeableTarget, value);\n', '    }\n', '\n', '    /// @notice Set address of upgrade target process.\n', '    /// @param upgradeAddress The address of the UpgradeableTarget contract.\n', '    function setUpgradeableTarget(address upgradeAddress) external onlyOwner {\n', '        upgradeableTarget = upgradeAddress;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/// @title Market Token\n', '/// @notice Our membership token.  Users must lock tokens to enable trading for a given Market Contract\n', '/// as well as have a minimum balance of tokens to create new Market Contracts.\n', '/// @author Phil Elsasser <phil@marketprotocol.io>\n', 'contract MarketToken is UpgradeableToken {\n', '\n', '    string public constant name = "MARKET Protocol Token";\n', '    string public constant symbol = "MKT";\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint public constant INITIAL_SUPPLY = 600000000 * 10**uint(decimals); // 600 million tokens with 18 decimals (6e+26)\n', '\n', '    uint public lockQtyToAllowTrading;\n', '    uint public minBalanceToAllowContractCreation;\n', '\n', '    mapping(address => mapping(address => uint)) contractAddressToUserAddressToQtyLocked;\n', '\n', '    event UpdatedUserLockedBalance(address indexed contractAddress, address indexed userAddress, uint balance);\n', '\n', '    function MarketToken(uint qtyToLockForTrading, uint minBalanceForCreation) public {\n', '        lockQtyToAllowTrading = qtyToLockForTrading;\n', '        minBalanceToAllowContractCreation = minBalanceForCreation;\n', "        totalSupply_ = INITIAL_SUPPLY;  //note totalSupply_ and INITIAL_SUPPLY may vary as token's are burnt.\n", '\n', '        balances[msg.sender] = INITIAL_SUPPLY; // for now allocate all tokens to creator\n', '    }\n', '\n', '    /*\n', '    // EXTERNAL METHODS\n', '    */\n', '\n', '    /// @notice checks if a user address has locked the needed qty to allow trading to a given contract address\n', '    /// @param marketContractAddress address of the MarketContract\n', '    /// @param userAddress address of the user\n', '    /// @return true if user has locked tokens to trade the supplied marketContractAddress\n', '    function isUserEnabledForContract(address marketContractAddress, address userAddress) external view returns (bool) {\n', '        return contractAddressToUserAddressToQtyLocked[marketContractAddress][userAddress] >= lockQtyToAllowTrading;\n', '    }\n', '\n', '    /// @notice checks if a user address has enough token balance to be eligible to create a contract\n', '    /// @param userAddress address of the user\n', '    /// @return true if user has sufficient balance of tokens\n', '    function isBalanceSufficientForContractCreation(address userAddress) external view returns (bool) {\n', '        return balances[userAddress] >= minBalanceToAllowContractCreation;\n', '    }\n', '\n', '    /// @notice allows user to lock tokens to enable trading for a given market contract\n', '    /// @param marketContractAddress address of the MarketContract\n', '    /// @param qtyToLock desired qty of tokens to lock\n', '    function lockTokensForTradingMarketContract(address marketContractAddress, uint qtyToLock) external {\n', '        uint256 lockedBalance = contractAddressToUserAddressToQtyLocked[marketContractAddress][msg.sender].add(\n', '            qtyToLock\n', '        );\n', '        transfer(this, qtyToLock);\n', '        contractAddressToUserAddressToQtyLocked[marketContractAddress][msg.sender] = lockedBalance;\n', '        UpdatedUserLockedBalance(marketContractAddress, msg.sender, lockedBalance);\n', '    }\n', '\n', '    /// @notice allows user to unlock tokens previously allocated to trading a MarketContract\n', '    /// @param marketContractAddress address of the MarketContract\n', '    /// @param qtyToUnlock desired qty of tokens to unlock\n', '    function unlockTokens(address marketContractAddress, uint qtyToUnlock) external {\n', '        uint256 balanceAfterUnLock = contractAddressToUserAddressToQtyLocked[marketContractAddress][msg.sender].sub(\n', '            qtyToUnlock\n', '        );  // no need to check balance, sub() will ensure sufficient balance to unlock!\n', '        contractAddressToUserAddressToQtyLocked[marketContractAddress][msg.sender] = balanceAfterUnLock;        // update balance before external call!\n', '        transferLockedTokensBackToUser(qtyToUnlock);\n', '        UpdatedUserLockedBalance(marketContractAddress, msg.sender, balanceAfterUnLock);\n', '    }\n', '\n', '    /// @notice get the currently locked balance for a user given the specific contract address\n', '    /// @param marketContractAddress address of the MarketContract\n', '    /// @param userAddress address of the user\n', '    /// @return the locked balance\n', '    function getLockedBalanceForUser(address marketContractAddress, address userAddress) external view returns (uint) {\n', '        return contractAddressToUserAddressToQtyLocked[marketContractAddress][userAddress];\n', '    }\n', '\n', '    /*\n', '    // EXTERNAL - ONLY CREATOR  METHODS\n', '    */\n', '\n', '    /// @notice allows the creator to set the qty each user address needs to lock in\n', '    /// order to trade a given MarketContract\n', '    /// @param qtyToLock qty needed to enable trading\n', '    function setLockQtyToAllowTrading(uint qtyToLock) external onlyOwner {\n', '        lockQtyToAllowTrading = qtyToLock;\n', '    }\n', '\n', '    /// @notice allows the creator to set minimum balance a user must have in order to create MarketContracts\n', '    /// @param minBalance balance to enable contract creation\n', '    function setMinBalanceForContractCreation(uint minBalance) external onlyOwner {\n', '        minBalanceToAllowContractCreation = minBalance;\n', '    }\n', '\n', '    /*\n', '    // PRIVATE METHODS\n', '    */\n', '\n', "    /// @dev returns locked balance from this contract to the user's balance\n", "    /// @param qtyToUnlock qty to return to user's balance\n", '    function transferLockedTokensBackToUser(uint qtyToUnlock) private {\n', '        balances[this] = balances[this].sub(qtyToUnlock);\n', '        balances[msg.sender] = balances[msg.sender].add(qtyToUnlock);\n', '        Transfer(this, msg.sender, qtyToUnlock);\n', '    }\n', '}']