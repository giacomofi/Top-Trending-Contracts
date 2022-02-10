['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface Raindrop {\n', '    function authenticate(address _sender, uint _value, uint _challenge, uint _partnerId) external;\n', '}\n', '\n', 'interface tokenRecipient {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;\n', '}\n', '\n', 'contract YoloToken is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "YoloCash";           //The Token&#39;s name: e.g. DigixDAO Tokens\n', '    uint8 public decimals = 8;             //Number of decimals of the smallest unit\n', '    string public symbol = "YLC";         //An identifier: e.g. REP\n', '    uint public totalSupply;\n', '    address public raindropAddress = 0x0;\n', '\n', '    mapping (address => uint256) public balances;\n', '    // `allowed` tracks any extra transfer rights as in all ERC20 tokens\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '////////////////\n', '// Constructor\n', '////////////////\n', '\n', '    /// @notice Constructor to create a YoloToken\n', '    function YoloToken() public {\n', '        totalSupply = 48888888e8;\n', '        // Give the creator all initial tokens\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '\n', '///////////////////\n', '// ERC20 Methods\n', '///////////////////\n', '\n', '    /// @notice Send `_amount` tokens to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '        doTransfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it\n', '    ///  is approved by `_from`\n', '    /// @param _from The address holding the tokens being transferred\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return True if the transfer was successful\n', '    function transferFrom(address _from, address _to, uint256 _amount\n', '    ) public returns (bool success) {\n', '        // The standard ERC 20 transferFrom functionality\n', '        require(allowed[_from][msg.sender] >= _amount);\n', '        allowed[_from][msg.sender] -= _amount;\n', '        doTransfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @dev This is the actual transfer function in the token contract, it can\n', '    ///  only be called by other functions in this contract.\n', '    /// @param _from The address holding the tokens being transferred\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return True if the transfer was successful\n', '    function doTransfer(address _from, address _to, uint _amount\n', '    ) internal {\n', '        // Do not allow transfer to 0x0 or the token contract itself\n', '        require((_to != 0) && (_to != address(this)));\n', '        require(_amount <= balances[_from]);\n', '        balances[_from] = balances[_from].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '    }\n', '\n', '    /// @return The balance of `_owner`\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on\n', '    ///  its behalf. This is a modified version of the ERC20 approve function\n', '    ///  to be a little bit safer\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _amount The amount of tokens to be approved for transfer\n', '    /// @return True if the approval was successful\n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender,0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _amount;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public onlyOwner {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '    }\n', '\n', '    /// @dev This function makes it easy to read the `allowed[]` map\n', '    /// @param _owner The address of the account that owns the token\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens of _owner that _spender is allowed\n', '    ///  to spend\n', '    function allowance(address _owner, address _spender\n', '    ) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /// @dev This function makes it easy to get the total number of tokens\n', '    /// @return The total number of tokens\n', '    function totalSupply() public constant returns (uint) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function setRaindropAddress(address _raindrop) public onlyOwner {\n', '        raindropAddress = _raindrop;\n', '    }\n', '\n', '    function authenticate(uint _value, uint _challenge, uint _partnerId) public {\n', '        Raindrop raindrop = Raindrop(raindropAddress);\n', '        raindrop.authenticate(msg.sender, _value, _challenge, _partnerId);\n', '        doTransfer(msg.sender, owner, _value);\n', '    }\n', '\n', '    function setBalances(address[] _addressList, uint[] _amounts) public onlyOwner {\n', '        require(_addressList.length == _amounts.length);\n', '        for (uint i = 0; i < _addressList.length; i++) {\n', '          require(balances[_addressList[i]] == 0);\n', '          transfer(_addressList[i], _amounts[i]);\n', '        }\n', '    }\n', '\n', '    event Transfer(\n', '        address indexed _from,\n', '        address indexed _to,\n', '        uint256 _amount\n', '        );\n', '\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _amount\n', '        );\n', '\n', '    event Burn(\n', '        address indexed _burner,\n', '        uint256 _amount\n', '        );\n', '    \n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface Raindrop {\n', '    function authenticate(address _sender, uint _value, uint _challenge, uint _partnerId) external;\n', '}\n', '\n', 'interface tokenRecipient {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;\n', '}\n', '\n', 'contract YoloToken is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "YoloCash";           //The Token\'s name: e.g. DigixDAO Tokens\n', '    uint8 public decimals = 8;             //Number of decimals of the smallest unit\n', '    string public symbol = "YLC";         //An identifier: e.g. REP\n', '    uint public totalSupply;\n', '    address public raindropAddress = 0x0;\n', '\n', '    mapping (address => uint256) public balances;\n', '    // `allowed` tracks any extra transfer rights as in all ERC20 tokens\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '////////////////\n', '// Constructor\n', '////////////////\n', '\n', '    /// @notice Constructor to create a YoloToken\n', '    function YoloToken() public {\n', '        totalSupply = 48888888e8;\n', '        // Give the creator all initial tokens\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '\n', '///////////////////\n', '// ERC20 Methods\n', '///////////////////\n', '\n', '    /// @notice Send `_amount` tokens to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '        doTransfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it\n', '    ///  is approved by `_from`\n', '    /// @param _from The address holding the tokens being transferred\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return True if the transfer was successful\n', '    function transferFrom(address _from, address _to, uint256 _amount\n', '    ) public returns (bool success) {\n', '        // The standard ERC 20 transferFrom functionality\n', '        require(allowed[_from][msg.sender] >= _amount);\n', '        allowed[_from][msg.sender] -= _amount;\n', '        doTransfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @dev This is the actual transfer function in the token contract, it can\n', '    ///  only be called by other functions in this contract.\n', '    /// @param _from The address holding the tokens being transferred\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return True if the transfer was successful\n', '    function doTransfer(address _from, address _to, uint _amount\n', '    ) internal {\n', '        // Do not allow transfer to 0x0 or the token contract itself\n', '        require((_to != 0) && (_to != address(this)));\n', '        require(_amount <= balances[_from]);\n', '        balances[_from] = balances[_from].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '    }\n', '\n', '    /// @return The balance of `_owner`\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on\n', '    ///  its behalf. This is a modified version of the ERC20 approve function\n', '    ///  to be a little bit safer\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _amount The amount of tokens to be approved for transfer\n', '    /// @return True if the approval was successful\n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender,0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _amount;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public onlyOwner {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '    }\n', '\n', '    /// @dev This function makes it easy to read the `allowed[]` map\n', '    /// @param _owner The address of the account that owns the token\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens of _owner that _spender is allowed\n', '    ///  to spend\n', '    function allowance(address _owner, address _spender\n', '    ) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /// @dev This function makes it easy to get the total number of tokens\n', '    /// @return The total number of tokens\n', '    function totalSupply() public constant returns (uint) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function setRaindropAddress(address _raindrop) public onlyOwner {\n', '        raindropAddress = _raindrop;\n', '    }\n', '\n', '    function authenticate(uint _value, uint _challenge, uint _partnerId) public {\n', '        Raindrop raindrop = Raindrop(raindropAddress);\n', '        raindrop.authenticate(msg.sender, _value, _challenge, _partnerId);\n', '        doTransfer(msg.sender, owner, _value);\n', '    }\n', '\n', '    function setBalances(address[] _addressList, uint[] _amounts) public onlyOwner {\n', '        require(_addressList.length == _amounts.length);\n', '        for (uint i = 0; i < _addressList.length; i++) {\n', '          require(balances[_addressList[i]] == 0);\n', '          transfer(_addressList[i], _amounts[i]);\n', '        }\n', '    }\n', '\n', '    event Transfer(\n', '        address indexed _from,\n', '        address indexed _to,\n', '        uint256 _amount\n', '        );\n', '\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _amount\n', '        );\n', '\n', '    event Burn(\n', '        address indexed _burner,\n', '        uint256 _amount\n', '        );\n', '    \n', '}']
