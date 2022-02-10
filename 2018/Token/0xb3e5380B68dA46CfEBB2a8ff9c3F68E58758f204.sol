['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c>=a && c>=b);\n', '        return c;\n', '   }\n', '}\n', '\n', '\n', 'contract BTBToken is SafeMath {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    address public owner;\n', '    bool public isContractFrozen;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    mapping (address => uint256) public freezeOf;\n', '\n', '    mapping (address => string) public btbAddressMapping;\n', '\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /* This notifies clients about the contract frozen */\n', '    event Freeze(address indexed from, string content);\n', '\n', '    /* This notifies clients about the contract unfrozen */\n', '    event Unfreeze(address indexed from, string content);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function BTBToken() public {\n', '        totalSupply = 10*10**26;                        // Update total supply\n', '        balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens\n', '        name = "BiTBrothers";                                   // Set the name for display purposes\n', '        symbol = "BTB";                               // Set the symbol for display purposes\n', '        decimals = 18;                            // Amount of decimals for display purposes\n', '        owner = msg.sender;\n', '        isContractFrozen = false;\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) external returns (bool success) {\n', '        assert(!isContractFrozen);\n', '        assert(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        assert(_value > 0);\n', '        assert(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        assert(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '        return true;\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) external returns (bool success) {\n', '        assert(!isContractFrozen);\n', '        assert(_value > 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '       \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {\n', '        assert(!isContractFrozen);\n', '        assert(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead\n', '        assert(_value > 0);\n', '        assert(balanceOf[_from] >= _value);                 // Check if the sender has enough\n', '        assert(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows\n', '        assert(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) external returns (bool success) {\n', '        assert(!isContractFrozen);\n', '        assert(msg.sender == owner);\n', '        assert(balanceOf[msg.sender] >= _value);            // Check if the sender has enough\n', '        assert(_value > 0);\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender\n', '        totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '    function freeze() external returns (bool success) {\n', '        assert(msg.sender == owner);\n', '        assert(!isContractFrozen);\n', '        isContractFrozen = true;\n', '        emit Freeze(msg.sender, "contract is frozen");\n', '        return true;\n', '    }\n', '\t\n', '    function unfreeze() external returns (bool success) {\n', '        assert(msg.sender == owner);\n', '        assert(isContractFrozen);\n', '        isContractFrozen = false;\n', '        emit Unfreeze(msg.sender, "contract is unfrozen");\n', '        return true;\n', '    }\n', '\n', '    function setBTBAddress(string btbAddress) external returns (bool success) {\n', '        assert(!isContractFrozen);\n', '        btbAddressMapping[msg.sender] = btbAddress;\n', '        return true;\n', '    }\n', '    // transfer balance to owner\n', '    function withdrawEther(uint256 amount) external {\n', '        assert(msg.sender == owner);\n', '        owner.transfer(amount);\n', '    }\n', '\t\n', '    // can accept ether\n', '    function() public payable {\n', '    }\n', '}']