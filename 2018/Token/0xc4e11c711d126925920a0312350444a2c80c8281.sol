['pragma solidity ^0.4.17;\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    function balanceOf(address who) constant public returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    \n', '    address public owner;\n', '\n', '    /**\n', '     * The address whcih deploys this contrcat is automatically assgined ownership.\n', '     * */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Functions with this modifier can only be executed by the owner of the contract. \n', '     * */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed from, address indexed to);\n', '\n', '    /**\n', '    * Transfers ownership to new Ethereum address. This function can only be called by the \n', '    * owner.\n', '    * @param _newOwner the address to be granted ownership.\n', '    **/\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != 0x0);\n', '        OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    /**\n', '     * Transfers tokens from the sender&#39;s account to another given account.\n', '     * \n', '     * @param _to The address of the recipient.\n', '     * @param _amount The amount of tokens to send.\n', '     * */\n', '    function transfer(address _to, uint256 _amount) public returns (bool) {\n', '        require(balances[msg.sender] >= _amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Returns the balance of a given address.\n', '     * \n', '     * @param _addr The address of the balance to query.\n', '     **/\n', '    function balanceOf(address _addr) public constant returns (uint256) {\n', '        return balances[_addr];\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant public returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public  returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract AdvancedToken is BasicToken, ERC20 {\n', '\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '    /**\n', '     * Transfers tokens from the account of the owner by an approved spender. \n', '     * The spender cannot spend more than the approved amount. \n', '     * \n', '     * @param _from The address of the owners account.\n', '     * @param _amount The amount of tokens to transfer.\n', '     * */\n', '    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {\n', '        require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);\n', '        allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);\n', '        balances[_from] = balances[_from].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Allows another account to spend a given amount of tokens on behalf of the \n', '     * sender&#39;s account.\n', '     * \n', '     * @param _spender The address of the spenders account.\n', '     * @param _amount The amount of tokens the spender is allowed to spend.\n', '     * */\n', '    function approve(address _spender, uint256 _amount) public returns (bool) {\n', '        allowances[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Increases the amount a given account can spend on behalf of the sender&#39;s \n', '     * account.\n', '     * \n', '     * @param _spender The address of the spenders account.\n', '     * @param _amount The amount of tokens the spender is allowed to spend.\n', '     * */\n', '    function increaseApproval(address _spender, uint256 _amount) public returns (bool) {\n', '        allowances[msg.sender][_spender] = allowances[msg.sender][_spender].add(_amount);\n', '        Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Decreases the amount of tokens a given account can spend on behalf of the \n', '     * sender&#39;s account.\n', '     * \n', '     * @param _spender The address of the spenders account.\n', '     * @param _amount The amount of tokens the spender is allowed to spend.\n', '     * */\n', '    function decreaseApproval(address _spender, uint256 _amount) public returns (bool) {\n', '        require(allowances[msg.sender][_spender] != 0);\n', '        if (_amount >= allowances[msg.sender][_spender]) {\n', '            allowances[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowances[msg.sender][_spender] = allowances[msg.sender][_spender].sub(_amount);\n', '            Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns the approved allowance from an owners account to a spenders account.\n', '     * \n', '     * @param _owner The address of the owners account.\n', '     * @param _spender The address of the spenders account.\n', '     **/\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is AdvancedToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0 && _value <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(msg.sender, _value);\n', '    }\n', '}\n', '\n', '\n', 'contract UWC is BurnableToken {\n', '\n', '    function UWC() public {\n', '        name = "Ubuntuwealthclub";\n', '        symbol = "UWC";\n', '        decimals = 18;\n', '        totalSupply = 200000000e18;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    function balanceOf(address who) constant public returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    \n', '    address public owner;\n', '\n', '    /**\n', '     * The address whcih deploys this contrcat is automatically assgined ownership.\n', '     * */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Functions with this modifier can only be executed by the owner of the contract. \n', '     * */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed from, address indexed to);\n', '\n', '    /**\n', '    * Transfers ownership to new Ethereum address. This function can only be called by the \n', '    * owner.\n', '    * @param _newOwner the address to be granted ownership.\n', '    **/\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != 0x0);\n', '        OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    /**\n', "     * Transfers tokens from the sender's account to another given account.\n", '     * \n', '     * @param _to The address of the recipient.\n', '     * @param _amount The amount of tokens to send.\n', '     * */\n', '    function transfer(address _to, uint256 _amount) public returns (bool) {\n', '        require(balances[msg.sender] >= _amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Returns the balance of a given address.\n', '     * \n', '     * @param _addr The address of the balance to query.\n', '     **/\n', '    function balanceOf(address _addr) public constant returns (uint256) {\n', '        return balances[_addr];\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant public returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public  returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract AdvancedToken is BasicToken, ERC20 {\n', '\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '    /**\n', '     * Transfers tokens from the account of the owner by an approved spender. \n', '     * The spender cannot spend more than the approved amount. \n', '     * \n', '     * @param _from The address of the owners account.\n', '     * @param _amount The amount of tokens to transfer.\n', '     * */\n', '    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {\n', '        require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);\n', '        allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);\n', '        balances[_from] = balances[_from].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Allows another account to spend a given amount of tokens on behalf of the \n', "     * sender's account.\n", '     * \n', '     * @param _spender The address of the spenders account.\n', '     * @param _amount The amount of tokens the spender is allowed to spend.\n', '     * */\n', '    function approve(address _spender, uint256 _amount) public returns (bool) {\n', '        allowances[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', "     * Increases the amount a given account can spend on behalf of the sender's \n", '     * account.\n', '     * \n', '     * @param _spender The address of the spenders account.\n', '     * @param _amount The amount of tokens the spender is allowed to spend.\n', '     * */\n', '    function increaseApproval(address _spender, uint256 _amount) public returns (bool) {\n', '        allowances[msg.sender][_spender] = allowances[msg.sender][_spender].add(_amount);\n', '        Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Decreases the amount of tokens a given account can spend on behalf of the \n', "     * sender's account.\n", '     * \n', '     * @param _spender The address of the spenders account.\n', '     * @param _amount The amount of tokens the spender is allowed to spend.\n', '     * */\n', '    function decreaseApproval(address _spender, uint256 _amount) public returns (bool) {\n', '        require(allowances[msg.sender][_spender] != 0);\n', '        if (_amount >= allowances[msg.sender][_spender]) {\n', '            allowances[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowances[msg.sender][_spender] = allowances[msg.sender][_spender].sub(_amount);\n', '            Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns the approved allowance from an owners account to a spenders account.\n', '     * \n', '     * @param _owner The address of the owners account.\n', '     * @param _spender The address of the spenders account.\n', '     **/\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is AdvancedToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0 && _value <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(msg.sender, _value);\n', '    }\n', '}\n', '\n', '\n', 'contract UWC is BurnableToken {\n', '\n', '    function UWC() public {\n', '        name = "Ubuntuwealthclub";\n', '        symbol = "UWC";\n', '        decimals = 18;\n', '        totalSupply = 200000000e18;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '}']
