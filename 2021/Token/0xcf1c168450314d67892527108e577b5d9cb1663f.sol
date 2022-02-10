['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-16\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2020-12-19\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2018-01-01\n', '*/\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '// Deployed [email\xa0protected] 31/12/17\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public constant returns (uint);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract UpgradedStandardToken is StandardToken {\n', '    // those methods are called by the legacy contract\n', '    // and they must ensure msg.sender to be the contract address\n', '    uint public _totalSupply;\n', '    function transferByLegacy(address from, address to, uint value) public returns (bool);\n', '    function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool);\n', '    function approveByLegacy(address from, address spender, uint value) public returns (bool);\n', '    function increaseApprovalByLegacy(address from, address spender, uint addedValue) public returns (bool);\n', '    function decreaseApprovalByLegacy(address from, address spender, uint subtractedValue) public returns (bool);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract StandardTokenWithFees is StandardToken, Ownable {\n', '\n', '  // Additional variables for use if transaction fees ever became necessary\n', '  uint256 public basisPointsRate = 0;\n', '  uint256 public maximumFee = 0;\n', '  uint256 constant MAX_SETTABLE_BASIS_POINTS = 20;\n', '  uint256 constant MAX_SETTABLE_FEE = 50;\n', '\n', '  string public site;\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint public _totalSupply;\n', '\n', '  uint public constant MAX_UINT = 2**256 - 1;\n', '\n', '  function calcFee(uint _value) constant returns (uint) {\n', '    uint fee = (_value.mul(basisPointsRate)).div(10000);\n', '    if (fee > maximumFee) {\n', '        fee = maximumFee;\n', '    }\n', '    return fee;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) public returns (bool) {\n', '    uint fee = calcFee(_value);\n', '    uint sendAmount = _value.sub(fee);\n', '\n', '    super.transfer(_to, sendAmount);\n', '    if (fee > 0) {\n', '      super.transfer(owner, fee);\n', '    }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    uint fee = calcFee(_value);\n', '    uint sendAmount = _value.sub(fee);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(sendAmount);\n', '    if (allowed[_from][msg.sender] < MAX_UINT) {\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    }\n', '    Transfer(_from, _to, sendAmount);\n', '    if (fee > 0) {\n', '      balances[owner] = balances[owner].add(fee);\n', '      Transfer(_from, owner, fee);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {\n', '      // Ensure transparency by hardcoding limit beyond which fees can never be added\n', '      require(newBasisPoints < MAX_SETTABLE_BASIS_POINTS);\n', '      require(newMaxFee < MAX_SETTABLE_FEE);\n', '\n', '      basisPointsRate = newBasisPoints;\n', '      maximumFee = newMaxFee.mul(uint(10)**decimals);\n', '\n', '      Params(basisPointsRate, maximumFee);\n', '  }\n', '\n', '  // Called if contract ever adds fees\n', '  event Params(uint feeBasisPoints, uint maxFee);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', 'contract BlackList is Ownable {\n', '\n', '    /////// Getter to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////\n', '    function getBlackListStatus(address _maker) external constant returns (bool) {\n', '        return isBlackListed[_maker];\n', '    }\n', '\n', '    mapping (address => bool) public isBlackListed;\n', '\n', '    function addBlackList (address _evilUser) public onlyOwner {\n', '        isBlackListed[_evilUser] = true;\n', '        AddedBlackList(_evilUser);\n', '    }\n', '\n', '    function removeBlackList (address _clearedUser) public onlyOwner {\n', '        isBlackListed[_clearedUser] = false;\n', '        RemovedBlackList(_clearedUser);\n', '    }\n', '\n', '    event AddedBlackList(address indexed _user);\n', '\n', '    event RemovedBlackList(address indexed _user);\n', '\n', '}\n', '\n', 'contract TetherToken is Pausable, StandardTokenWithFees, BlackList {\n', '\n', '    address public upgradedAddress;\n', '    bool public deprecated;\n', '\n', '    //  The contract can be initialized with a number of tokens\n', '    //  All the tokens are deposited to the owner address\n', '    //\n', '    // @param _balance Initial supply of the contract\n', '    // @param _name Token Name\n', '    // @param _symbol Token symbol\n', '    // @param _decimals Token decimals\n', '    function TetherToken(uint _initialSupply, string _site,string _name, string _symbol, uint8 _decimals) public {\n', '        _totalSupply = _initialSupply;\n', '        site = _site;\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        balances[owner] = _initialSupply;\n', '        deprecated = false;\n', '    }\n', '\n', '    // Forward ERC20 methods to upgraded contract if this one is deprecated\n', '    function transfer(address _to, uint _value) public whenNotPaused returns (bool) {\n', '        require(!isBlackListed[msg.sender]);\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);\n', '        } else {\n', '            return super.transfer(_to, _value);\n', '        }\n', '    }\n', '\n', '    // Forward ERC20 methods to upgraded contract if this one is deprecated\n', '    function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {\n', '        require(!isBlackListed[_from]);\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);\n', '        } else {\n', '            return super.transferFrom(_from, _to, _value);\n', '        }\n', '    }\n', '\n', '    // Forward ERC20 methods to upgraded contract if this one is deprecated\n', '    function balanceOf(address who) public constant returns (uint) {\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).balanceOf(who);\n', '        } else {\n', '            return super.balanceOf(who);\n', '        }\n', '    }\n', '\n', '    // Allow checks of balance at time of deprecation\n', '    function oldBalanceOf(address who) public constant returns (uint) {\n', '        if (deprecated) {\n', '            return super.balanceOf(who);\n', '        }\n', '    }\n', '\n', '    // Forward ERC20 methods to upgraded contract if this one is deprecated\n', '    function approve(address _spender, uint _value) public whenNotPaused returns (bool) {\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);\n', '        } else {\n', '            return super.approve(_spender, _value);\n', '        }\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).increaseApprovalByLegacy(msg.sender, _spender, _addedValue);\n', '        } else {\n', '            return super.increaseApproval(_spender, _addedValue);\n', '        }\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {\n', '        if (deprecated) {\n', '            return UpgradedStandardToken(upgradedAddress).decreaseApprovalByLegacy(msg.sender, _spender, _subtractedValue);\n', '        } else {\n', '            return super.decreaseApproval(_spender, _subtractedValue);\n', '        }\n', '    }\n', '\n', '    // Forward ERC20 methods to upgraded contract if this one is deprecated\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        if (deprecated) {\n', '            return StandardToken(upgradedAddress).allowance(_owner, _spender);\n', '        } else {\n', '            return super.allowance(_owner, _spender);\n', '        }\n', '    }\n', '\n', '    // deprecate current contract in favour of a new one\n', '    function deprecate(address _upgradedAddress) public onlyOwner {\n', '        require(_upgradedAddress != address(0));\n', '        deprecated = true;\n', '        upgradedAddress = _upgradedAddress;\n', '        Deprecate(_upgradedAddress);\n', '    }\n', '\n', '    // deprecate current contract if favour of a new one\n', '    function totalSupply() public constant returns (uint) {\n', '        if (deprecated) {\n', '            return StandardToken(upgradedAddress).totalSupply();\n', '        } else {\n', '            return _totalSupply;\n', '        }\n', '    }\n', '\n', '    // Issue a new amount of tokens\n', '    // these tokens are deposited into the owner address\n', '    //\n', '    // @param _amount Number of tokens to be issued\n', '    function issue(uint amount) public onlyOwner {\n', '        balances[owner] = balances[owner].add(amount);\n', '        _totalSupply = _totalSupply.add(amount);\n', '        Issue(amount);\n', '        Transfer(address(0), owner, amount);\n', '    }\n', '\n', '    // Redeem tokens.\n', '    // These tokens are withdrawn from the owner address\n', '    // if the balance must be enough to cover the redeem\n', '    // or the call will fail.\n', '    // @param _amount Number of tokens to be issued\n', '    function redeem(uint amount) public onlyOwner {\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        balances[owner] = balances[owner].sub(amount);\n', '        Redeem(amount);\n', '        Transfer(owner, address(0), amount);\n', '    }\n', '\n', '    function destroyBlackFunds (address _blackListedUser) public onlyOwner {\n', '        require(isBlackListed[_blackListedUser]);\n', '        uint dirtyFunds = balanceOf(_blackListedUser);\n', '        balances[_blackListedUser] = 0;\n', '        _totalSupply = _totalSupply.sub(dirtyFunds);\n', '        DestroyedBlackFunds(_blackListedUser, dirtyFunds);\n', '    }\n', '\n', '    event DestroyedBlackFunds(address indexed _blackListedUser, uint _balance);\n', '\n', '    // Called when new token are issued\n', '    event Issue(uint amount);\n', '\n', '    // Called when tokens are redeemed\n', '    event Redeem(uint amount);\n', '\n', '    // Called when contract is deprecated\n', '    event Deprecate(address newAddress);\n', '\n', '}']