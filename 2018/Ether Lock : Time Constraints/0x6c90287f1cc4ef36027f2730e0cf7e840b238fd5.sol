['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  \n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20{\n', '    \n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract RenCap is StandardToken {\n', '    \n', '    // Meta data\n', '    \n', '    string  public constant name        = "RenCap";\n', '    string  public constant symbol      = "RNP";\n', '    uint    public constant decimals    = 18;\n', '    uint256 public etherRaised = 0;\n', '    \n', '    \n', '    // Supply alocation and addresses\n', '\n', '    uint public constant initialSupply  = 50000000 * (10 ** uint256(decimals));\n', '    uint public salesSupply             = 25000000 * (10 ** uint256(decimals));\n', '    uint public reserveSupply           = 22000000 * (10 ** uint256(decimals));\n', '    uint public coreSupply              = 3000000  * (10 ** uint256(decimals));\n', '    \n', '    uint public stageOneCap             =  4500000 * (10 ** uint256(decimals));\n', '    uint public stageTwoCap             = 13000000 * (10 ** uint256(decimals));\n', '    uint public stageThreeCap           =  4400000 * (10 ** uint256(decimals));\n', '    uint public stageFourCap            =  3100000 * (10 ** uint256(decimals));\n', '    \n', '\n', '    address public FundsWallet          = 0x6567cb2bfB628c74a190C0aF5745Ae1c090223a3;\n', '    address public addressReserveSupply = 0x6567cb2bfB628c74a190C0aF5745Ae1c090223a3;\n', '    address public addressSalesSupply   = 0x010AfFE21A326E327C273295BBd509ff6446F2F3;\n', '    address public addressCoreSupply    = 0xbED065c02684364824749cE4dA317aC4231780AF;\n', '    address public owner;\n', '    \n', '    \n', '    // Dates\n', '\n', '    uint public constant secondsInDay   = 86400; // 24hr * 60mnt * 60sec\n', '    \n', '    uint public stageOneStart           = 1523865600; // 16-Apr-18 08:00:00 UTC\n', '    uint public stageOneEnd             = stageOneStart + (15 * secondsInDay);\n', '  \n', '    uint public stageTwoStart           = 1525680000; // 07-May-18 08:00:00 UTC\n', '    uint public stageTwoEnd             = stageTwoStart + (22 * secondsInDay);\n', '  \n', '    uint public stageThreeStart         = 1528099200; // 04-Jun-18 08:00:00 UTC\n', '    uint public stageThreeEnd           = stageThreeStart + (15 * secondsInDay);\n', '  \n', '    uint public stageFourStart          = 1530518400; // 02-Jul-18 08:00:00 UTC\n', '    uint public stageFourEnd            = stageFourStart + (15 * secondsInDay);\n', '    \n', '\n', '    // constructor\n', '    \n', '    function RenCap() public {\n', '        owner = msg.sender;\n', '        \n', '        totalSupply_                    = initialSupply;\n', '        balances[owner]                 = reserveSupply;\n', '        balances[addressSalesSupply]    = salesSupply;\n', '        balances[addressCoreSupply]     = coreSupply;\n', '        \n', '        emit Transfer(0x0, owner, reserveSupply);\n', '        emit Transfer(0x0, addressSalesSupply, salesSupply);\n', '        emit Transfer(0x0, addressCoreSupply, coreSupply);\n', '    }\n', '    \n', '    // Modifiers and Controllers\n', '    \n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier onSaleRunning() {\n', '        // Checks, if ICO is running and has not been stopped\n', '        require(\n', '            (stageOneStart   <= now  &&  now <=   stageOneEnd && stageOneCap   >= 0 &&  msg.value <= 1000 ether) ||\n', '            (stageTwoStart   <= now  &&  now <=   stageTwoEnd && stageTwoCap   >= 0) ||\n', '            (stageThreeStart <= now  &&  now <= stageThreeEnd && stageThreeCap >= 0) ||\n', '            (stageFourStart  <= now  &&  now <=  stageFourEnd && stageFourCap  >= 0)\n', '            );\n', '        _;\n', '    }\n', '    \n', '    \n', '    \n', '    // ExchangeRate\n', '    \n', '    function rate() public view returns (uint256) {\n', '        if (stageOneStart   <= now  &&  now <=   stageOneEnd) return 1500;\n', '        if (stageTwoStart   <= now  &&  now <=   stageTwoEnd) return 1300;\n', '        if (stageThreeStart <= now  &&  now <= stageThreeEnd) return 1100;\n', '            return 1030;\n', '    }\n', '    \n', '    \n', '    // Token Exchange\n', '    \n', '    function buyTokens(address _buyer, uint256 _value) internal {\n', '        require(_buyer != 0x0);\n', '        require(_value > 0);\n', '        uint256 tokens =  _value.mul(rate());\n', '      \n', '        balances[_buyer] = balances[_buyer].add(tokens);\n', '        balances[addressSalesSupply] = balances[addressSalesSupply].sub(tokens);\n', '        etherRaised = etherRaised.add(_value);\n', '        updateCap(tokens);\n', '        \n', '        owner.transfer(_value);\n', '        emit Transfer(addressSalesSupply, _buyer, tokens );\n', '    }\n', '    \n', '    // Token Cap Update\n', '\n', '    function updateCap (uint256 _cap) internal {\n', '        if (stageOneStart   <= now  &&  now <=   stageOneEnd) {\n', '            stageOneCap = stageOneCap.sub(_cap);\n', '        }\n', '        if (stageTwoStart   <= now  &&  now <=   stageTwoEnd) {\n', '            stageTwoCap = stageTwoCap.sub(_cap);\n', '        }\n', '        if (stageThreeStart   <= now  &&  now <=   stageThreeEnd) {\n', '            stageThreeCap = stageThreeCap.sub(_cap);\n', '        }\n', '        if (stageFourStart   <= now  &&  now <=   stageFourEnd) {\n', '            stageFourCap = stageFourCap.sub(_cap);\n', '        }\n', '    }\n', '    \n', '    \n', '    // Fallback function\n', '    \n', '    function () public onSaleRunning payable {\n', '        require(msg.value >= 100 finney);\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '  \n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  \n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20{\n', '    \n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract RenCap is StandardToken {\n', '    \n', '    // Meta data\n', '    \n', '    string  public constant name        = "RenCap";\n', '    string  public constant symbol      = "RNP";\n', '    uint    public constant decimals    = 18;\n', '    uint256 public etherRaised = 0;\n', '    \n', '    \n', '    // Supply alocation and addresses\n', '\n', '    uint public constant initialSupply  = 50000000 * (10 ** uint256(decimals));\n', '    uint public salesSupply             = 25000000 * (10 ** uint256(decimals));\n', '    uint public reserveSupply           = 22000000 * (10 ** uint256(decimals));\n', '    uint public coreSupply              = 3000000  * (10 ** uint256(decimals));\n', '    \n', '    uint public stageOneCap             =  4500000 * (10 ** uint256(decimals));\n', '    uint public stageTwoCap             = 13000000 * (10 ** uint256(decimals));\n', '    uint public stageThreeCap           =  4400000 * (10 ** uint256(decimals));\n', '    uint public stageFourCap            =  3100000 * (10 ** uint256(decimals));\n', '    \n', '\n', '    address public FundsWallet          = 0x6567cb2bfB628c74a190C0aF5745Ae1c090223a3;\n', '    address public addressReserveSupply = 0x6567cb2bfB628c74a190C0aF5745Ae1c090223a3;\n', '    address public addressSalesSupply   = 0x010AfFE21A326E327C273295BBd509ff6446F2F3;\n', '    address public addressCoreSupply    = 0xbED065c02684364824749cE4dA317aC4231780AF;\n', '    address public owner;\n', '    \n', '    \n', '    // Dates\n', '\n', '    uint public constant secondsInDay   = 86400; // 24hr * 60mnt * 60sec\n', '    \n', '    uint public stageOneStart           = 1523865600; // 16-Apr-18 08:00:00 UTC\n', '    uint public stageOneEnd             = stageOneStart + (15 * secondsInDay);\n', '  \n', '    uint public stageTwoStart           = 1525680000; // 07-May-18 08:00:00 UTC\n', '    uint public stageTwoEnd             = stageTwoStart + (22 * secondsInDay);\n', '  \n', '    uint public stageThreeStart         = 1528099200; // 04-Jun-18 08:00:00 UTC\n', '    uint public stageThreeEnd           = stageThreeStart + (15 * secondsInDay);\n', '  \n', '    uint public stageFourStart          = 1530518400; // 02-Jul-18 08:00:00 UTC\n', '    uint public stageFourEnd            = stageFourStart + (15 * secondsInDay);\n', '    \n', '\n', '    // constructor\n', '    \n', '    function RenCap() public {\n', '        owner = msg.sender;\n', '        \n', '        totalSupply_                    = initialSupply;\n', '        balances[owner]                 = reserveSupply;\n', '        balances[addressSalesSupply]    = salesSupply;\n', '        balances[addressCoreSupply]     = coreSupply;\n', '        \n', '        emit Transfer(0x0, owner, reserveSupply);\n', '        emit Transfer(0x0, addressSalesSupply, salesSupply);\n', '        emit Transfer(0x0, addressCoreSupply, coreSupply);\n', '    }\n', '    \n', '    // Modifiers and Controllers\n', '    \n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier onSaleRunning() {\n', '        // Checks, if ICO is running and has not been stopped\n', '        require(\n', '            (stageOneStart   <= now  &&  now <=   stageOneEnd && stageOneCap   >= 0 &&  msg.value <= 1000 ether) ||\n', '            (stageTwoStart   <= now  &&  now <=   stageTwoEnd && stageTwoCap   >= 0) ||\n', '            (stageThreeStart <= now  &&  now <= stageThreeEnd && stageThreeCap >= 0) ||\n', '            (stageFourStart  <= now  &&  now <=  stageFourEnd && stageFourCap  >= 0)\n', '            );\n', '        _;\n', '    }\n', '    \n', '    \n', '    \n', '    // ExchangeRate\n', '    \n', '    function rate() public view returns (uint256) {\n', '        if (stageOneStart   <= now  &&  now <=   stageOneEnd) return 1500;\n', '        if (stageTwoStart   <= now  &&  now <=   stageTwoEnd) return 1300;\n', '        if (stageThreeStart <= now  &&  now <= stageThreeEnd) return 1100;\n', '            return 1030;\n', '    }\n', '    \n', '    \n', '    // Token Exchange\n', '    \n', '    function buyTokens(address _buyer, uint256 _value) internal {\n', '        require(_buyer != 0x0);\n', '        require(_value > 0);\n', '        uint256 tokens =  _value.mul(rate());\n', '      \n', '        balances[_buyer] = balances[_buyer].add(tokens);\n', '        balances[addressSalesSupply] = balances[addressSalesSupply].sub(tokens);\n', '        etherRaised = etherRaised.add(_value);\n', '        updateCap(tokens);\n', '        \n', '        owner.transfer(_value);\n', '        emit Transfer(addressSalesSupply, _buyer, tokens );\n', '    }\n', '    \n', '    // Token Cap Update\n', '\n', '    function updateCap (uint256 _cap) internal {\n', '        if (stageOneStart   <= now  &&  now <=   stageOneEnd) {\n', '            stageOneCap = stageOneCap.sub(_cap);\n', '        }\n', '        if (stageTwoStart   <= now  &&  now <=   stageTwoEnd) {\n', '            stageTwoCap = stageTwoCap.sub(_cap);\n', '        }\n', '        if (stageThreeStart   <= now  &&  now <=   stageThreeEnd) {\n', '            stageThreeCap = stageThreeCap.sub(_cap);\n', '        }\n', '        if (stageFourStart   <= now  &&  now <=   stageFourEnd) {\n', '            stageFourCap = stageFourCap.sub(_cap);\n', '        }\n', '    }\n', '    \n', '    \n', '    // Fallback function\n', '    \n', '    function () public onSaleRunning payable {\n', '        require(msg.value >= 100 finney);\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '  \n', '}']