['pragma solidity 0.4.20;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\tuint256 public totalSupply;\n', '\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    \n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Token is Ownable {\n', '    using SafeMath for uint;\n', '\n', '    string public name = "Invox";\n', '    string public symbol = "INVOX";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 0;\n', '\n', '    address private owner;\n', '\n', '    address internal constant FOUNDERS = 0x16368c58BDb7444C8b97cC91172315D99fB8dc81;\n', '    address internal constant OPERATIONAL_FUND = 0xc97E0F6AcCB18e3B3703c85c205509d02700aCAa;\n', '\n', '    uint256 private constant MAY_15_2018 = 1526342400;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function Token () public {\n', '        balances[msg.sender] = 0;\n', '    }\n', '\n', '    function balanceOf(address who) public constant returns (uint256) {\n', '        return balances[who];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        require(to != address(0));\n', '        require(balances[msg.sender] >= value);\n', '\n', '        require(now >= MAY_15_2018 + 14 days);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '\n', '        Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        require(from != address(0));\n', '        require(to != address(0));\n', '        require(balances[from] >= value && allowed[from][msg.sender] >= value && balances[to] + value >= balances[to]);\n', '\n', '        balances[from] = balances[from].sub(value);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '\n', '        Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public returns (bool) {\n', '        require(spender != address(0));\n', '        require(allowed[msg.sender][spender] == 0 || amount == 0);\n', '\n', '        allowed[msg.sender][spender] = amount;\n', '        Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ICO is Token {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 private constant MARCH_15_2018 = 1521072000;\n', '    uint256 private constant MARCH_25_2018 = 1521936000;\n', '    uint256 private constant APRIL_15_2018 = 1523750400;\n', '    uint256 private constant APRIL_17_2018 = 1523923200;\n', '    uint256 private constant APRIL_20_2018 = 1524182400;\n', '    uint256 private constant APRIL_30_2018 = 1525046400;\n', '    uint256 private constant MAY_15_2018 = 1526342400;\n', '\n', '    uint256 private constant PRE_SALE_MIN = 1 ether;\n', '    uint256 private constant MAIN_SALE_MIN = 10 ** 17 wei;\n', '\n', '    uint256 private constant PRE_SALE_HARD_CAP = 2491 ether;\n', '    uint256 private constant MAX_CAP = 20000 ether;\n', '    uint256 private constant TOKEN_PRICE = 10 ** 14 wei;\n', '\n', '    uint256 private constant TIER_1_MIN = 10 ether;\n', '    uint256 private constant TIER_2_MIN = 50 ether;\n', '\n', '    uint8 private constant FOUNDERS_ADVISORS_ALLOCATION = 20; //Percent\n', '    uint8 private constant OPERATIONAL_FUND_ALLOCATION = 20; //Percent\n', '    uint8 private constant AIR_DROP_ALLOCATION = 5; //Percent\n', '\n', '    address private constant FOUNDERS_LOCKUP = 0x0000000000000000000000000000000000009999;\n', '    address private constant OPERATIONAL_FUND_LOCKUP = 0x0000000000000000000000000000000000008888;\n', '\n', '    address private constant WITHDRAW_ADDRESS = 0x8B7aa4103Ae75A7dDcac9d2E90aEaAe915f2C75E;\n', '    address private constant AIR_DROP = 0x1100784Cb330ae0BcAFEd061fa95f8aE093d7769;\n', '\n', '    mapping (address => bool) public whitelistAdmins;\n', '    mapping (address => bool) public whitelist;\n', '    mapping (address => address) public tier1;\n', '    mapping (address => address) public tier2;\n', '\n', '    uint32 public whitelistCount;\n', '    uint32 public tier1Count;\n', '    uint32 public tier2Count;\n', '\n', '    uint256 public preICOwei = 0;\n', '    uint256 public ICOwei = 0;\n', '\n', '    function getCurrentBonus(address participant) public constant returns (uint256) {\n', '\n', '        if (isInTier2(participant)) {\n', '            return 60;\n', '        }\n', '\n', '        if (isInTier1(participant)) {\n', '            return 40;\n', '        }\n', '\n', '        if (inPublicPreSalePeriod()) {\n', '            return 30;\n', '        }\n', '\n', '        if (inAngelPeriod()) {\n', '            return 20;\n', '        }\n', '\n', '        if (now >= APRIL_17_2018 && now < APRIL_20_2018) {\n', '            return 10;\n', '        }\n', '\n', '        if (now >= APRIL_20_2018 && now < APRIL_30_2018) {\n', '            return 5;\n', '        }\n', '\n', '        return 0;\n', '    }\n', '\n', '    function inPrivatePreSalePeriod() public constant returns (bool) {\n', '        if (now >= MARCH_15_2018 && now < APRIL_15_2018) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function inPublicPreSalePeriod() public constant returns (bool) {\n', '        if (now >= MARCH_15_2018 && now < MARCH_25_2018) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function inAngelPeriod() public constant returns (bool) {\n', '        if (now >= APRIL_15_2018 && now < APRIL_17_2018) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function inMainSalePeriod() public constant returns (bool) {\n', '        if (now >= APRIL_17_2018 && now < MAY_15_2018) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function addWhitelistAdmin(address newAdmin) public onlyOwner {\n', '        whitelistAdmins[newAdmin] = true;\n', '    }\n', '\n', '    function isInWhitelist(address participant) public constant returns (bool) {\n', '        require(participant != address(0));\n', '        return whitelist[participant];\n', '    }\n', '\n', '    function addToWhitelist(address participant) public onlyWhiteLister {\n', '        require(participant != address(0));\n', '        require(!isInWhitelist(participant));\n', '        whitelist[participant] = true;\n', '        whitelistCount += 1;\n', '\n', '        NewWhitelistParticipant(participant);\n', '    }\n', '\n', '    function addMultipleToWhitelist(address[] participants) public onlyWhiteLister {\n', '        require(participants.length != 0);\n', '        for (uint16 i = 0; i < participants.length; i++) {\n', '            addToWhitelist(participants[i]);\n', '        }\n', '    }\n', '\n', '    function isInTier1(address participant) public constant returns (bool) {\n', '        require(participant != address(0));\n', '        return !(tier1[participant] == address(0));\n', '    }\n', '\n', '    function addTier1Member(address participant) public onlyWhiteLister {\n', '        require(participant != address(0));\n', '        require(!isInTier1(participant)); // unless we require this, the count variable could get out of sync\n', '        tier1[participant] = participant;\n', '        tier1Count += 1;\n', '\n', '        NewTier1Participant(participant);\n', '    }\n', '\n', '    function addMultipleTier1Members(address[] participants) public onlyWhiteLister {\n', '        require(participants.length != 0);\n', '        for (uint16 i = 0; i < participants.length; i++) {\n', '            addTier1Member(participants[i]);\n', '        }\n', '    }\n', '\n', '    function isInTier2(address participant) public constant returns (bool) {\n', '        require(participant != address(0));\n', '        return !(tier2[participant] == address(0));\n', '    }\n', '\n', '    function addTier2Member(address participant) public onlyWhiteLister {\n', '        require(participant != address(0));\n', '        require(!isInTier2(participant)); // unless we require this, the count variable could get out of sync\n', '        tier2[participant] = participant;\n', '        tier2Count += 1;\n', '\n', '        NewTier2Participant(participant);\n', '    }\n', '\n', '    function addMultipleTier2Members(address[] participants) public onlyWhiteLister {\n', '        require(participants.length != 0);\n', '        for (uint16 i = 0; i < participants.length; i++) {\n', '            addTier2Member(participants[i]);\n', '        }\n', '    }\n', '\n', '    function buyTokens() public payable {\n', '\n', '        require(msg.sender != address(0));\n', '        require(isInTier1(msg.sender) || isInTier2(msg.sender) || isInWhitelist(msg.sender));\n', '        \n', '        require(inPrivatePreSalePeriod() || inPublicPreSalePeriod() || inAngelPeriod() || inMainSalePeriod());\n', '\n', '        if (isInTier1(msg.sender)) {\n', '            require(msg.value >= TIER_1_MIN);\n', '        }\n', '\n', '        if (isInTier2(msg.sender)) {\n', '            require(msg.value >= TIER_2_MIN);\n', '        }\n', '\n', '        if (inPrivatePreSalePeriod() == true) {\n', '            require(msg.value >= PRE_SALE_MIN);\n', '\n', '            require(PRE_SALE_HARD_CAP >= preICOwei.add(msg.value));\n', '            preICOwei = preICOwei.add(msg.value);\n', '        }\n', '\n', '        if (inMainSalePeriod() == true) {\n', '            require(msg.value >= MAIN_SALE_MIN);\n', '\n', '            require(MAX_CAP >= preICOwei + ICOwei.add(msg.value));\n', '            ICOwei = ICOwei.add(msg.value);\n', '        }\n', '\n', '        uint256 deltaTokens = 0;\n', '\n', '        uint256 tokens = msg.value.div(TOKEN_PRICE);\n', '        uint256 bonusTokens = getCurrentBonus(msg.sender).mul(tokens.div(100));\n', '\n', '        tokens = tokens.add(bonusTokens);\n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '\n', '        deltaTokens = deltaTokens.add(tokens);\n', '\n', '        balances[FOUNDERS] += tokens.mul(100).div(FOUNDERS_ADVISORS_ALLOCATION).div(2);\n', '        balances[FOUNDERS_LOCKUP] += tokens.mul(100).div(FOUNDERS_ADVISORS_ALLOCATION).div(2);\n', '        deltaTokens += tokens.mul(100).div(FOUNDERS_ADVISORS_ALLOCATION);\n', '\n', '        balances[OPERATIONAL_FUND] += tokens.mul(100).div(OPERATIONAL_FUND_ALLOCATION).div(2);\n', '        balances[OPERATIONAL_FUND_LOCKUP] += tokens.mul(100).div(OPERATIONAL_FUND_ALLOCATION).div(2);\n', '        deltaTokens += tokens.mul(100).div(OPERATIONAL_FUND_ALLOCATION);\n', '\n', '        balances[AIR_DROP] += tokens.mul(100).div(AIR_DROP_ALLOCATION);\n', '        deltaTokens += tokens.mul(100).div(AIR_DROP_ALLOCATION);\n', '\n', '        totalSupply = totalSupply.add(deltaTokens);\n', '\n', '        TokenPurchase(msg.sender, msg.value, tokens);\n', '    }\n', '\n', '    function() public payable {\n', '        buyTokens();\n', '    }\n', '\n', '    function withdrawPreICOEth() public {\n', '        require(now > MARCH_25_2018);\n', '        WITHDRAW_ADDRESS.transfer(preICOwei);\n', '    }\n', '\n', '    function withdrawICOEth() public {\n', '        require(now > MAY_15_2018);\n', '        WITHDRAW_ADDRESS.transfer(ICOwei);\n', '    }\n', '\n', '    function withdrawAll() public {\n', '        require(now > MAY_15_2018);\n', '        WITHDRAW_ADDRESS.transfer(this.balance);\n', '    }\n', '\n', '    function unlockTokens() public {\n', '        require(now > (MAY_15_2018 + 180 days));\n', '        balances[FOUNDERS] += balances[FOUNDERS_LOCKUP];\n', '        balances[FOUNDERS_LOCKUP] = 0;\n', '        balances[OPERATIONAL_FUND] += balances[OPERATIONAL_FUND_LOCKUP];\n', '        balances[OPERATIONAL_FUND_LOCKUP] = 0;\n', '    }\n', '\n', '    event TokenPurchase(address indexed _purchaser, uint256 _value, uint256 _amount);\n', '\n', '    event NewWhitelistParticipant(address indexed _participant);\n', '    event NewTier1Participant(address indexed _participant);\n', '    event NewTier2Participant(address indexed _participant);\n', '\n', '    //\n', '    modifier onlyWhiteLister() {\n', '        require(whitelistAdmins[msg.sender]);\n', '        _;\n', '    }\n', '}']
['pragma solidity 0.4.20;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\tuint256 public totalSupply;\n', '\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    \n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Token is Ownable {\n', '    using SafeMath for uint;\n', '\n', '    string public name = "Invox";\n', '    string public symbol = "INVOX";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 0;\n', '\n', '    address private owner;\n', '\n', '    address internal constant FOUNDERS = 0x16368c58BDb7444C8b97cC91172315D99fB8dc81;\n', '    address internal constant OPERATIONAL_FUND = 0xc97E0F6AcCB18e3B3703c85c205509d02700aCAa;\n', '\n', '    uint256 private constant MAY_15_2018 = 1526342400;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function Token () public {\n', '        balances[msg.sender] = 0;\n', '    }\n', '\n', '    function balanceOf(address who) public constant returns (uint256) {\n', '        return balances[who];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        require(to != address(0));\n', '        require(balances[msg.sender] >= value);\n', '\n', '        require(now >= MAY_15_2018 + 14 days);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '\n', '        Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        require(from != address(0));\n', '        require(to != address(0));\n', '        require(balances[from] >= value && allowed[from][msg.sender] >= value && balances[to] + value >= balances[to]);\n', '\n', '        balances[from] = balances[from].sub(value);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '\n', '        Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public returns (bool) {\n', '        require(spender != address(0));\n', '        require(allowed[msg.sender][spender] == 0 || amount == 0);\n', '\n', '        allowed[msg.sender][spender] = amount;\n', '        Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ICO is Token {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 private constant MARCH_15_2018 = 1521072000;\n', '    uint256 private constant MARCH_25_2018 = 1521936000;\n', '    uint256 private constant APRIL_15_2018 = 1523750400;\n', '    uint256 private constant APRIL_17_2018 = 1523923200;\n', '    uint256 private constant APRIL_20_2018 = 1524182400;\n', '    uint256 private constant APRIL_30_2018 = 1525046400;\n', '    uint256 private constant MAY_15_2018 = 1526342400;\n', '\n', '    uint256 private constant PRE_SALE_MIN = 1 ether;\n', '    uint256 private constant MAIN_SALE_MIN = 10 ** 17 wei;\n', '\n', '    uint256 private constant PRE_SALE_HARD_CAP = 2491 ether;\n', '    uint256 private constant MAX_CAP = 20000 ether;\n', '    uint256 private constant TOKEN_PRICE = 10 ** 14 wei;\n', '\n', '    uint256 private constant TIER_1_MIN = 10 ether;\n', '    uint256 private constant TIER_2_MIN = 50 ether;\n', '\n', '    uint8 private constant FOUNDERS_ADVISORS_ALLOCATION = 20; //Percent\n', '    uint8 private constant OPERATIONAL_FUND_ALLOCATION = 20; //Percent\n', '    uint8 private constant AIR_DROP_ALLOCATION = 5; //Percent\n', '\n', '    address private constant FOUNDERS_LOCKUP = 0x0000000000000000000000000000000000009999;\n', '    address private constant OPERATIONAL_FUND_LOCKUP = 0x0000000000000000000000000000000000008888;\n', '\n', '    address private constant WITHDRAW_ADDRESS = 0x8B7aa4103Ae75A7dDcac9d2E90aEaAe915f2C75E;\n', '    address private constant AIR_DROP = 0x1100784Cb330ae0BcAFEd061fa95f8aE093d7769;\n', '\n', '    mapping (address => bool) public whitelistAdmins;\n', '    mapping (address => bool) public whitelist;\n', '    mapping (address => address) public tier1;\n', '    mapping (address => address) public tier2;\n', '\n', '    uint32 public whitelistCount;\n', '    uint32 public tier1Count;\n', '    uint32 public tier2Count;\n', '\n', '    uint256 public preICOwei = 0;\n', '    uint256 public ICOwei = 0;\n', '\n', '    function getCurrentBonus(address participant) public constant returns (uint256) {\n', '\n', '        if (isInTier2(participant)) {\n', '            return 60;\n', '        }\n', '\n', '        if (isInTier1(participant)) {\n', '            return 40;\n', '        }\n', '\n', '        if (inPublicPreSalePeriod()) {\n', '            return 30;\n', '        }\n', '\n', '        if (inAngelPeriod()) {\n', '            return 20;\n', '        }\n', '\n', '        if (now >= APRIL_17_2018 && now < APRIL_20_2018) {\n', '            return 10;\n', '        }\n', '\n', '        if (now >= APRIL_20_2018 && now < APRIL_30_2018) {\n', '            return 5;\n', '        }\n', '\n', '        return 0;\n', '    }\n', '\n', '    function inPrivatePreSalePeriod() public constant returns (bool) {\n', '        if (now >= MARCH_15_2018 && now < APRIL_15_2018) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function inPublicPreSalePeriod() public constant returns (bool) {\n', '        if (now >= MARCH_15_2018 && now < MARCH_25_2018) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function inAngelPeriod() public constant returns (bool) {\n', '        if (now >= APRIL_15_2018 && now < APRIL_17_2018) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function inMainSalePeriod() public constant returns (bool) {\n', '        if (now >= APRIL_17_2018 && now < MAY_15_2018) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function addWhitelistAdmin(address newAdmin) public onlyOwner {\n', '        whitelistAdmins[newAdmin] = true;\n', '    }\n', '\n', '    function isInWhitelist(address participant) public constant returns (bool) {\n', '        require(participant != address(0));\n', '        return whitelist[participant];\n', '    }\n', '\n', '    function addToWhitelist(address participant) public onlyWhiteLister {\n', '        require(participant != address(0));\n', '        require(!isInWhitelist(participant));\n', '        whitelist[participant] = true;\n', '        whitelistCount += 1;\n', '\n', '        NewWhitelistParticipant(participant);\n', '    }\n', '\n', '    function addMultipleToWhitelist(address[] participants) public onlyWhiteLister {\n', '        require(participants.length != 0);\n', '        for (uint16 i = 0; i < participants.length; i++) {\n', '            addToWhitelist(participants[i]);\n', '        }\n', '    }\n', '\n', '    function isInTier1(address participant) public constant returns (bool) {\n', '        require(participant != address(0));\n', '        return !(tier1[participant] == address(0));\n', '    }\n', '\n', '    function addTier1Member(address participant) public onlyWhiteLister {\n', '        require(participant != address(0));\n', '        require(!isInTier1(participant)); // unless we require this, the count variable could get out of sync\n', '        tier1[participant] = participant;\n', '        tier1Count += 1;\n', '\n', '        NewTier1Participant(participant);\n', '    }\n', '\n', '    function addMultipleTier1Members(address[] participants) public onlyWhiteLister {\n', '        require(participants.length != 0);\n', '        for (uint16 i = 0; i < participants.length; i++) {\n', '            addTier1Member(participants[i]);\n', '        }\n', '    }\n', '\n', '    function isInTier2(address participant) public constant returns (bool) {\n', '        require(participant != address(0));\n', '        return !(tier2[participant] == address(0));\n', '    }\n', '\n', '    function addTier2Member(address participant) public onlyWhiteLister {\n', '        require(participant != address(0));\n', '        require(!isInTier2(participant)); // unless we require this, the count variable could get out of sync\n', '        tier2[participant] = participant;\n', '        tier2Count += 1;\n', '\n', '        NewTier2Participant(participant);\n', '    }\n', '\n', '    function addMultipleTier2Members(address[] participants) public onlyWhiteLister {\n', '        require(participants.length != 0);\n', '        for (uint16 i = 0; i < participants.length; i++) {\n', '            addTier2Member(participants[i]);\n', '        }\n', '    }\n', '\n', '    function buyTokens() public payable {\n', '\n', '        require(msg.sender != address(0));\n', '        require(isInTier1(msg.sender) || isInTier2(msg.sender) || isInWhitelist(msg.sender));\n', '        \n', '        require(inPrivatePreSalePeriod() || inPublicPreSalePeriod() || inAngelPeriod() || inMainSalePeriod());\n', '\n', '        if (isInTier1(msg.sender)) {\n', '            require(msg.value >= TIER_1_MIN);\n', '        }\n', '\n', '        if (isInTier2(msg.sender)) {\n', '            require(msg.value >= TIER_2_MIN);\n', '        }\n', '\n', '        if (inPrivatePreSalePeriod() == true) {\n', '            require(msg.value >= PRE_SALE_MIN);\n', '\n', '            require(PRE_SALE_HARD_CAP >= preICOwei.add(msg.value));\n', '            preICOwei = preICOwei.add(msg.value);\n', '        }\n', '\n', '        if (inMainSalePeriod() == true) {\n', '            require(msg.value >= MAIN_SALE_MIN);\n', '\n', '            require(MAX_CAP >= preICOwei + ICOwei.add(msg.value));\n', '            ICOwei = ICOwei.add(msg.value);\n', '        }\n', '\n', '        uint256 deltaTokens = 0;\n', '\n', '        uint256 tokens = msg.value.div(TOKEN_PRICE);\n', '        uint256 bonusTokens = getCurrentBonus(msg.sender).mul(tokens.div(100));\n', '\n', '        tokens = tokens.add(bonusTokens);\n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '\n', '        deltaTokens = deltaTokens.add(tokens);\n', '\n', '        balances[FOUNDERS] += tokens.mul(100).div(FOUNDERS_ADVISORS_ALLOCATION).div(2);\n', '        balances[FOUNDERS_LOCKUP] += tokens.mul(100).div(FOUNDERS_ADVISORS_ALLOCATION).div(2);\n', '        deltaTokens += tokens.mul(100).div(FOUNDERS_ADVISORS_ALLOCATION);\n', '\n', '        balances[OPERATIONAL_FUND] += tokens.mul(100).div(OPERATIONAL_FUND_ALLOCATION).div(2);\n', '        balances[OPERATIONAL_FUND_LOCKUP] += tokens.mul(100).div(OPERATIONAL_FUND_ALLOCATION).div(2);\n', '        deltaTokens += tokens.mul(100).div(OPERATIONAL_FUND_ALLOCATION);\n', '\n', '        balances[AIR_DROP] += tokens.mul(100).div(AIR_DROP_ALLOCATION);\n', '        deltaTokens += tokens.mul(100).div(AIR_DROP_ALLOCATION);\n', '\n', '        totalSupply = totalSupply.add(deltaTokens);\n', '\n', '        TokenPurchase(msg.sender, msg.value, tokens);\n', '    }\n', '\n', '    function() public payable {\n', '        buyTokens();\n', '    }\n', '\n', '    function withdrawPreICOEth() public {\n', '        require(now > MARCH_25_2018);\n', '        WITHDRAW_ADDRESS.transfer(preICOwei);\n', '    }\n', '\n', '    function withdrawICOEth() public {\n', '        require(now > MAY_15_2018);\n', '        WITHDRAW_ADDRESS.transfer(ICOwei);\n', '    }\n', '\n', '    function withdrawAll() public {\n', '        require(now > MAY_15_2018);\n', '        WITHDRAW_ADDRESS.transfer(this.balance);\n', '    }\n', '\n', '    function unlockTokens() public {\n', '        require(now > (MAY_15_2018 + 180 days));\n', '        balances[FOUNDERS] += balances[FOUNDERS_LOCKUP];\n', '        balances[FOUNDERS_LOCKUP] = 0;\n', '        balances[OPERATIONAL_FUND] += balances[OPERATIONAL_FUND_LOCKUP];\n', '        balances[OPERATIONAL_FUND_LOCKUP] = 0;\n', '    }\n', '\n', '    event TokenPurchase(address indexed _purchaser, uint256 _value, uint256 _amount);\n', '\n', '    event NewWhitelistParticipant(address indexed _participant);\n', '    event NewTier1Participant(address indexed _participant);\n', '    event NewTier2Participant(address indexed _participant);\n', '\n', '    //\n', '    modifier onlyWhiteLister() {\n', '        require(whitelistAdmins[msg.sender]);\n', '        _;\n', '    }\n', '}']
