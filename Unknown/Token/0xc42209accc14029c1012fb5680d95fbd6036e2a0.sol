['pragma solidity ^ 0.4.17;\n', '\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) pure internal returns(uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) pure internal returns(uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) pure internal returns(uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) public view returns(uint);\n', '\n', '    function allowance(address owner, address spender) public view returns(uint);\n', '\n', '    function transfer(address to, uint value) public returns(bool ok);\n', '\n', '    function transferFrom(address from, address to, uint value) public returns(bool ok);\n', '\n', '    function approve(address spender, uint value) public returns(bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) \n', '            owner = newOwner;\n', '    }\n', '\n', '    function kill() public {\n', '        if (msg.sender == owner) \n', '            selfdestruct(owner);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender == owner)\n', '            _;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '// The PPP token\n', 'contract Token is ERC20, SafeMath, Ownable {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals; // How many decimals to show.\n', '    string public version = "v0.1";\n', '    uint public initialSupply;\n', '    uint public totalSupply;\n', '    bool public locked;   \n', '    address public preSaleAddress;       \n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    // Lock transfer for contributors during the ICO \n', '    modifier onlyUnlocked() {\n', '        if (msg.sender != preSaleAddress && locked) \n', '            revert();\n', '        _;\n', '    }\n', '\n', '    modifier onlyAuthorized() {\n', '        if (msg.sender != owner) \n', '            revert();\n', '        _;\n', '    }\n', '\n', '    // The PPP Token created with the time at which the crowdsale ends\n', '    function Token() public {\n', '        // Lock the transfCrowdsaleer function during the crowdsale\n', '        locked = true;\n', '        initialSupply = 165000000e18;\n', '        totalSupply = initialSupply;\n', '        name = "PayPie"; // Set the name for display purposes\n', '        symbol = "PPP"; // Set the symbol for display purposes\n', '        decimals = 18; // Amount of decimals for display purposes        \n', '        preSaleAddress = 0xf8A15b1540d5f9D002D9cCb7FD1F23E795c2859d;      \n', '\n', '        // Allocate tokens for pre-sale customers - private sale \n', '        balances[preSaleAddress] = 82499870672369211638818601 - 2534559883e16;\n', '        // Allocate tokens for the team/reserve/advisors/\n', '        balances[0xF821Fd99BCA2111327b6a411C90BE49dcf78CE0f] = totalSupply - balances[preSaleAddress];       \n', '    }\n', '\n', '    function unlock() public onlyAuthorized {\n', '        locked = false;\n', '    }\n', '\n', '    function lock() public onlyAuthorized {\n', '        locked = true;\n', '    }\n', '\n', '    function burn( address _member, uint256 _value) public onlyAuthorized returns(bool) {\n', '        balances[_member] = safeSub(balances[_member], _value);\n', '        totalSupply = safeSub(totalSupply, _value);\n', '        Transfer(_member, 0x0, _value);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {\n', '        require(_to != address(0));\n', '        require (balances[_from] >= _value); // Check if the sender has enough                            \n', '        require (_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal        \n', '        balances[_from] = safeSub(balances[_from], _value); // Subtract from the sender\n', '        balances[_to] = safeAdd(balances[_to],_value); // Add the same to the recipient\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);  // decrease allowed amount\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns(uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '    function approve(address _spender, uint _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '\n', '    /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}']