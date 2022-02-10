['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-22\n', '*/\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '//18705343\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title ERC20Basic\n', '\n', ' * @dev Simpler version of ERC20 interface\n', '\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', '\n', ' */\n', '\n', 'contract ERC20Basic {\n', '\n', '  function totalSupply() public view returns (uint256);\n', '\n', '  function balanceOf(address _who) public view returns (uint256);\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title SafeMath\n', '\n', ' * @dev Math operations with safety checks that throw on error\n', '\n', ' */\n', '\n', 'library SafeMath {\n', '\n', '\n', '\n', '  /**\n', '\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '\n', '  */\n', '\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", '\n', "    // benefit is lost if 'b' is also tested.\n", '\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '\n', '    if (_a == 0) {\n', '\n', '      return 0;\n', '\n', '    }\n', '\n', '\n', '\n', '    c = _a * _b;\n', '\n', '    assert(c / _a == _b);\n', '\n', '    return c;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '\n', '  */\n', '\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '\n', '    // uint256 c = _a / _b;\n', '\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '\n', '    return _a / _b;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '\n', '  */\n', '\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '\n', '    assert(_b <= _a);\n', '\n', '    return _a - _b;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '  * @dev Adds two numbers, throws on overflow.\n', '\n', '  */\n', '\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '\n', '    c = _a + _b;\n', '\n', '    assert(c >= _a);\n', '\n', '    return c;\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Basic token\n', '\n', ' * @dev Basic version of StandardToken, with no allowances.\n', '\n', ' */\n', '\n', 'contract BasicToken is ERC20Basic {\n', '\n', '  using SafeMath for uint256;\n', '\n', '\n', '\n', '  mapping(address => uint256) internal balances;\n', '\n', '\n', '\n', '  uint256 internal totalSupply_;\n', '\n', '\n', '\n', '  /**\n', '\n', '  * @dev Total number of tokens in existence\n', '\n', '  */\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '\n', '    return totalSupply_;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '  * @dev Transfer token for a specified address\n', '\n', '  * @param _to The address to transfer to.\n', '\n', '  * @param _value The amount to be transferred.\n', '\n', '  */\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    require(_to != address(0));\n', '\n', '\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '  * @dev Gets the balance of the specified address.\n', '\n', '  * @param _owner The address to query the the balance of.\n', '\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '\n', '  */\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '\n', '    return balances[_owner];\n', '\n', '  }\n', '\n', '\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title ERC20 interface\n', '\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', '\n', ' */\n', '\n', 'contract ERC20 is ERC20Basic {\n', '\n', '  function allowance(address _owner, address _spender)\n', '\n', '    public view returns (uint256);\n', '\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '\n', '    public returns (bool);\n', '\n', '\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '  event Approval(\n', '\n', '    address indexed owner,\n', '\n', '    address indexed spender,\n', '\n', '    uint256 value\n', '\n', '  );\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Standard ERC20 token\n', '\n', ' *\n', '\n', ' * @dev Implementation of the basic standard token.\n', '\n', ' * https://github.com/ethereum/EIPs/issues/20\n', '\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '\n', ' */\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Transfer tokens from one address to another\n', '\n', '   * @param _from address The address which you want to send tokens from\n', '\n', '   * @param _to address The address which you want to transfer to\n', '\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '\n', '   */\n', '\n', '  function transferFrom(\n', '\n', '    address _from,\n', '\n', '    address _to,\n', '\n', '    uint256 _value\n', '\n', '  )\n', '\n', '    public\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    require(_value <= balances[_from]);\n', '\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    require(_to != address(0));\n', '\n', '\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '   * @param _spender The address which will spend the funds.\n', '\n', '   * @param _value The amount of tokens to be spent.\n', '\n', '   */\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '\n', '    emit Approval(msg.sender, _spender, _value);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '\n', '   * @param _owner address The address which owns the funds.\n', '\n', '   * @param _spender address The address which will spend the funds.\n', '\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '\n', '   */\n', '\n', '  function allowance(\n', '\n', '    address _owner,\n', '\n', '    address _spender\n', '\n', '   )\n', '\n', '    public\n', '\n', '    view\n', '\n', '    returns (uint256)\n', '\n', '  {\n', '\n', '    return allowed[_owner][_spender];\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '\n', '   * the first transaction is mined)\n', '\n', '   * From MonolithDAO Token.sol\n', '\n', '   * @param _spender The address which will spend the funds.\n', '\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '\n', '   */\n', '\n', '  function increaseApproval(\n', '\n', '    address _spender,\n', '\n', '    uint256 _addedValue\n', '\n', '  )\n', '\n', '    public\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    allowed[msg.sender][_spender] = (\n', '\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '\n', '   * the first transaction is mined)\n', '\n', '   * From MonolithDAO Token.sol\n', '\n', '   * @param _spender The address which will spend the funds.\n', '\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '\n', '   */\n', '\n', '  function decreaseApproval(\n', '\n', '    address _spender,\n', '\n', '    uint256 _subtractedValue\n', '\n', '  )\n', '\n', '    public\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '\n', '    if (_subtractedValue >= oldValue) {\n', '\n', '      allowed[msg.sender][_spender] = 0;\n', '\n', '    } else {\n', '\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\n', '    }\n', '\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title DetailedERC20 token\n', '\n', ' * @dev The decimals are only for visualization purposes.\n', '\n', ' * All the operations are done using the smallest and indivisible token unit,\n', '\n', ' * just as on Ethereum all the operations are done in wei.\n', '\n', ' */\n', '\n', 'contract DetailedERC20 is ERC20 {\n', '\n', '  string public name;\n', '\n', '  string public symbol;\n', '\n', '  uint8 public decimals;\n', '\n', '\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals) public {\n', '\n', '    name = _name;\n', '\n', '    symbol = _symbol;\n', '\n', '    decimals = _decimals;\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Ownable\n', '\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', '\n', ' * functions, this simplifies the implementation of "user permissions".\n', '\n', ' */\n', '\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '\n', '\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '\n', '  event OwnershipTransferred(\n', '\n', '    address indexed previousOwner,\n', '\n', '    address indexed newOwner\n', '\n', '  );\n', '\n', '\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '\n', '   * account.\n', '\n', '   */\n', '\n', '  constructor() public {\n', '\n', '    owner = msg.sender;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Throws if called by any account other than the owner.\n', '\n', '   */\n', '\n', '  modifier onlyOwner() {\n', '\n', '    require(msg.sender == owner);\n', '\n', '    _;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '\n', '   * modifier anymore.\n', '\n', '   */\n', '\n', '  function renounceOwnership() public onlyOwner {\n', '\n', '    emit OwnershipRenounced(owner);\n', '\n', '    owner = address(0);\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '\n', '   * @param _newOwner The address to transfer ownership to.\n', '\n', '   */\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '\n', '    _transferOwnership(_newOwner);\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Transfers control of the contract to a newOwner.\n', '\n', '   * @param _newOwner The address to transfer ownership to.\n', '\n', '   */\n', '\n', '  function _transferOwnership(address _newOwner) internal {\n', '\n', '    require(_newOwner != address(0));\n', '\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '\n', '    owner = _newOwner;\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Mintable token\n', '\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', '\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', '\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  event MintFinished();\n', '\n', '\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '\n', '\n', '\n', '  modifier canMint() {\n', '\n', '    require(!mintingFinished);\n', '\n', '    _;\n', '\n', '  }\n', '\n', '\n', '\n', '  modifier hasMintPermission() {\n', '\n', '    require(msg.sender == owner);\n', '\n', '    _;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Function to mint tokens\n', '\n', '   * @param _to The address that will receive the minted tokens.\n', '\n', '   * @param _amount The amount of tokens to mint.\n', '\n', '   * @return A boolean that indicates if the operation was successful.\n', '\n', '   */\n', '\n', '  function mint(\n', '\n', '    address _to,\n', '\n', '    uint256 _amount\n', '\n', '  )\n', '\n', '    public\n', '\n', '    hasMintPermission\n', '\n', '    canMint\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '\n', '    balances[_to] = balances[_to].add(_amount);\n', '\n', '    emit Mint(_to, _amount);\n', '\n', '    emit Transfer(address(0), _to, _amount);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Function to stop minting new tokens.\n', '\n', '   * @return True if the operation was successful.\n', '\n', '   */\n', '\n', '  function finishMinting() public onlyOwner canMint returns (bool) {\n', '\n', '    mintingFinished = true;\n', '\n', '    emit MintFinished();\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Burnable Token\n', '\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', '\n', ' */\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Burns a specific amount of tokens.\n', '\n', '   * @param _value The amount of token to be burned.\n', '\n', '   */\n', '\n', '  function burn(uint256 _value) public {\n', '\n', '    _burn(msg.sender, _value);\n', '\n', '  }\n', '\n', '\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '\n', '    require(_value <= balances[_who]);\n', '\n', '    // no need to require value <= totalSupply, since that would imply the\n', '\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '\n', '\n', '    balances[_who] = balances[_who].sub(_value);\n', '\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '\n', '    emit Burn(_who, _value);\n', '\n', '    emit Transfer(_who, address(0), _value);\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Pausable\n', '\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', '\n', ' */\n', '\n', 'contract Pausable is Ownable {\n', '\n', '  event Pause();\n', '\n', '  event Unpause();\n', '\n', '\n', '\n', '  bool public paused = false;\n', '\n', '\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '\n', '   */\n', '\n', '  modifier whenNotPaused() {\n', '\n', '    require(!paused);\n', '\n', '    _;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '\n', '   */\n', '\n', '  modifier whenPaused() {\n', '\n', '    require(paused);\n', '\n', '    _;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev called by the owner to pause, triggers stopped state\n', '\n', '   */\n', '\n', '  function pause() public onlyOwner whenNotPaused {\n', '\n', '    paused = true;\n', '\n', '    emit Pause();\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev called by the owner to unpause, returns to normal state\n', '\n', '   */\n', '\n', '  function unpause() public onlyOwner whenPaused {\n', '\n', '    paused = false;\n', '\n', '    emit Unpause();\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Pausable token\n', '\n', ' * @dev StandardToken modified with pausable transfers.\n', '\n', ' **/\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '\n', '\n', '  function transfer(\n', '\n', '    address _to,\n', '\n', '    uint256 _value\n', '\n', '  )\n', '\n', '    public\n', '\n', '    whenNotPaused\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    return super.transfer(_to, _value);\n', '\n', '  }\n', '\n', '\n', '\n', '  function transferFrom(\n', '\n', '    address _from,\n', '\n', '    address _to,\n', '\n', '    uint256 _value\n', '\n', '  )\n', '\n', '    public\n', '\n', '    whenNotPaused\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    return super.transferFrom(_from, _to, _value);\n', '\n', '  }\n', '\n', '\n', '\n', '  function approve(\n', '\n', '    address _spender,\n', '\n', '    uint256 _value\n', '\n', '  )\n', '\n', '    public\n', '\n', '    whenNotPaused\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    return super.approve(_spender, _value);\n', '\n', '  }\n', '\n', '\n', '\n', '  function increaseApproval(\n', '\n', '    address _spender,\n', '\n', '    uint _addedValue\n', '\n', '  )\n', '\n', '    public\n', '\n', '    whenNotPaused\n', '\n', '    returns (bool success)\n', '\n', '  {\n', '\n', '    return super.increaseApproval(_spender, _addedValue);\n', '\n', '  }\n', '\n', '\n', '\n', '  function decreaseApproval(\n', '\n', '    address _spender,\n', '\n', '    uint _subtractedValue\n', '\n', '  )\n', '\n', '    public\n', '\n', '    whenNotPaused\n', '\n', '    returns (bool success)\n', '\n', '  {\n', '\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Claimable.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Claimable\n', '\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', '\n', ' * This allows the new owner to accept the transfer.\n', '\n', ' */\n', '\n', 'contract Claimable is Ownable {\n', '\n', '  address public pendingOwner;\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '\n', '   */\n', '\n', '  modifier onlyPendingOwner() {\n', '\n', '    require(msg.sender == pendingOwner);\n', '\n', '    _;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '\n', '   * @param newOwner The address to transfer ownership to.\n', '\n', '   */\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '\n', '    pendingOwner = newOwner;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '\n', '   */\n', '\n', '  function claimOwnership() public onlyPendingOwner {\n', '\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '\n', '    owner = pendingOwner;\n', '\n', '    pendingOwner = address(0);\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title SafeERC20\n', '\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', '\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', '\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', '\n', ' */\n', '\n', 'library SafeERC20 {\n', '\n', '  function safeTransfer(\n', '\n', '    ERC20Basic _token,\n', '\n', '    address _to,\n', '\n', '    uint256 _value\n', '\n', '  )\n', '\n', '    internal\n', '\n', '  {\n', '\n', '    require(_token.transfer(_to, _value));\n', '\n', '  }\n', '\n', '\n', '\n', '  function safeTransferFrom(\n', '\n', '    ERC20 _token,\n', '\n', '    address _from,\n', '\n', '    address _to,\n', '\n', '    uint256 _value\n', '\n', '  )\n', '\n', '    internal\n', '\n', '  {\n', '\n', '    require(_token.transferFrom(_from, _to, _value));\n', '\n', '  }\n', '\n', '\n', '\n', '  function safeApprove(\n', '\n', '    ERC20 _token,\n', '\n', '    address _spender,\n', '\n', '    uint256 _value\n', '\n', '  )\n', '\n', '    internal\n', '\n', '  {\n', '\n', '    require(_token.approve(_spender, _value));\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Contracts that should be able to recover tokens\n', '\n', ' * @author SylTi\n', '\n', ' * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.\n', '\n', ' * This will prevent any accidental loss of tokens.\n', '\n', ' */\n', '\n', 'contract CanReclaimToken is Ownable {\n', '\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Reclaim all ERC20Basic compatible tokens\n', '\n', '   * @param _token ERC20Basic The address of the token contract\n', '\n', '   */\n', '\n', '  function reclaimToken(ERC20Basic _token) external onlyOwner {\n', '\n', '    uint256 balance = _token.balanceOf(this);\n', '\n', '    _token.safeTransfer(owner, balance);\n', '\n', '  }\n', '\n', '\n', '\n', '}\n', '\n', '\n', '\n', '// File: contracts/utils/OwnableContract.sol\n', '\n', '\n', '\n', '// empty block is used as this contract just inherits others.\n', '\n', 'contract OwnableContract is CanReclaimToken, Claimable { } /* solhint-disable-line no-empty-blocks */\n', '\n', '\n', '\n', '// File: contracts/token/WBTC.sol\n', '\n', '\n', '\n', 'contract WBTC is StandardToken, DetailedERC20("Pyramid", "MLM", 8),\n', '\n', '    MintableToken, BurnableToken, PausableToken, OwnableContract {\n', '\n', '\n', '\n', '    function burn(uint value) public onlyOwner {\n', '\n', '        super.burn(value);\n', '\n', '    }\n', '\n', '\n', '\n', '    function finishMinting() public onlyOwner returns (bool) {\n', '\n', '        return false;\n', '\n', '    }\n', '\n', '\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '\n', '        revert("renouncing ownership is blocked");\n', '\n', '    }\n', '\n', '}']