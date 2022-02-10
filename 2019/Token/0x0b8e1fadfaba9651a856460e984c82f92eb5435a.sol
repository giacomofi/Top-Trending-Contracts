['pragma solidity ^0.5.9;\n', ' \n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */ \n', 'library SafeMath{\n', '    function mul(uint a, uint b) internal pure returns (uint){\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', ' \n', '    function div(uint a, uint b) internal pure returns (uint){\n', '        uint c = a / b;\n', '        return c;\n', '    }\n', ' \n', '    function sub(uint a, uint b) internal pure returns (uint){\n', '        assert(b <= a); \n', '        return a - b; \n', '    } \n', '  \n', '    function add(uint a, uint b) internal pure returns (uint){ \n', '        uint c = a + b; assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title BIP Token token\n', ' * @dev ERC20 Token implementation, with its own specific\n', ' */\n', 'contract BIPToken{\n', '    using SafeMath for uint;\n', '    \n', '    string public constant name = "Blockchain Invest Platform Token";\n', '    string public constant symbol = "BIP";\n', '    uint32 public constant decimals = 18;\n', '\n', '    address public constant addressICO = 0x6712397d604410b0F99A205Aa8f7ac1B1a358F91;\n', '    address public constant addressInvestors = 0x83DBcaDD8e9c7535DD0Dc42356B8e0AcDccb8c2b;\n', '    address public constant addressMarketing = 0x01D98aa48D98bae8F1E30Ebf2A31b532018C3C61;\n', '    address public constant addressPreICO = 0xE556E2Dd0fE094032FD7242c7880F140c89f17B8;\n', '    address public constant addressTeam = 0xa3C9E790979D226435Da43022e41AF1CA7f8080B;\n', '    address public constant addressBounty = 0x9daf97360086e1454ea8379F61ae42ECe0935740;\n', '    \n', '    uint public totalSupply = 200000000 * 1 ether;\n', '    mapping(address => uint) balances;\n', '    mapping (address => mapping (address => uint)) internal allowed;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '    /** \n', '     * @dev Initial token transfers.\n', '     */\n', '    constructor() public{\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '\n', '        _transfer(addressICO,       124000000 * 1 ether);\n', '        _transfer(addressInvestors,  32000000 * 1 ether);\n', '        _transfer(addressMarketing,  16000000 * 1 ether);\n', '        _transfer(addressPreICO,     14000000 * 1 ether);\n', '        _transfer(addressTeam,        8000000 * 1 ether);\n', '        _transfer(addressBounty,      6000000 * 1 ether);\n', '    }\n', '    \n', '    /** \n', '     * @dev Gets the balance of the specified address.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint){\n', '        return balances[_owner];\n', '    }\n', ' \n', '    /**\n', '     * @dev Transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */ \n', '    function _transfer(address _to, uint _value) private returns (bool){\n', '        require(msg.sender != address(0));\n', '        require(_to != address(0));\n', '        require(_value > 0 && _value <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true; \n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */ \n', '    function transfer(address _to, uint _value) public returns (bool){\n', '        return _transfer(_to, _value);\n', '    } \n', '    \n', '    /**\n', '     * @dev Transfer several token for a specified addresses\n', '     * @param _to The array of addresses to transfer to.\n', '     * @param _value The array of amounts to be transferred.\n', '     */ \n', '    function massTransfer(address[] memory _to, uint[] memory _value) public returns (bool){\n', '        require(_to.length == _value.length);\n', '\n', '        uint len = _to.length;\n', '        for(uint i = 0; i < len; i++){\n', '            if(!_transfer(_to[i], _value[i])){\n', '                return false;\n', '            }\n', '        }\n', '        return true;\n', '    } \n', '    \n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */ \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool){\n', '        require(msg.sender != address(0));\n', '        require(_to != address(0));\n', '        require(_value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', ' \n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint _value) public returns (bool){\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', ' \n', '    /** \n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint){\n', '        return allowed[_owner][_spender]; \n', '    } \n', ' \n', '    /**\n', '     * @dev Increase approved amount of tokents that could be spent on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to be spent.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool){\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); \n', '        return true; \n', '    }\n', ' \n', '    /**\n', '     * @dev Decrease approved amount of tokents that could be spent on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to be spent.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if(_subtractedValue > oldValue){\n', '            allowed[msg.sender][_spender] = 0;\n', '        }else{\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}']