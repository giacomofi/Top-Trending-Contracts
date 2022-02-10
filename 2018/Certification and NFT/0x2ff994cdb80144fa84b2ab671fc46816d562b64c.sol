['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title SafeMath for performing valid mathematics.\n', ' */\n', 'library SafeMath {\n', ' \n', '  function Mul(uint a, uint b) internal pure returns (uint) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function Div(uint a, uint b) internal pure returns (uint) {\n', '    //assert(b > 0); // Solidity automatically throws when Dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function Sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  } \n', '\n', '  function Add(uint a, uint b) internal pure returns (uint) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  } \n', '}\n', '\n', '/**\n', '* @title Contract that will work with ERC223 tokens.\n', '*/\n', 'contract ERC223ReceivingContract { \n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '/**\n', ' * Contract "Ownable"\n', ' * Purpose: Defines Owner for contract and provide functionality to transfer ownership to another account\n', ' */\n', 'contract Ownable {\n', '\n', '  //owner variable to store contract owner account\n', '  address public owner;\n', '  //add another owner\n', '  address deployer;\n', '\n', '  //Constructor for the contract to store owner&#39;s account on deployement\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '    deployer = msg.sender;\n', '  }\n', '\n', '  //modifier to check transaction initiator is only owner\n', '  modifier onlyOwner() {\n', '    require (msg.sender == owner || msg.sender == deployer);\n', '      _;\n', '  }\n', '\n', '  //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner&#39;s account\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    require (_newOwner != address(0));\n', '    owner = _newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '  uint256 private pauseTime;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    //Record the pausing time only if any startTime is defined\n', '    //in other cases, it will work as a toggle switch only\n', '    if(startTime > 0){\n', '        pauseTime = now;\n', '    }\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    //if endTime is defined, only then proceed with its updation\n', '    if(endTime > 0 && pauseTime > startTime){\n', '        uint256 pauseDuration = pauseTime - startTime;\n', '        endTime = endTime + pauseDuration;\n', '    }\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 is Pausable {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) public view returns (uint256 value);\n', '    function transfer(address _to, uint256 _value) public returns (bool _success);\n', '    function allowance(address owner, address spender) public view returns (uint256 _value);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool _success);\n', '    function approve(address spender, uint256 value) public returns (bool _success);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '}\n', '\n', 'contract ECHO is ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '    //The name of the  token\n', '    string public constant name = "ECHO token";\n', '    //The token symbol\n', '    string public constant symbol = "ECHO";\n', '    //To denote the locking on transfer of tokens among token holders\n', '    bool public locked;\n', '    //The precision used in the calculations in contract\n', '    uint8 public constant decimals = 18;\n', '    //number of tokens available for 1 eth\n', '    uint256 public constant PRICE=4000;\n', '    //maximum number of tokens\n', '    uint256 constant MAXCAP = 322500000e18;\n', '    //maximum number of tokens available for Sale\n', '    uint256 constant HARD_CAP = 8e7*1e18;\n', '    //the account which will receive all balance\n', '    address ethCollector;\n', '    //to save total number of ethers received\n', '    uint256 public totalWeiReceived;\n', '    //type of sale: 1=presale, 2=ICO\n', '    uint256 public saleType;\n', '    \n', '\n', '    //Mapping to relate owner and spender to the tokens allowed to transfer from owner\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    //Mapping to relate number of token to the account\n', '    mapping(address => uint256) balances;\n', '    \n', '    function isSaleRunning() public view returns (bool){\n', '        bool status = false;\n', '        // 1522972800 = 6 april 2018\n', '        // 1525392000 = 4 may 2018\n', '        // 1527811200 = 1 june 2018\n', '        // 1531094400 = 9 july 2018\n', '        \n', '        //Presale is going on\n', '        if(now >= startTime  && now <= 1525392000){\n', '            //Aprill 6 to before 4 may\n', '            status = true;\n', '        }\n', '    \n', '        //ICO is going on\n', '        if(now >= 1527811200 && now <= endTime){\n', '            // june 1 to before july 9\n', '            status = true;\n', '        }\n', '        return status;\n', '    }\n', '\n', '    function countDownToEndCrowdsale() public view returns(uint256){\n', '        assert(isSaleRunning());\n', '        return endTime.Sub(now);\n', '    }\n', '    //events\n', '    event StateChanged(bool);\n', '\n', '    function ECHO() public{\n', '        totalSupply = 0;\n', '        startTime = 1522972800; //April 6, 2018 GMT\n', '        endTime = 1531094400; //9 july, 2018 GMT\n', '        locked = true;\n', '        setEthCollector(0xc8522E0444a94Ec9a5A08242765e1196DF1EC6B5);\n', '    }\n', '    //To handle ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    modifier onlyUnlocked() { \n', '        require (!locked); \n', '        _; \n', '    }\n', '\n', '    modifier validTimeframe(){\n', '        require(isSaleRunning());\n', '        _;\n', '    }\n', '    \n', '    function setEthCollector(address _ethCollector) public onlyOwner{\n', '        require(_ethCollector != address(0));\n', '        ethCollector = _ethCollector;\n', '    }\n', '\n', '    //To enable transfer of tokens\n', '    function unlockTransfer() external onlyOwner{\n', '        locked = false;\n', '    }\n', '\n', '    /**\n', '    * @dev Check if the address being passed belongs to a contract\n', '    *\n', '    * @param _address The address which you want to verify\n', '    * @return A bool specifying if the address is that of contract or not\n', '    */\n', '    function isContract(address _address) private view returns(bool _isContract){\n', '        assert(_address != address(0) );\n', '        uint length;\n', '        //inline assembly code to check the length of address\n', '        assembly{\n', '            length := extcodesize(_address)\n', '        }\n', '        if(length > 0){\n', '            return true;\n', '        }\n', '        else{\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Check balance of given account address\n', '    *\n', '    * @param _owner The address account whose balance you want to know\n', '    * @return balance of the account\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 _value){\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer sender&#39;s token to a given address\n', '    *\n', '    * @param _to The address which you want to transfer to\n', '    * @param _value the amount of tokens to be transferred\n', '    * @return A bool if the transfer was a success or not\n', '    */\n', '    function transfer(address _to, uint _value) onlyUnlocked onlyPayloadSize(2 * 32) public returns(bool _success) {\n', '        require( _to != address(0) );\n', '        bytes memory _empty;\n', '        assert((balances[msg.sender] >= _value) && _value > 0 && _to != address(0));\n', '        balances[msg.sender] = balances[msg.sender].Sub(_value);\n', '        balances[_to] = balances[_to].Add(_value);\n', '        if(isContract(_to)){\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _empty);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens to an address given by sender. To make ERC223 compliant\n', '    *\n', '    * @param _to The address which you want to transfer to\n', '    * @param _value the amount of tokens to be transferred\n', '    * @param _data additional information of account from where to transfer from\n', '    * @return A bool if the transfer was a success or not\n', '    */\n', '    function transfer(address _to, uint _value, bytes _data) onlyUnlocked onlyPayloadSize(3 * 32) public returns(bool _success) {\n', '        assert((balances[msg.sender] >= _value) && _value > 0 && _to != address(0));\n', '        balances[msg.sender] = balances[msg.sender].Sub(_value);\n', '        balances[_to] = balances[_to].Add(_value);\n', '        if(isContract(_to)){\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '        \n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another, for ERC20.\n', '    *\n', '    * @param _from The address which you want to send tokens from\n', '    * @param _to The address which you want to transfer to\n', '    * @param _value the amount of tokens to be transferred\n', '    * @return A bool if the transfer was a success or not \n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3*32) public onlyUnlocked returns (bool){\n', '        bytes memory _empty;\n', '        assert((_value > 0)\n', '           && (_to != address(0))\n', '           && (_from != address(0))\n', '           && (allowed[_from][msg.sender] >= _value ));\n', '       balances[_from] = balances[_from].Sub(_value);\n', '       balances[_to] = balances[_to].Add(_value);\n', '       allowed[_from][msg.sender] = allowed[_from][msg.sender].Sub(_value);\n', '       if(isContract(_to)){\n', '           ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '           receiver.tokenFallback(msg.sender, _value, _empty);\n', '       }\n', '       emit Transfer(_from, _to, _value);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner has allowed a spender to recieve from owner.\n', '    *\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender to spend.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256){\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool){\n', '        if( _value > 0 && (balances[msg.sender] >= _value)){\n', '            allowed[msg.sender][_spender] = _value;\n', '            emit Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        }\n', '        else{\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function mintAndTransfer(address beneficiary, uint256 tokensToBeTransferred) public validTimeframe onlyOwner {\n', '        require(totalSupply.Add(tokensToBeTransferred) <= MAXCAP);\n', '        totalSupply = totalSupply.Add(tokensToBeTransferred);\n', '        balances[beneficiary] = balances[beneficiary].Add(tokensToBeTransferred);\n', '        emit Transfer(0x0, beneficiary ,tokensToBeTransferred);\n', '    }\n', '\n', '    function getBonus(uint256 _tokensBought)public view returns(uint256){\n', '        uint256 bonus = 0;\n', '        /*April 6- April 13 -- 20% \n', '        April 14- April 21 -- 10% \n', '        April 22 - May 3-- 5% \n', '        \n', '        ICO BONUS WEEKS: \n', '        June 1 - June 9 -- 20% \n', '        June 10 - June 17 -- 10% \n', '        June 18 - June 30 -- 5% \n', '        July 1 - July 9 -- No bonus \n', '        */\n', '        // 1522972800 = 6 april 2018\n', '        // 1523577600 = 13 April 2018\n', '        // 1523664000 = 14 April 2018\n', '        // 1524268800 = 21 April 2018\n', '        // 1524355200 = 22 April 2018\n', '        // 1525305600 = 3 April 2018\n', '        // 1525392000 = 4 may 2018\n', '        // 1527811200 = 1 june 2018\n', '        // 1528502400 = 9 june 2018\n', '        // 1528588800 = 10 june 2018\n', '        // 1529193600 = 17 june 2018\n', '        // 1529280000 = 18 june 2018\n', '        // 1530316800 = 30 june 2018\n', '        // 1530403200 = 1 july 2018\n', '        // 1531094400 = 9 july 2018\n', '        if(saleType == 1){\n', '            //Presale is going on\n', '            if(now >= 1522972800 && now < 1523664000){\n', '                //6 april to before 14 april\n', '                bonus = _tokensBought*20/100;\n', '            }\n', '            else if(now >= 1523664000 && now < 1524355200){\n', '                //14 april to before 22 april\n', '                bonus = _tokensBought*10/100;\n', '            }\n', '            else if(now >= 1524355200 && now < 1525392000){\n', '                //Aprill 22 to before 4 may\n', '                bonus = _tokensBought*5/100;\n', '            }\n', '        }\n', '        if(saleType == 2){\n', '            //ICO is going on\n', '            if(now >= 1527811200 && now < 1528588800){\n', '                // 1 june to before 10 june\n', '                bonus = _tokensBought*20/100;\n', '            }\n', '            else if(now >= 1528588800 && now < 1529280000){\n', '                // june 10 to before june 18\n', '                bonus = _tokensBought*10/100;\n', '            }\n', '            else if(now >= 1529280000 && now < 1530403200){\n', '                // june 18 to before july 1\n', '                bonus = _tokensBought*5/100;\n', '            }\n', '        }\n', '        return bonus;\n', '    }\n', '    function buyTokens(address beneficiary) internal validTimeframe {\n', '        uint256 tokensBought = msg.value.Mul(PRICE);\n', '        tokensBought = tokensBought.Add(getBonus(tokensBought));\n', '        balances[beneficiary] = balances[beneficiary].Add(tokensBought);\n', '        totalSupply = totalSupply.Add(tokensBought);\n', '       \n', '        assert(totalSupply <= HARD_CAP);\n', '        totalWeiReceived = totalWeiReceived.Add(msg.value);\n', '        ethCollector.transfer(msg.value);\n', '        emit Transfer(0x0, beneficiary, tokensBought);\n', '    }\n', '\n', '    /**\n', '    * Finalize the crowdsale\n', '    */\n', '    function finalize() public onlyUnlocked onlyOwner {\n', '        //Make sure Sale is not running\n', '        //If sale is running, then check if the hard cap has been reached or not\n', '        assert(!isSaleRunning() || (HARD_CAP.Sub(totalSupply)) <= 1e18);\n', '        endTime = now;\n', '\n', '        //enable transferring of tokens among token holders\n', '        locked = false;\n', '        //Emit event when crowdsale state changes\n', '        emit StateChanged(true);\n', '    }\n', '\n', '    function () public payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '    * Failsafe drain\n', '    */\n', '    function drain() public onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title SafeMath for performing valid mathematics.\n', ' */\n', 'library SafeMath {\n', ' \n', '  function Mul(uint a, uint b) internal pure returns (uint) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function Div(uint a, uint b) internal pure returns (uint) {\n', '    //assert(b > 0); // Solidity automatically throws when Dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function Sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  } \n', '\n', '  function Add(uint a, uint b) internal pure returns (uint) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  } \n', '}\n', '\n', '/**\n', '* @title Contract that will work with ERC223 tokens.\n', '*/\n', 'contract ERC223ReceivingContract { \n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '/**\n', ' * Contract "Ownable"\n', ' * Purpose: Defines Owner for contract and provide functionality to transfer ownership to another account\n', ' */\n', 'contract Ownable {\n', '\n', '  //owner variable to store contract owner account\n', '  address public owner;\n', '  //add another owner\n', '  address deployer;\n', '\n', "  //Constructor for the contract to store owner's account on deployement\n", '  function Ownable() public {\n', '    owner = msg.sender;\n', '    deployer = msg.sender;\n', '  }\n', '\n', '  //modifier to check transaction initiator is only owner\n', '  modifier onlyOwner() {\n', '    require (msg.sender == owner || msg.sender == deployer);\n', '      _;\n', '  }\n', '\n', "  //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account\n", '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    require (_newOwner != address(0));\n', '    owner = _newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '  uint256 private pauseTime;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    //Record the pausing time only if any startTime is defined\n', '    //in other cases, it will work as a toggle switch only\n', '    if(startTime > 0){\n', '        pauseTime = now;\n', '    }\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    //if endTime is defined, only then proceed with its updation\n', '    if(endTime > 0 && pauseTime > startTime){\n', '        uint256 pauseDuration = pauseTime - startTime;\n', '        endTime = endTime + pauseDuration;\n', '    }\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 is Pausable {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) public view returns (uint256 value);\n', '    function transfer(address _to, uint256 _value) public returns (bool _success);\n', '    function allowance(address owner, address spender) public view returns (uint256 _value);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool _success);\n', '    function approve(address spender, uint256 value) public returns (bool _success);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '}\n', '\n', 'contract ECHO is ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '    //The name of the  token\n', '    string public constant name = "ECHO token";\n', '    //The token symbol\n', '    string public constant symbol = "ECHO";\n', '    //To denote the locking on transfer of tokens among token holders\n', '    bool public locked;\n', '    //The precision used in the calculations in contract\n', '    uint8 public constant decimals = 18;\n', '    //number of tokens available for 1 eth\n', '    uint256 public constant PRICE=4000;\n', '    //maximum number of tokens\n', '    uint256 constant MAXCAP = 322500000e18;\n', '    //maximum number of tokens available for Sale\n', '    uint256 constant HARD_CAP = 8e7*1e18;\n', '    //the account which will receive all balance\n', '    address ethCollector;\n', '    //to save total number of ethers received\n', '    uint256 public totalWeiReceived;\n', '    //type of sale: 1=presale, 2=ICO\n', '    uint256 public saleType;\n', '    \n', '\n', '    //Mapping to relate owner and spender to the tokens allowed to transfer from owner\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    //Mapping to relate number of token to the account\n', '    mapping(address => uint256) balances;\n', '    \n', '    function isSaleRunning() public view returns (bool){\n', '        bool status = false;\n', '        // 1522972800 = 6 april 2018\n', '        // 1525392000 = 4 may 2018\n', '        // 1527811200 = 1 june 2018\n', '        // 1531094400 = 9 july 2018\n', '        \n', '        //Presale is going on\n', '        if(now >= startTime  && now <= 1525392000){\n', '            //Aprill 6 to before 4 may\n', '            status = true;\n', '        }\n', '    \n', '        //ICO is going on\n', '        if(now >= 1527811200 && now <= endTime){\n', '            // june 1 to before july 9\n', '            status = true;\n', '        }\n', '        return status;\n', '    }\n', '\n', '    function countDownToEndCrowdsale() public view returns(uint256){\n', '        assert(isSaleRunning());\n', '        return endTime.Sub(now);\n', '    }\n', '    //events\n', '    event StateChanged(bool);\n', '\n', '    function ECHO() public{\n', '        totalSupply = 0;\n', '        startTime = 1522972800; //April 6, 2018 GMT\n', '        endTime = 1531094400; //9 july, 2018 GMT\n', '        locked = true;\n', '        setEthCollector(0xc8522E0444a94Ec9a5A08242765e1196DF1EC6B5);\n', '    }\n', '    //To handle ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    modifier onlyUnlocked() { \n', '        require (!locked); \n', '        _; \n', '    }\n', '\n', '    modifier validTimeframe(){\n', '        require(isSaleRunning());\n', '        _;\n', '    }\n', '    \n', '    function setEthCollector(address _ethCollector) public onlyOwner{\n', '        require(_ethCollector != address(0));\n', '        ethCollector = _ethCollector;\n', '    }\n', '\n', '    //To enable transfer of tokens\n', '    function unlockTransfer() external onlyOwner{\n', '        locked = false;\n', '    }\n', '\n', '    /**\n', '    * @dev Check if the address being passed belongs to a contract\n', '    *\n', '    * @param _address The address which you want to verify\n', '    * @return A bool specifying if the address is that of contract or not\n', '    */\n', '    function isContract(address _address) private view returns(bool _isContract){\n', '        assert(_address != address(0) );\n', '        uint length;\n', '        //inline assembly code to check the length of address\n', '        assembly{\n', '            length := extcodesize(_address)\n', '        }\n', '        if(length > 0){\n', '            return true;\n', '        }\n', '        else{\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Check balance of given account address\n', '    *\n', '    * @param _owner The address account whose balance you want to know\n', '    * @return balance of the account\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 _value){\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', "    * @dev Transfer sender's token to a given address\n", '    *\n', '    * @param _to The address which you want to transfer to\n', '    * @param _value the amount of tokens to be transferred\n', '    * @return A bool if the transfer was a success or not\n', '    */\n', '    function transfer(address _to, uint _value) onlyUnlocked onlyPayloadSize(2 * 32) public returns(bool _success) {\n', '        require( _to != address(0) );\n', '        bytes memory _empty;\n', '        assert((balances[msg.sender] >= _value) && _value > 0 && _to != address(0));\n', '        balances[msg.sender] = balances[msg.sender].Sub(_value);\n', '        balances[_to] = balances[_to].Add(_value);\n', '        if(isContract(_to)){\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _empty);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens to an address given by sender. To make ERC223 compliant\n', '    *\n', '    * @param _to The address which you want to transfer to\n', '    * @param _value the amount of tokens to be transferred\n', '    * @param _data additional information of account from where to transfer from\n', '    * @return A bool if the transfer was a success or not\n', '    */\n', '    function transfer(address _to, uint _value, bytes _data) onlyUnlocked onlyPayloadSize(3 * 32) public returns(bool _success) {\n', '        assert((balances[msg.sender] >= _value) && _value > 0 && _to != address(0));\n', '        balances[msg.sender] = balances[msg.sender].Sub(_value);\n', '        balances[_to] = balances[_to].Add(_value);\n', '        if(isContract(_to)){\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '        \n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another, for ERC20.\n', '    *\n', '    * @param _from The address which you want to send tokens from\n', '    * @param _to The address which you want to transfer to\n', '    * @param _value the amount of tokens to be transferred\n', '    * @return A bool if the transfer was a success or not \n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3*32) public onlyUnlocked returns (bool){\n', '        bytes memory _empty;\n', '        assert((_value > 0)\n', '           && (_to != address(0))\n', '           && (_from != address(0))\n', '           && (allowed[_from][msg.sender] >= _value ));\n', '       balances[_from] = balances[_from].Sub(_value);\n', '       balances[_to] = balances[_to].Add(_value);\n', '       allowed[_from][msg.sender] = allowed[_from][msg.sender].Sub(_value);\n', '       if(isContract(_to)){\n', '           ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '           receiver.tokenFallback(msg.sender, _value, _empty);\n', '       }\n', '       emit Transfer(_from, _to, _value);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner has allowed a spender to recieve from owner.\n', '    *\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender to spend.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256){\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool){\n', '        if( _value > 0 && (balances[msg.sender] >= _value)){\n', '            allowed[msg.sender][_spender] = _value;\n', '            emit Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        }\n', '        else{\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function mintAndTransfer(address beneficiary, uint256 tokensToBeTransferred) public validTimeframe onlyOwner {\n', '        require(totalSupply.Add(tokensToBeTransferred) <= MAXCAP);\n', '        totalSupply = totalSupply.Add(tokensToBeTransferred);\n', '        balances[beneficiary] = balances[beneficiary].Add(tokensToBeTransferred);\n', '        emit Transfer(0x0, beneficiary ,tokensToBeTransferred);\n', '    }\n', '\n', '    function getBonus(uint256 _tokensBought)public view returns(uint256){\n', '        uint256 bonus = 0;\n', '        /*April 6- April 13 -- 20% \n', '        April 14- April 21 -- 10% \n', '        April 22 - May 3-- 5% \n', '        \n', '        ICO BONUS WEEKS: \n', '        June 1 - June 9 -- 20% \n', '        June 10 - June 17 -- 10% \n', '        June 18 - June 30 -- 5% \n', '        July 1 - July 9 -- No bonus \n', '        */\n', '        // 1522972800 = 6 april 2018\n', '        // 1523577600 = 13 April 2018\n', '        // 1523664000 = 14 April 2018\n', '        // 1524268800 = 21 April 2018\n', '        // 1524355200 = 22 April 2018\n', '        // 1525305600 = 3 April 2018\n', '        // 1525392000 = 4 may 2018\n', '        // 1527811200 = 1 june 2018\n', '        // 1528502400 = 9 june 2018\n', '        // 1528588800 = 10 june 2018\n', '        // 1529193600 = 17 june 2018\n', '        // 1529280000 = 18 june 2018\n', '        // 1530316800 = 30 june 2018\n', '        // 1530403200 = 1 july 2018\n', '        // 1531094400 = 9 july 2018\n', '        if(saleType == 1){\n', '            //Presale is going on\n', '            if(now >= 1522972800 && now < 1523664000){\n', '                //6 april to before 14 april\n', '                bonus = _tokensBought*20/100;\n', '            }\n', '            else if(now >= 1523664000 && now < 1524355200){\n', '                //14 april to before 22 april\n', '                bonus = _tokensBought*10/100;\n', '            }\n', '            else if(now >= 1524355200 && now < 1525392000){\n', '                //Aprill 22 to before 4 may\n', '                bonus = _tokensBought*5/100;\n', '            }\n', '        }\n', '        if(saleType == 2){\n', '            //ICO is going on\n', '            if(now >= 1527811200 && now < 1528588800){\n', '                // 1 june to before 10 june\n', '                bonus = _tokensBought*20/100;\n', '            }\n', '            else if(now >= 1528588800 && now < 1529280000){\n', '                // june 10 to before june 18\n', '                bonus = _tokensBought*10/100;\n', '            }\n', '            else if(now >= 1529280000 && now < 1530403200){\n', '                // june 18 to before july 1\n', '                bonus = _tokensBought*5/100;\n', '            }\n', '        }\n', '        return bonus;\n', '    }\n', '    function buyTokens(address beneficiary) internal validTimeframe {\n', '        uint256 tokensBought = msg.value.Mul(PRICE);\n', '        tokensBought = tokensBought.Add(getBonus(tokensBought));\n', '        balances[beneficiary] = balances[beneficiary].Add(tokensBought);\n', '        totalSupply = totalSupply.Add(tokensBought);\n', '       \n', '        assert(totalSupply <= HARD_CAP);\n', '        totalWeiReceived = totalWeiReceived.Add(msg.value);\n', '        ethCollector.transfer(msg.value);\n', '        emit Transfer(0x0, beneficiary, tokensBought);\n', '    }\n', '\n', '    /**\n', '    * Finalize the crowdsale\n', '    */\n', '    function finalize() public onlyUnlocked onlyOwner {\n', '        //Make sure Sale is not running\n', '        //If sale is running, then check if the hard cap has been reached or not\n', '        assert(!isSaleRunning() || (HARD_CAP.Sub(totalSupply)) <= 1e18);\n', '        endTime = now;\n', '\n', '        //enable transferring of tokens among token holders\n', '        locked = false;\n', '        //Emit event when crowdsale state changes\n', '        emit StateChanged(true);\n', '    }\n', '\n', '    function () public payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '    * Failsafe drain\n', '    */\n', '    function drain() public onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}']