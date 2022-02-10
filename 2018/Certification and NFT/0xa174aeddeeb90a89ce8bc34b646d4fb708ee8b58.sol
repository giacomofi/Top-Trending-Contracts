['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = _a * _b;\n', '    require(c / _a == _b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    require(_b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    require(_b <= _a);\n', '    uint256 c = _a - _b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    uint256 c = _a + _b;\n', '    require(c >= _a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '\n', '  function balanceOf(address _who) public view returns (uint256);\n', '\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract Rays is ERC20, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) internal balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private allowed;\n', '\n', '  uint256 internal totalSupply_;\n', '  \n', '  \n', '  event Burn(address indexed burner, uint256 value);\n', '  \n', '  string public name = "Rays Network";\n', '  string public symbol = "RAYS";\n', '  uint8 public decimals = 18;\n', '  uint256 public constant INITIAL_SUPPLY = 500000000 * 10**18;\n', '\n', '  constructor() public {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '  }\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '  \n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param _account The account that will receive the created tokens.\n', '   * @param _amount The amount that will be created.\n', '   */\n', '  function _mint(address _account, uint256 _amount) public onlyOwner {\n', '    require(_account != 0);\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_account] = balances[_account].add(_amount);\n', '    emit Transfer(address(0), _account, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param _account The account whose tokens will be burnt.\n', '   * @param _amount The amount that will be burnt.\n', '   */\n', '  function _burn(address _account, uint256 _amount) public onlyOwner {\n', '    require(_account != 0);\n', '    require(_amount <= balances[_account]);\n', '\n', '    totalSupply_ = totalSupply_.sub(_amount);\n', '    balances[_account] = balances[_account].sub(_amount);\n', '    emit Transfer(_account, address(0), _amount);\n', '  }\n', '  \n', '}\n', '\n', 'contract Crowdsale is Rays {\n', '    // ICO rounds\n', '    enum IcoStages {preSale, preIco, ico} \n', '    IcoStages Stage;\n', '    bool private crowdsaleFinished;\n', '    \n', '    uint private startPreSaleDate;\n', '    uint private endPreSaleDate;\n', '    uint public preSaleGoal;\n', '    uint private preSaleRaised;\n', '    \n', '    uint private startPreIcoDate;\n', '    uint private endPreIcoDate;\n', '    uint public preIcoGoal;\n', '    uint private preIcoRaised;\n', '    \n', '    uint private startIcoDate;\n', '    uint private endIcoDate;\n', '    uint public icoGoal;\n', '    uint private icoRaised;\n', '    \n', '    uint private softCup; // 2 000 000 $ (300$ = 1 ether)\n', '    uint private totalCup;\n', '    uint private price;\n', '    uint private total;\n', '    uint private reserved;\n', '    uint private hardCup;// 20 000 000 $ (300$ = 1 ether)\n', '    \n', '    struct Benefeciary{ // collect all participants of ICO\n', '        address wallet;\n', '        uint amount;\n', '    }\n', '    Benefeciary[] private benefeciary;\n', '    uint private ethersRefund;\n', '    \n', '    constructor() public {\n', '        startPreSaleDate = 1534723200; // insert here your pre sale start date\n', '        endPreSaleDate = 1536969600; // insert here your pre sale end date\n', '        preSaleGoal = 60000000; // pre-sale goal \n', '        preSaleRaised = 0; // raised on pre-sale stage\n', '        startPreIcoDate = 1534723200; // insert here your pre ico start date\n', '        endPreIcoDate = 1538265600; // insert here your pre ico end date\n', '        preIcoGoal = 60000000; // pre ico goal \n', '        preIcoRaised = 0; // raised on pre ico\n', '        startIcoDate = 1534723200; // insert here your ico start date\n', '        endIcoDate = 1546214400; // insert here your ico end date\n', '        icoGoal = 80000000; // ico goal \n', '        icoRaised = 0; // raised on ico stage\n', '        softCup = 6670 * 10**18; \n', '        hardCup = 66670 * 10**18;\n', '        totalCup = 0;\n', '        price = 1160;\n', '        total = preSaleGoal + preIcoGoal + icoGoal;\n', '        reserved = (70000000 + 200000000 + 5000000 + 25000000) * 10**18;\n', '        crowdsaleFinished = false;\n', '    }\n', '  \n', '    function getCrowdsaleInfo() private returns(uint stage, \n', '                                               uint tokenAvailable, \n', '                                               uint bonus){\n', '        // Token calculating\n', '        if(now <= endPreSaleDate && preSaleRaised < preSaleGoal){\n', '            Stage = IcoStages.preSale;\n', '            tokenAvailable = preSaleGoal - preSaleRaised;\n', '            total -= preSaleRaised;\n', '            bonus = 0; // insert your bonus value on pre sale phase\n', '        } else if(startPreIcoDate <= now && now <= endPreIcoDate && preIcoRaised < preIcoGoal){\n', '            Stage = IcoStages.preIco;\n', '            tokenAvailable = preIcoGoal - preIcoRaised;\n', '            total -= preIcoRaised;\n', '            bonus = 50; // + 50% seems like bonus\n', '        } else if(startIcoDate <= now && now <= endIcoDate && icoRaised < total){\n', '            tokenAvailable = total - icoRaised;\n', '            Stage = IcoStages.ico;\n', '            bonus = 0;\n', '        } else {\n', '            // if ICO has not been started\n', '            revert();\n', '        }\n', '        return (uint(Stage), tokenAvailable, bonus);\n', '    }\n', '    //per 0.1 ether will recieved 116 tokens\n', '    function evaluateTokens(uint _value, address _sender) private returns(uint tokens){\n', '        ethersRefund = 0;\n', '        uint bonus;\n', '        uint tokenAvailable;\n', '        uint stage;\n', '        (stage,tokenAvailable,bonus) = getCrowdsaleInfo();\n', '        tokens = _value * price / 10**18; \n', '        if(bonus != 0){\n', '            tokens = tokens + (tokens * bonus / 100); // calculate bonus tokens\n', '        } \n', '        if(tokenAvailable < tokens){ // if not enough tokens in reserve\n', '            tokens = tokenAvailable;\n', '            ethersRefund = _value - (tokens / price * 10**18); // calculate how many ethers will respond to user\n', '            _sender.transfer(ethersRefund);// payback \n', '        }\n', '        owner.transfer(_value - ethersRefund);\n', '        // Add token value to raised variable\n', '        if(stage == 0){\n', '            preSaleRaised += tokens;\n', '        } else if(stage == 1){\n', '            preIcoRaised += tokens;\n', '        } else if(stage == 2){\n', '            icoRaised += tokens;\n', '        } \n', '        addInvestor(_sender, _value);\n', '        return tokens;\n', '    }\n', '    \n', '    function addInvestor(address _sender, uint _value) private {\n', '        Benefeciary memory ben;\n', '        for(uint i = 0; i < benefeciary.length; i++){\n', '            if(benefeciary[i].wallet == _sender){\n', '                benefeciary[i].amount = benefeciary[i].amount + _value - ethersRefund;\n', '            }\n', '        }\n', '        ben.wallet = msg.sender;\n', '        ben.amount = msg.value - ethersRefund;\n', '        benefeciary.push(ben);\n', '    }\n', '    \n', '    \n', '    function() public payable {\n', '        require(startPreSaleDate <= now && now <= endIcoDate);\n', '        require(msg.value >= 0.1 ether);\n', '        require(!crowdsaleFinished);\n', '        totalCup += msg.value;\n', '        uint token = evaluateTokens(msg.value, msg.sender);\n', '        // send tokens to buyer\n', '        balances[msg.sender] = balances[msg.sender].add(token * 10**18);\n', '        balances[owner] = balances[owner].sub(token * 10**18);\n', '        emit Transfer(owner, msg.sender, token * 10**18);\n', '    }\n', '    \n', '    function showParticipantWei(address _wallet) public view onlyOwner returns(uint){\n', '        for(uint i = 0; i < benefeciary.length; i++){\n', '            if(benefeciary[i].wallet == _wallet){\n', '                return benefeciary[i].amount;// show in wei\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '    \n', '    function burnUnsoldTokens() public onlyOwner icoHasFinished{\n', '        _burn(owner, balanceOf(owner).sub(reserved));\n', '    }\n', '    \n', '    function crowdSaleStage() public view returns(string){\n', '        string memory result;\n', '        if(uint(Stage) == 0){\n', '            result = "Pre Sale";\n', '        } else if(uint(Stage) == 1){\n', '            result = "Pre-ICO";\n', '        } else if(uint(Stage) == 2){\n', '            result = "ICO";\n', '        }\n', '        return result;\n', '    }\n', '    \n', '    function preSaleRaise() public view returns(uint){\n', '        return preSaleRaised;\n', '    }\n', '    \n', '    function preIcoRaise() public view returns(uint){\n', '        return preIcoRaised;\n', '    }\n', '    \n', '    function icoRaise() public view returns(uint){\n', '        return icoRaised;\n', '    }\n', '    \n', '    modifier icoHasFinished() {\n', '        require(now >= endIcoDate || icoRaised == total || crowdsaleFinished);\n', '        _;\n', '    }\n', '    \n', '    function endIcoByCup() public onlyOwner{\n', '        require(!crowdsaleFinished);\n', '        require(totalCup >= softCup && totalCup <= hardCup);\n', '        crowdsaleFinished = true;\n', '    }\n', '    \n', '    // Output all funds in wei\n', '    function showAllFunds() public onlyOwner view returns(uint){\n', '        return totalCup;\n', '    }\n', '}']