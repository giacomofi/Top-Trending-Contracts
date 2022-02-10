['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function balanceOf(address _who) public view returns (uint256);\n', '\n', '    function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '    function approve(address _spender, uint256 _value)\n', '    public returns (bool);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = _a * _b;\n', '        require(c / _a == _b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = _a / _b;\n', '        // assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b <= _a);\n', '        uint256 c = _a - _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        uint256 c = _a + _b;\n', '        require(c >= _a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '    public\n', '    view\n', '    returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        require(_to != address(0));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(_to != address(0));\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(\n', '        address _spender,\n', '        uint256 _addedValue\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = (\n', '        allowed[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(\n', '        address _spender,\n', '        uint256 _subtractedValue\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'interface ERC223Receiver {\n', '\n', '    function tokenFallback(address _from, uint256 _value, bytes _data) external;\n', '\n', '}\n', '\n', '/**\n', ' * Secure Crypto Payments ERC223 token contract\n', ' *\n', ' * Designed and developed by BlockSoft.biz\n', ' */\n', 'contract SecureCryptoToken is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    event Release();\n', '    event AddressLocked(address indexed _address, uint256 _time);\n', '    event TokensReverted(address indexed _address, uint256 _amount);\n', '    event AddressLockedByKYC(address indexed _address);\n', '    event KYCVerified(address indexed _address);\n', '    event TokensRevertedByKYC(address indexed _address, uint256 _amount);\n', '    event SetTechAccount(address indexed _address);\n', '\n', '    string public constant name = "Secure Crypto Payments";\n', '\n', '    string public constant symbol = "SEC";\n', '\n', '    string public constant standard = "ERC223";\n', '\n', '    uint256 public constant decimals = 8;\n', '\n', '    bool public released = false;\n', '    bool public ignoreKYCLockup = false;\n', '\n', '    address public tokensWallet;\n', '    address public techAccount;\n', '\n', '    mapping(address => uint) public lockedAddresses;\n', '    mapping(address => bool) public verifiedKYCAddresses;\n', '\n', '    modifier isReleased() {\n', '        require(released || msg.sender == tokensWallet || msg.sender == owner || msg.sender == techAccount);\n', '        require(lockedAddresses[msg.sender] <= now);\n', '        if (!ignoreKYCLockup) {\n', '            require(verifiedKYCAddresses[msg.sender]);\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier hasAddressLockupPermission() {\n', '        require(msg.sender == owner || msg.sender == techAccount);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = 0xc8F9bFc1B5b77A44484b27ebF4583f1E0207EBb5;\n', '        tokensWallet = owner;\n', '        verifiedKYCAddresses[owner] = true;\n', '\n', '        techAccount = 0x41D621De050A551F5f0eBb83D1332C75339B61E4;\n', '        verifiedKYCAddresses[techAccount] = true;\n', '        emit SetTechAccount(techAccount);\n', '\n', '        totalSupply_ = 121000000 * (10 ** decimals);\n', '        balances[tokensWallet] = totalSupply_;\n', '        emit Transfer(0x0, tokensWallet, totalSupply_);\n', '    }\n', '\n', '    function lockAddress(address _address, uint256 _time) public hasAddressLockupPermission returns (bool) {\n', '        require(_address != owner && _address != tokensWallet && _address != techAccount);\n', '        require(balances[_address] == 0 && lockedAddresses[_address] == 0 && _time > now);\n', '        lockedAddresses[_address] = _time;\n', '\n', '        emit AddressLocked(_address, _time);\n', '        return true;\n', '    }\n', '\n', '    function revertTokens(address _address) public hasAddressLockupPermission returns (bool) {\n', '        require(lockedAddresses[_address] > now && balances[_address] > 0);\n', '\n', '        uint256 amount = balances[_address];\n', '        balances[tokensWallet] = balances[tokensWallet].add(amount);\n', '        balances[_address] = 0;\n', '\n', '        emit Transfer(_address, tokensWallet, amount);\n', '        emit TokensReverted(_address, amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function lockAddressByKYC(address _address) public hasAddressLockupPermission returns (bool) {\n', '        require(released);\n', '        require(balances[_address] == 0 && verifiedKYCAddresses[_address]);\n', '\n', '        verifiedKYCAddresses[_address] = false;\n', '        emit AddressLockedByKYC(_address);\n', '\n', '        return true;\n', '    }\n', '\n', '    function verifyKYC(address _address) public hasAddressLockupPermission returns (bool) {\n', '        verifiedKYCAddresses[_address] = true;\n', '        emit KYCVerified(_address);\n', '\n', '        return true;\n', '    }\n', '\n', '    function revertTokensByKYC(address _address) public hasAddressLockupPermission returns (bool) {\n', '        require(!verifiedKYCAddresses[_address] && balances[_address] > 0);\n', '\n', '        uint256 amount = balances[_address];\n', '        balances[tokensWallet] = balances[tokensWallet].add(amount);\n', '        balances[_address] = 0;\n', '\n', '        emit Transfer(_address, tokensWallet, amount);\n', '        emit TokensRevertedByKYC(_address, amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function setKYCLockupIgnoring(bool _ignoreFlag) public onlyOwner {\n', '        ignoreKYCLockup = _ignoreFlag;\n', '    }\n', '\n', '    function release() public onlyOwner returns (bool) {\n', '        require(!released);\n', '        released = true;\n', '        emit Release();\n', '        return true;\n', '    }\n', '\n', '    function getOwner() public view returns (address) {\n', '        return owner;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public isReleased returns (bool) {\n', '        if (released) {\n', '            verifiedKYCAddresses[_to] = true;\n', '        }\n', '\n', '        if (super.transfer(_to, _value)) {\n', '            uint codeLength;\n', '            assembly {\n', '                codeLength := extcodesize(_to)\n', '            }\n', '            if (codeLength > 0) {\n', '                ERC223Receiver receiver = ERC223Receiver(_to);\n', '                receiver.tokenFallback(msg.sender, _value, msg.data);\n', '            }\n', '\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {\n', '        if (released) {\n', '            verifiedKYCAddresses[_to] = true;\n', '        }\n', '\n', '        if (super.transferFrom(_from, _to, _value)) {\n', '            uint codeLength;\n', '            assembly {\n', '                codeLength := extcodesize(_to)\n', '            }\n', '            if (codeLength > 0) {\n', '                ERC223Receiver receiver = ERC223Receiver(_to);\n', '                receiver.tokenFallback(_from, _value, msg.data);\n', '            }\n', '\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public isReleased returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public isReleased returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != owner);\n', '        require(lockedAddresses[newOwner] < now);\n', '        address oldOwner = owner;\n', '        super.transferOwnership(newOwner);\n', '\n', '        if (oldOwner != tokensWallet) {\n', '            allowed[tokensWallet][oldOwner] = 0;\n', '            emit Approval(tokensWallet, oldOwner, 0);\n', '        }\n', '\n', '        if (owner != tokensWallet) {\n', '            allowed[tokensWallet][owner] = balances[tokensWallet];\n', '            emit Approval(tokensWallet, owner, balances[tokensWallet]);\n', '        }\n', '\n', '        verifiedKYCAddresses[newOwner] = true;\n', '        emit KYCVerified(newOwner);\n', '    }\n', '\n', '    function changeTechAccountAddress(address _address) public onlyOwner {\n', '        require(_address != address(0) && _address != techAccount);\n', '        require(lockedAddresses[_address] < now);\n', '\n', '        techAccount = _address;\n', '        emit SetTechAccount(techAccount);\n', '\n', '        verifiedKYCAddresses[_address] = true;\n', '        emit KYCVerified(_address);\n', '    }\n', '\n', '}']