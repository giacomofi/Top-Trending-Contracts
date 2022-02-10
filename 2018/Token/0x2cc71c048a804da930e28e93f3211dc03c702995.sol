['pragma solidity 0.4.21;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint a, uint b) internal pure  returns(uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure  returns(uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure  returns(uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(address(0) != _newOwner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, msg.sender);\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) public view returns(uint);\n', '\n', '    function allowance(address owner, address spender) public view returns(uint);\n', '\n', '    function transfer(address to, uint value) public returns(bool ok);\n', '\n', '    function transferFrom(address from, address to, uint value) public returns(bool ok);\n', '\n', '    function approve(address spender, uint value) public returns(bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '// The token\n', 'contract Token is ERC20, Ownable {\n', '\n', '    using SafeMath for uint;\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals; // How many decimals to show.\n', '    string public version = "v0.1";\n', '    uint public totalSupply;\n', '    bool public locked;\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    address public crowdSaleAddress;\n', '\n', '\n', '    // Lock transfer for contributors during the ICO\n', '    modifier onlyUnlocked() {\n', '        if (msg.sender != crowdSaleAddress && msg.sender != owner && locked)\n', '            revert();\n', '        _;\n', '    }\n', '\n', '    modifier onlyAuthorized() {\n', '        if (msg.sender != owner && msg.sender != crowdSaleAddress)\n', '            revert();\n', '        _;\n', '    }\n', '\n', '    // @notice The Token contract\n', '    function Token(address _crowdsaleAddress) public {\n', '\n', '        require(_crowdsaleAddress != address(0));\n', '        locked = true; // Lock the transfer of tokens during the crowdsale\n', '        totalSupply = 2600000000e8;\n', '        name = "Kripton";                           // Set the name for display purposes\n', '        symbol = "LPK";                             // Set the symbol for display purposes\n', '        decimals = 8;                               // Amount of decimals\n', '        crowdSaleAddress = _crowdsaleAddress;\n', '        balances[_crowdsaleAddress] = totalSupply;\n', '    }\n', '\n', '    // @notice unlock token for trading\n', '    function unlock() public onlyAuthorized {\n', '        locked = false;\n', '    }\n', '\n', '    // @lock token from trading during ICO\n', '    function lock() public onlyAuthorized {\n', '        locked = true;\n', '    }\n', '\n', '    // @notice transfer tokens to given address\n', '    // @param _to {address} address or recipient\n', '    // @param _value {uint} amount to transfer\n', '    // @return  {bool} true if successful\n', '    function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice transfer tokens from given address to another address\n', '    // @param _from {address} from whom tokens are transferred\n', '    // @param _to {address} to whom tokens are transferred\n', '    // @parm _value {uint} amount of tokens to transfer\n', '    // @return  {bool} true if successful\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {\n', '        require(balances[_from] >= _value); // Check if the sender has enough\n', '        require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal\n', '        balances[_from] = balances[_from].sub(_value); // Subtract from the sender\n', '        balances[_to] = balances[_to].add(_value); // Add the same to the recipient\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice to query balance of account\n', '    // @return _owner {address} address of user to query balance\n', '    function balanceOf(address _owner) public view returns(uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '    * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice to query of allowance of one user to the other\n', '    // @param _owner {address} of the owner of the account\n', '    // @param _spender {address} of the spender of the account\n', '    // @return remaining {uint} amount of remaining allowance\n', '    function allowance(address _owner, address _spender) public view returns(uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity 0.4.21;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint a, uint b) internal pure  returns(uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure  returns(uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure  returns(uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(address(0) != _newOwner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, msg.sender);\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) public view returns(uint);\n', '\n', '    function allowance(address owner, address spender) public view returns(uint);\n', '\n', '    function transfer(address to, uint value) public returns(bool ok);\n', '\n', '    function transferFrom(address from, address to, uint value) public returns(bool ok);\n', '\n', '    function approve(address spender, uint value) public returns(bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '// The token\n', 'contract Token is ERC20, Ownable {\n', '\n', '    using SafeMath for uint;\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals; // How many decimals to show.\n', '    string public version = "v0.1";\n', '    uint public totalSupply;\n', '    bool public locked;\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    address public crowdSaleAddress;\n', '\n', '\n', '    // Lock transfer for contributors during the ICO\n', '    modifier onlyUnlocked() {\n', '        if (msg.sender != crowdSaleAddress && msg.sender != owner && locked)\n', '            revert();\n', '        _;\n', '    }\n', '\n', '    modifier onlyAuthorized() {\n', '        if (msg.sender != owner && msg.sender != crowdSaleAddress)\n', '            revert();\n', '        _;\n', '    }\n', '\n', '    // @notice The Token contract\n', '    function Token(address _crowdsaleAddress) public {\n', '\n', '        require(_crowdsaleAddress != address(0));\n', '        locked = true; // Lock the transfer of tokens during the crowdsale\n', '        totalSupply = 2600000000e8;\n', '        name = "Kripton";                           // Set the name for display purposes\n', '        symbol = "LPK";                             // Set the symbol for display purposes\n', '        decimals = 8;                               // Amount of decimals\n', '        crowdSaleAddress = _crowdsaleAddress;\n', '        balances[_crowdsaleAddress] = totalSupply;\n', '    }\n', '\n', '    // @notice unlock token for trading\n', '    function unlock() public onlyAuthorized {\n', '        locked = false;\n', '    }\n', '\n', '    // @lock token from trading during ICO\n', '    function lock() public onlyAuthorized {\n', '        locked = true;\n', '    }\n', '\n', '    // @notice transfer tokens to given address\n', '    // @param _to {address} address or recipient\n', '    // @param _value {uint} amount to transfer\n', '    // @return  {bool} true if successful\n', '    function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice transfer tokens from given address to another address\n', '    // @param _from {address} from whom tokens are transferred\n', '    // @param _to {address} to whom tokens are transferred\n', '    // @parm _value {uint} amount of tokens to transfer\n', '    // @return  {bool} true if successful\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {\n', '        require(balances[_from] >= _value); // Check if the sender has enough\n', '        require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal\n', '        balances[_from] = balances[_from].sub(_value); // Subtract from the sender\n', '        balances[_to] = balances[_to].add(_value); // Add the same to the recipient\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice to query balance of account\n', '    // @return _owner {address} address of user to query balance\n', '    function balanceOf(address _owner) public view returns(uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice to query of allowance of one user to the other\n', '    // @param _owner {address} of the owner of the account\n', '    // @param _spender {address} of the spender of the account\n', '    // @return remaining {uint} amount of remaining allowance\n', '    function allowance(address _owner, address _spender) public view returns(uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}']