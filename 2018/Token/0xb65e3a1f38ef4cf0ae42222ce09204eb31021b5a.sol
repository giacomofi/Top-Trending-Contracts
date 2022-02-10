['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC223\n', ' * @dev Interface for ERC223\n', ' */\n', 'interface ERC223 {\n', '\n', '    // functions\n', '    function balanceOf(address _owner) external constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '    function allowance(address _owner, address _spender) external constant returns (uint256 remaining);\n', '\n', '\n', '\n', '    // Getters\n', '    function name() external constant returns  (string _name);\n', '    function symbol() external constant returns  (string _symbol);\n', '    function decimals() external constant returns (uint8 _decimals);\n', '    function totalSupply() external constant returns (uint256 _totalSupply);\n', '\n', '\n', '    // Events\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    event Burn(address indexed burner, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @notice A contract will throw tokens if it does not inherit this\n', ' * @title ERC223ReceivingContract\n', ' * @dev Contract for ERC223 token fallback\n', ' */\n', 'contract ERC223ReceivingContract {\n', '\n', '    TKN internal fallback;\n', '\n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '    function tokenFallback(address _from, uint256 _value, bytes _data) external pure {\n', '        TKN memory tkn;\n', '        tkn.sender = _from;\n', '        tkn.value = _value;\n', '        tkn.data = _data;\n', '        uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '        tkn.sig = bytes4(u);\n', '\n', '        /*\n', '         * tkn variable is analogue of msg variable of Ether transaction\n', '         * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '         * tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '         * tkn.data is data of token transaction   (analogue of msg.data)\n', '         * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution\n', '         */\n', '\n', '\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two numbers, truncating the quotient.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two numbers, throws on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    \n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(\n', '      address indexed previousOwner,\n', '      address indexed newOwner\n', '    );\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title C3Coin\n', ' * @dev C3Coin is an ERC223 Token with ERC20 functions and events\n', ' *      Fully backward compatible with ERC20\n', ' */\n', 'contract C3Coin is ERC223, Ownable {\n', '    using SafeMath for uint;\n', '\n', '\n', '    string public name = "C3coin";\n', '    string public symbol = "CCC";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 10e11 * 1e18;\n', '\n', '\n', '    constructor() public {\n', '        balances[msg.sender] = totalSupply; \n', '    }\n', '\n', '\n', '    mapping (address => uint256) public balances;\n', '\n', '    mapping(address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '    /**\n', '     * @dev Getters\n', '     */\n', '    // Function to access name of token .\n', '    function name() external constant returns (string _name) {\n', '        return name;\n', '    }\n', '    // Function to access symbol of token .\n', '    function symbol() external constant returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    // Function to access decimals of token .\n', '    function decimals() external constant returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() external constant returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Get balance of a token owner\n', '     * @param _owner The address which one owns tokens\n', '     */\n', '    function balanceOf(address _owner) external constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice This function is modified for erc223 standard\n', '     * @dev ERC20 transfer function added for backward compatibility.\n', '     * @param _to Address of token receiver\n', '     * @param _value Number of tokens to send\n', '     */\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        bytes memory empty = hex"00000000";\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev ERC223 transfer function\n', '     * @param _to Address of token receiver\n', '     * @param _value Number of tokens to send\n', '     * @param _data Data equivalent to tx.data from ethereum transaction\n', '     */\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '\n', '    // function which is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit ERC223Transfer(msg.sender, _to, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    // function which is called when transaction target is a contract\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        emit ERC223Transfer(msg.sender, _to, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     *      Added due to backwards compatibility with ERC20\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 The amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) external returns (bool success) {\n', '        allowance[msg.sender][_spender] = 0; // mitigate the race condition\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner Address The address which owns the funds.\n', '     * @param _spender Address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Function to distribute tokens to the list of addresses by the provided uniform amount\n', '     * @param _addresses List of addresses\n', '     * @param _amount Uniform amount of tokens\n', '     */\n', '    function multiTransfer(address[] _addresses, uint256 _amount) public returns (bool) {\n', '\n', '        uint256 totalAmount = _amount.mul(_addresses.length);\n', '        require(balances[msg.sender] >= totalAmount);\n', '\n', '        for (uint j = 0; j < _addresses.length; j++) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '            balances[_addresses[j]] = balances[_addresses[j]].add(_amount);\n', '            emit Transfer(msg.sender, _addresses[j], _amount);\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Function to distribute tokens to the list of addresses by the provided various amount\n', '     * @param _addresses List of addresses\n', '     * @param _amounts List of token amounts\n', '     */\n', '    function multiTransfer(address[] _addresses, uint256[] _amounts) public returns (bool) {\n', '\n', '        uint256 totalAmount = 0;\n', '\n', '        for(uint j = 0; j < _addresses.length; j++){\n', '\n', '            totalAmount = totalAmount.add(_amounts[j]);\n', '        }\n', '        require(balances[msg.sender] >= totalAmount);\n', '\n', '        for (j = 0; j < _addresses.length; j++) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_amounts[j]);\n', '            balances[_addresses[j]] = balances[_addresses[j]].add(_amounts[j]);\n', '            emit Transfer(msg.sender, _addresses[j], _amounts[j]);\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) onlyOwner public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _owner, uint256 _value) internal {\n', '        require(_value <= balances[_owner]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        balances[_owner] = balances[_owner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(_owner, _value);\n', '        emit Transfer(_owner, address(0), _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Default payable function executed after receiving ether\n', '     */\n', '    function () public payable {\n', '        // does not accept ether\n', '    }\n', '}']