['pragma solidity ^0.4.23;\n', '\n', '\n', '/*\n', ' *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐ \n', ' *             ║ ║├┤ ├┤ ││  │├─┤│   │          MSCE.vip       │ ║║║├┤ ├┴┐╚═╗│ │ ├┤  \n', ' *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬─────────────────────┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘ \n', ' *   ┌────────────────────────────────┘                     └──────────────────────────────┐\n', ' *   │    ┌─────────────────────────────────────────────────────────────────────────────┐  │\n', ' *   └────┤ Dev:John ├──────────────────────┤ Boss:Jack ├──────────────────┤ Sup:Kilmas ├──┘\n', ' *        └─────────────────────────────────────────────────────────────────────────────┘\n', ' */\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', '    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) internal balances;\n', '\n', '  uint256 internal totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '\n', '\n', '}\n', '\n', 'contract MSCE is Ownable, StandardToken, BurnableToken{\n', '    using SafeMath for uint256;\n', '\n', '    uint8 public constant TOKEN_DECIMALS = 18;\n', '\n', '    string public name = "Mobile Ecosystem"; \n', '    string public symbol = "MSCE";\n', '    uint8 public decimals = TOKEN_DECIMALS;\n', '\n', '\n', '    uint256 public totalSupply = 500000000 *(10**uint256(TOKEN_DECIMALS)); \n', '    uint256 public soldSupply = 0; \n', '    uint256 public sellSupply = 0; \n', '    uint256 public buySupply = 0; \n', '    bool public stopSell = true;\n', '    bool public stopBuy = false;\n', '\n', '    uint256 public crowdsaleStartTime = block.timestamp;\n', '    uint256 public crowdsaleEndTime = 1526831999;\n', '\n', '    uint256 public crowdsaleTotal = 2000*40000*(10**18);\n', '\n', '\n', '    uint256 public buyExchangeRate = 40000;   \n', '    uint256 public sellExchangeRate = 100000;  \n', '    address public ethFundDeposit;  \n', '\n', '\n', '    bool public allowTransfers = true; \n', '\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    bool public enableInternalLock = true;\n', '    uint256 unitCount = 100; \n', '    uint256 unitTime = 1 days;\n', '    uint256 lockTime = unitCount * unitTime;\n', '\n', '    mapping (address => bool) public internalLockAccount;\n', '    mapping (address => uint256) public releaseLockAccount;\n', '    mapping (address => uint256) public lockAmount;\n', '    mapping (address => uint256) public lockStartTime;\n', '    mapping (address => uint256) public lockReleaseTime;\n', '\n', '    event LockAmount(address _from, address _to, uint256 amount, uint256 releaseTime);\n', '    event FrozenFunds(address target, bool frozen);\n', '    event IncreaseSoldSaleSupply(uint256 _value);\n', '    event DecreaseSoldSaleSupply(uint256 _value);\n', '\n', '    function MSCE() public {\n', '        balances[msg.sender] = totalSupply;\n', '        ethFundDeposit = msg.sender;                      \n', '        allowTransfers = true;\n', '    }\n', '\n', '    function _isUserInternalLock() internal view returns (bool) {\n', '\n', '        return getAccountLockState(msg.sender);\n', '\n', '    }\n', '\n', '    function increaseSoldSaleSupply (uint256 _value) onlyOwner public {\n', '        require (_value + soldSupply < totalSupply);\n', '        soldSupply = soldSupply.add(_value);\n', '        emit IncreaseSoldSaleSupply(_value);\n', '    }\n', '\n', '    function decreaseSoldSaleSupply (uint256 _value) onlyOwner public {\n', '        require (soldSupply - _value > 0);\n', '        soldSupply = soldSupply.sub(_value);\n', '        emit DecreaseSoldSaleSupply(_value);\n', '    }\n', '\n', '\n', '    function setEthFundDeposit(address _ethFundDeposit) onlyOwner public {\n', '        require(_ethFundDeposit != address(0));\n', '        ethFundDeposit = _ethFundDeposit;\n', '    }\n', '\n', '    function transferETH() onlyOwner public {\n', '        require(ethFundDeposit != address(0));\n', '        require(this.balance != 0);\n', '        require(ethFundDeposit.send(this.balance));\n', '    }\n', '\n', '\n', '    function setExchangeRate(uint256 _sellExchangeRate, uint256 _buyExchangeRate) onlyOwner public {\n', '        sellExchangeRate = _sellExchangeRate;\n', '        buyExchangeRate = _buyExchangeRate;\n', '    }\n', '\n', '    function setExchangeStatus(bool _stopSell, bool _stopBuy) onlyOwner public {\n', '        stopSell = _stopSell;\n', '        stopBuy = _stopBuy;\n', '    }\n', '\n', '    function setAllowTransfers(bool _allowTransfers) onlyOwner public {\n', '        allowTransfers = _allowTransfers;\n', '    }\n', '\n', '    function setEnableInternalLock(bool _isEnable) onlyOwner public {\n', '        enableInternalLock = _isEnable;\n', '    }\n', '\n', '\n', '\n', '    function getAccountUnlockTime(address _target) public view returns(uint256) {\n', '\n', '        return releaseLockAccount[_target];\n', '\n', '    }\n', '    function getAccountLockState(address _target) public view returns(bool) {\n', '        if(enableInternalLock && internalLockAccount[_target]){\n', '            if((releaseLockAccount[_target] > 0)&&(releaseLockAccount[_target]<block.timestamp)){       \n', '                return false;\n', '            }          \n', '            return true;\n', '        }\n', '        return false;\n', '\n', '    }\n', '\n', '    function setUnitTime(uint256 unit) external onlyOwner{\n', '        unitTime = unit;\n', '    }\n', '    \n', '    function isOwner() internal view returns(bool success) {\n', '        if (msg.sender == owner) return true;\n', '        return false;\n', '    }\n', '    /***************************************************/\n', '    /*              BASE Functions                     */\n', '    /***************************************************/\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        if (!isOwner()) {\n', '            require (allowTransfers);\n', '            require(!frozenAccount[_from]);                                         \n', '            require(!frozenAccount[_to]);                                        \n', '            require(!_isUserInternalLock());\n', '        }\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        if (!isOwner()) {\n', '            require (allowTransfers);\n', '            require(!frozenAccount[msg.sender]);                                       \n', '            require(!frozenAccount[_to]);                                             \n', '            require(!_isUserInternalLock());\n', '            require(_value <= balances[msg.sender] - lockAmount[msg.sender] + releasedAmount(msg.sender));\n', '        }\n', '        if(_value >= releasedAmount(msg.sender)){\n', '            lockAmount[msg.sender] = lockAmount[msg.sender].sub(releasedAmount(msg.sender));\n', '        }else{\n', '            lockAmount[msg.sender] = lockAmount[msg.sender].sub(_value);\n', '        }\n', '        \n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        if (!isOwner()) {\n', '            require (allowTransfers);\n', '            require(!frozenAccount[msg.sender]);                                         \n', '            require(!frozenAccount[_spender]);                                        \n', '            require(!_isUserInternalLock());\n', '            require(_value <= balances[msg.sender] - lockAmount[msg.sender] + releasedAmount(msg.sender));\n', '        }\n', '        if(_value >= releasedAmount(msg.sender)){\n', '            lockAmount[msg.sender] = lockAmount[msg.sender].sub(releasedAmount(msg.sender));\n', '        }else{\n', '            lockAmount[msg.sender] = lockAmount[msg.sender].sub(_value);\n', '        }\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function transferFromAdmin(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function () internal payable{\n', '\n', '        uint256 currentTime = block.timestamp;\n', '        require((currentTime>crowdsaleStartTime)&&(currentTime<crowdsaleEndTime));\n', '        require(crowdsaleTotal>0);\n', '\n', '        require(buy());\n', '\n', '        crowdsaleTotal = crowdsaleTotal.sub(msg.value.mul(buyExchangeRate));\n', '\n', '    }\n', '\n', '    function buy() payable public returns (bool){\n', '\n', '\n', '        uint256 amount = msg.value.mul(buyExchangeRate);\n', '\n', '        require(!stopBuy);\n', '        require(amount <= balances[owner]);\n', '\n', '        balances[owner] = balances[owner].sub(amount);\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '\n', '        soldSupply = soldSupply.add(amount);\n', '        buySupply = buySupply.add(amount);\n', '\n', '        Transfer(owner, msg.sender, amount);\n', '        return true;\n', '    }\n', '\n', '    function sell(uint256 amount) public {\n', '        uint256 ethAmount = amount.div(sellExchangeRate);\n', '        require(!stopSell);\n', '        require(this.balance >= ethAmount);      \n', '        require(ethAmount >= 1);      \n', '\n', '        require(balances[msg.sender] >= amount);                 \n', '        require(balances[owner] + amount > balances[owner]);       \n', '        require(!frozenAccount[msg.sender]);                       \n', '        require(!_isUserInternalLock());                                          \n', '\n', '        balances[owner] = balances[owner].add(amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '\n', '        soldSupply = soldSupply.sub(amount);\n', '        sellSupply = sellSupply.add(amount);\n', '\n', '        Transfer(msg.sender, owner, amount);\n', '\n', '        msg.sender.transfer(ethAmount); \n', '    }\n', '\n', '    function setCrowdsaleStartTime(uint256 _crowdsaleStartTime) onlyOwner public {\n', '        crowdsaleStartTime = _crowdsaleStartTime;\n', '    }\n', '\n', '    function setCrowdsaleEndTime(uint256 _crowdsaleEndTime) onlyOwner public {\n', '        crowdsaleEndTime = _crowdsaleEndTime;\n', '    }\n', '   \n', '\n', '    function setCrowdsaleTotal(uint256 _crowdsaleTotal) onlyOwner public {\n', '        crowdsaleTotal = _crowdsaleTotal;\n', '    }\n', '\n', '    /***************************************************/\n', '    /*              Lock Functions                     */\n', '    /***************************************************/\n', '    function transferLockAmount(address _to, uint256 _value) public{\n', '        // require(_value >= _value, "Not enough MSCE");\n', '        require(balances[msg.sender] >= _value, "Not enough MSCE");\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        lockAmount[_to] = lockAmount[_to].add(_value);\n', '        _resetReleaseTime(_to);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit LockAmount(msg.sender, _to, _value, uint256(now + lockTime));\n', '    }\n', '\n', '    function _resetReleaseTime(address _target) internal {\n', '        lockStartTime[_target] = uint256(now);\n', '        lockReleaseTime[_target] = uint256(now + lockTime);\n', '    }\n', '\n', '    function releasedAmount(address _target) public view returns (uint256) {\n', '        if(now >= lockReleaseTime[_target]){\n', '            return lockAmount[_target];\n', '        }\n', '        else{\n', '            return (now - lockStartTime[_target]).div(unitTime).mul(lockAmount[_target]).div(100);\n', '        }\n', '    }\n', '    \n', '}\n', '\n', '\n', 'contract MSCEVote is MSCE {\n', '    //Vote Setting\n', '    uint256 votingRight = 10000;\n', '    uint256 dealTime = 3 days;\n', '    \n', '     \n', '    struct Vote{\n', '        bool isActivated;\n', '        bytes32 name;\n', '        address target;\n', '        address spender;\n', '        uint256 targetAmount;\n', '        bool freeze;\n', '        string newName;\n', '        string newSymbol;\n', '        uint256 agreeSupply;\n', '        uint256 disagreeSupply;\n', '        uint256 startTime;\n', '        uint256 endTime;\n', '        uint256 releaseTime;\n', '    }\n', ' \n', '    Vote[] public votes;\n', '\n', '    mapping (uint256 => address) public voteToOwner;\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event NewVote(address _initiator, bytes32 name, address target, uint256 targetAmount);\n', '\n', '    modifier onlySuperNode() {\n', '        require(balances[msg.sender] >= 5000000*(10**18), "Just for SuperNodes");\n', '        _;\n', '    }\n', '\n', '    modifier onlyVotingRight() {\n', '        require(balances[msg.sender] >= votingRight*(10**18), "You haven&#39;t voting right.");\n', '        _;\n', '    }    \n', '\n', '    function createVote(bytes32 _name, address _target, address _spender,uint256 _targetAmount, bool _freeze, string _newName, string _newSymbol, uint256 _releaseTime) onlySuperNode public {\n', '        uint256 id = votes.push(Vote(true, _name,  _target, _spender,_targetAmount, _freeze, _newName, _newSymbol, 0, 0, uint256(now), uint256(now + dealTime), _releaseTime)) - 1;\n', '        voteToOwner[id] = msg.sender;\n', '        emit NewVote(msg.sender, _name, _target, _targetAmount);\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlySuperNode public {\n', '        createVote("MINT", target, target, mintedAmount, false, "", "", 0);\n', '    }\n', '\n', '    function destroyToken(address target, uint256 amount) onlySuperNode public {\n', '        createVote("DESTROY", target, target, amount, false, "", "", 0);\n', '    }\n', '\n', '    function freezeAccount(address _target, bool freeze) onlySuperNode public {\n', '        createVote("FREEZE", _target, _target, 0, freeze, "", "", 0);\n', '    }\n', '\n', '    function lockInternalAccount(address _target, bool _lock, uint256 _releaseTime) onlySuperNode public {\n', '        require(_target != address(0));\n', '        createVote("LOCK", _target, _target, 0, _lock, "", "", _releaseTime);\n', '    }\n', '\n', '    function setName(string _name) onlySuperNode public {\n', '        createVote("CHANGENAME", msg.sender, msg.sender, 0, false, _name, "", 0);\n', '        \n', '    }\n', '\n', '    function setSymbol(string _symbol) onlySuperNode public {\n', '        createVote("CHANGESYMBOL", msg.sender, msg.sender, 0, false, "", _symbol, 0);\n', '    }\n', '\n', '    function transferFromAdmin(address _from, address _to, uint256 _value) onlySuperNode public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        createVote("TRANS",_from, _to, _value, false, "", "", 0);\n', '        return true;\n', '    }\n', '\n', '    /***************************************************/\n', '    /*              Vote Functions                     */\n', '    /***************************************************/\n', '    function getVote(uint _id) \n', '        public \n', '        view \n', '        returns (bool, bytes32, address, address, uint256, bool, string, string, uint256, uint256, uint256, uint256){\n', '        Vote storage _vote = votes[_id];\n', '        return(\n', '            _vote.isActivated,\n', '            _vote.name,\n', '            _vote.target,\n', '            _vote.spender,\n', '            _vote.targetAmount,\n', '            _vote.freeze,\n', '            _vote.newName,\n', '            _vote.newSymbol,\n', '            _vote.agreeSupply,\n', '            _vote.disagreeSupply,\n', '            _vote.startTime,\n', '            _vote.endTime\n', '        );\n', '    }\n', '\n', '    function voteXId(uint256 _id, bool _agree) onlyVotingRight public{\n', '        Vote storage vote = votes[_id];\n', '        uint256 rate = 100;\n', '        if(vote.name == "FREEZE")\n', '        {\n', '            rate = 30;\n', '        }else if(vote.name == "DESTROY")\n', '        {\n', '            rate = 51;\n', '        }\n', '        else{\n', '            rate = 80;\n', '        }\n', '        if(now > vote.endTime){\n', '            vote.isActivated = false;\n', '            votes[_id] = vote;\n', '        }\n', '        require(vote.isActivated == true, "The vote ended");\n', '        if(_agree == true){\n', '            vote.agreeSupply = vote.agreeSupply.add(balances[msg.sender]);\n', '        }\n', '        else{\n', '            vote.disagreeSupply = vote.disagreeSupply.add(balances[msg.sender]);\n', '        }\n', '\n', '        if (vote.agreeSupply >= soldSupply * (rate/100)){\n', '            executeVote(_id);\n', '        }else if (vote.disagreeSupply >= soldSupply * ((100-rate)/100)) {\n', '            vote.isActivated = false;\n', '            votes[_id] = vote;\n', '        }\n', '\n', '    }\n', '\n', '    function executeVote(uint256 _id)private{\n', '        Vote storage vote = votes[_id];\n', '        vote.isActivated = false;\n', '\n', '        if(vote.name == "MINT"){\n', '            balances[vote.target] = balances[vote.target].add(vote.targetAmount);\n', '            totalSupply = totalSupply.add(vote.targetAmount);\n', '            emit Transfer(0, this, vote.targetAmount);\n', '            emit Transfer(this, vote.target, vote.targetAmount);\n', '        }else if(vote.name == "DESTROY"){\n', '            balances[vote.target] = balances[vote.target].sub(vote.targetAmount);\n', '            totalSupply = totalSupply.sub(vote.targetAmount);\n', '            emit Transfer(vote.target, this, vote.targetAmount);\n', '            emit Transfer(this, 0, vote.targetAmount);\n', '        }else if(vote.name == "CHANGENAME"){\n', '            name = vote.newName;\n', '        }else if(vote.name == "CHANGESYMBOL"){\n', '            symbol = vote.newSymbol;\n', '        }else if(vote.name == "FREEZE"){\n', '            frozenAccount[vote.target] = vote.freeze;\n', '            emit FrozenFunds(vote.target, vote.freeze);\n', '        }else if(vote.name == "LOCK"){\n', '            internalLockAccount[vote.target] = vote.freeze;\n', '            releaseLockAccount[vote.target] = vote.endTime;\n', '        }\n', '        else if(vote.name == "TRANS"){\n', '            balances[vote.target] = balances[vote.target].sub(vote.targetAmount);\n', '            balances[vote.spender] = balances[vote.spender].add(vote.targetAmount);\n', '            emit Transfer(vote.target, vote.spender, vote.targetAmount);\n', '        }\n', '        votes[_id] = vote;\n', '    }\n', '\n', '    \n', '}']