['pragma solidity ^0.4.24;\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '\n', '/**\n', '* @dev Multiplies two numbers, throws on overflow.\n', '*/\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '    /**\n', '    * @title Ownable\n', '    * @dev The Ownable contract has an owner address, and provides basic authorization control\n', '    * functions, this simplifies the implementation of "user permissions".\n', '    */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Lockable is Ownable {\n', '    uint256 public creationTime;\n', '    bool public tokenTransferLocker;\n', '    mapping(address => bool) lockaddress;\n', '\n', '    event Locked(address lockaddress);\n', '    event Unlocked(address lockaddress);\n', '    event TokenTransferLocker(bool _setto);\n', '\n', '    // if Token transfer\n', '    modifier isTokenTransfer {\n', '        // only contract holder can send token during locked period\n', '        if(msg.sender != owner) {\n', '            // if token transfer is not allow\n', '            require(!tokenTransferLocker);\n', '            if(lockaddress[msg.sender]){\n', '                revert();\n', '            }\n', '        }\n', '        _;\n', '    }\n', '\n', '    // This modifier check whether the contract should be in a locked\n', '    // or unlocked state, then acts and updates accordingly if\n', '    // necessary\n', '    modifier checkLock {\n', '        if (lockaddress[msg.sender]) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        creationTime = now;\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    function isTokenTransferLocked()\n', '    external\n', '    view\n', '    returns (bool)\n', '    {\n', '        return tokenTransferLocker;\n', '    }\n', '\n', '    function enableTokenTransfer()\n', '    external\n', '    onlyOwner\n', '    {\n', '        delete tokenTransferLocker;\n', '        emit TokenTransferLocker(false);\n', '    }\n', '\n', '    function disableTokenTransfer()\n', '    external\n', '    onlyOwner\n', '    {\n', '        tokenTransferLocker = true;\n', '        emit TokenTransferLocker(true);\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) view external returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract CoolPandaToken is ERC20, Lockable  {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public decimals = 18;\n', '    address public fundWallet = 0x071961b88F848D09C3d988E8814F38cbAE755C44;\n', '    uint256 public tokenPrice;\n', '\n', '    function balanceOf(address _addr) external view returns (uint256) {\n', '        return balances[_addr];\n', '    }\n', '\n', '    function allowance(address _from, address _spender) external view returns (uint256) {\n', '        return allowed[_from][_spender];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)\n', '    isTokenTransfer\n', '    public\n', '    returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value)\n', '    isTokenTransfer\n', '    external\n', '    returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '    isTokenTransfer\n', '    public\n', '    returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        isTokenTransfer\n', '        external\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function setFundWallet(address _newAddr) external onlyOwner {\n', '        require(_newAddr != address(0));\n', '        fundWallet = _newAddr;\n', '    }\n', '\n', '    function transferEth() onlyOwner external {\n', '        fundWallet.transfer(address(this).balance);\n', '    }\n', '\n', '    function setTokenPrice(uint256 _newBuyPrice) external onlyOwner {\n', '        tokenPrice = _newBuyPrice;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract PaoToken is CoolPandaToken {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "PAO Token";\n', '    string public symbol = "PAO";\n', '    uint fundRatio = 6;\n', '    uint256 public minBuyETH = 50;\n', '\n', '    JPYC public jpyc;                       //JPYC Address\n', '    uint256 public jypcBonus = 40000;       \n', '\n', '    event JypcBonus(uint256 paoAmount, uint256 jpycAmount);\n', '\n', '    // constructor\n', '    constructor() public {\n', '        totalSupply = 10000000000 * 10 ** uint256(decimals);\n', '        tokenPrice = 50000;\n', '        balances[fundWallet] = totalSupply * fundRatio / 10;\n', '        balances[address(this)] = totalSupply.sub(balances[fundWallet]);\n', '    }\n', '\n', '    // @notice Buy tokens from contract by sending ether\n', '    function () payable public {\n', '        if(fundWallet != msg.sender){\n', '            require (msg.value >= (minBuyETH * 10 ** uint256(decimals)));   // Check if minimum amount \n', '            uint256 amount = msg.value.mul(tokenPrice);                     // calculates the amount\n', '            _buyToken(msg.sender, amount);                                  // makes the transfers\n', '            fundWallet.transfer(msg.value);                              // send ether to the fundWallet\n', '        }\n', '    }\n', '\n', '    function _buyToken(address _to, uint256 _value) isTokenTransfer internal {\n', '        address _from = address(this);\n', '        require (_to != 0x0);                                                   // Prevent transfer to 0x0 address.\n', '        require (balances[_from] >= _value);                                    // Check if the sender has enough\n', '        require (balances[_to].add(_value) >= balances[_to]);                   // Check for overflows\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        //give bonus consume token\n', '        uint256 _jpycAmount = _getJYPCBonus();\n', '        jpyc.giveBonus(_to, _jpycAmount);\n', '\n', '        emit JypcBonus(_value,_jpycAmount);\n', '    }\n', '\n', '    function _getJYPCBonus() internal view returns (uint256 amount){\n', '        return msg.value.mul(jypcBonus); \n', '    }  \n', '\n', '    function setMinBuyEth(uint256 _amount) external onlyOwner{\n', '        minBuyETH = _amount;\n', '    }\n', '\n', '    function setJypcBonus(uint256 _amount) external onlyOwner{\n', '        jypcBonus = _amount;\n', '    }\n', '\n', '    function transferToken() onlyOwner external {\n', '        address _from = address(this);\n', '        uint256 _total = balances[_from];\n', '        balances[_from] = balances[_from].sub(_total);\n', '        balances[fundWallet] = balances[fundWallet].add(_total);\n', '    }\n', '\n', '    function setJpycContactAddress(address _tokenAddress) external onlyOwner {\n', '        jpyc = JPYC(_tokenAddress);\n', '    }\n', '}\n', '\n', 'contract JPYC is CoolPandaToken {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Japan Yen Coin";\n', '    uint256 _initialSupply = 10000000000 * 10 ** uint256(decimals);\n', '    string public symbol = "JPYC";\n', '    address public paoContactAddress;\n', '\n', '    event Issue(uint256 amount);\n', '\n', '    // constructor\n', '    constructor() public {\n', '        tokenPrice = 47000;           //JPY to ETH (rough number)\n', '        totalSupply = _initialSupply;\n', '        balances[fundWallet] = _initialSupply;\n', '    }\n', '\n', '    function () payable public {\n', '        uint amount = msg.value.mul(tokenPrice);             // calculates the amount\n', '        _giveToken(msg.sender, amount);                          // makes the transfers\n', '        fundWallet.transfer(msg.value);                         // send ether to the public collection wallet\n', '    }\n', '\n', '    function _giveToken(address _to, uint256 _value) isTokenTransfer internal {\n', '        require (_to != 0x0);                                       // Prevent transfer to 0x0 address.\n', '        require(totalSupply.add(_value) >= totalSupply);\n', '        require (balances[_to].add(_value) >= balances[_to]);       // Check for overflows\n', '\n', '        totalSupply = totalSupply.add(_value);\n', '        balances[_to] = balances[_to].add(_value);                  // Add the same to the recipient\n', '        emit Transfer(address(this), _to, _value);\n', '    }\n', '\n', '    function issue(uint256 amount) external onlyOwner {\n', '        _giveToken(fundWallet, amount);\n', '\n', '        emit Issue(amount);\n', '    }\n', '\n', '    function setPaoContactAddress(address _newAddr) external onlyOwner {\n', '        require(_newAddr != address(0));\n', '        paoContactAddress = _newAddr;\n', '    }\n', '\n', '    function giveBonus(address _to, uint256 _value)\n', '    isTokenTransfer\n', '    external\n', '    returns (bool success) {\n', '        require(_to != address(0));\n', '        if(msg.sender == paoContactAddress){\n', '            _giveToken(_to,_value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '}']