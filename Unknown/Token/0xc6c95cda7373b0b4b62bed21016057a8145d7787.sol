['/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue)\n', '    returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue)\n', '    returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '// This is just a contract of a BIX Token.\n', '// It is a ERC20 token\n', 'contract BIXToken is StandardToken, Ownable{\n', '    \n', '    string public version = "1.0";\n', '    string public name = "BIX Token";\n', '    string public symbol = "BIX";\n', '    uint8 public  decimals = 18;\n', '\n', '    mapping(address=>uint256)  lockedBalance;\n', '    mapping(address=>uint)     timeRelease; \n', '    \n', '    uint256 internal constant INITIAL_SUPPLY = 500 * (10**6) * (10 **18);\n', '    uint256 internal constant DEVELOPER_RESERVED = 175 * (10**6) * (10**18);\n', '\n', '    //address public developer;\n', '    //uint256 internal crowdsaleAvaible;\n', '\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '    event Lock(address indexed locker, uint256 value, uint releaseTime);\n', '    event UnLock(address indexed unlocker, uint256 value);\n', '    \n', '\n', '    // constructor\n', '    function BIXToken(address _developer) { \n', '        balances[_developer] = DEVELOPER_RESERVED;\n', '        totalSupply = DEVELOPER_RESERVED;\n', '    }\n', '\n', '    //balance of locked\n', '    function lockedOf(address _owner) public constant returns (uint256 balance) {\n', '        return lockedBalance[_owner];\n', '    }\n', '\n', '    //release time of locked\n', '    function unlockTimeOf(address _owner) public constant returns (uint timelimit) {\n', '        return timeRelease[_owner];\n', '    }\n', '\n', '\n', '    // transfer to and lock it\n', '    function transferAndLock(address _to, uint256 _value, uint _releaseTime) public returns (bool success) {\n', '        require(_to != 0x0);\n', '        require(_value <= balances[msg.sender]);\n', '        require(_value > 0);\n', '        require(_releaseTime > now && _releaseTime <= now + 60*60*24*365*5);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '       \n', '        //if preLock can release \n', '        uint preRelease = timeRelease[_to];\n', '        if (preRelease <= now && preRelease != 0x0) {\n', '            balances[_to] = balances[_to].add(lockedBalance[_to]);\n', '            lockedBalance[_to] = 0;\n', '        }\n', '\n', '        lockedBalance[_to] = lockedBalance[_to].add(_value);\n', '        timeRelease[_to] =  _releaseTime >= timeRelease[_to] ? _releaseTime : timeRelease[_to]; \n', '        Transfer(msg.sender, _to, _value);\n', '        Lock(_to, _value, _releaseTime);\n', '        return true;\n', '    }\n', '\n', '\n', '   /**\n', '   * @notice Transfers tokens held by lock.\n', '   */\n', '   function unlock() public constant returns (bool success){\n', '        uint256 amount = lockedBalance[msg.sender];\n', '        require(amount > 0);\n', '        require(now >= timeRelease[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '        lockedBalance[msg.sender] = 0;\n', '        timeRelease[msg.sender] = 0;\n', '\n', '        Transfer(0x0, msg.sender, amount);\n', '        UnLock(msg.sender, amount);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '    \n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '        return true;\n', '    }\n', '\n', '    // \n', '    function isSoleout() public constant returns (bool) {\n', '        return (totalSupply >= INITIAL_SUPPLY);\n', '    }\n', '\n', '\n', '    modifier canMint() {\n', '        require(!isSoleout());\n', '        _;\n', '    } \n', '    \n', '    /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '    function mintBIX(address _to, uint256 _amount, uint256 _lockAmount, uint _releaseTime) onlyOwner canMint public returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        if (_lockAmount > 0) {\n', '            totalSupply = totalSupply.add(_lockAmount);\n', '            lockedBalance[_to] = lockedBalance[_to].add(_lockAmount);\n', '            timeRelease[_to] =  _releaseTime >= timeRelease[_to] ? _releaseTime : timeRelease[_to];            \n', '            Lock(_to, _lockAmount, _releaseTime);\n', '        }\n', '\n', '        Transfer(0x0, _to, _amount);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '// Contract for BIX Token sale\n', 'contract BIXCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '      // The token being sold\n', '      BIXToken public bixToken;\n', '      \n', '      address public owner;\n', '\n', '      // start and end timestamps where investments are allowed (both inclusive)\n', '      uint256 public startTime;\n', '      uint256 public endTime;\n', '      \n', '\n', '      uint256 internal constant baseExchangeRate =  1800 ;       //1800 BIX tokens per 1 ETH\n', '      uint256 internal constant earlyExchangeRate = 2000 ;\n', '      uint256 internal constant vipExchangeRate =   2400 ;\n', '      uint256 internal constant vcExchangeRate  =   2500 ;\n', '      uint8  internal constant  DaysForEarlyDay = 11;\n', '      uint256  internal constant vipThrehold = 1000 * (10**18);\n', '            \n', '\n', '      //\n', '      event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '      // amount of eth crowded in wei\n', '      uint256 public weiCrowded;\n', '\n', '\n', '      //constructor\n', '      function BIXCrowdsale(uint256 _startTime, uint256 _endTime, address _wallet) {\n', '            require(_startTime >= now);\n', '            require(_endTime >= _startTime);\n', '            require(_wallet != 0);\n', '\n', '            owner = _wallet;\n', '            bixToken = new BIXToken(owner);\n', '            \n', '\n', '            startTime = _startTime;\n', '            endTime = _endTime;\n', '      }\n', '\n', '      // fallback function can be used to buy tokens\n', '      function () payable {\n', '          buyTokens(msg.sender);\n', '      }\n', '\n', '      // low level token purchase function\n', '      function buyTokens(address beneficiary) public payable {\n', '            require(beneficiary != 0x0);\n', '            require(validPurchase());\n', '\n', '            uint256 weiAmount = msg.value;\n', '            weiCrowded = weiCrowded.add(weiAmount);\n', '\n', '            \n', '            // calculate token amount to be created\n', '            uint256 rRate = rewardRate();\n', '            uint256 rewardBIX = weiAmount.mul(rRate);\n', '            uint256 baseBIX = weiAmount.mul(baseExchangeRate);\n', '\n', '            // let it can sale exceed the INITIAL_SUPPLY only at the first time then crowd will end\n', '             uint256 bixAmount = baseBIX.add(rewardBIX);\n', '           \n', '            // the rewardBIX lock in 3 mounthes\n', '            if(rewardBIX > (earlyExchangeRate - baseExchangeRate)) {\n', '                uint releaseTime = startTime + (60 * 60 * 24 * 30 * 3);\n', '                bixToken.mintBIX(beneficiary, baseBIX, rewardBIX, releaseTime);  \n', '            } else {\n', '                bixToken.mintBIX(beneficiary, bixAmount, 0, 0);  \n', '            }\n', '            \n', '            TokenPurchase(msg.sender, beneficiary, weiAmount, bixAmount);\n', '            forwardFunds();           \n', '      }\n', '\n', '      /**\n', '       * reward rate for purchase\n', '       */\n', '      function rewardRate() internal constant returns (uint256) {\n', '            \n', '            uint256 rate = baseExchangeRate;\n', '\n', '            if (now < startTime) {\n', '                rate = vcExchangeRate;\n', '            } else {\n', '                uint crowdIndex = (now - startTime) / (24 * 60 * 60); \n', '                if (crowdIndex < DaysForEarlyDay) {\n', '                    rate = earlyExchangeRate;\n', '                } else {\n', '                    rate = baseExchangeRate;\n', '                }\n', '\n', '                //vip\n', '                if (msg.value >= vipThrehold) {\n', '                    rate = vipExchangeRate;\n', '                }\n', '            }\n', '            return rate - baseExchangeRate;\n', '        \n', '      }\n', '\n', '\n', '\n', '      // send ether to the fund collection wallet\n', '      function forwardFunds() internal {\n', '            owner.transfer(msg.value);\n', '      }\n', '\n', '      // @return true if the transaction can buy tokens\n', '      function validPurchase() internal constant returns (bool) {\n', '            bool nonZeroPurchase = msg.value != 0;\n', '            bool noEnd = !hasEnded();\n', '            \n', '            return  nonZeroPurchase && noEnd;\n', '      }\n', '\n', '      // @return true if crowdsale event has ended\n', '      function hasEnded() public constant returns (bool) {\n', '            return (now > endTime) || bixToken.isSoleout(); \n', '      }\n', '}']