['pragma solidity ^0.4.18;\n', '\n', 'contract TBsell{\n', '    TBCoin TBSC =TBCoin(0x6158e3F89b4398f5fb20D20DbFc5a5c955F0F6dd);\n', '    address public wallet = 0x61C8C6d0119Cdc3fFFB4E49ebf0899887e49761D;\n', '    address public TBowner;\n', '    uint public TBrate = 1200;\n', '    function TBsell() public{\n', '        TBowner = msg.sender;\n', '    }\n', '    function () public payable{\n', '        require(TBSC.balanceOf(this) >= msg.value*TBrate);\n', '        TBSC.transfer(msg.sender,msg.value*TBrate);\n', '        wallet.transfer(msg.value);\n', '    }\n', '    function getbackTB(uint amount) public{\n', '        assert(msg.sender == TBowner);\n', '        TBSC.transfer(TBowner,amount);\n', '    }\n', '    function changeTBrate(uint rate) public{\n', '        assert(msg.sender == TBowner);\n', '        TBrate = rate;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', '    * @dev Math operations with safety checks that throw on error\n', '       */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', '    * @dev The Ownable contract has an owner address, and provides basic authorization control \n', '       * functions, this simplifies the implementation of "user permissions". \n', '          */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '        * account.\n', '             */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '        */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '        * @param newOwner The address to transfer ownership to. \n', '             */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', '    *\n', '      * @dev Implementation of the basic standard token.\n', '         * @dev https://github.com/ethereum/EIPs/issues/20\n', '            * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '               */\n', 'contract StandardToken {\n', '  using SafeMath for uint256;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  mapping(address => uint256) balances;\n', '  mapping(address => bool) preICO_address;\n', '  uint256 public totalSupply;\n', '  uint256 public endDate;\n', '  /**\n', '  * @dev transfer token for a specified address\n', '      * @param _to The address to transfer to.\n', '          * @param _value The amount to be transferred.\n', '              */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '\n', '    if( preICO_address[msg.sender] ) require( now > endDate + 120 days ); //Lock coin\n', '    else require( now > endDate ); //Lock coin\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '      * @param _owner The address to query the the balance of. \n', '          * @return An uint256 representing the amount owned by the passed address.\n', '              */\n', '  function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '        * @param _from address The address which you want to send tokens from\n', '             * @param _to address The address which you want to transfer to\n', '                  * @param _value uint256 the amout of tokens to be transfered\n', '                       */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    if( preICO_address[_from] ) require( now > endDate + 120 days ); //Lock coin\n', '    else require( now > endDate ); //Lock coin\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '        * @param _spender The address which will spend the funds.\n', '             * @param _value The amount of tokens to be spent.\n', '                  */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    if( preICO_address[msg.sender] ) require( now > endDate + 120 days ); //Lock coin\n', '    else require( now > endDate ); //Lock coin\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '        * @param _owner address The address which owns the funds.\n', '             * @param _spender address The address which will spend the funds.\n', '                  * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '                       */\n', '  function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract TBCoin is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // Token Info.\n', '    string  public constant name = "TimeBox Coin";\n', '    string  public constant symbol = "TB";\n', '    uint8   public constant decimals = 18;\n', '\n', '    // Sale period.\n', '    uint256 public startDate;\n', '    // uint256 public endDate;\n', '\n', '    // Token Cap for each rounds\n', '    uint256 public saleCap;\n', '\n', '    // Address where funds are collected.\n', '    address public wallet;\n', '\n', '    // Amount of raised money in wei.\n', '    uint256 public weiRaised;\n', '\n', '    // Event\n', '    event TokenPurchase(address indexed purchaser, uint256 value,\n', '                        uint256 amount);\n', '    event PreICOTokenPushed(address indexed buyer, uint256 amount);\n', '\n', '    // Modifiers\n', '    modifier uninitialized() {\n', '        require(wallet == 0x0);\n', '        _;\n', '    }\n', '\n', '    function TBCoin() public{\n', '    }\n', '// \n', '    function initialize(address _wallet, uint256 _start, uint256 _end,\n', '                        uint256 _saleCap, uint256 _totalSupply)\n', '                        public onlyOwner uninitialized {\n', '        require(_start >= getCurrentTimestamp());\n', '        require(_start < _end);\n', '        require(_wallet != 0x0);\n', '        require(_totalSupply > _saleCap);\n', '\n', '        startDate = _start;\n', '        endDate = _end;\n', '        saleCap = _saleCap;\n', '        wallet = _wallet;\n', '        totalSupply = _totalSupply;\n', '\n', '        balances[wallet] = _totalSupply.sub(saleCap);\n', '        balances[0xb1] = saleCap;\n', '    }\n', '\n', '    function supply() internal view returns (uint256) {\n', '        return balances[0xb1];\n', '    }\n', '\n', '    function getCurrentTimestamp() internal view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '    function getRateAt(uint256 at) public constant returns (uint256) {\n', '        if (at < startDate) {\n', '            return 0;\n', '        } else if (at < (startDate + 3 days)) {\n', '            return 1500;\n', '        } else if (at < (startDate + 9 days)) {\n', '            return 1440;\n', '        } else if (at < (startDate + 15 days)) {\n', '            return 1380;\n', '        } else if (at < (startDate + 21 days)) {\n', '            return 1320;\n', '        } else if (at < (startDate + 27 days)) {\n', '            return 1260;\n', '        } else if (at <= endDate) {\n', '            return 1200;\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    // Fallback function can be used to buy tokens\n', '    function () public payable {\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    // For pushing pre-ICO records\n', '    function push(address buyer, uint256 amount) public onlyOwner { //b753a98c\n', '        require(balances[wallet] >= amount);\n', '        require(now < startDate);\n', '        require(buyer != wallet);\n', '\n', '        preICO_address[ buyer ] = true;\n', '\n', '        // Transfer\n', '        balances[wallet] = balances[wallet].sub(amount);\n', '        balances[buyer] = balances[buyer].add(amount);\n', '        PreICOTokenPushed(buyer, amount);\n', '    }\n', '\n', '    function buyTokens(address sender, uint256 value) internal {\n', '        require(saleActive());\n', '\n', '        uint256 weiAmount = value;\n', '        uint256 updatedWeiRaised = weiRaised.add(weiAmount);\n', '\n', '        // Calculate token amount to be purchased\n', '        uint256 actualRate = getRateAt(getCurrentTimestamp());\n', '        uint256 amount = weiAmount.mul(actualRate);\n', '\n', '        // We have enough token to sale\n', '        require(supply() >= amount);\n', '\n', '        // Transfer\n', '        balances[0xb1] = balances[0xb1].sub(amount);\n', '        balances[sender] = balances[sender].add(amount);\n', '        TokenPurchase(sender, weiAmount, amount);\n', '\n', '        // Update state.\n', '        weiRaised = updatedWeiRaised;\n', '\n', '        // Forward the fund to fund collection wallet.\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '    function finalize() public onlyOwner {\n', '        require(!saleActive());\n', '\n', '        // Transfer the rest of token to TB team\n', '        balances[wallet] = balances[wallet].add(balances[0xb1]);\n', '        balances[0xb1] = 0;\n', '    }\n', '\n', '    function saleActive() public constant returns (bool) {\n', '        return (getCurrentTimestamp() >= startDate &&\n', '                getCurrentTimestamp() < endDate && supply() > 0);\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract TBsell{\n', '    TBCoin TBSC =TBCoin(0x6158e3F89b4398f5fb20D20DbFc5a5c955F0F6dd);\n', '    address public wallet = 0x61C8C6d0119Cdc3fFFB4E49ebf0899887e49761D;\n', '    address public TBowner;\n', '    uint public TBrate = 1200;\n', '    function TBsell() public{\n', '        TBowner = msg.sender;\n', '    }\n', '    function () public payable{\n', '        require(TBSC.balanceOf(this) >= msg.value*TBrate);\n', '        TBSC.transfer(msg.sender,msg.value*TBrate);\n', '        wallet.transfer(msg.value);\n', '    }\n', '    function getbackTB(uint amount) public{\n', '        assert(msg.sender == TBowner);\n', '        TBSC.transfer(TBowner,amount);\n', '    }\n', '    function changeTBrate(uint rate) public{\n', '        assert(msg.sender == TBowner);\n', '        TBrate = rate;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', '    * @dev Math operations with safety checks that throw on error\n', '       */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', '    * @dev The Ownable contract has an owner address, and provides basic authorization control \n', '       * functions, this simplifies the implementation of "user permissions". \n', '          */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '        * account.\n', '             */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '        */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '        * @param newOwner The address to transfer ownership to. \n', '             */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', '    *\n', '      * @dev Implementation of the basic standard token.\n', '         * @dev https://github.com/ethereum/EIPs/issues/20\n', '            * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '               */\n', 'contract StandardToken {\n', '  using SafeMath for uint256;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  mapping(address => uint256) balances;\n', '  mapping(address => bool) preICO_address;\n', '  uint256 public totalSupply;\n', '  uint256 public endDate;\n', '  /**\n', '  * @dev transfer token for a specified address\n', '      * @param _to The address to transfer to.\n', '          * @param _value The amount to be transferred.\n', '              */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '\n', '    if( preICO_address[msg.sender] ) require( now > endDate + 120 days ); //Lock coin\n', '    else require( now > endDate ); //Lock coin\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '      * @param _owner The address to query the the balance of. \n', '          * @return An uint256 representing the amount owned by the passed address.\n', '              */\n', '  function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '        * @param _from address The address which you want to send tokens from\n', '             * @param _to address The address which you want to transfer to\n', '                  * @param _value uint256 the amout of tokens to be transfered\n', '                       */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    if( preICO_address[_from] ) require( now > endDate + 120 days ); //Lock coin\n', '    else require( now > endDate ); //Lock coin\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '        * @param _spender The address which will spend the funds.\n', '             * @param _value The amount of tokens to be spent.\n', '                  */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    if( preICO_address[msg.sender] ) require( now > endDate + 120 days ); //Lock coin\n', '    else require( now > endDate ); //Lock coin\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '        * @param _owner address The address which owns the funds.\n', '             * @param _spender address The address which will spend the funds.\n', '                  * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '                       */\n', '  function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract TBCoin is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // Token Info.\n', '    string  public constant name = "TimeBox Coin";\n', '    string  public constant symbol = "TB";\n', '    uint8   public constant decimals = 18;\n', '\n', '    // Sale period.\n', '    uint256 public startDate;\n', '    // uint256 public endDate;\n', '\n', '    // Token Cap for each rounds\n', '    uint256 public saleCap;\n', '\n', '    // Address where funds are collected.\n', '    address public wallet;\n', '\n', '    // Amount of raised money in wei.\n', '    uint256 public weiRaised;\n', '\n', '    // Event\n', '    event TokenPurchase(address indexed purchaser, uint256 value,\n', '                        uint256 amount);\n', '    event PreICOTokenPushed(address indexed buyer, uint256 amount);\n', '\n', '    // Modifiers\n', '    modifier uninitialized() {\n', '        require(wallet == 0x0);\n', '        _;\n', '    }\n', '\n', '    function TBCoin() public{\n', '    }\n', '// \n', '    function initialize(address _wallet, uint256 _start, uint256 _end,\n', '                        uint256 _saleCap, uint256 _totalSupply)\n', '                        public onlyOwner uninitialized {\n', '        require(_start >= getCurrentTimestamp());\n', '        require(_start < _end);\n', '        require(_wallet != 0x0);\n', '        require(_totalSupply > _saleCap);\n', '\n', '        startDate = _start;\n', '        endDate = _end;\n', '        saleCap = _saleCap;\n', '        wallet = _wallet;\n', '        totalSupply = _totalSupply;\n', '\n', '        balances[wallet] = _totalSupply.sub(saleCap);\n', '        balances[0xb1] = saleCap;\n', '    }\n', '\n', '    function supply() internal view returns (uint256) {\n', '        return balances[0xb1];\n', '    }\n', '\n', '    function getCurrentTimestamp() internal view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '    function getRateAt(uint256 at) public constant returns (uint256) {\n', '        if (at < startDate) {\n', '            return 0;\n', '        } else if (at < (startDate + 3 days)) {\n', '            return 1500;\n', '        } else if (at < (startDate + 9 days)) {\n', '            return 1440;\n', '        } else if (at < (startDate + 15 days)) {\n', '            return 1380;\n', '        } else if (at < (startDate + 21 days)) {\n', '            return 1320;\n', '        } else if (at < (startDate + 27 days)) {\n', '            return 1260;\n', '        } else if (at <= endDate) {\n', '            return 1200;\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    // Fallback function can be used to buy tokens\n', '    function () public payable {\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    // For pushing pre-ICO records\n', '    function push(address buyer, uint256 amount) public onlyOwner { //b753a98c\n', '        require(balances[wallet] >= amount);\n', '        require(now < startDate);\n', '        require(buyer != wallet);\n', '\n', '        preICO_address[ buyer ] = true;\n', '\n', '        // Transfer\n', '        balances[wallet] = balances[wallet].sub(amount);\n', '        balances[buyer] = balances[buyer].add(amount);\n', '        PreICOTokenPushed(buyer, amount);\n', '    }\n', '\n', '    function buyTokens(address sender, uint256 value) internal {\n', '        require(saleActive());\n', '\n', '        uint256 weiAmount = value;\n', '        uint256 updatedWeiRaised = weiRaised.add(weiAmount);\n', '\n', '        // Calculate token amount to be purchased\n', '        uint256 actualRate = getRateAt(getCurrentTimestamp());\n', '        uint256 amount = weiAmount.mul(actualRate);\n', '\n', '        // We have enough token to sale\n', '        require(supply() >= amount);\n', '\n', '        // Transfer\n', '        balances[0xb1] = balances[0xb1].sub(amount);\n', '        balances[sender] = balances[sender].add(amount);\n', '        TokenPurchase(sender, weiAmount, amount);\n', '\n', '        // Update state.\n', '        weiRaised = updatedWeiRaised;\n', '\n', '        // Forward the fund to fund collection wallet.\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '    function finalize() public onlyOwner {\n', '        require(!saleActive());\n', '\n', '        // Transfer the rest of token to TB team\n', '        balances[wallet] = balances[wallet].add(balances[0xb1]);\n', '        balances[0xb1] = 0;\n', '    }\n', '\n', '    function saleActive() public constant returns (bool) {\n', '        return (getCurrentTimestamp() >= startDate &&\n', '                getCurrentTimestamp() < endDate && supply() > 0);\n', '    }\n', '    \n', '}']
