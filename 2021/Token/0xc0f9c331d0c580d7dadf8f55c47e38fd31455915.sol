['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-18\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(\n', '        address indexed _from, \n', '        address indexed _to, \n', '        uint256 _value\n', '    );\n', '} \n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender)\n', '        public view returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(\n', '      address indexed _owner,\n', '      address indexed _spender,\n', '      uint256 _value\n', '    );\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        // avoid race condition \n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0), "reset allowance to 0 before change it\'s value.");\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender]; \n', '    } \n', '\n', '} \n', '\n', 'contract KHToken_StandardToken is StandardToken { \n', '    \n', '    // region{fields}\n', '    string public name;                         \n', '    string public symbol;            \n', '    uint8 public decimals;      \n', '    uint256 public claimAmount;    \n', '\n', '    // region{Constructor}\n', '    // note : [(final)totalSupply] >> claimAmount * 10 ** decimals\n', '    // example : args << "The Kh Token No.X", "KHTX", "10000000000", "18"\n', '    constructor(\n', '        string _token_name, \n', '        string _symbol, \n', '        uint256 _claim_amount, \n', '        uint8 _decimals\n', '    ) public {\n', '        name = _token_name;                              \n', '        symbol = _symbol;     \n', '        claimAmount = _claim_amount;                                     \n', '        decimals = _decimals;\n', '        totalSupply_ = claimAmount.mul(10 ** uint256(decimals)); \n', '        balances[msg.sender] = totalSupply_;   \n', '        emit Transfer(0x0, msg.sender, totalSupply_); \n', '    }\n', '}\n', '\n', 'contract KHToken_StandardToken_U is StandardToken { \n', '    \n', '    // region{fields}\n', '    string public name;                         \n', '    string public symbol;            \n', '    uint8 public decimals;      \n', '    uint256 public claimAmount;    \n', '\n', '    // region{Constructor}\n', '    // note : [(final)totalSupply] >> claimAmount * 10 ** decimals\n', '    // example : args << "The Kh Token No.X", "KHTX", "10000000000", "18"\n', '    constructor(\n', '        string _token_name, \n', '        string _symbol, \n', '        uint256 _claim_amount, \n', '        uint8 _decimals,\n', '        address _initial_account\n', '    ) public {\n', '        name = _token_name;                              \n', '        symbol = _symbol;     \n', '        claimAmount = _claim_amount;                                     \n', '        decimals = _decimals;\n', '        totalSupply_ = claimAmount.mul(10 ** uint256(decimals)); \n', '        balances[_initial_account] = totalSupply_;   \n', '        emit Transfer(0x0, _initial_account, totalSupply_); \n', '    }\n', '}']