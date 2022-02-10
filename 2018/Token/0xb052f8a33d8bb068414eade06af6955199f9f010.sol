['pragma solidity  0.4.21;\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint a, uint b) internal pure returns(uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure  returns(uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal  pure returns(uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) public view returns(uint);\n', '\n', '    function allowance(address owner, address spender) public view returns(uint);\n', '\n', '    function transfer(address to, uint value) public returns(bool ok);\n', '\n', '    function transferFrom(address from, address to, uint value) public returns(bool ok);\n', '\n', '    function approve(address spender, uint value) public returns(bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '// The  Exchange token\n', 'contract MultiToken is ERC20, Ownable {\n', '\n', '    using SafeMath for uint;\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals; // How many decimals to show.\n', '    string public version;\n', '    uint public totalSupply;\n', '    uint public tokenPrice;\n', '    bool public exchangeEnabled;\n', '    bool public codeExportEnabled;\n', '  \n', '    mapping(address => uint) public balances;\n', '    mapping(address => mapping(address => uint)) public allowed;\n', '\n', '\n', '    // The Token constructor     \n', '    function MultiToken(uint _initialSupply,\n', '                        string _tokenName,\n', '                        uint _decimalUnits,\n', '                        string _tokenSymbol,\n', '                        string _version,                       \n', '                        uint _tokenPrice\n', '                        ) public \n', '    {\n', '\n', '        totalSupply = _initialSupply * (10**_decimalUnits);                                             \n', '        name = _tokenName;          // Set the name for display purposes\n', '        symbol = _tokenSymbol;      // Set the symbol for display purposes\n', '        decimals = _decimalUnits;   // Amount of decimals for display purposes\n', '        version = _version;         // Version of token\n', '        tokenPrice = _tokenPrice;   // Token price in ETH           \n', '        balances[0xeadA6cDDC45656d0E72089997eE3d6D4383Bce89] = totalSupply;    \n', '        codeExportEnabled = true;\n', '        exchangeEnabled = true;            \n', '        \n', '             \n', '    }\n', '\n', '    event TransferSold(address indexed to, uint value);\n', '    event TokenExchangeEnabled(address caller, uint exchangeCost);\n', '    event TokenExportEnabled(address caller, uint enableCost);\n', '\n', '\n', '    // @notice It will send tokens to sender based on the token price    \n', '    function swapTokens() public payable {     \n', '\n', '        require(exchangeEnabled);   \n', '        uint tokensToSend;\n', '        tokensToSend = (msg.value * (10**decimals)) / tokenPrice; \n', '        require(balances[owner] >= tokensToSend);\n', '        balances[msg.sender] += tokensToSend;\n', '        balances[owner] -= tokensToSend;\n', '        owner.transfer(msg.value);\n', '        emit Transfer(owner, msg.sender, tokensToSend);\n', '        emit TransferSold(msg.sender, tokensToSend);       \n', '    }\n', '\n', '\n', '    // @notice will be able to mint tokens in the future\n', '    // @param _target {address} address to which new tokens will be assigned\n', '    // @parm _mintedAmount {uint256} amouont of tokens to mint\n', '    function mintToken(address _target, uint256 _mintedAmount) public onlyOwner() {        \n', '        \n', '        balances[_target] += _mintedAmount;\n', '        totalSupply += _mintedAmount;\n', '        emit Transfer(0, _target, _mintedAmount);       \n', '    }\n', '  \n', '    // @notice transfer tokens to given address\n', '    // @param _to {address} address or recipient\n', '    // @param _value {uint} amount to transfer\n', '    // @return  {bool} true if successful\n', '    function transfer(address _to, uint _value) public returns(bool) {\n', '\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice transfer tokens from given address to another address\n', '    // @param _from {address} from whom tokens are transferred\n', '    // @param _to {address} to whom tokens are transferred\n', '    // @param _value {uint} amount of tokens to transfer\n', '    // @return  {bool} true if successful\n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns(bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value); // Check if the sender has enough\n', '        require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal\n', '        balances[_from] = balances[_from].sub(_value); // Subtract from the sender\n', '        balances[_to] = balances[_to].add(_value); // Add the same to the recipient\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // adjust allowed\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice to query balance of account\n', '    // @return _owner {address} address of user to query balance\n', '    function balanceOf(address _owner) public view returns(uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '    * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice to query of allowance of one user to the other\n', '    // @param _owner {address} of the owner of the account\n', '    // @param _spender {address} of the spender of the account\n', '    // @return remaining {uint} amount of remaining allowance\n', '    function allowance(address _owner, address _spender) public view returns(uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity  0.4.21;\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint a, uint b) internal pure returns(uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure  returns(uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal  pure returns(uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) public view returns(uint);\n', '\n', '    function allowance(address owner, address spender) public view returns(uint);\n', '\n', '    function transfer(address to, uint value) public returns(bool ok);\n', '\n', '    function transferFrom(address from, address to, uint value) public returns(bool ok);\n', '\n', '    function approve(address spender, uint value) public returns(bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '// The  Exchange token\n', 'contract MultiToken is ERC20, Ownable {\n', '\n', '    using SafeMath for uint;\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals; // How many decimals to show.\n', '    string public version;\n', '    uint public totalSupply;\n', '    uint public tokenPrice;\n', '    bool public exchangeEnabled;\n', '    bool public codeExportEnabled;\n', '  \n', '    mapping(address => uint) public balances;\n', '    mapping(address => mapping(address => uint)) public allowed;\n', '\n', '\n', '    // The Token constructor     \n', '    function MultiToken(uint _initialSupply,\n', '                        string _tokenName,\n', '                        uint _decimalUnits,\n', '                        string _tokenSymbol,\n', '                        string _version,                       \n', '                        uint _tokenPrice\n', '                        ) public \n', '    {\n', '\n', '        totalSupply = _initialSupply * (10**_decimalUnits);                                             \n', '        name = _tokenName;          // Set the name for display purposes\n', '        symbol = _tokenSymbol;      // Set the symbol for display purposes\n', '        decimals = _decimalUnits;   // Amount of decimals for display purposes\n', '        version = _version;         // Version of token\n', '        tokenPrice = _tokenPrice;   // Token price in ETH           \n', '        balances[0xeadA6cDDC45656d0E72089997eE3d6D4383Bce89] = totalSupply;    \n', '        codeExportEnabled = true;\n', '        exchangeEnabled = true;            \n', '        \n', '             \n', '    }\n', '\n', '    event TransferSold(address indexed to, uint value);\n', '    event TokenExchangeEnabled(address caller, uint exchangeCost);\n', '    event TokenExportEnabled(address caller, uint enableCost);\n', '\n', '\n', '    // @notice It will send tokens to sender based on the token price    \n', '    function swapTokens() public payable {     \n', '\n', '        require(exchangeEnabled);   \n', '        uint tokensToSend;\n', '        tokensToSend = (msg.value * (10**decimals)) / tokenPrice; \n', '        require(balances[owner] >= tokensToSend);\n', '        balances[msg.sender] += tokensToSend;\n', '        balances[owner] -= tokensToSend;\n', '        owner.transfer(msg.value);\n', '        emit Transfer(owner, msg.sender, tokensToSend);\n', '        emit TransferSold(msg.sender, tokensToSend);       \n', '    }\n', '\n', '\n', '    // @notice will be able to mint tokens in the future\n', '    // @param _target {address} address to which new tokens will be assigned\n', '    // @parm _mintedAmount {uint256} amouont of tokens to mint\n', '    function mintToken(address _target, uint256 _mintedAmount) public onlyOwner() {        \n', '        \n', '        balances[_target] += _mintedAmount;\n', '        totalSupply += _mintedAmount;\n', '        emit Transfer(0, _target, _mintedAmount);       \n', '    }\n', '  \n', '    // @notice transfer tokens to given address\n', '    // @param _to {address} address or recipient\n', '    // @param _value {uint} amount to transfer\n', '    // @return  {bool} true if successful\n', '    function transfer(address _to, uint _value) public returns(bool) {\n', '\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice transfer tokens from given address to another address\n', '    // @param _from {address} from whom tokens are transferred\n', '    // @param _to {address} to whom tokens are transferred\n', '    // @param _value {uint} amount of tokens to transfer\n', '    // @return  {bool} true if successful\n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns(bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value); // Check if the sender has enough\n', '        require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal\n', '        balances[_from] = balances[_from].sub(_value); // Subtract from the sender\n', '        balances[_to] = balances[_to].add(_value); // Add the same to the recipient\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // adjust allowed\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice to query balance of account\n', '    // @return _owner {address} address of user to query balance\n', '    function balanceOf(address _owner) public view returns(uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // @notice to query of allowance of one user to the other\n', '    // @param _owner {address} of the owner of the account\n', '    // @param _spender {address} of the spender of the account\n', '    // @return remaining {uint} amount of remaining allowance\n', '    function allowance(address _owner, address _spender) public view returns(uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}']
