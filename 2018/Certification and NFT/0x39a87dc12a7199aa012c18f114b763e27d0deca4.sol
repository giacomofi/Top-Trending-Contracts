['pragma solidity ^0.4.19;\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// Based on the final ERC20 specification at:\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function name() public view returns (string);\n', '    function symbol() public view returns (string);\n', '    function decimals() public view returns (uint8);\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract ERC20Token is ERC20Interface {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string  private tokenName;\n', '    string  private tokenSymbol;\n', '    uint8   private tokenDecimals;\n', '    uint256 internal tokenTotalSupply;\n', '    uint256 public publicReservedToken;\n', '    uint256 public tokenConversionFactor = 10**4;\n', '    mapping(address => uint256) internal balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    function ERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply,address _publicReserved,uint256 _publicReservedPersentage,address[] boardReserved,uint256[] boardReservedPersentage) public {\n', '        tokenName = _name;\n', '        tokenSymbol = _symbol;\n', '        tokenDecimals = _decimals;\n', '        tokenTotalSupply = _totalSupply;\n', '\n', '        // The initial Public Reserved balance of tokens is assigned to the given token holder address.\n', '        // from total supple 90% tokens assign to public reserved  holder\n', '        publicReservedToken = _totalSupply.mul(_publicReservedPersentage).div(tokenConversionFactor);\n', '        balances[_publicReserved] = publicReservedToken;\n', '\n', '        //10 persentage token available for board members\n', '        uint256 boardReservedToken = _totalSupply.sub(publicReservedToken);\n', '\n', '        // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.\n', '        Transfer(0x0, _publicReserved, publicReservedToken);\n', '\n', '        // The initial Board Reserved balance of tokens is assigned to the given token holder address.\n', '        uint256 persentageSum = 0;\n', '        for(uint i=0; i<boardReserved.length; i++){\n', '            //\n', '            persentageSum = persentageSum.add(boardReservedPersentage[i]);\n', '            require(persentageSum <= 10000);\n', '            //assigning board members persentage tokens to particular board member address.\n', '            uint256 token = boardReservedToken.mul(boardReservedPersentage[i]).div(tokenConversionFactor);\n', '            balances[boardReserved[i]] = token;\n', '            Transfer(0x0, boardReserved[i], token);\n', '        }\n', '\n', '    }\n', '\n', '\n', '    function name() public view returns (string) {\n', '        return tokenName;\n', '    }\n', '\n', '\n', '    function symbol() public view returns (string) {\n', '        return tokenSymbol;\n', '    }\n', '\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return tokenDecimals;\n', '    }\n', '\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return tokenTotalSupply;\n', '    }\n', '\n', '    // Get the token balance for account `tokenOwner`\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        uint256 fromBalance = balances[msg.sender];\n', '        if (fromBalance < _value) return false;\n', '        if (_value > 0 && msg.sender != _to) {\n', '          balances[msg.sender] = fromBalance.sub(_value);\n', '          balances[_to] = balances[_to].add(_value);\n', '        }\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    // Send `tokens` amount of tokens from address `from` to address `to`\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        \n', '        uint256 spenderAllowance = allowed [_from][msg.sender];\n', '        if (spenderAllowance < _value) return false;\n', '        uint256 fromBalance = balances [_from];\n', '        if (fromBalance < _value) return false;\n', '    \n', '        allowed [_from][msg.sender] = spenderAllowance.sub(_value);\n', '    \n', '        if (_value > 0 && _from != _to) {\n', '          balances [_from] = fromBalance.add(_value);\n', '          balances [_to] = balances[_to].add(_value);\n', '        }\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '    address public proposedOwner = address(0);\n', '\n', '    event OwnershipTransferInitiated(address indexed _proposedOwner);\n', '    event OwnershipTransferCompleted(address indexed _newOwner);\n', '    event OwnershipTransferCanceled();\n', '\n', '\n', '    function Owned() public\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(msg.sender));\n', '        _;\n', '    }\n', '\n', '\n', '    function isOwner(address _address) public view returns (bool) {\n', '        return (_address == owner);\n', '    }\n', '\n', '\n', '    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {\n', '        require(_proposedOwner != address(0));\n', '        require(_proposedOwner != address(this));\n', '        require(_proposedOwner != owner);\n', '\n', '        proposedOwner = _proposedOwner;\n', '\n', '        OwnershipTransferInitiated(proposedOwner);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function cancelOwnershipTransfer() public onlyOwner returns (bool) {\n', '        //if proposedOwner address already address(0) then it will return true.\n', '        if (proposedOwner == address(0)) {\n', '            return true;\n', '        }\n', '        //if not then first it will do address(0) then it will return true.\n', '        proposedOwner = address(0);\n', '\n', '        OwnershipTransferCanceled();\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function completeOwnershipTransfer() public returns (bool) {\n', '\n', '        require(msg.sender == proposedOwner);\n', '\n', '        owner = msg.sender;\n', '        proposedOwner = address(0);\n', '\n', '        OwnershipTransferCompleted(owner);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract FinalizableToken is ERC20Token, Owned {\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '    /**\n', '         * @dev Call publicReservedAddress - library function exposed for testing.\n', '    */\n', '    address public publicReservedAddress;\n', '\n', '    //board members time list\n', '    mapping(address=>uint) private boardReservedAccount;\n', '    uint256[] public BOARD_RESERVED_YEARS = [1 years,2 years,3 years,4 years,5 years,6 years,7 years,8 years,9 years,10 years];\n', '    \n', '    event Burn(address indexed burner,uint256 value);\n', '\n', '    // The constructor will assign the initial token supply to the owner (msg.sender).\n', '    function FinalizableToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply,address _publicReserved,uint256 _publicReservedPersentage,address[] _boardReserved,uint256[] _boardReservedPersentage) public\n', '    ERC20Token(_name, _symbol, _decimals, _totalSupply, _publicReserved, _publicReservedPersentage, _boardReserved, _boardReservedPersentage)\n', '    Owned(){\n', '        publicReservedAddress = _publicReserved;\n', '        for(uint i=0; i<_boardReserved.length; i++){\n', '            boardReservedAccount[_boardReserved[i]] = currentTime() + BOARD_RESERVED_YEARS[i];\n', '        }\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(validateTransfer(msg.sender, _to));\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(validateTransfer(msg.sender, _to));\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '\n', '    function validateTransfer(address _sender, address _to) private view returns(bool) {\n', '        //check null address\n', '        require(_to != address(0));\n', '        \n', '        //check board member address\n', '        uint256 time = boardReservedAccount[_sender];\n', '        if (time == 0) {\n', '            //if not then return and allow for transfer\n', '            return true;\n', '        }else{\n', '            // else  then check allowed token for board member\n', '            return currentTime() > time;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        tokenTotalSupply = tokenTotalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '    \n', '     //get current time\n', '    function currentTime() public constant returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '}\n', '\n', 'contract DOCTokenConfig {\n', '\n', '    string  public constant TOKEN_SYMBOL      = "DOC";\n', '    string  public constant TOKEN_NAME        = "DOMUSCOINS Token";\n', '    uint8   public constant TOKEN_DECIMALS    = 18;\n', '\n', '    uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);\n', '    uint256 public constant TOKEN_TOTALSUPPLY = 1000000000 * DECIMALSFACTOR;\n', '\n', '    address public constant PUBLIC_RESERVED = 0xcd6b3d0c0dd850bad071cd20e428940d2e25120f;\n', '    uint256 public constant PUBLIC_RESERVED_PERSENTAGE = 9000;\n', '\n', '    address[] public BOARD_RESERVED = [ 0x91cdb4c96d43591432fba178b672800b30266d63,\n', '    0x5a4dd8f6fc098869fa306c4143b281f214384de4,\n', '    0x2e067592283a463f9b425165c3bde40bc6cf8309,\n', '    0x49cbdc6c74b57eeccd6487999c2170a723193851,\n', '    0xd6c723a5fbe81e9744ac1a72767ba0744f67e713,\n', '    0x81409970ed8b78769eb58d62c0bf0371dad772e1,\n', '    0x13505e4fe6bdc6813b5e6fb63c44ac9ed4ac44ac,\n', '    0x87da1a7e6d460cad057740ef56f0c223dc572ebb,\n', '    0x05cb91a12b8da165f19cd4f81002566b0383cef7,\n', '    0xaf68b2dc937301d84d6d350d9beec880448dbac0\n', '    ];\n', '\n', '    uint256[] public BOARD_RESERVED_PERSENTAGE = [200,200,200,500,500,1000,1000,2000,2000,2400];\n', '\n', '}\n', '\n', 'contract DOCToken is FinalizableToken, DOCTokenConfig {\n', '\n', '    using SafeMath for uint256;\n', '    event TokensReclaimed(uint256 _amount);\n', '\n', '    function DOCToken() public\n', '    FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY, PUBLIC_RESERVED, PUBLIC_RESERVED_PERSENTAGE, BOARD_RESERVED, BOARD_RESERVED_PERSENTAGE)\n', '    {\n', '\n', '    }\n', '\n', '\n', '    // Allows the owner to reclaim tokens that have been sent to the token address itself.\n', '    function reclaimTokens() public onlyOwner returns (bool) {\n', '\n', '        address account = address(this);\n', '        uint256 amount  = balanceOf(account);\n', '\n', '        if (amount == 0) {\n', '            return false;\n', '        }\n', '\n', '        balances[account] = balances[account].sub(amount);\n', '        balances[owner] = balances[owner].add(amount);\n', '\n', '        Transfer(account, owner, amount);\n', '\n', '        TokensReclaimed(amount);\n', '\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// Based on the final ERC20 specification at:\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function name() public view returns (string);\n', '    function symbol() public view returns (string);\n', '    function decimals() public view returns (uint8);\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract ERC20Token is ERC20Interface {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string  private tokenName;\n', '    string  private tokenSymbol;\n', '    uint8   private tokenDecimals;\n', '    uint256 internal tokenTotalSupply;\n', '    uint256 public publicReservedToken;\n', '    uint256 public tokenConversionFactor = 10**4;\n', '    mapping(address => uint256) internal balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    function ERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply,address _publicReserved,uint256 _publicReservedPersentage,address[] boardReserved,uint256[] boardReservedPersentage) public {\n', '        tokenName = _name;\n', '        tokenSymbol = _symbol;\n', '        tokenDecimals = _decimals;\n', '        tokenTotalSupply = _totalSupply;\n', '\n', '        // The initial Public Reserved balance of tokens is assigned to the given token holder address.\n', '        // from total supple 90% tokens assign to public reserved  holder\n', '        publicReservedToken = _totalSupply.mul(_publicReservedPersentage).div(tokenConversionFactor);\n', '        balances[_publicReserved] = publicReservedToken;\n', '\n', '        //10 persentage token available for board members\n', '        uint256 boardReservedToken = _totalSupply.sub(publicReservedToken);\n', '\n', '        // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.\n', '        Transfer(0x0, _publicReserved, publicReservedToken);\n', '\n', '        // The initial Board Reserved balance of tokens is assigned to the given token holder address.\n', '        uint256 persentageSum = 0;\n', '        for(uint i=0; i<boardReserved.length; i++){\n', '            //\n', '            persentageSum = persentageSum.add(boardReservedPersentage[i]);\n', '            require(persentageSum <= 10000);\n', '            //assigning board members persentage tokens to particular board member address.\n', '            uint256 token = boardReservedToken.mul(boardReservedPersentage[i]).div(tokenConversionFactor);\n', '            balances[boardReserved[i]] = token;\n', '            Transfer(0x0, boardReserved[i], token);\n', '        }\n', '\n', '    }\n', '\n', '\n', '    function name() public view returns (string) {\n', '        return tokenName;\n', '    }\n', '\n', '\n', '    function symbol() public view returns (string) {\n', '        return tokenSymbol;\n', '    }\n', '\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return tokenDecimals;\n', '    }\n', '\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return tokenTotalSupply;\n', '    }\n', '\n', '    // Get the token balance for account `tokenOwner`\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        uint256 fromBalance = balances[msg.sender];\n', '        if (fromBalance < _value) return false;\n', '        if (_value > 0 && msg.sender != _to) {\n', '          balances[msg.sender] = fromBalance.sub(_value);\n', '          balances[_to] = balances[_to].add(_value);\n', '        }\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    // Send `tokens` amount of tokens from address `from` to address `to`\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        \n', '        uint256 spenderAllowance = allowed [_from][msg.sender];\n', '        if (spenderAllowance < _value) return false;\n', '        uint256 fromBalance = balances [_from];\n', '        if (fromBalance < _value) return false;\n', '    \n', '        allowed [_from][msg.sender] = spenderAllowance.sub(_value);\n', '    \n', '        if (_value > 0 && _from != _to) {\n', '          balances [_from] = fromBalance.add(_value);\n', '          balances [_to] = balances[_to].add(_value);\n', '        }\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '    address public proposedOwner = address(0);\n', '\n', '    event OwnershipTransferInitiated(address indexed _proposedOwner);\n', '    event OwnershipTransferCompleted(address indexed _newOwner);\n', '    event OwnershipTransferCanceled();\n', '\n', '\n', '    function Owned() public\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(msg.sender));\n', '        _;\n', '    }\n', '\n', '\n', '    function isOwner(address _address) public view returns (bool) {\n', '        return (_address == owner);\n', '    }\n', '\n', '\n', '    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {\n', '        require(_proposedOwner != address(0));\n', '        require(_proposedOwner != address(this));\n', '        require(_proposedOwner != owner);\n', '\n', '        proposedOwner = _proposedOwner;\n', '\n', '        OwnershipTransferInitiated(proposedOwner);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function cancelOwnershipTransfer() public onlyOwner returns (bool) {\n', '        //if proposedOwner address already address(0) then it will return true.\n', '        if (proposedOwner == address(0)) {\n', '            return true;\n', '        }\n', '        //if not then first it will do address(0) then it will return true.\n', '        proposedOwner = address(0);\n', '\n', '        OwnershipTransferCanceled();\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function completeOwnershipTransfer() public returns (bool) {\n', '\n', '        require(msg.sender == proposedOwner);\n', '\n', '        owner = msg.sender;\n', '        proposedOwner = address(0);\n', '\n', '        OwnershipTransferCompleted(owner);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract FinalizableToken is ERC20Token, Owned {\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '    /**\n', '         * @dev Call publicReservedAddress - library function exposed for testing.\n', '    */\n', '    address public publicReservedAddress;\n', '\n', '    //board members time list\n', '    mapping(address=>uint) private boardReservedAccount;\n', '    uint256[] public BOARD_RESERVED_YEARS = [1 years,2 years,3 years,4 years,5 years,6 years,7 years,8 years,9 years,10 years];\n', '    \n', '    event Burn(address indexed burner,uint256 value);\n', '\n', '    // The constructor will assign the initial token supply to the owner (msg.sender).\n', '    function FinalizableToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply,address _publicReserved,uint256 _publicReservedPersentage,address[] _boardReserved,uint256[] _boardReservedPersentage) public\n', '    ERC20Token(_name, _symbol, _decimals, _totalSupply, _publicReserved, _publicReservedPersentage, _boardReserved, _boardReservedPersentage)\n', '    Owned(){\n', '        publicReservedAddress = _publicReserved;\n', '        for(uint i=0; i<_boardReserved.length; i++){\n', '            boardReservedAccount[_boardReserved[i]] = currentTime() + BOARD_RESERVED_YEARS[i];\n', '        }\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(validateTransfer(msg.sender, _to));\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(validateTransfer(msg.sender, _to));\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '\n', '    function validateTransfer(address _sender, address _to) private view returns(bool) {\n', '        //check null address\n', '        require(_to != address(0));\n', '        \n', '        //check board member address\n', '        uint256 time = boardReservedAccount[_sender];\n', '        if (time == 0) {\n', '            //if not then return and allow for transfer\n', '            return true;\n', '        }else{\n', '            // else  then check allowed token for board member\n', '            return currentTime() > time;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        tokenTotalSupply = tokenTotalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '    \n', '     //get current time\n', '    function currentTime() public constant returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '}\n', '\n', 'contract DOCTokenConfig {\n', '\n', '    string  public constant TOKEN_SYMBOL      = "DOC";\n', '    string  public constant TOKEN_NAME        = "DOMUSCOINS Token";\n', '    uint8   public constant TOKEN_DECIMALS    = 18;\n', '\n', '    uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);\n', '    uint256 public constant TOKEN_TOTALSUPPLY = 1000000000 * DECIMALSFACTOR;\n', '\n', '    address public constant PUBLIC_RESERVED = 0xcd6b3d0c0dd850bad071cd20e428940d2e25120f;\n', '    uint256 public constant PUBLIC_RESERVED_PERSENTAGE = 9000;\n', '\n', '    address[] public BOARD_RESERVED = [ 0x91cdb4c96d43591432fba178b672800b30266d63,\n', '    0x5a4dd8f6fc098869fa306c4143b281f214384de4,\n', '    0x2e067592283a463f9b425165c3bde40bc6cf8309,\n', '    0x49cbdc6c74b57eeccd6487999c2170a723193851,\n', '    0xd6c723a5fbe81e9744ac1a72767ba0744f67e713,\n', '    0x81409970ed8b78769eb58d62c0bf0371dad772e1,\n', '    0x13505e4fe6bdc6813b5e6fb63c44ac9ed4ac44ac,\n', '    0x87da1a7e6d460cad057740ef56f0c223dc572ebb,\n', '    0x05cb91a12b8da165f19cd4f81002566b0383cef7,\n', '    0xaf68b2dc937301d84d6d350d9beec880448dbac0\n', '    ];\n', '\n', '    uint256[] public BOARD_RESERVED_PERSENTAGE = [200,200,200,500,500,1000,1000,2000,2000,2400];\n', '\n', '}\n', '\n', 'contract DOCToken is FinalizableToken, DOCTokenConfig {\n', '\n', '    using SafeMath for uint256;\n', '    event TokensReclaimed(uint256 _amount);\n', '\n', '    function DOCToken() public\n', '    FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY, PUBLIC_RESERVED, PUBLIC_RESERVED_PERSENTAGE, BOARD_RESERVED, BOARD_RESERVED_PERSENTAGE)\n', '    {\n', '\n', '    }\n', '\n', '\n', '    // Allows the owner to reclaim tokens that have been sent to the token address itself.\n', '    function reclaimTokens() public onlyOwner returns (bool) {\n', '\n', '        address account = address(this);\n', '        uint256 amount  = balanceOf(account);\n', '\n', '        if (amount == 0) {\n', '            return false;\n', '        }\n', '\n', '        balances[account] = balances[account].sub(amount);\n', '        balances[owner] = balances[owner].add(amount);\n', '\n', '        Transfer(account, owner, amount);\n', '\n', '        TokensReclaimed(amount);\n', '\n', '        return true;\n', '    }\n', '}']
