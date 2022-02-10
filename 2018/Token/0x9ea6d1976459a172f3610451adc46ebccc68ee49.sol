['pragma solidity ^0.4.19;\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/ERC20.sol\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'pragma solidity ^0.4.19;\n', '\n', '\n', '/*\n', 'This contract was editted and deploy by ICONEMY - An platform that makes crypto easy! \n', 'For more information check: www.iconemy.io\n', '\n', 'This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans. \n', '\n', 'This contract was adapted by Iconemy to suit the EtherMania token.\n', '*/\n', 'contract ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    /* Public variables of the token */\n', '    uint256 constant MAX_UINT256 = 2**256 - 1;\n', '    string public name = "EtherMania Asset";                   \n', '    uint8 public decimals = 18;                \n', '    string public symbol = "EMA";                 \n', '    uint256 public totalSupply = 1200000000000000000000000;  \n', '    uint256 public multiplier = 100000000;\n', '    address public initialOwner = 0x715b94a938dC6c3651CD43bd61284719772F3D86;\n', '    mapping (address => uint256) balances;   \n', '\n', '    function ERC20() public {\n', '        balances[initialOwner] = totalSupply;               \n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '\n', '    // Get the balance of this caller\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        //Call internal transfer method\n', '        if(_transfer(msg.sender, _to, _value)){\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal returns(bool success){\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balances[_from] >= _value);\n', '        // Check for overflows (as max number is 2**256 - 1 - balances will overflow after that)\n', '        require(balances[_to] + _value > balances[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[_from] + balances[_to];\n', '        // Subtract from the sender\n', '        balances[_from] = balances[_from].sub(_value);\n', '        // Add the same to the recipient\n', '        balances[_to] =  balances[_to].add(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: contracts/ERC20_allowance.sol\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'pragma solidity ^0.4.19;\n', '\n', '\n', '\n', '/*\n', 'This contract was editted and deploy by ICONEMY - An platform that makes crypto easy! \n', 'For more information check: www.iconemy.io\n', '\n', 'This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.\n', '\n', 'This contract was then adapted by Iconemy to suit the EtherMania token \n', '\n', '1) Initial Finite Supply (upon creation one specifies how much is minted).\n', '2) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.\n', '*/\n', 'contract ERC20_allowance is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;   \n', '\n', '    // Constructor function which takes in values from migrations and passes to parent contract\n', '    function ERC20_allowance() public ERC20() {}\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // Get the allowance of a spender for a certain account\n', '    function allowanceOf(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        //Check the allowance of the address spending tokens on behalf of account\n', '        uint256 allowance = allowanceOf(_from, msg.sender);\n', '        //Require that they must have more in their allowance than they wish to send\n', '        require(allowance >= _value);\n', '\n', '        //Require that allowance isnt the max integer\n', '        require(allowance < MAX_UINT256);\n', '            \n', '        //If so, take from their allowance and transfer\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        if(_transfer(_from, _to, _value)){\n', '            return true;\n', '        } else {\n', '            return false;\n', '        } \n', '        \n', '    }\n', '\n', '    // Approve the allowance for a certain spender\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value) public returns (bool success) {\n', '        // This function is used by contracts to allowing the token to notify them when an approval has been made. \n', '        tokenSpender spender = tokenSpender(_spender);\n', '\n', '        if(approve(_spender, _value)){\n', '            spender.receiveApproval();\n', '            return true;\n', '        }\n', '    }\n', '}\n', '\n', '// Interface for Metafusions crowdsale contract\n', 'contract tokenSpender { \n', '    function receiveApproval() external; \n', '}']