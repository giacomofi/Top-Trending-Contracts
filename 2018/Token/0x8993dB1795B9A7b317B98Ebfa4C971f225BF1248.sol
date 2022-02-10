['pragma solidity ^0.4.20;\n', '\n', '/**\n', ' *  Standard Interface for ERC20 Contract\n', ' */\n', 'contract IERC20 {\n', '    function totalSupply() public constant returns (uint _totalSupply);\n', '    function balanceOf(address _owner) public constant returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) constant public returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', '/**\n', ' * Checking overflows for various operations\n', ' */\n', 'library SafeMathLib {\n', '\n', '/**\n', '* Issue: Change to internal constant\n', '**/\n', '  function minus(uint a, uint b) internal constant returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '/**\n', '* Issue: Change to internal constant\n', '**/\n', '  function plus(uint a, uint b) internal constant returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @notice The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @notice The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @notice Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '    \n', '}\n', '\n', 'contract HasAddresses {\n', '    address teamAddress = 0xb72D3a827c7a7267C0c8E14A1F4729bF38950887;\n', '    address advisoryPoolAddress = 0x83a330c4A0f7b2bBe1B463F7a5a5eb6EA429E981;\n', '    address companyReserveAddress = 0x6F221CFDdac264146DEBaF88DaaE7Bb811C29fB5;\n', '    address freePoolAddress = 0x108102b4e6F92a7A140C38F3529c7bfFc950081B;\n', '}\n', '\n', '\n', 'contract VestingPeriods{\n', '    uint teamVestingTime = 1557360000;            // GMT: Thursday, 9 May 2019 00:00:00 \n', '    uint advisoryPoolVestingTime = 1541721600;    // Human time (GMT): Friday, 9 November 2018 00:00:00\n', '    uint companyReserveAmountVestingTime = 1541721600;    // Human time (GMT): Friday, 9 November 2018 00:00:00\n', '\n', '}\n', '\n', '\n', 'contract Vestable {\n', '\n', '    uint defaultVestingDate = 1526428800;  // timestamp after which transfers will be enabled,  Wednesday, 16 May 2018 00:00:00\n', '\n', '    mapping(address => uint) vestedAddresses ;    // Addresses vested till date\n', '    bool isVestingOver = false;\n', '\n', '    function addVestingAddress(address vestingAddress, uint maturityTimestamp) internal{\n', '        vestedAddresses[vestingAddress] = maturityTimestamp;\n', '    }\n', '\n', '    function checkVestingTimestamp(address testAddress) public constant returns(uint){\n', '        return vestedAddresses[testAddress];\n', '\n', '    }\n', '\n', '    function checkVestingCondition(address sender) internal returns(bool) {\n', '        uint vestingTimestamp = vestedAddresses[sender];\n', '        if(vestingTimestamp == 0){\n', '            vestingTimestamp = defaultVestingDate;\n', '        }\n', '        return now > vestingTimestamp;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ENKToken Token\n', ' * @notice The ERC20 Token.\n', ' */\n', 'contract ENKToken is IERC20, Ownable, Vestable, HasAddresses, VestingPeriods {\n', '    \n', '    using SafeMathLib for uint256;\n', '    \n', '    uint256 public constant totalTokenSupply = 1500000000 * 10**18;\n', '\n', '    uint256 public burntTokens;\n', '\n', '    string public constant name = "Enkidu";    // Enkidu\n', '    string public constant symbol = "ENK";  // ENK\n', '    uint8 public constant decimals = 18;\n', '            \n', '    mapping (address => uint256) public balances;\n', '    //approved[owner][spender]\n', '    mapping(address => mapping(address => uint256)) approved;\n', '    \n', '    function ENKToken() public {\n', '        \n', '        uint256 teamPoolAmount = 420 * 10**6 * 10**18;         // 420 million ENK\n', '        uint256 advisoryPoolAmount = 19 * 10**5 * 10**18;      // 1.9 million ENK\n', '        uint256 companyReserveAmount = 135 * 10**6 * 10**18;   // 135 million ENK\n', '        \n', '        uint256 freePoolAmmount = totalTokenSupply - teamPoolAmount - advisoryPoolAmount;     //   1.5 billion - ( 556.9 million )\n', '        balances[teamAddress] = teamPoolAmount;\n', '        balances[freePoolAddress] = freePoolAmmount;\n', '        balances[advisoryPoolAddress] = advisoryPoolAmount;    \n', '        balances[companyReserveAddress] = companyReserveAmount;\n', '        emit Transfer(address(this), teamAddress, teamPoolAmount);\n', '        emit Transfer(address(this), freePoolAddress, freePoolAmmount);\n', '        emit Transfer(address(this), advisoryPoolAddress, advisoryPoolAmount);\n', '        emit Transfer(address(this), companyReserveAddress, companyReserveAmount);\n', '        addVestingAddress(teamAddress, teamVestingTime);            // GMT: Thursday, 9 May 2019 00:00:00 \n', '        addVestingAddress(advisoryPoolAddress, advisoryPoolVestingTime);    // Human time (GMT): Friday, 9 November 2018 00:00:00\n', '        addVestingAddress(companyReserveAddress, companyReserveAmountVestingTime);    // Human time (GMT): Friday, 9 November 2018 00:00:00\n', '    }\n', '\n', '    function burn(uint256 _value) public {\n', '        require (balances[msg.sender] >= _value);                 // Check if the sender has enough\n', '        balances[msg.sender] = balances[msg.sender].minus(_value);\n', '        burntTokens += _value;\n', '        emit BurnToken(msg.sender, _value);\n', '    } \n', '\n', '    \n', '    function totalSupply() constant public returns (uint256 _totalSupply) {\n', '        return totalTokenSupply - burntTokens;\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balances[_from] >= _value);                 // Check if the sender has enough\n', '        require (balances[_to] + _value > balances[_to]);   // Check for overflows\n', '        balances[_from] = balances[_from].minus(_value);    // Subtract from the sender\n', '        balances[_to] = balances[_to].plus(_value);         // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @notice Send `_value` tokens to `_to` from your account\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        require(checkVestingCondition(msg.sender));\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @notice Send `_value` tokens to `_to` on behalf of `_from`\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(checkVestingCondition(_from));\n', '        require (_value <= approved[_from][msg.sender]);     // Check allowance\n', '        approved[_from][msg.sender] = approved[_from][msg.sender].minus(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @notice Approve `_value` tokens for `_spender`\n', '     * @param _spender The address of the sender\n', '     * @param _value the amount to send\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(checkVestingCondition(_spender));\n', '        if(balances[msg.sender] >= _value) {\n', '            approved[msg.sender][_spender] = _value;\n', '            emit Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '        \n', '    /**\n', '     * @notice Check `_value` tokens allowed to `_spender` by `_owner`\n', '     * @param _owner The address of the Owner\n', '     * @param _spender The address of the Spender\n', '     */\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return approved[_owner][_spender];\n', '    }\n', '        \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    event BurnToken(address _owner, uint256 _value);\n', '    \n', '}']