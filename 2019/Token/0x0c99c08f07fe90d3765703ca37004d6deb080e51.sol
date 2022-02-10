['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '    address public pendingOwner;\n', '\n', '    /**\n', '     * @dev Modifier throws if called by any account other than the pendingOwner.\n', '     */\n', '    modifier onlyPendingOwner() {\n', '        require(msg.sender == pendingOwner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to set the pendingOwner address.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        pendingOwner = newOwner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the pendingOwner address to finalize the transfer.\n', '     */\n', '    function claimOwnership() onlyPendingOwner public {\n', '        OwnershipTransferred(owner, pendingOwner);\n', '        owner = pendingOwner;\n', '        pendingOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title LimitedTransferToken\n', ' * @dev LimitedTransferToken defines the generic interface and the implementation to limit token\n', ' * transferability for different events. It is intended to be used as a base class for other token\n', ' * contracts.\n', ' * LimitedTransferToken has been designed to allow for different limiting factors,\n', ' * this can be achieved by recursively calling super.transferableTokens() until the base class is\n', ' * hit. For example:\n', ' *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {\n', ' *       return min256(unlockedTokens, super.transferableTokens(holder, time));\n', ' *     }\n', ' * A working example is VestedToken.sol:\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol\n', ' */\n', '\n', 'contract LimitedTransferToken is ERC20 {\n', '\n', '  /**\n', '   * @dev Checks whether it can transfer or otherwise throws.\n', '   */\n', '  modifier canTransfer(address _sender, uint256 _value) {\n', '   require(_value <= transferableTokens(_sender, uint64(now)));\n', '   _;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks modifier and allows transfer if tokens are not locked.\n', '   * @param _to The address that will receive the tokens.\n', '   * @param _value The amount of tokens to be transferred.\n', '   */\n', '  function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Checks modifier and allows transfer if tokens are not locked.\n', '  * @param _from The address that will send the tokens.\n', '  * @param _to The address that will receive the tokens.\n', '  * @param _value The amount of tokens to be transferred.\n', '  */\n', '  function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Default transferable tokens function returns all tokens for a holder (no limit).\n', '   * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the\n', '   * specific logic for limiting token transferability for a holder over time.\n', '   */\n', '  function transferableTokens(address holder, uint64 time) public view returns (uint256) {\n', '    return balanceOf(holder);\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Claimable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '/*\n', '    Smart Token interface\n', '*/\n', 'contract ISmartToken {\n', '\n', '    // =================================================================================================================\n', '    //                                      Members\n', '    // =================================================================================================================\n', '\n', '    bool public transfersEnabled = false;\n', '\n', '    // =================================================================================================================\n', '    //                                      Event\n', '    // =================================================================================================================\n', '\n', '    // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory\n', '    event NewSmartToken(address _token);\n', '    // triggered when the total supply is increased\n', '    event Issuance(uint256 _amount);\n', '    // triggered when the total supply is decreased\n', '    event Destruction(uint256 _amount);\n', '\n', '    // =================================================================================================================\n', '    //                                      Functions\n', '    // =================================================================================================================\n', '\n', '    function disableTransfers(bool _disable) public;\n', '    function issue(address _to, uint256 _amount) public;\n', '    function destroy(address _from, uint256 _amount) public;\n', '}\n', '\n', '\n', '/**\n', '    BancorSmartToken\n', '*/\n', 'contract LimitedTransferBancorSmartToken is MintableToken, ISmartToken, LimitedTransferToken {\n', '\n', '    // =================================================================================================================\n', '    //                                      Modifiers\n', '    // =================================================================================================================\n', '\n', '    /**\n', '     * @dev Throws if destroy flag is not enabled.\n', '     */\n', '    modifier canDestroy() {\n', '        require(destroyEnabled);\n', '        _;\n', '    }\n', '\n', '    // =================================================================================================================\n', '    //                                      Members\n', '    // =================================================================================================================\n', '\n', '    // We add this flag to avoid users and owner from destroy tokens during crowdsale,\n', '    // This flag is set to false by default and blocks destroy function,\n', '    // We enable destroy option on finalize, so destroy will be possible after the crowdsale.\n', '    bool public destroyEnabled = false;\n', '\n', '    // =================================================================================================================\n', '    //                                      Public Functions\n', '    // =================================================================================================================\n', '\n', '    function setDestroyEnabled(bool _enable) onlyOwner public {\n', '        destroyEnabled = _enable;\n', '    }\n', '\n', '    // =================================================================================================================\n', '    //                                      Impl ISmartToken\n', '    // =================================================================================================================\n', '\n', '    //@Override\n', '    function disableTransfers(bool _disable) onlyOwner public {\n', '        transfersEnabled = !_disable;\n', '    }\n', '\n', '    //@Override\n', '    function issue(address _to, uint256 _amount) onlyOwner public {\n', '        require(super.mint(_to, _amount));\n', '        Issuance(_amount);\n', '    }\n', '\n', '    //@Override\n', '    function destroy(address _from, uint256 _amount) canDestroy public {\n', '\n', '        require(msg.sender == _from || msg.sender == owner); // validate input\n', '\n', '        balances[_from] = balances[_from].sub(_amount);\n', '        totalSupply = totalSupply.sub(_amount);\n', '\n', '        Destruction(_amount);\n', '        Transfer(_from, 0x0, _amount);\n', '    }\n', '\n', '    // =================================================================================================================\n', '    //                                      Impl LimitedTransferToken\n', '    // =================================================================================================================\n', '\n', '\n', '    // Enable/Disable token transfer\n', '    // Tokens will be locked in their wallets until the end of the Crowdsale.\n', '    // @holder - token`s owner\n', '    // @time - not used (framework unneeded functionality)\n', '    //\n', '    // @Override\n', '    function transferableTokens(address holder, uint64 time) public constant returns (uint256) {\n', '        require(transfersEnabled);\n', '        return super.transferableTokens(holder, time);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', "  A Token which is 'Bancor' compatible and can mint new tokens and pause token-transfer functionality\n", '*/\n', 'contract SirinSmartToken is LimitedTransferBancorSmartToken {\n', '\n', '    // =================================================================================================================\n', '    //                                         Members\n', '    // =================================================================================================================\n', '\n', '    string public name = "INVEST";\n', '\n', '    string public symbol = "INVEST";\n', '\n', '    uint8 public decimals = 18;\n', '\n', '    // =================================================================================================================\n', '    //                                         Constructor\n', '    // =================================================================================================================\n', '\n', '    function SirinSmartToken() public {\n', "        //Apart of 'Bancor' computability - triggered when a smart token is deployed\n", '        NewSmartToken(address(this));\n', '    }\n', '}']