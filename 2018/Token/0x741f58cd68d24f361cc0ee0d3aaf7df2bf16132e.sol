['pragma solidity ^0.4.24;\n', '\n', '/*\n', '*\n', '*  Blockonix Tokens are governed by the Terms & Conditions separately notified to each existing token holder\n', '*  of Bitindia, and available on https://blockonix.com and https://blockonix.com/tokenswap\n', '*\n', '*/\n', '\n', '\n', '/**\n', ' *  Standard Interface for ERC20 Contract\n', ' */\n', 'contract IERC20 {\n', '    function totalSupply() public constant returns (uint _totalSupply);\n', '    function balanceOf(address _owner) public constant returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) constant public returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', '/**\n', ' * Checking overflows for various operations\n', ' */\n', 'library SafeMathLib {\n', '\n', '/**\n', '* Issue: Change to internal pure\n', '**/\n', '  function minus(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '/**\n', '* Issue: Change to internal pure\n', '**/\n', '  function plus(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @notice The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @notice The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @notice Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '    \n', '}\n', '\n', 'contract HasAddresses {\n', '    address founder1FirstLockup = 0xfC866793142059C79E924d537C26E5E68a3d0CB4;\n', '    address founder1SecondLockup = 0xa5c5EdA285866a89fbe9434BF85BC7249Fa98D45;\n', '    address founder1ThirdLockup = 0xBE2D892D27309EE50D53aa3460fB21A2762625d6;\n', '    \n', '    address founder2FirstLockup = 0x7aeFB5F308C60D6fD9f9D79D6BEb32e2BbEf8F3C;\n', '    address founder2SecondLockup = 0x9d92785510fadcBA9D0372e96882441536d6876a;\n', '    address founder2ThirdLockup = 0x0e0B9943Ea00393B596089631D520bF1489d4d2E;\n', '\n', '    address founder3FirstLockup = 0x8E06EdC382Dd2Bf3F2C36f7e2261Af2c7Eb84835;\n', '    address founder3SecondLockup = 0x6A5AebCd6fA054ff4D10c51bABce17F189A9998a;\n', '    address founder3ThirdLockup = 0xe10E613Be00a6383Dde52152Bc33007E5669e861;\n', '\n', '}\n', '\n', '\n', 'contract VestingPeriods{\n', '    uint firstLockup = 1544486400; // Human time (GMT): Tuesday, 11 December 2018 00:00:00  \n', '    uint secondLockup = 1560211200; // Human time (GMT): Tuesday, 11 June 2019 00:00:00\n', '    uint thirdLockup = 1576022400; // Human time (GMT): Wednesday, 11 December 2019 00:00:00\n', '}\n', '\n', '\n', 'contract Vestable {\n', '\n', '    mapping(address => uint) vestedAddresses ;    // Addresses vested till date\n', '    bool isVestingOver = false;\n', '    event AddVestingAddress(address vestingAddress, uint maturityTimestamp);\n', '\n', '    function addVestingAddress(address vestingAddress, uint maturityTimestamp) internal{\n', '        vestedAddresses[vestingAddress] = maturityTimestamp;\n', '        emit AddVestingAddress(vestingAddress, maturityTimestamp);\n', '    }\n', '\n', '    function checkVestingTimestamp(address testAddress) public view returns(uint){\n', '        return vestedAddresses[testAddress];\n', '    }\n', '\n', '    function checkVestingCondition(address sender) internal view returns(bool) {\n', '        uint vestingTimestamp = vestedAddresses[sender];\n', '        if(vestingTimestamp > 0) {\n', '            return (now > vestingTimestamp);\n', '        }\n', '        else {\n', '            return true;\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract IsUpgradable{\n', '    address oldTokenAddress = 0x420335D3DEeF2D5b87524Ff9D0fB441F71EA621f;\n', '    uint upgradeDeadline = 1543536000;\n', '    address oldTokenBurnAddress = 0x30E055F7C16B753dbF77B57f38782C11A9f1C653;\n', '    IERC20 oldToken = IERC20(oldTokenAddress);\n', '\n', '\n', '}\n', '\n', '/**\n', ' * @title BlockonixToken Token\n', ' * @notice The ERC20 Token.\n', ' */\n', 'contract BlockonixToken is IERC20, Ownable, Vestable, HasAddresses, VestingPeriods, IsUpgradable {\n', '    \n', '    using SafeMathLib for uint256;\n', '    \n', '    uint256 public constant totalTokenSupply = 1009208335 * 10**16;    // Total Supply:10,092,083.35\n', '\n', '    uint256 public burntTokens;\n', '\n', '    string public constant name = "Blockonix";    // Blockonix\n', '    string public constant symbol = "BDT";  // BDT\n', '    uint8 public constant decimals = 18;            \n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping(address => mapping(address => uint256)) approved;\n', '    \n', '    event Upgraded(address _owner, uint256 amount); \n', '    constructor() public {\n', '        \n', '        uint256 lockedTokenPerAddress = 280335648611111000000000;   // Total Founder Tokens(LOCKED): 2,523,020.8375, divided equally in 9 chunks\n', '        balances[founder1FirstLockup] = lockedTokenPerAddress;\n', '        balances[founder2FirstLockup] = lockedTokenPerAddress;\n', '        balances[founder3FirstLockup] = lockedTokenPerAddress;\n', '        balances[founder1SecondLockup] = lockedTokenPerAddress;\n', '        balances[founder2SecondLockup] = lockedTokenPerAddress;\n', '        balances[founder3SecondLockup] = lockedTokenPerAddress;\n', '        balances[founder1ThirdLockup] = lockedTokenPerAddress;\n', '        balances[founder2ThirdLockup] = lockedTokenPerAddress;\n', '        balances[founder3ThirdLockup] = lockedTokenPerAddress;\n', '\n', '        emit Transfer(address(this), founder1FirstLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder2FirstLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder3FirstLockup, lockedTokenPerAddress);\n', '        \n', '        emit Transfer(address(this), founder1SecondLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder2SecondLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder3SecondLockup, lockedTokenPerAddress);\n', '\n', '        emit Transfer(address(this), founder1ThirdLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder2ThirdLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder3ThirdLockup, lockedTokenPerAddress);\n', '\n', '\n', '        addVestingAddress(founder1FirstLockup, firstLockup);\n', '        addVestingAddress(founder2FirstLockup, firstLockup);\n', '        addVestingAddress(founder3FirstLockup, firstLockup);\n', '\n', '        addVestingAddress(founder1SecondLockup, secondLockup);\n', '        addVestingAddress(founder2SecondLockup, secondLockup);\n', '        addVestingAddress(founder3SecondLockup, secondLockup);\n', '\n', '        addVestingAddress(founder1ThirdLockup, thirdLockup);\n', '        addVestingAddress(founder2ThirdLockup, thirdLockup);\n', '        addVestingAddress(founder3ThirdLockup, thirdLockup);\n', '\n', '    }\n', '\n', '    function burn(uint256 _value) public {\n', '        require (balances[msg.sender] >= _value);                 // Check if the sender has enough\n', '        balances[msg.sender] = balances[msg.sender].minus(_value);\n', '        burntTokens += _value;\n', '        emit BurnToken(msg.sender, _value);\n', '    } \n', '\n', '    \n', '    function totalSupply() view public returns (uint256 _totalSupply) {\n', '        return totalTokenSupply - burntTokens;\n', '    }\n', '    \n', '    function balanceOf(address _owner) view public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balances[_from] >= _value);                 // Check if the sender has enough\n', '        require (balances[_to] + _value > balances[_to]);   // Check for overflows\n', '        balances[_from] = balances[_from].minus(_value);    // Subtract from the sender\n', '        balances[_to] = balances[_to].plus(_value);         // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @notice Send `_value` tokens to `_to` from your account\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        require(checkVestingCondition(msg.sender));\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @notice Send `_value` tokens to `_to` on behalf of `_from`\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(checkVestingCondition(_from));\n', '        require (_value <= approved[_from][msg.sender]);     // Check allowance\n', '        approved[_from][msg.sender] = approved[_from][msg.sender].minus(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @notice Approve `_value` tokens for `_spender`\n', '     * @param _spender The address of the sender\n', '     * @param _value the amount to send\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(checkVestingCondition(_spender));\n', '        if(balances[msg.sender] >= _value) {\n', '            approved[msg.sender][_spender] = _value;\n', '            emit Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '        \n', '    /**\n', '     * @notice Check `_value` tokens allowed to `_spender` by `_owner`\n', '     * @param _owner The address of the Owner\n', '     * @param _spender The address of the Spender\n', '     */\n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\n', '        return approved[_owner][_spender];\n', '    }\n', '        \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    event BurnToken(address _owner, uint256 _value);\n', '    \n', '     /**\n', '     * Upgrade function, requires the owner to first approve tokens equal to their old token balance to this address \n', '     *\n', '     */\n', '    function upgrade() external {\n', '        require(now <=upgradeDeadline);\n', '        uint256 balance = oldToken.balanceOf(msg.sender);\n', '        require(balance>0);\n', '        oldToken.transferFrom(msg.sender, oldTokenBurnAddress, balance);\n', '        balances[msg.sender] += balance;\n', '        emit Transfer(this, msg.sender, balance);\n', '        emit Upgraded(msg.sender, balance);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/*\n', '*\n', '*  Blockonix Tokens are governed by the Terms & Conditions separately notified to each existing token holder\n', '*  of Bitindia, and available on https://blockonix.com and https://blockonix.com/tokenswap\n', '*\n', '*/\n', '\n', '\n', '/**\n', ' *  Standard Interface for ERC20 Contract\n', ' */\n', 'contract IERC20 {\n', '    function totalSupply() public constant returns (uint _totalSupply);\n', '    function balanceOf(address _owner) public constant returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) constant public returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', '/**\n', ' * Checking overflows for various operations\n', ' */\n', 'library SafeMathLib {\n', '\n', '/**\n', '* Issue: Change to internal pure\n', '**/\n', '  function minus(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '/**\n', '* Issue: Change to internal pure\n', '**/\n', '  function plus(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @notice The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @notice The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @notice Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '    \n', '}\n', '\n', 'contract HasAddresses {\n', '    address founder1FirstLockup = 0xfC866793142059C79E924d537C26E5E68a3d0CB4;\n', '    address founder1SecondLockup = 0xa5c5EdA285866a89fbe9434BF85BC7249Fa98D45;\n', '    address founder1ThirdLockup = 0xBE2D892D27309EE50D53aa3460fB21A2762625d6;\n', '    \n', '    address founder2FirstLockup = 0x7aeFB5F308C60D6fD9f9D79D6BEb32e2BbEf8F3C;\n', '    address founder2SecondLockup = 0x9d92785510fadcBA9D0372e96882441536d6876a;\n', '    address founder2ThirdLockup = 0x0e0B9943Ea00393B596089631D520bF1489d4d2E;\n', '\n', '    address founder3FirstLockup = 0x8E06EdC382Dd2Bf3F2C36f7e2261Af2c7Eb84835;\n', '    address founder3SecondLockup = 0x6A5AebCd6fA054ff4D10c51bABce17F189A9998a;\n', '    address founder3ThirdLockup = 0xe10E613Be00a6383Dde52152Bc33007E5669e861;\n', '\n', '}\n', '\n', '\n', 'contract VestingPeriods{\n', '    uint firstLockup = 1544486400; // Human time (GMT): Tuesday, 11 December 2018 00:00:00  \n', '    uint secondLockup = 1560211200; // Human time (GMT): Tuesday, 11 June 2019 00:00:00\n', '    uint thirdLockup = 1576022400; // Human time (GMT): Wednesday, 11 December 2019 00:00:00\n', '}\n', '\n', '\n', 'contract Vestable {\n', '\n', '    mapping(address => uint) vestedAddresses ;    // Addresses vested till date\n', '    bool isVestingOver = false;\n', '    event AddVestingAddress(address vestingAddress, uint maturityTimestamp);\n', '\n', '    function addVestingAddress(address vestingAddress, uint maturityTimestamp) internal{\n', '        vestedAddresses[vestingAddress] = maturityTimestamp;\n', '        emit AddVestingAddress(vestingAddress, maturityTimestamp);\n', '    }\n', '\n', '    function checkVestingTimestamp(address testAddress) public view returns(uint){\n', '        return vestedAddresses[testAddress];\n', '    }\n', '\n', '    function checkVestingCondition(address sender) internal view returns(bool) {\n', '        uint vestingTimestamp = vestedAddresses[sender];\n', '        if(vestingTimestamp > 0) {\n', '            return (now > vestingTimestamp);\n', '        }\n', '        else {\n', '            return true;\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract IsUpgradable{\n', '    address oldTokenAddress = 0x420335D3DEeF2D5b87524Ff9D0fB441F71EA621f;\n', '    uint upgradeDeadline = 1543536000;\n', '    address oldTokenBurnAddress = 0x30E055F7C16B753dbF77B57f38782C11A9f1C653;\n', '    IERC20 oldToken = IERC20(oldTokenAddress);\n', '\n', '\n', '}\n', '\n', '/**\n', ' * @title BlockonixToken Token\n', ' * @notice The ERC20 Token.\n', ' */\n', 'contract BlockonixToken is IERC20, Ownable, Vestable, HasAddresses, VestingPeriods, IsUpgradable {\n', '    \n', '    using SafeMathLib for uint256;\n', '    \n', '    uint256 public constant totalTokenSupply = 1009208335 * 10**16;    // Total Supply:10,092,083.35\n', '\n', '    uint256 public burntTokens;\n', '\n', '    string public constant name = "Blockonix";    // Blockonix\n', '    string public constant symbol = "BDT";  // BDT\n', '    uint8 public constant decimals = 18;            \n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping(address => mapping(address => uint256)) approved;\n', '    \n', '    event Upgraded(address _owner, uint256 amount); \n', '    constructor() public {\n', '        \n', '        uint256 lockedTokenPerAddress = 280335648611111000000000;   // Total Founder Tokens(LOCKED): 2,523,020.8375, divided equally in 9 chunks\n', '        balances[founder1FirstLockup] = lockedTokenPerAddress;\n', '        balances[founder2FirstLockup] = lockedTokenPerAddress;\n', '        balances[founder3FirstLockup] = lockedTokenPerAddress;\n', '        balances[founder1SecondLockup] = lockedTokenPerAddress;\n', '        balances[founder2SecondLockup] = lockedTokenPerAddress;\n', '        balances[founder3SecondLockup] = lockedTokenPerAddress;\n', '        balances[founder1ThirdLockup] = lockedTokenPerAddress;\n', '        balances[founder2ThirdLockup] = lockedTokenPerAddress;\n', '        balances[founder3ThirdLockup] = lockedTokenPerAddress;\n', '\n', '        emit Transfer(address(this), founder1FirstLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder2FirstLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder3FirstLockup, lockedTokenPerAddress);\n', '        \n', '        emit Transfer(address(this), founder1SecondLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder2SecondLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder3SecondLockup, lockedTokenPerAddress);\n', '\n', '        emit Transfer(address(this), founder1ThirdLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder2ThirdLockup, lockedTokenPerAddress);\n', '        emit Transfer(address(this), founder3ThirdLockup, lockedTokenPerAddress);\n', '\n', '\n', '        addVestingAddress(founder1FirstLockup, firstLockup);\n', '        addVestingAddress(founder2FirstLockup, firstLockup);\n', '        addVestingAddress(founder3FirstLockup, firstLockup);\n', '\n', '        addVestingAddress(founder1SecondLockup, secondLockup);\n', '        addVestingAddress(founder2SecondLockup, secondLockup);\n', '        addVestingAddress(founder3SecondLockup, secondLockup);\n', '\n', '        addVestingAddress(founder1ThirdLockup, thirdLockup);\n', '        addVestingAddress(founder2ThirdLockup, thirdLockup);\n', '        addVestingAddress(founder3ThirdLockup, thirdLockup);\n', '\n', '    }\n', '\n', '    function burn(uint256 _value) public {\n', '        require (balances[msg.sender] >= _value);                 // Check if the sender has enough\n', '        balances[msg.sender] = balances[msg.sender].minus(_value);\n', '        burntTokens += _value;\n', '        emit BurnToken(msg.sender, _value);\n', '    } \n', '\n', '    \n', '    function totalSupply() view public returns (uint256 _totalSupply) {\n', '        return totalTokenSupply - burntTokens;\n', '    }\n', '    \n', '    function balanceOf(address _owner) view public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balances[_from] >= _value);                 // Check if the sender has enough\n', '        require (balances[_to] + _value > balances[_to]);   // Check for overflows\n', '        balances[_from] = balances[_from].minus(_value);    // Subtract from the sender\n', '        balances[_to] = balances[_to].plus(_value);         // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @notice Send `_value` tokens to `_to` from your account\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        require(checkVestingCondition(msg.sender));\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @notice Send `_value` tokens to `_to` on behalf of `_from`\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(checkVestingCondition(_from));\n', '        require (_value <= approved[_from][msg.sender]);     // Check allowance\n', '        approved[_from][msg.sender] = approved[_from][msg.sender].minus(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @notice Approve `_value` tokens for `_spender`\n', '     * @param _spender The address of the sender\n', '     * @param _value the amount to send\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(checkVestingCondition(_spender));\n', '        if(balances[msg.sender] >= _value) {\n', '            approved[msg.sender][_spender] = _value;\n', '            emit Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '        \n', '    /**\n', '     * @notice Check `_value` tokens allowed to `_spender` by `_owner`\n', '     * @param _owner The address of the Owner\n', '     * @param _spender The address of the Spender\n', '     */\n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\n', '        return approved[_owner][_spender];\n', '    }\n', '        \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    event BurnToken(address _owner, uint256 _value);\n', '    \n', '     /**\n', '     * Upgrade function, requires the owner to first approve tokens equal to their old token balance to this address \n', '     *\n', '     */\n', '    function upgrade() external {\n', '        require(now <=upgradeDeadline);\n', '        uint256 balance = oldToken.balanceOf(msg.sender);\n', '        require(balance>0);\n', '        oldToken.transferFrom(msg.sender, oldTokenBurnAddress, balance);\n', '        balances[msg.sender] += balance;\n', '        emit Transfer(this, msg.sender, balance);\n', '        emit Upgraded(msg.sender, balance);\n', '    }\n', '\n', '}']
